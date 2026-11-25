# Project brief — 小小夢魔：星夜理財夢

**Status:** Reference-rule redesign; implementation and release verification in progress
**Requirements version:** 0.8
**Decision owner:** User / project owner

## Goal

Deliver a Traditional Chinese financial-literacy game for elementary students. The player walks from home to school, interacts with in-world scenario markers, and completes a ten-day saving challenge based on the user's linked example. The ten days form two five-day chapters with scores and key rewards. The ending shows savings progress toward a toy goal and learning recap. Publish a Godot Web build to the existing GitHub Pages site.

## Audience and learning context

Children playing alone or with a parent/teacher. Practice everyday budgeting, needs versus wants, saving toward a goal, delayed consequences, happiness, and fictional investment risk. The experience uses no real money, financial products, advice, identity data, or analytics.

## Evidence and design basis

The owner rejected the earlier design and identified two concrete school-day examples: choose a breakfast plan on the trip to school and respond when an eraser is missing in class. The linked reference is a ten-day saving challenge. It uses difficulty presets; starting savings, happiness, and allowance schedules; daily decisions with immediate feedback; delayed consequences; a toy savings goal; and a day-ten result. This game adapts that cycle to an explorable home-to-school and school setting. The educational framing is informed by these external sources, which are not evidence that this game improves learning:

- [OECD PISA 2022 Financial Literacy Framework](https://www.oecd.org/en/publications/pisa-2022-assessment-and-analytical-framework_dfe0bf9c-en/full-report/component-4.html)
- [CFPB: School-age children and saving](https://www.consumerfinance.gov/consumer-tools/money-as-you-grow/school-age-children-preteens/explore-saving/)
- [SEC Investor.gov: Asset allocation and diversification](https://www.investor.gov/introduction-investing/getting-started/asset-allocation)

## Gameplay and outputs

- **Controls:** Arrow keys/WASD move the avatar; reach the glowing in-world marker, then click it or press E/Enter/Space. Touch devices have an on-screen pad.
- **Daily loop:** Choose among three plans, preview projected savings/happiness and explanation, then confirm. Balance updates by current savings + daily allowance − spending. Happiness is bounded from 0–20; the reference's mood modifiers and selected delayed events are applied.
- **Chapters:** Days 1–5 are the home-to-school route with breakfast, supplies, rain, lunch, and missing eraser. Days 6–10 include weekend choices, the toy-shop goal, another eraser event, the fictional garden-risk event, and final breakfast. Each chapter scores up to 90 points.
- **Keys:** The first chapter key follows completion of day five. The second key requires day-ten savings to meet the selected toy goal. Zero happiness ends the challenge early.
- **Ending:** Display both chapter scores, total score, savings against goal, happiness, keys, and learning recap.

## MVP and non-goals

Godot 4.7.2 GDScript, two explorable scene backdrops, original pixel-art UI, bundled Traditional Chinese font, existing Blender-made 3D key, and a static Web export for `https://rabbit-chun.github.io/game2b/`. Excluded: accounts, identity/analytics, multiplayer, real financial products, personalized recommendations, and learning-efficacy claims.

## Constraints and risks

- Keep all outcomes fictional and avoid implying guaranteed investment returns.
- Keep choices recoverable before confirmation; no speed-based scoring.
- The Blender Toolkit configuration is absent; the existing `.blend` and GLB remain integrated.
- The WebAssembly bundle is large due to Godot and the CJK font.
- No child playtest or financial educator review has been completed.

## Acceptance examples

1. Start each difficulty and verify its starting balance, happiness, daily allowances, and savings goal.
2. Walk to the day-one breakfast shop marker; a distant trigger fails, a nearby click or E opens three plans.
3. Preview and confirm a choice; savings/happiness update and score is added. The day-eight missing-eraser task offers borrowing and purchase plans.
4. Complete days 1–5 to receive key one and a score /90; complete days 6–10 to see the second score and goal result. Key two appears only when the goal is met.
5. Final recap shows both chapter scores, total /180, goal progress, happiness, keys, and the lesson that diversification cannot guarantee against loss.
6. Publish and play the static Godot Web build from the project Pages path.

## User approval

The owner requested the redesign, linked rule set, player movement and in-scene tasks, use of the required skills, Godot Web publication, and public-site update. These instructions authorize implementation and redeployment to the existing `rabbit-chun/game2b` site.
