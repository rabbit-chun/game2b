# Project brief — 小小夢魔：星夜理財夢

**Status:** Approved scope; DT-to-SDLC handoff pending gameplay selection  
**Requirements version:** 0.3  
**Decision owner:** User / project owner

## Goal

Deliver a short, child-friendly financial-literacy game with two meaningful interactions, a key reward for each completed level, per-level scores, and an end-of-game progress summary. Run the game in a browser from a Godot Web export and publish it on the existing GitHub Pages site.

## Target users and context

Elementary-school children playing independently or with a parent/teacher. Use Traditional Chinese and familiar everyday situations. Exact grade band is open for prototype calibration.

## Evidence and pain points

The project owner specified everyday financial management and investment as the subject, children as the audience, two key-gated levels, scores and a closing progress summary. External curriculum references support needs-versus-wants, budgeting, goals and saving, and risk/reward as useful financial-literacy concepts. These sources are design grounding, not evidence that this game improves learning.

- [OECD PISA 2022 Financial Literacy Framework](https://www.oecd.org/en/publications/pisa-2022-assessment-and-analytical-framework_dfe0bf9c-en/full-report/component-4.html)
- [CFPB: School-age children and saving](https://www.consumerfinance.gov/consumer-tools/money-as-you-grow/school-age-children-preteens/explore-saving/)
- [SEC Investor.gov: Asset allocation and diversification](https://www.investor.gov/introduction-investing/getting-started/asset-allocation)

## Problem statement

Children need an engaging, low-stakes way to practice prioritizing money, planning for a savings goal, and recognizing that investment outcomes are uncertain. The current published prototype presents these ideas as multiple-choice questions; it does not yet have a Godot project or a consequential in-world interaction loop.

## Inputs, processing, and outputs

- **Inputs:** child selects, sorts, allocates, or inspects fictional money/assets through mouse, touch, or keyboard-accessible controls.
- **Processing:** deterministic level rules update fictional resources, explain consequences, award points, and unlock a key when the interaction is complete.
- **Outputs:** visible per-level score, two key states, contextual learning feedback, and an end summary of concepts practiced.

## AI role and authority

AI supports concept generation, evidence-labeled pre-scoring, content drafts, and implementation. The owner selects the gameplay and visual directions. No AI model runs in the game or makes financial recommendations.

## MVP and non-goals

**MVP:** Godot project in GDScript; level 1 allocates a 10-coin purse among needs, savings, and wants; level 2 spreads fictional seeds across gardens and observes a fixed risk scenario; keys and scores; final progress recap; original Blender 3D key asset; Web export served at the root GitHub Pages path.

**Non-goals:** real money, brokerage or bank integrations, individual investment advice, student accounts, analytics, multiplayer, formal educational efficacy claims, and a research study.

## Constraints and risks

- Use installed Godot 4.7.2 and Blender 5.3.
- GitHub Pages hosts static files; Web export must work at `/game2b/`, including asset paths and MIME types.
- Godot export templates are absent and must be installed before a Web build.
- Avoid presenting diversification as a guarantee against loss; keep all investment examples fictional.
- Make text readable and input forgiving for younger players; avoid speed as the primary scoring factor.
- No playtest or learning outcome data have been collected.

## Delivery context

Browser-playable Godot Web export in the root of `rabbit-chun/game2b`, hosted at `https://rabbit-chun.github.io/game2b/`. Godot source and Blender source assets remain in the repository.

## Success measures

- The Web export loads at the GitHub Pages URL and on a local static server.
- A player can complete both levels, receive both keys, see each score, and see the progress recap.
- Feedback explains why a financial choice is helpful or risky.
- Keyboard and touch/mouse input work without relying on timed reflexes.
- No player identity or financial data leave the browser.
- Learning effectiveness remains unverified until appropriate child playtesting.

## Assumptions to test

- A two-interaction, 3–5 minute session can hold elementary players’ attention.
- Fictional visual metaphors can teach investment risk without implying guaranteed profit.
- The existing dream-school theme remains appropriate after the gameplay direction is chosen.

## Acceptance examples

1. Completing level 1 awards the first key, shows its score, and enables level 2.
2. Completing level 2 awards the second key and shows both level scores plus a skills-based progress recap.
3. Selecting a risky fictional investment produces an explanation that losses are possible; spreading fictional assets reduces some concentration risk but does not guarantee a gain.
4. A player can finish without entering personal information or interacting with real financial products.

## Open questions

- Which of the three comparable visual directions should be used?
- What grade band should receive the final reading-level pass?

## User approval

Scope and delivery are confirmed from the user's original request and the follow-up specifying Godot Web. Education diagnostic profile, evidence indicators, and gameplay B were selected by the user. Visual approval remains pending.
