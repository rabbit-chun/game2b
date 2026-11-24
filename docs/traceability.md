# Requirements traceability

| Requirement | Implementation | Evidence | Status |
| --- | --- | --- | --- |
| FR-01: exactly two levels | Two Godot interaction screens: Wish Shop and Seed Gardens | Source `godot/scripts/main.gd`; Godot headless runtime smoke check | Implemented; full player walkthrough pending |
| FR-02: one primary interaction per level | Allocate 10 coins, then distribute 6 seeds | Same source; design brief | Implemented; child playtest pending |
| FR-03: solved levels award keys | First key requires needs >= 4 and savings >= 1; second requires seeds in at least two gardens | Source scoring and reward functions | Implemented; full walkthrough pending |
| FR-04: per-level score | Each reward shows score out of 90; HUD sums score | Source reward and HUD functions | Implemented; full walkthrough pending |
| FR-05: final progress recap | Summary explains needs/wants, saving, diversification and uncertainty | Source `_show_summary()` | Implemented; educator review pending |
| FR-06: age-appropriate finance content | Fictional coins, savings goal, and fixed garden scenario; no recommendations or guaranteed returns | Scenario copy and requirements review | Implemented; child/expert validation pending |
| FR-07: Blender asset in game | GLB imported in Godot, shown on reward screen; source `.blend` retained | Godot import and Web pack log; `godot/assets/dream_key.glb` | Imported and packaged; visual review pending |
| FR-08: Godot Web/GitHub Pages | Web preset exports root `index.html` and companion files | Godot 4.7.2 no-threads export completed | Local export passed; public Pages check pending |
| FR-09: session-only, no identity | Game state is in memory; no analytics or login | Source review | Implemented; remote browser inspection pending |
| NFR-01: Traditional Chinese | Bundled Noto Sans TC font and Traditional Chinese UI | Godot font import/export log | Packaged; browser visual review pending |
| NFR-02: keyboard/touch | Godot Buttons provide pointer/touch and keyboard focus navigation | UI Button controls in source | Implemented; device checks pending |
| NFR-03: recover from wrong answers | Retry/reallocate buttons and explanatory feedback, no timer | Interaction functions in source | Implemented; walkthrough pending |
| NFR-04: no personal data | No student input fields or telemetry | Source review | Implemented; network inspection pending |
| NFR-05: `/game2b/` base path | Relative Godot Web export resources | Generated `index.html` and project Web preset | Local export passed; Pages subpath verification pending |
