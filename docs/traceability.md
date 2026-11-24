# Requirements traceability

| Requirement | Implementation | Evidence | Status |
| --- | --- | --- | --- |
| FR-01: exactly two levels | Two Godot interaction screens: Wish Shop and Seed Gardens | Published browser walkthrough completed both levels | Verified in browser |
| FR-02: one primary interaction per level | Allocate 10 coins, then distribute 6 seeds | Published browser walkthrough performed both interactions | Verified in browser |
| FR-03: solved levels award keys | First key requires needs >= 4 and savings >= 1; second requires seeds in at least two gardens | Walkthrough showed 1/2 then 2/2 keys after solved choices | Verified in browser |
| FR-04: per-level score | Each reward shows score out of 90; HUD sums score | Walkthrough showed 90/90 per level and 180 total | Verified in browser |
| FR-05: final progress recap | Summary explains needs/wants, saving, diversification and uncertainty | Published final screen showed both learning outcomes and scores | Verified in browser |
| FR-06: age-appropriate finance content | Fictional coins, savings goal, and fixed garden scenario; no recommendations or guaranteed returns | Scenario copy and requirements review | Implemented; child/expert validation pending |
| FR-07: Blender asset in game | GLB imported in Godot, shown on reward screen; source `.blend` retained | Reward key visible on public page in both reward sequences; Godot pack contains imported GLB. Blender CLI source validation failed to launch. | In-game asset verified; Blender source-scene check pending |
| FR-08: Godot Web/GitHub Pages | Web preset exports root `index.html` and companion files; export script assigns the PCK a content-hashed filename to avoid serving a stale cached game | Godot 4.7.2 export succeeded (exit 0); public browser walkthrough reached final summary | Verified in public browser |
| Visual D-008: pixel-art interior | `godot/assets/pixel_dream_shop.svg`, warm square-corner UI, and Blender GLB reward reveal | Public browser showed the pixel-art shop, interaction panels, and reward screens | Implemented and reviewed in browser; owner acceptance pending |
| FR-09: session-only, no identity | Game state is in memory; no analytics or login | Source review | Implemented; remote browser inspection pending |
| FR-10: move through room and trigger missions | Pixel explorer moves with arrow keys/WASD; the level mission activates only within marker range using E/Enter/Space or the on-screen interaction button; narrow screens get touch direction controls | Godot 4.7.2 parsed and exported the updated script; live input/proximity check not available in this turn | Implemented in source; browser interaction check pending |
| NFR-01: Traditional Chinese | Bundled Noto Sans TC font and Traditional Chinese UI | Published browser walkthrough showed Traditional Chinese UI | Verified in browser |
| NFR-02: keyboard/touch | Godot Buttons provide pointer/touch and keyboard focus navigation | UI Button controls in source | Implemented; device checks pending |
| NFR-03: recover from wrong answers | Retry/reallocate buttons and explanatory feedback, no timer | Source review; browser walkthrough confirmed reallocation controls | Implemented; wrong-answer branch not exercised in browser |
| NFR-04: no personal data | No student input fields or telemetry | Source review | Implemented; network inspection pending |
| NFR-05: `/game2b/` base path | Relative Godot Web export resources | Public project-site URL loaded the entry, JS, WASM, PCK, and worklet | Deployed and verified |
