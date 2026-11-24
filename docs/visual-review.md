# Visual direction gate — gameplay B

**Gameplay selection:** B — Wish Shop Budget Sort, approved by the project owner on 2026-11-24.  
**Visual status:** approved by the project owner on 2026-11-24.  
**Comparison control:** all three directions show the identical level 1 screen and state: level 1, 0/2 keys, 0 points, 10 moon-coins allocated as 4 needs (raincoat), 3 savings (star telescope), and 3 wants (star stickers). Only composition, world treatment, surfaces, lighting, and hierarchy change.

| Direction | Visual language | Readability / accessibility | Emotional tone | Godot fit | Main trade-off |
| --- | --- | --- | --- | --- | --- |
| **霓虹校園** | Dark school shop, glowing sign, luminous accents, scene on the left and decision panel on the right. | Strong labels and contrasting cards; glow must remain behind text and respect reduced motion. | Mysterious, adventurous; closest to the supplied campus screenshot. | Fits the existing top-down school map and the low-poly key. | Most atmospheric; highest risk that neon decorations compete with the money decision. |
| **紙藝繪本** | Cut-paper hills, layered shop façade, warm page-like surfaces, three allocation cards in one row. | Large separated allocation areas and generous labels; color must not be the only category cue. | Gentle, playful, classroom-friendly. | Simple layered 2D UI and Godot Control nodes; low art cost. | Most approachable; less like a dark dream-school adventure. |
| **月光玩具盒** | Low-poly diorama with a lit platform, muted teal night, moonstone materials, floating glass-like decision panel. | High visual hierarchy and less decoration; transparency must keep text contrast stable. | Quiet, crafted, dreamlike. | Strongest match for the Blender GLB and Godot 3D scene. | Best asset integration; needs careful mobile scaling and transparent-panel contrast. **Selected.** |

## Same-screen visual tournament criteria

Compare the options by first-action clarity, child-readable text, focus on the budget decision, emotional tone, mobile reflow, keyboard/touch target size, reduced-motion behavior, and cost to build and maintain. The owner chooses one direction or requests a revision. No scoring or recommendation is used to substitute for that choice.

## Approval

- Selected direction: 月光玩具盒 / Moonlight Toybox
- Conditions/revision: keep the decision panel high contrast and responsive; retain the quiet low-poly moonlit school atmosphere.
- Owner/date: project owner / 2026-11-24
