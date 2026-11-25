# Requirements traceability

| Requirement | Implementation | Evidence | Status |
| --- | --- | --- | --- |
| FR-01: exactly two five-day chapters | Days 1–5 and 6–10 | Godot acceptance harness and public result screens | Verified locally and in published build |
| FR-02: walk and trigger daily scene tasks | Arrow/WASD explorer and nearby clickable marker/E interaction; route and classroom scenes | Browser walked to breakfast marker and opened the mission; harness tested distant and nearby cases | Verified |
| FR-03: three difficulty presets | Exact reference starting balance, happiness, ten allowances, and goal | Acceptance harness checked all three data sets | Verified |
| FR-04: preview then confirm each choice | Three daily choice options and preview of balance/happiness/feedback | Public browser showed day-one choice preview and applied confirmation | Verified |
| FR-05: balance/happiness and delayed consequence | Balance formula, happiness modifiers, delayed rainy-day expenses and garden result | Godot run exercised all ten daily decisions including later events | Verified locally; content not independently reviewed by educator |
| FR-06: chapter and final scores | Five choices each contribute up to 18; results show /90 and recap /180 | Acceptance harness checked both chapter scores and final recap | Verified locally |
| FR-07: solve gates keys | Key one at day-five completion; key two only if savings meet goal on day 10 | Harness completed target success and target miss branches | Verified locally |
| FR-08: financial learning | Need/want, savings target, delayed cost and fictional garden risk | Scenario copy and recap | Implemented; educator review pending |
| FR-09: Blender 3D assets in gameplay and rewards | Blender-made low-poly player renders in a transparent SubViewport and moves with the explorer; Blender key remains the chapter reward | Editable Blender source and GLB; Godot import; local visual preview; full ten-day success/miss harness | Local verification passed; Web/public verification pending |
| FR-10: Godot Web static deploy | Godot Web preset, content-hashed PCK, project Pages path | Existing public build verified before D-011; new player-model package pending | Reopened for D-011 |
| FR-11: privacy/scope | No IDs, telemetry or real financial service | Source review | Implemented |
| NFR-01: Traditional Chinese | Bundled Noto Sans TC and child-oriented copy | Public browser game screen | Verified |
| NFR-02: keyboard/touch | Keyboard, pointer marker, on-screen touch pad | Public keyboard movement verified; touch device not available | Keyboard verified; physical touch pending |
| NFR-03: recoverable, non-timed play | Choice preview before confirm; no timer | UI code | Implemented |
| NFR-04: runtime | Godot 4.7.2 | Headless import and run exit 0 | Passed locally |
