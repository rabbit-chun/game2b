# Visual direction update — D-008

**Status:** Owner-directed visual implementation; owner acceptance recorded 2026-11-24.

**Reference:** Pixel-art room image supplied by the project owner on 2026-11-24.

## Implemented visual language

- Warm wood-brick interior, cream transom windows, green trim, colorful shelves, checkout counter, seating rug, water cooler, potted plant, and sofa.
- Crisp SVG edges and simple color blocks to match the reference's pixel-art treatment.
- Parchment content panel with square wood-colored frame; square garden-green and terracotta buttons.
- A readable, compact HUD shows key count and score at the top right.
- Existing Blender-made 3D dream key appears at a readable scale in the unobstructed reward area.

## Interaction and readability criteria

- The same two approved money interactions remain primary: allocate 10 coins, then spread 6 fictional seeds.
- Scores, key count, progress feedback, and the final learning summary remain visible in the UI.
- Color is accompanied by Traditional Chinese labels; buttons remain large Godot controls for pointer, touch, and keyboard focus.
- Keep financial results deterministic and explain that diversification does not guarantee against loss.

## Review status — 2026-11-24

- Godot 4.7.2 Web export refreshed successfully; the latest content-hashed package is `index-31e038d0ee42.pck`.
- Public GitHub Pages browser review confirmed the shop screen, both game interactions, reward/key screens, and final learning summary render.
- v0.7 desktop/public review verified arrow-key movement, direction-pad movement, E-triggered nearby mission screens for both levels, key rewards, level scores, and the final progress recap.
- A separate physical mobile-device touch and wide desktop layout review remains useful; the current public walk-through used desktop Chrome.
