# Requirements baseline v0.8 — ten-day saving challenge

## Functional requirements

| ID | Requirement | Acceptance example |
| --- | --- | --- |
| FR-01 | Exactly two chapters, five daily scenarios each. | Days 1–5 award key one at chapter completion; days 6–10 conclude the challenge. |
| FR-02 | Each daily scenario begins in an explorable scene. The player walks from home toward school and triggers a breakfast-shop mission on day 1; later classroom and schoolyard missions include the missing-eraser decision and fictional garden event. | Arrow keys/WASD move the avatar. A nearby sign or E/Enter/Space opens the daily scenario. |
| FR-03 | Offer Easy/Medium/Hard challenges with the reference game's starting savings, happiness, daily allowance schedule, and toy goal. | Easy 80/18/260; Medium 40/12/174; Hard 20/6/60. |
| FR-04 | Each day presents multiple choices and a preview of cost, updated savings, happiness change, and explanatory feedback before confirmation. | Selecting is reversible; confirm applies the choice once. |
| FR-05 | Apply current balance + allowance − spending. Track happiness from 0 to 20, with positive happiness above 15 halved and negative changes at 5 or below amplified. Apply selected delayed consequences on a later day. | The rainy-day umbrella can break and cause a later cost; outcomes explain why. |
| FR-06 | Display score for each chapter and final progress. Each daily choice contributes up to 18 points; each five-day chapter is out of 90. | Chapter results and final recap display both scores and /180 total. |
| FR-07 | Award key one after completing the first five days. Award key two only if day 10 ends with savings at or above the selected toy goal. | An unmet final savings goal shows the amount still needed and does not award key two. |
| FR-08 | Teach needs/wants, saving toward a goal, delayed spending, and uncertainty/diversification with fictional assets and age-appropriate explanations. | The garden result explicitly says diversification does not guarantee against loss. |
| FR-09 | Integrate the existing Blender-made key asset as the level reward. | GLB is visible on reward screens. |
| FR-10 | Provide a Godot Web build deployable as a static site under `/game2b/`. | Root `index.html` loads all hashed package and companion files from GitHub Pages. |
| FR-11 | Keep the experience single-player and session-only. | No accounts, personal data, analytics, real-money decisions, or financial recommendations. |

## Non-functional requirements

| ID | Requirement | Acceptance example |
| --- | --- | --- |
| NFR-01 | Traditional Chinese, child-readable copy. | Daily scenes use familiar school/home situations. |
| NFR-02 | Desktop and mobile controls. | Arrow keys/WASD, on-screen direction pad, nearby sign click and interaction button work. |
| NFR-03 | No speed-based scoring; explain choices and allow scenario review before confirming. | No timer or reflex penalty. |
| NFR-04 | Godot 4.7.2 and the committed Web export preset are used. | Project imports, launches, and exports with the matching official templates. |

## Reference rules and implementation notes

The user-selected Markdown link destination is `https://rabbit-chun.github.io/game1b/` (十天存錢挑戰). Its rules inform three difficulty presets, ten daily allowance values, savings goal, happiness resource, daily choices, immediate feedback, delayed events, early ending at zero happiness, and a day-ten goal check. Scenario text and school journey are original. The game's allowance schedules and goals are reproduced exactly; outcome content is adapted to the requested breakfast and missing-eraser situations.

The two chapters are days 1–5 (home-to-school and daily spending) and days 6–10 (weekend, savings goal, school supplies, and fictional garden risk). Scores are choice-based formative feedback, not evidence of learning efficacy.

## Visual direction

Retain the owner's warm pixel-art direction, original route and classroom SVG scenes, and existing Blender GLB key reward. Do not copy reference-game artwork or characters.

## Skills and evidence profile

The approved Learning-first diagnostic remains documented in the game-design artifacts. Current ratings are AI pre-scores, not child/user research. No child playtest or educator validation has occurred. See `docs/skills-audit.md` and `docs/traceability.md` for applied skills and evidence.
