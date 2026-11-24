param(
    [string]$GodotExe = 'C:\Godot\Godot_v4.7.2-stable_win64_console.exe'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$godotProject = Join-Path $repoRoot 'godot'
$htmlPath = Join-Path $repoRoot 'index.html'
$packPath = Join-Path $repoRoot 'index.pck'

if (-not (Test-Path -LiteralPath $GodotExe -PathType Leaf)) {
    throw "Godot executable not found: $GodotExe"
}

& $GodotExe --headless --path $godotProject --export-release Web $htmlPath
if ($LASTEXITCODE -ne 0) {
    throw "Godot Web export failed with exit code $LASTEXITCODE"
}

if (-not (Test-Path -LiteralPath $packPath -PathType Leaf)) {
    throw "Godot export did not create $packPath"
}

$hash = (Get-FileHash -LiteralPath $packPath -Algorithm SHA256).Hash.ToLowerInvariant().Substring(0, 12)
$packName = "index-$hash.pck"
$versionedPack = Join-Path $repoRoot $packName
Move-Item -LiteralPath $packPath -Destination $versionedPack -Force

$html = [IO.File]::ReadAllText($htmlPath, [Text.Encoding]::UTF8)
$html = $html.Replace('<html lang="en">', '<html lang="zh-Hant">')
$html = [regex]::Replace(
    $html,
    '"fileSizes":\{"index\.pck":(\d+)',
    [System.Text.RegularExpressions.MatchEvaluator]{ param($match) '"fileSizes":{"' + $packName + '":' + $match.Groups[1].Value },
    1
)
$html = [regex]::Replace(
    $html,
    '"executable":"index"',
    '"executable":"index","mainPack":"' + $packName + '"',
    1
)
if (-not $html.Contains('"mainPack":"' + $packName + '"') -or -not $html.Contains('"' + $packName + '"')) {
    throw 'Could not update the Godot HTML shell with the versioned PCK path.'
}
[IO.File]::WriteAllText($htmlPath, $html, [Text.UTF8Encoding]::new($false))
Write-Output "Web export ready: index.html → $packName"
