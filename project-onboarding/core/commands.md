# Known commands — v2.0 (from Lintent pathway v1.11, 2026-10-24)

The owner's exact phrases that move a gate. **Nothing else moves one**: a question is not a waiver, an unclear phrase means "not given",
a repeated command that a rule blocks is still blocked. Anything not in this register is answered or drafted, never acted on as a gate;
when one would need a gate, the agent names the command for it.

**One grammar:** verb first, then the object, then the ID — no "for", no trailing "agreed". `<P>` = the project code (`PAC_DECISION_3`);
sibling repos prefix their own records the same way.

## The diagram

```text
Decide (docs/strategy)                 Do (docs/execution/specs)
IDLE ─write ANALYSIS─▶ DISCUSSING       READY ─Golden Thread─▶ DISCUSSING ─implement─▶ EXECUTING ─▶ VERIFYING
     ─write DECISION─▶ DISCUSSING   ─approve DECISION─▶ READY        (review scope ↺)            (added ↺)
                                         VERIFYING ─close─▶ CLOSING ─commits─▶ REVIEW ─agree review─▶ READY / IDLE
```

One phase at a time; the status file's PHASE names it. A sub-task `<ID>.N` is born from its parent's review, not a DECISION.

## ① Decide — whether, and what

| Command | Writes | Next |
|---|---|---|
| `write <P>_ANALYSIS_N` | `docs/strategy/analysis/<P>_ANALYSIS_N_<date>.md` + index row (findings, options, plan / effort / protects / gaps each) | `write <P>_DECISION_N` |
| `write <P>_DECISION_N` | `docs/strategy/decision/…` + index row (options, recommendation) | `approve <P>_DECISION_N[, option]` |
| `approve <P>_DECISION_N[, option]` | Board rows, stage file, renumbering (R-04), status | `Golden Thread <ID>` |
| `write SETUP_N` / `approve SETUP_N` | How the repos are run (workflow, tooling) — never an ANALYSIS / DECISION; `docs/setup/SETUP_N_<date>.md`: Problem · Decision · Scope · Impact, ≤ 3 bullets each; approved → one `chore(SETUP_N)` commit, or a setup task when it needs a build and evidence | — |
| `ok, <name>` | A named go-ahead the card offered (a setup change, picking up a sibling's handoff) | — |

## ② Scope — how

| Command | Writes | Next |
|---|---|---|
| `Golden Thread <ID>` | The open task as a flat file `tasks/<ID>-<slug>.md` (ROOT … Done when, Task path), board link, status. Again = revise | `review scope <ID>` |
| `review scope <ID>` | Approves **one** send: the other agent, read-only, reviews the scope before code → `evidence/GT-review.md`; the builder verifies every finding the same turn | `Golden Thread <ID>` (revise) · `implement <ID>` |
| `skip scope review <ID>` | The waiver and its reason in the task | `implement <ID>` |
| `<letter><n>` (`a1`, `b2`) | The answer to an open owner check in the task | — |

## ③ Build and verify

| Command | Writes | Next |
|---|---|---|
| `implement <ID>` | Tests first (red on today's code), then the change; the "before" evidence before any rebuild that would hide the bug | live check |
| `added` | The owner saved captures / files in the task folder: the agent reads, verifies, renames | more captures · `close <ID>` |
| `skip evidence <ID>: <item>` | The skip and the substitute evidence in the task — the **only** way to accept a missing item | — |

## ④ Close and review

| Command | Writes | Next |
|---|---|---|
| `close <ID>` | The close checklist ([rules.md](rules.md) R-06, R-08; [conventions](conventions.reference.md)): verification report, folder README, board, records, checks, commits by kind | the other agent's review runs |
| `verify review <ID>` | Reproduces every review finding; `## Post-close review` in the task | `agree review <ID>` |
| `agree review <ID>` | Commits the review; reproduced in-scope defects → sub-tasks `<ID>.N` | sub-tasks, then the next Golden Thread |
| `skip review <ID>` · `rerun review <ID>` · `no task <finding>` | As named | — |

## ⑤ Runs

| Command | Does |
|---|---|
| `commit` | Commits the listed records (never `git add -A` / `git add .`) |
| `review flow` · `review performance` · `review code` | A review at that level ([reviews.md](reviews.md)) |
| `approve live <ID>: <action>` | One named outside action (a deploy to a named environment, a send, a credential) — one per command, recorded in the task; production, real credentials and DNS are never implied |
| `call STAGE_N` | Opens a validation stage (people, not code) |

Every task file ends with `## Task path`: the pathway version, its variants, **Origin**, **Planned** (at the Golden Thread) and
**Actual** (at the close).
