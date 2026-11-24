# AI Game Design Tournament — Decision Report

**Version/date:** 0.2 / 2026-11-24  
**Decision status:** Awaiting owner selection; no Godot gameplay code or visual mockups created for this design yet.

## Brief and hard gates

- **Audience:** elementary-school children; exact grade range to be checked during prototype.
- **Purpose:** practice everyday financial decisions and introductory investment-risk thinking.
- **Platform/session:** Godot Web, GitHub Pages, single-player; target session 3–5 minutes.
- **Decision owner:** project owner.
- **Hard gates fixed before scoring:** exactly two levels; one primary interaction per level; both interactions require an applied money decision and produce visible feedback; no speed-only gate; completing a level grants its key even after a mistake; per-level scores and final progress recap; risk is represented without guaranteed returns, real-money services, or personal data; Godot Web deployment is feasible.
- **Educational diagnostic gate:** `R_edu >= 60` per game-design default. The user declined G/C hard-elimination thresholds; G/C remain diagnostic flags only.
- **Evidence sources:** [OECD PISA 2022 financial-literacy framework](https://www.oecd.org/en/publications/pisa-2022-assessment-and-analytical-framework_dfe0bf9c-en/full-report/component-4.html), [CFPB school-age saving activities](https://www.consumerfinance.gov/consumer-tools/money-as-you-grow/school-age-children-preteens/explore-saving/), and [SEC Investor.gov on risk and diversification](https://www.investor.gov/introduction-investing/getting-started/asset-allocation). These ground the concepts; they do not validate this game's effectiveness.

## Educational priorities

- **Selected profile:** Learning-first (selected by user before scoring).
- **Weights:** `L=.50`, `E=.15`, `M=.10`, `A=.25`.
- **Penalties:** `pG=.15`, `pC=.10`.
- **G/C hard gates:** none.
- **Indicators:** L: short concept scenarios and explanations; E: completion and voluntary replay; M: competence/willingness-to-retry pulse; A: completion, recovery and help use; G: random/rapid choice and skipped rationale; C: repeated instruction visits, confusion/help requests and difficulty explaining a decision.
- **Formula:** `R_edu = clamp(.50L + .15E + .10M + .25A - .15G - .10C, 0, 100)`.
- **Evidence label/confidence:** AI pre-score / low. No child playtest, teacher review, or financial educator review has been conducted.

## Tournament summary

- **Candidate population:** 8 concepts with materially different core verbs and feedback models.
- **Generations:** 4 passes (initial population plus 3 evolution rounds). Round 1 retained/simplified; round 2 recombined and specialized; round 3 removed pressure and repeated rules where learning evidence was weak. Stop condition: three distinct, feasible concepts remain and further edits change presentation more than the decision loop.
- **Review lenses:** five separated AI analysis passes: game-design depth; first-time child discoverability/accessibility; finance concept accuracy; assessment/validity; production/maintenance.
- **Limit:** the five lenses were run by one AI agent as separate passes, not independent human experts or participants. Treat scores as hypotheses.
- **Ranking:** Pareto fronts first, then minimum G/P/D dimension, then mean, then ID. For this non-research product, `research_validity` in the machine scorecard is interpreted as **Purpose Fit**; it is not a claim of formal study validity.
- **Thresholds:** G ≥ 75, Purpose Fit ≥ 75, D ≥ 75. Educational diagnostic below 60 does not advance absent a written exception.

### Iteration record

- **Round 0 — eight distinct concepts:** A–H varied the core verb across exploration, sorting, planning, simulation, investigation, branching, speed pressure, and quiz recall.
- **Round 1 — retain/simplify/specialize:** retained A's campus exploration; simplified B's allocation choices; specialized C's goal planning; converted D from changing weather to a fixed, explainable scenario; reduced E/F reading and joined clue evidence with story consequence.
- **Round 2 — recombine/mutate:** retained B's concrete resource movement; gave F an explicit “why this happened” explanation; added C's goal target before comparison; removed score bonuses for risk-seeking or fast clicking.
- **Round 3 — retire/freeze shortlist:** retired G for time-pressure/diagnostic failures and H for having no in-world consequence. B, F, and C remained mechanically distinct and passed the gates. A, D, and E remain eligible but rank lower under the predeclared Pareto tie-breaker.
- **Stop condition:** another round would mainly change story dressing or card art, not the three remaining decision loops; human selection is needed before a visual tournament.

## Initial candidates and evolutionary path

| ID | Concept and 30–60 second loop | Meaningful choice, consequence and recovery | Generation decision |
| --- | --- | --- | --- |
| A | **Starry School Quest:** inspect a top-down dream-school map, make one budget choice at the shop, then choose a seed-spreading plan in the investment garden. | A limited allowance forces prioritization; a fictional weather event shows that spreading risk can soften one setback, not guarantee profit. Mistakes show a short explanation and can be retried. | Retain. Preserve school exploration and key-gated progression; simplify each level to one deliberate choice. |
| B | **Wish Shop Budget Sort:** drag a fixed set of moon-coins into needs, savings goal, or wants; in level 2 allocate star-seeds among three fictional gardens, then reveal a fixed scenario. | Visible allocation bars and remaining balance show trade-offs. Retry costs no points or key; explanations reinforce why essentials/goals come first and why diversification only reduces concentration risk. | Retain and simplify. Two clear, visually distinct allocation tasks make the decision legible. |
| C | **Dream Goal Workshop:** set a savings target and arrange small weekly deposits; level 2 compare fictional investment cards by risk and time horizon. | Progress meter makes waiting visible; feedback explains higher uncertainty and possible loss. No real product names or return promises. | Retain; specialize savings planning in level 1 and risk comparison in level 2. |
| D | **Moonlight Garden:** choose which three beds to plant and observe a non-random weather event; level 1 decides how much to keep for a near-term goal. | Players compare liquidity and uncertainty, then inspect outcomes. Extra simulation rules may crowd out the simple learning decision. | Mutate into a smaller, fixed-outcome allocation task; retain as a finalist for risk-learning potential. |
| E | **Investment Clue Detective:** inspect three claims, identify an unsupported “guaranteed growth” promise; level 2 choose which evidence to trust before distributing seeds. | Clue inspection makes skepticism visible; clue density and reading load are risks for younger players. | Recombine with branching story feedback; retain “ask/check before acting” as a reusable teaching mechanism. |
| F | **Starry Choice Diary:** make one spending/saving decision in a short story; level 2 choose a response to a fictional investment downturn, with the ending reflecting the choice. | Branches make consequences memorable and support retrying another path. Risk: story text can hide the financial reasoning unless feedback names it. | Recombine with E's evidence clues; keep short scenes and explicit causal feedback. |
| G | **Timed Star Market Sprint:** race a clock to buy and sell through a rapidly moving market. | Speed creates pressure, but rewards fast guessing and confounds financial reasoning with reading/motor speed. | Retire: fails the no-speed-only gate and has `R_edu=58.75`, below the 60 diagnostic threshold. |
| H | **Dream Quiz Relay:** answer rapid money questions to collect points; the world state does not change. | Easy to implement, but does not require applying a decision or seeing its consequence. | Retire: fails the visible-consequence gate and has `R_edu=58.80`, below threshold. |

### Roles, success, duration, and cheapest prototype

| ID | Player role / ending condition | Expected session | Cheapest test for the riskiest assumption | Complexity |
| --- | --- | --- | --- | --- |
| A | A dream-school visitor reaches both rooms, makes a money choice in each, and collects both keys. | 4–5 min | Clickable 2D map with the two decisions; observe whether exploration delays the choices. | Medium |
| B | A young shop helper allocates a fixed purse, then plants three seed tokens; finishing both allocations opens the school gate. | 3–4 min | Two Godot card/token interactions with a balance bar and fixed outcome feedback. | Low |
| C | A dreamer reaches a savings target through small deposits, then compares two fictional risk cards; both keys complete the journal. | 3–4 min | Paper or clickable target meter plus two fictional investment cards. | Low |
| D | A garden keeper reserves money for a near-term goal, then spreads the rest across garden beds; completing both decisions ends the harvest. | 4–5 min | One fixed “weather” card and three allocation areas. | Medium |
| E | A night detective checks an investment claim, then chooses which sources to trust before the final gate opens. | 4–5 min | Three claim cards with one explanatory clue each; test reading load. | Medium |
| F | A journal keeper chooses a spending/saving response and later reacts to a fictional downturn; the story closes after two key decisions. | 3–5 min | Two short branching scenes and a visible cause/effect recap. | Low |
| G | A fast shopper tries to clear two timed counters and finish before the clock expires. | 2–3 min | A paper timer exercise (retired before prototype). | Low |
| H | A quiz contestant answers two sets of rapid recall prompts and reaches a point threshold. | 2–3 min | A static quiz card set (retired before prototype). | Low |

## Separated review-lens findings

1. **Game-design lens:** allocation, story choice, and exploration offer distinct loops. Use short turns and a clear failure recovery; avoid turning investment into a reflex game.
2. **First-time child lens:** concrete objects, few choices, icon-plus-text labels, and visible remaining coins are easier to discover than abstract percentages. Exact readability is untested.
3. **Finance-content lens:** needs/wants and a concrete savings goal fit school-age activities; investment feedback must state both uncertainty and possible loss. Diversification does not eliminate market risk.
4. **Assessment lens:** show the reason for a decision, not only the correct answer. Game scores are formative; they are not a validated test of financial literacy.
5. **Production lens:** two bounded Godot scenes, deterministic outcomes, one Blender key asset, and no external services are the lowest-maintenance scope. Web export templates are currently missing.

## Ranked shortlist

| Rank | ID | Concept | G | P (Purpose Fit) | D | R_edu | G/C flags | Evidence / confidence | Main advantage | Main risk | Next falsifiable test |
| ---: | --- | --- | ---: | ---: | ---: | ---: | --- | --- | --- | --- | --- |
| 1 | B | Wish Shop Budget Sort | 83 | 84 | 90 | 81.35 | none | AI pre-score / low | Clearest match between choice, financial trade-off, and visible feedback; small scope. | Drag-allocation may feel too puzzle-like; test whether children can explain the trade-off. | Ask a child with parent/teacher consent to complete each task and explain one choice; record success and explanation independently. |
| 2 | F | Starry Choice Diary | 84 | 82 | 91 | 79.60 | none | AI pre-score / low | Strong story motivation and recovery; efficient Godot/Web implementation. | Narrative can overshadow the financial concept. | Compare whether players can state why the branch changed the outcome without rereading the scene. |
| 3 | C | Dream Goal Workshop | 80 | 86 | 89 | 81.80 | none | AI pre-score / low | Strong learning and purpose fit with excellent feasibility; makes goal steps visible. | The comparison interaction could become too abstract unless represented with concrete cards and tokens. | Ask a child with parent/teacher consent to set a savings goal, then explain which fictional asset has more uncertainty. |

Machine Pareto order for the remaining eligible concepts: E (front 1, min 78, mean 83.33), A (front 2, min 81, mean 83.00), D (front 2, min 81, mean 81.33). They meet hard gates but fall outside the top three order; their mechanisms remain available for revision. The order follows Pareto front first, then minimum dimension, then mean. G and H are retired for the reasons above, not because of G/C hard thresholds.

## Educational diagnostic values for finalists

| ID | L | E | M | A | G | C | Calculation | Result |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- | ---: |
| B | 90 | 79 | 78 | 85 | 15 | 23 | 45 + 11.85 + 7.8 + 21.25 − 2.25 − 2.3 | 81.35 |
| F | 84 | 88 | 90 | 82 | 22 | 18 | 42 + 13.2 + 9 + 20.5 − 3.3 − 1.8 | 79.60 |
| C | 88 | 74 | 77 | 90 | 10 | 20 | 44 + 11.1 + 7.7 + 22.5 − 1.5 − 2 | 81.80 |

These normalized values are structured AI pre-scores, not observed outcomes. None reaches G ≥ 60 or C ≥ 70 diagnostic flags. R_edu is kept separate from G/P/D.

## Pareto order / rejected alternatives

- Eligible concepts are on Pareto front 1; tie-breaker order is the published minimum dimension, then mean. Candidate B leads by the higher minimum dimension among the shortlist; F precedes A.
- **Retired G:** speed-only pressure fails the fixed accessibility/learning gate; low R_edu.
- **Retired H:** quiz-only points do not change a world state or show causal feedback; low R_edu.
- No high mean score rescues either hard-gate failure.

## Recommendation

- **Recommended candidate:** B — Wish Shop Budget Sort.
- **Why it leads:** highest learning-first R_edu and highest minimum G/P/D score among the finalists, while keeping two interactions concrete and deterministic.
- **What remains uncertain:** whether children interpret “need/want” examples as intended; whether the investment garden is understandable without numerical abstractions; whether the scene text suits the chosen grade band.
- **Cheapest falsification test:** low-fidelity Godot interaction prototype with two fictional decisions and a short, consented, adult-supervised think-aloud session; no identifiable data collection.
- **User decision:** approved candidate `B` — Wish Shop Budget Sort, selected by the owner on 2026-11-24. Visual direction is a separate pending gate.

## Human decision

- Decision: approve
- Selected concept: B — Wish Shop Budget Sort
- Conditions/rationale: preserve the two distinct allocation interactions, visible consequences, recoverable errors, and fictional non-guaranteed outcomes.
- User approval date: 2026-11-24
