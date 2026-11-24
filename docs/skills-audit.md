# Requested skills audit

| Skill | Applied work | Status |
| --- | --- | --- |
| `dt-sdlc` with `dt` and `sdlc` | Saved the project brief, requirements baseline, state, decision and change logs, traceability, review gates, delivery evidence, and final-acceptance status. The user explicitly approved gameplay B and Moonlight Toybox, allowing the DT handoff into SDLC build. | Build and release verification in progress; final acceptance remains for the owner. |
| `game-design` | Ran the evidence-based concept tournament and recorded the Learning-first weights and metrics. Owner chose Wish Shop Budget Sort and then chose Moonlight Toybox from three same-state comparisons. Added child-facing scoring, retries, key rewards, risk explanation, and final learning recap. | Implemented in Godot; AI ratings remain low-confidence and were not tested with children. |
| `blender-toolkit` | Created and retained the low-poly dream key as `assets/dream_key.blend` and `assets/dream_key.glb`; imported the GLB into the Godot project and display it as the reward key. | Blender 5.3 asset workflow applied. The optional Blender Toolkit add-on/config is absent locally, so its MCP workflow could not be used. |
| `blender-threejs-export` | Reviewed the export route and reused the GLB asset. | Its Three.js viewer is not the game runtime because the approved deployment target is Godot Web. |
| Godot Web delivery | Added `godot/project.godot`, scene/script, Web preset, Noto Sans TC, and GLB. Installed the official matching Godot 4.7.2 no-threads Web template and produced a static Web export for GitHub Pages. | Build produced. Remote Pages verification and release evidence pending. |

## Evidence and limitations

- `docs/game-design-scorecard.json` passed the deterministic tournament validator; the accepted concept is B. The scoring is a design aid, not child-play evidence.
- Godot 4.7.2 successfully imported the project and exported the Web preset using its official no-threads release template.
- The Web build embeds the CJK font, which increases download size. It bundles a Blender-made GLB key; the remaining diorama is assembled from Godot primitives.
- Score and keys are session-only. The game does not collect identifying data, provide real investment advice, or promise returns.
