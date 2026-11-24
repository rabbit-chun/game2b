"""Install only Godot's official single-threaded Web release template from the TPZ archive.

The official all-platform TPZ is over 1 GB. ZIP byte ranges let this script fetch only the
central directory and the requested Web template, while verifying the entry CRC.
"""

from __future__ import annotations

import argparse
import os
import re
import struct
import sys
import urllib.request
import zlib
from pathlib import Path


VERSION = "4.7.2.stable"
URL = "https://godot-releases.nbg1.your-objectstorage.com/4.7.2-stable/Godot_v4.7.2-stable_export_templates.tpz"
TARGET = "web_nothreads_release.zip"


def get_range(start: int, end: int) -> bytes:
    request = urllib.request.Request(URL, headers={"Range": f"bytes={start}-{end}", "User-Agent": "Game2b-Godot-Web-Template/1.0"})
    with urllib.request.urlopen(request, timeout=90) as response:
        if response.status != 206:
            raise RuntimeError(f"Expected HTTP 206 for bytes {start}-{end}, got {response.status}")
        return response.read()


def list_entries() -> tuple[int, int, list[dict[str, int | str]]]:
    first = get_range(0, 0)
    if len(first) != 1:
        raise RuntimeError("Server did not return a valid one-byte range")
    # A suffix request discovers the exact archive size without downloading it.
    request = urllib.request.Request(URL, headers={"Range": "bytes=-1048576", "User-Agent": "Game2b-Godot-Web-Template/1.0"})
    with urllib.request.urlopen(request, timeout=90) as response:
        if response.status != 206:
            raise RuntimeError("Godot release host does not support the required byte ranges")
        content_range = response.headers.get("Content-Range", "")
        match = re.fullmatch(r"bytes (\d+)-(\d+)/(\d+)", content_range)
        if not match:
            raise RuntimeError(f"Invalid Content-Range: {content_range!r}")
        tail_start, _, total_size = map(int, match.groups())
        tail = response.read()
    eocd_pos = tail.rfind(b"PK\x05\x06")
    if eocd_pos < 0 or len(tail) - eocd_pos < 22:
        raise RuntimeError("Could not locate the ZIP end-of-central-directory record")
    _, disk, cd_disk, entries_disk, entries_total, cd_size, cd_offset, comment_size = struct.unpack_from("<IHHHHIIH", tail, eocd_pos)
    if disk or cd_disk or entries_disk != entries_total:
        raise RuntimeError("Multi-disk ZIP archives are unsupported")
    if cd_size == 0xFFFFFFFF or cd_offset == 0xFFFFFFFF:
        raise RuntimeError("ZIP64 central directories are unsupported by this helper")
    if eocd_pos + 22 + comment_size > len(tail):
        raise RuntimeError("Truncated ZIP end record")
    if cd_offset >= tail_start and cd_offset + cd_size <= tail_start + len(tail):
        central = tail[cd_offset - tail_start : cd_offset - tail_start + cd_size]
    else:
        central = get_range(cd_offset, cd_offset + cd_size - 1)
    if len(central) != cd_size:
        raise RuntimeError("Truncated ZIP central directory")
    entries: list[dict[str, int | str]] = []
    offset = 0
    for _ in range(entries_total):
        if central[offset : offset + 4] != b"PK\x01\x02":
            raise RuntimeError(f"Invalid central-directory entry at {offset}")
        flags = struct.unpack_from("<H", central, offset + 8)[0]
        method = struct.unpack_from("<H", central, offset + 10)[0]
        crc = struct.unpack_from("<I", central, offset + 16)[0]
        compressed = struct.unpack_from("<I", central, offset + 20)[0]
        uncompressed = struct.unpack_from("<I", central, offset + 24)[0]
        name_len, extra_len, comment_len = struct.unpack_from("<HHH", central, offset + 28)
        local_offset = struct.unpack_from("<I", central, offset + 42)[0]
        raw_name = central[offset + 46 : offset + 46 + name_len]
        name = raw_name.decode("utf-8" if flags & 0x800 else "cp437")
        entries.append({"name": name, "method": method, "crc": crc, "compressed": compressed, "uncompressed": uncompressed, "local_offset": local_offset})
        offset += 46 + name_len + extra_len + comment_len
    if offset != cd_size:
        raise RuntimeError("ZIP central directory size did not match parsed entries")
    return total_size, cd_size, entries


def extract_entry(entry: dict[str, int | str], output: Path) -> None:
    local = int(entry["local_offset"])
    header = get_range(local, local + 29)
    if header[:4] != b"PK\x03\x04":
        raise RuntimeError("Invalid local ZIP header")
    name_len, extra_len = struct.unpack_from("<HH", header, 26)
    start = local + 30 + name_len + extra_len
    size = int(entry["compressed"])
    compressed = get_range(start, start + size - 1)
    method = int(entry["method"])
    if method == 0:
        data = compressed
    elif method == 8:
        data = zlib.decompress(compressed, -15)
    else:
        raise RuntimeError(f"Unsupported ZIP compression method {method}")
    if len(data) != int(entry["uncompressed"]):
        raise RuntimeError("Extracted size does not match the central directory")
    crc = zlib.crc32(data) & 0xFFFFFFFF
    if crc != int(entry["crc"]):
        raise RuntimeError("Extracted template failed CRC verification")
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_bytes(data)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--list", action="store_true", help="list Web template entries without downloading them")
    parser.add_argument("--install", action="store_true", help="install the Web no-threads release template into the current user's Godot template directory")
    args = parser.parse_args()
    if not args.list and not args.install:
        parser.error("choose --list or --install")
    try:
        total_size, central_size, entries = list_entries()
        matches = [e for e in entries if Path(str(e["name"])).name == TARGET]
        if args.list:
            print(f"Official archive: {total_size:,} bytes; central directory: {central_size:,} bytes")
            for e in entries:
                if "web" in str(e["name"]).lower():
                    print(f"{e['name']} ({int(e['uncompressed']):,} bytes)")
        if args.install:
            if len(matches) != 1:
                raise RuntimeError(f"Expected one {TARGET}, found {len(matches)}")
            appdata = os.environ.get("APPDATA")
            if not appdata:
                raise RuntimeError("APPDATA is not set")
            target = Path(appdata) / "Godot" / "export_templates" / VERSION / TARGET
            extract_entry(matches[0], target)
            print(f"Installed and CRC-verified: {target}")
        return 0
    except Exception as exc:  # Fail clearly; never leave a partial template behind.
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
