# Decision log

## D-001 — Use Godot Web for the published game

- **Date:** 2026-11-24
- **Decision:** Replace the current standalone HTML/JavaScript implementation as the published game with a Godot Web export; keep GitHub Pages as the target.
- **Owner/evidence:** User request: “godot發布成網頁版”.
- **Rationale:** It satisfies the requested engine and remains statically hostable.
- **Status:** Accepted; gameplay selection and export template installation still pending.

## D-002 — Learning-first design profile

- **Date:** 2026-11-24
- **Decision:** L/E/M/A weights are 50/15/10/25; guessing and cognitive-overload penalties are 15%/10%.
- **Owner/evidence:** User selected “學習優先”.
- **Status:** Locked before candidate scoring.

## D-003 — No G/C hard thresholds

- **Date:** 2026-11-24
- **Decision:** Do not hard-eliminate candidates on G or C. Use the observable indicators in `requirements.md` and keep flag thresholds as diagnostic warnings only.
- **Owner/evidence:** User selected the recommended option.
- **Status:** Locked before candidate scoring.

## D-004 — Evidence labels and ranking method

- **Date:** 2026-11-24
- **Decision:** Score concept alternatives with separate G/P/D axes, evidence-labeled `ai_pre_score`, and low confidence. Rank by Pareto front, then minimum dimension, mean, then candidate ID.
- **Owner/evidence:** `game-design` skill requirements.
- **Status:** Applied for this tournament only; no player evidence exists.

## D-005 — Blender tool boundary

- **Date:** 2026-11-24
- **Decision:** Use the installed Blender 5.3 and source `.blend`/`.glb` assets in the Godot project. Do not add Three.js to the game runtime; Godot is the chosen runtime.
- **Owner/evidence:** User requested Blender and then specified Godot Web. Toolkit add-on/config is absent; direct Blender Python generation is available.
- **Status:** Accepted; integration in the selected Godot concept remains pending.

## D-006 — Select Wish Shop Budget Sort

- **Date:** 2026-11-24
- **Decision:** Select candidate B: first allocate 10 fictional coins among needs, a savings goal, and wants; then spread fictional star-seeds across garden areas and inspect a fixed, explainable scenario.
- **Owner/evidence:** User selected “1. 核准 B: 願望雜貨店預算分配”.
- **Rationale:** The two interactions make different financial trade-offs visible with a short, recoverable choice and direct explanation.
- **Status:** Accepted; implemented in the Godot build.

## D-007 — Select Moonlight Toybox visual direction

- **Date:** 2026-11-24
- **Decision:** Use a low-poly moonlit diorama, muted teal and warm gold, a readable dark glass panel, and the Blender dream key as the level reward.
- **Owner/evidence:** User selected “月光玩具盒”.
- **Rationale:** Matches the reference's playful night campus while keeping the money-choice panel clear.
- **Status:** Accepted and implemented; browser visual review still pending.

## D-008 — Update visual direction to the attached pixel-art interior

- **Date:** 2026-11-24
- **Decision:** Use the owner's attached image as reference: warm wood-brick walls, cream upper trim, colorful shelves, shop counter, rug, furniture and plants, rendered with crisp pixel edges. Keep the Blender-made dream key as a 3D reward reveal.
- **Owner/evidence:** User's explicit request: “設計風格如圖片”.
- **Rationale:** The image is the current visual instruction and supersedes the earlier Moonlight Toybox direction.
- **Status:** Accepted; applied to the Godot Web build, pending final owner acceptance.
