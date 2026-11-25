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

## D-009 — Replace abstract interactions with an interactive school-day journey

- **Date:** 2026-11-25
- **Decision:** Use two walkable scenes: home-to-school with a breakfast planning mission, followed by a school mission for a missing eraser and a fictional seed-garden investment event. Preserve arrow-key movement, nearby in-world task triggers, keys, scores, feedback, and the end progress recap.
- **Owner/evidence:** Owner's explicit redesign request and examples. The reference game contributes everyday money resources, spending/saving/investment decisions, visible consequences and scoring; the owner explicitly asks for direct walking exploration rather than keeping its dice-board movement.
- **Acceptance rule:** First key requires a plan that covers breakfast, saves at least 10 of the 50 fictional dollars, and retains school pocket money. Second key requires allocating all six seed tokens across at least two gardens. Unsuccessful attempts explain the goal and can be revised.
- **Visual decision:** Keep D-008's original warm pixel-art palette, create original home-route and classroom SVG scenes, and retain the Blender-made 3D key reveal. No reference-game artwork or characters are copied.
- **Impact:** Replaces the prior 10-coin needs/savings/wants interaction and generic mission room; updates FR-02/03/10 and adds FR-11. Requirements version increases to 0.7. Reopen implementation and public acceptance checks.
- **Status:** Owner-directed scope; implementation and public verification in progress.

## D-010 — Adopt the linked ten-day savings rules

- **Date:** 2026-11-25
- **Decision:** Replace the prior one-screen-per-level allocation game with a ten-day savings challenge split into two five-day, walkable chapters. Preserve the reference's Easy/Medium/Hard starting balance, happiness, allowance schedule, goal, daily choice preview, delayed consequences, zero-happiness early end, and day-ten goal check. Adapt scenario content to breakfast on the home-to-school route, a missing eraser at school, and a fictional seed-garden risk choice.
- **Owner/evidence:** User explicitly said all gameplay should be revised to match the linked reference rules and supplied breakfast/eraser examples. The Markdown destination is `https://rabbit-chun.github.io/game1b/`.
- **Acceptance rule:** Complete days 1–5 to earn key one. Earn key two only if day-ten savings meet the selected toy target. Each chapter displays its score; final recap shows learning progress and goal result.
- **Impact:** Requirements increment from 0.7 to 0.8. Replaced the earlier 50-dollar one-time breakfast budget and six-seed allocation counters; re-opened implementation, release, and public acceptance checks.
- **Status:** Implemented locally; fresh Web export and public acceptance pending.
