# Reviews — v2.0 (from Lintent R-09, R-11 and pathway v1.6, 2026-11-17)

Two agents check each other: the one that did **not** write a piece of work reviews it, read-only. A review is information to weigh —
nothing becomes a task unless the builder reproduced it and the owner agreed.

## Levels (R-11) — a review states its level and source in its first line

| Level | Checks | Against | Who | When |
|---|---|---|---|---|
| **L1 · Task** | Is the task's change right? | its ROOT, Done when, DECISION | the other agent (R-09) | after a numbered task's close |
| **L2 · Parent ↔ child** | Did the sub-tasks fix what the parent's review found? | the parent review's own reproductions, re-run | the builder → `## Review coverage` | after the last sub-task |
| **L3 · Flow** | Does each step of each user flow read right to a first-time person? | the flow register (`docs/execution/flows/`), from the owner's captures | the other agent | before user testing; after tasks that change a flow |
| **L4 · People** | Do real people understand and finish the flows? | the validation stage's probes | testers with the owner | a validation stage |
| **L5 · Code quality** | Is the codebase as a whole sound? | the L5 checklist below | the other agent, read-only, per `approve live` | while waiting; before a release |
| **Perf** | Fast and complete enough? | a time per input size, from the product's own log | the builder | before testing; before a release |

Reviews of a whole run live in `docs/execution/reviews/<date>-<kind>/` (README · review.md · verify.md · tool outputs).

## Before code — scope review (`review scope <ID>`)

- Required for a numbered task born from a DECISION; optional for a defect fix; none for a sub-task or a records-only task.
- One send, read-only, the filled prompt only: trace (ANALYSIS → DECISION → task), coverage, ROOT, LOCATE (does the cited code say so?), flows.
- The builder reproduces each finding (✓ · ◐ · ✗) the same turn and writes `## Golden Thread review`; in-scope → revise the Golden Thread.

## After close — R-09

1. The close commits land; the builder runs the other agent's CLI itself when the owner gave a **standing approval** for exactly that
   command, else writes `⇄ REVIEW PENDING for <reviewer>` and the owner runs it. Example (Codex, read-only, one repo):
   ```
   codex exec -s read-only -C <repo> -o docs/execution/specs/tasks/<ID>-<slug>/review/R-09-review.md \
     "R-09 review <ID> — follow handoff/rules/R-09-…md. You are read-only: return the review as your final message."
   ```
   The `-o` folder must exist first.
2. `verify review <ID>` — reproduce **every** finding (input → output, file:line); mark reproduced · observed · hypothesis · not reproduced.
3. Route: reproduced in-scope defect → sub-task `<ID>.N` (one per PROXY) · product question → open questions / ANALYSIS · not
   reproduced → recorded, no task · owner's `no task <finding>` → recorded with the reason.
4. `agree review <ID>` → commit the review; build the sub-tasks; then `## Review coverage` in the parent (each finding ✓ / ◐ / ✗,
   backed by re-running the parent review's reproductions — never a sub-task's word alone).
5. A new kind of defect → one line in **Checks learned**, run before every later close.

Finding IDs: D defect · Q product question · N next-step problem, numbered per review.

## Checks learned — a portable starter set

| # | Check |
|---|---|
| 1 | Every name one output refers to exists in the output it points at |
| 2 | A count said in more than one place is the same count everywhere |
| 3 | A promise in the UI's words holds for every item it names |
| 4 | Inputs beyond the fixture: quotes, slashes, case-only differences, empty values, an older stored shape |
| 5 | Keys from user data never walk inherited properties (`__proto__`, `constructor`) |
| 6 | Escaping covers every control character and decodes back to the original |
| 7 | A recursive walk over untrusted input is iterative or depth-bounded — a validator returns, never throws |
| 8 | An outside API is used as the **installed** version defines it — read its types or probe first, never from memory |
| 9 | A write to two stores is checked in both — a partial write fails closed |
| 10 | A guard and the check it stands in for read the same object |
| 11 | A record keyed by an identity that can come back is read as prior state before the new event overwrites it |
| 12 | A public sentence keeps every boundary its evidence states (which build, which input, how many runs) |
| 13 | A cause stated from counts alone holds for every set with those counts — else say the counts, not the cause |
| 14 | A known failure reports as KNOWN, never PASS |

## L5 — code-quality checklist (start here; the owner adds project rows)

| # | Check |
|---|---|
| 1 | The platform's hard boundaries hold (threads, sandboxes, entry points) |
| 2 | The project's code conventions (one entry per rule, cited from code comments) |
| 3 | Baselines don't grow: type errors, lint count, build, tests — recorded at each close |
| 4 | Pure logic is tested; an untested domain module is listed |
| 5 | Checks learned hold across the codebase, not only in the last task |
| 6 | Dead code and leftovers of removed features |
| 7 | Secrets and network: no credential in a build; network only where declared |
| 8 | A junior developer can read a module and debug it: one job per file; names say what a thing is; the path from a control to the code that runs can be followed by reading; comments say why; files over ~400 lines and functions over ~80 lines listed with what they mix |
