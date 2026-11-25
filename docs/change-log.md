# Change log

## v0.9 — 2026-11-25 — interactive everyday scenarios

- Replaced the abstract shop allocation screen with an original walk from home toward school and a clickable breakfast-shop task sign.
- Let the player plan a 50-dollar allowance across breakfast, a savings goal, and money carried to school. Plans that miss the savings goal give feedback and can be revised before awarding the first key.
- Added a distinct classroom scene and nearby lost-eraser mission, with borrowing/basic/decorated purchase plans and the remaining balance carried from the breakfast decision.
- Kept the original fictional six-seed garden event in the school mission. All seeds must be placed, and at least two gardens must be used to earn the second key; feedback describes the fixed wind outcome and risk limits.
- Added original warm-pixel SVG backgrounds for the route and classroom; retained the Blender dream key and existing visual direction.
- Added mission-sign click-to-interact while preserving near-marker distance checks, keyboard movement, E/Enter, and the touch direction pad.
- Updated the requirements baseline from v0.6 to v0.7 and recorded the owner-directed change in D-009.
- Godot 4.7.2 project import, headless scene launch, and Web release export passed locally. Public gameplay verification is pending deployment.

## v0.8 — 2026-11-24

- Published build `index-6154d144e2a0.pck` to GitHub Pages and refreshed the page with a cache-busting URL for acceptance review.
- Verified keyboard and on-screen direction movement, proximity-gated E mission triggers in both levels, both key rewards and scores, and the final 120/180 progress recap in Chrome.
- Recorded the user's acceptance request and completed the SDLC verification handoff; direct mobile-device testing remains a limitation.

## v0.7 — 2026-11-24

- Route keyboard movement from `_input` so arrow keys and WASD work while the game canvas is active.
- Add a clickable direction pad on desktop and mobile; each tap advances the player through the room, and holding keyboard input still moves continuously.
- Web export is `index-6154d144e2a0.pck`; direction-pad and mission proximity walkthrough are pending.

## v0.6 — 2026-11-24

- Added a controllable pixel character to the room exploration loop.
- Arrow keys and WASD move through the scene; short taps advance the explorer while a held key moves continuously. A nearby glowing mission marker opens its level task on E, Enter, or Space.
- Added touch direction controls for narrow browser screens and an on-screen interaction button.
- Kept each finance challenge, score, key reward, and final learning summary inside the existing two-level flow; updated FR-10 and input requirements.
- Godot 4.7.2 Web export completed as `index-bf266e68e1c2.pck`; public exploration screen verified, and approach/mission trigger verification is in progress.

## v0.5 — 2026-11-24

- Re-exported the Godot 4.7.2 Web build with the project export script; the current package is `index-31e038d0ee42.pck`.
- Walked through both levels on the public GitHub Pages site and reached the final learning summary.
- Recorded Blender command-line startup failure as an outstanding source-scene validation limitation; the GLB reward still renders in the game.
- Updated skills audit, traceability, project-state evidence, and browser visual review.

## v0.4 — 2026-11-24

- Replaced the moonlit 3D campus backdrop with a crisp, warm pixel-art dream shop based on the owner's attached reference image.
- Re-styled panels and buttons with parchment, wood, and garden colors and square borders.
- Kept the Blender-made GLB dream key and reveal it on each level reward screen.
- Recorded the visual direction change as D-008; the two finance interactions, keys, scores, and learning recap remain in scope.
- Fixed HUD label widths and moved the Blender key into the unobstructed reward area; slowed its rotation so the 3D key stays recognizable.

## v0.3 — 2026-11-24

- Owner selected tournament candidate B, Wish Shop Budget Sort.
- Defined the level 1 10-coin needs/savings/wants interaction and level 2 fictional seed-diversification interaction.
- Prepared three visually distinct comparisons of the same level 1 screen and state; owner selected Moonlight Toybox.
- Built the approved two-level interaction in Godot 4.7.2 with session scoring, two key rewards, and a learning recap.
- Added the Blender key GLB, Traditional Chinese font, responsive web preset, and root GitHub Pages export.

## v0.2 — 2026-11-24

- Added Godot Web as the target runtime and retained GitHub Pages hosting.
- Locked the learning-first reward profile and measurable evidence plan.
- Added a game-design tournament gate before selecting the Godot vertical slice.
- Recorded the current HTML prototype and missing Web export templates as migration constraints.

## v0.1 — 2026-11-24

- Initial two-level financial literacy game scope: elementary audience, key rewards, level scores, progress summary, and static web hosting.

## v0.10 — Implement ten-day saving challenge redesign (2026-11-25)

- Replaced the prior two-task budget counter with the linked ten-day saving-challenge loop and three difficulty presets.
- Added per-day in-scene movement/trigger, preview-and-confirm choices, savings and happiness tracking, delayed outcomes, breakfast and missing-eraser scenarios, and a fictional garden-risk lesson.
- Split days into two five-day chapters with separate scores. Key two now requires the selected day-ten savings goal.
- Updated requirements to v0.8, brief, traceability, project state, and skills audit; local Godot import and headless run passed. Fresh Web export and public acceptance remain pending.

## v0.11 — Show Blender 3D player in exploration (2026-11-26)

- Identified why the prior game looked fully 2D: SVG backgrounds covered the 3D viewport; the moving avatar was custom 2D rectangles and the GLB key appeared only on rewards.
- Created an original low-poly dream explorer in Blender 5.3, saving editable `.blend` source, reproducible builder, and web-ready GLB.
- Replaced the drawn avatar with a transparent Godot SubViewport-rendered GLB that moves with the existing route controls; tuned size, front-facing angle, and lighting.
- Updated requirements to v0.9 and reopened Godot/runtime/Web/public visual verification.
