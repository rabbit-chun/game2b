# Requirements baseline v0.4

## Functional requirements

| ID | Requirement | Acceptance example |
| --- | --- | --- |
| FR-01 | Provide exactly two playable levels. | Map exposes two levels; level 2 is gated by the first key. |
| FR-02 | Each level contains one primary interaction unit teaching an applicable money decision. For selected gameplay B, level 1 allocates a fixed 10-coin purse among need/savings/want; level 2 allocates fictional star-seeds across gardens and observes a fixed scenario. | Each level's main interaction is distinct and resolves with visible feedback. |
| FR-03 | Completing a level awards its key, regardless of score, to avoid trapping a learner. | A low-scoring player still unlocks the next level. |
| FR-04 | Display a score for each level. | Each score is visible on its result and final summary. |
| FR-05 | Show an end-of-game learning progress summary. | It names the concepts practiced, not just a total score. |
| FR-06 | Teach needs/wants, planning or saving goals, and investment uncertainty/risk at an age-appropriate level. | Scenario feedback describes the cause of each outcome. |
| FR-07 | Integrate the Blender-made key asset into the game. | Imported GLB is visible as the key reward in Godot. |
| FR-08 | Provide a Godot Web build deployable as a static site. | Root `index.html` and its companion files load from `/game2b/`. |
| FR-09 | Keep the experience single-player and free of real financial services. | No account, personal data, real-money choice, or personalized recommendation. |

## Non-functional requirements

| ID | Requirement | Acceptance example |
| --- | --- | --- |
| NFR-01 | Traditional Chinese interface with child-readable wording. | Instructions and feedback use short, concrete sentences. |
| NFR-02 | Support desktop and mobile browser input. | Pointer/touch and keyboard focus can operate the interactions. |
| NFR-03 | Avoid speed-dependent scoring and allow recovery from mistakes. | Wrong choices receive explanatory feedback and can be retried. |
| NFR-04 | Do not persist personal information. | Refresh resets session state; browser storage contains no identifiers. |
| NFR-05 | Deploy from GitHub Pages with correct relative paths. | Assets resolve beneath `/game2b/`, not `/`. |
| NFR-06 | Use Godot 4.7.2 and commit the Web export preset/source. | A clean checkout imports and exports with matching templates. |

## Visual direction update

- D-008 supersedes the earlier Moonlight Toybox selection with the owner's attached warm pixel-art shop interior.
- Use crisp pixel edges, brick and wood surfaces, bookshelves, counter, rug, furniture, and plants; keep UI panels and controls readable in warm parchment and wood colors.
- Preserve the Blender GLB as a visible 3D key reveal on level rewards.

## Locked educational diagnostic

- Profile: **Learning-first**, selected by user.
- Positive weights: `L=0.50`, `E=0.15`, `M=0.10`, `A=0.25`.
- Penalty coefficients: `pG=0.15`, `pC=0.10`.
- Formula: `R_edu = clamp(0.50L + 0.15E + 0.10M + 0.25A - 0.15G - 0.10C, 0, 100)`.
- No G/C hard-elimination thresholds, selected by user. Skill-default diagnostic threshold `R_edu >= 60` is retained; a score below 60 does not advance without a written exception.
- Proposed observations: L from short pre/post concept scenarios and explanation quality; E from completion and voluntary replay; M from a brief competence/willingness-to-retry item; A from completion, error recovery, and help use; G from random/rapid selections and skipping explanation; C from repeated instruction visits, confusion/help requests, and difficulty explaining a choice.
- All current candidate values are **AI pre-scores**, not player evidence.
