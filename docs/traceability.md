# Requirements traceability

| Requirement | Implementation | Evidence | Status |
| --- | --- | --- | --- |
| FR-01: exactly two five-day chapters | Days 1–5 and 6–10 | Source control flow; chapter results | Implemented; browser walkthrough pending |
| FR-02: walk and trigger daily scene tasks | Arrow/WASD explorer and nearby clickable marker/E interaction; route and classroom scenes | `godot/scripts/main.gd`; exported build | Implemented; public verification pending |
| FR-03: three difficulty presets | Exact reference starting balance, happiness, ten allowances, and goal | `_start_game` data table | Implemented; runtime scenario verification pending |
| FR-04: preview then confirm each choice | Three daily choice options and preview of balance/happiness/feedback | `_show_day_mission`, `_confirm_choice` | Implemented; browser verification pending |
| FR-05: balance/happiness and delayed consequence | Balance formula, happiness modifiers, delayed rainy-day expenses and garden result | `_confirm_choice`, `_begin_day` | Implemented; rule-path verification pending |
| FR-06: chapter and final scores | Five choices each contribute up to 18; results show /90 and recap /180 | `_show_reward`, `_show_summary` | Implemented; browser verification pending |
| FR-07: solve gates keys | Key one at day-five completion; key two only if savings meet goal on day 10 | `_confirm_choice` | Implemented; goal-success/failure walkthrough pending |
| FR-08: financial learning | Need/want, savings target, delayed cost and fictional garden risk | Scenario copy and recap | Implemented; educator review pending |
| FR-09: Blender reward model | Existing GLB is revealed on reward screens; source blend retained | `godot/assets/dream_key.glb`, `assets/dream_key.blend` | In game; Blender CLI validation remains unavailable |
| FR-10: Godot Web static deploy | Godot Web preset, content-hashed PCK, project Pages path | Export script and deployment files | Fresh export/public load pending |
| FR-11: privacy/scope | No IDs, telemetry or real financial service | Source review | Implemented |
| NFR-01: Traditional Chinese | Bundled Noto Sans TC and child-oriented copy | Browser walkthrough pending | Implemented |
| NFR-02: keyboard/touch | Keyboard, pointer marker, on-screen touch pad | Source interaction controls | Implemented; mobile device check pending |
| NFR-03: recoverable, non-timed play | Choice preview before confirm; no timer | UI code | Implemented |
| NFR-04: runtime | Godot 4.7.2 | Headless import and run exit 0 | Passed locally |
