# Profile — product-build — v2.0

**Use when:** the owner owns the repositories and the work comes from product hypotheses (reference: Lintent — Code, API, Landing).

| Adds to core | Detail |
|---|---|
| Docs inside each repo | `docs/` per repo; one repo hosts the hub (`handoff/README.md`) for all; each `AGENTS.md` is the single rule source, `CLAUDE.md` = `@AGENTS.md`; a `check:agents` script checks every repo cites the same rules |
| Strategy register | One register (S-numbers); sibling repos name the strategy they serve; a graduation / override row when a sibling starts work the gate would hold |
| Stages | `STAGE_N_tasks|validation.md`, numbered in run order (R-05); a hard stop before user testing; only defects pass it |
| Cross-repo | Sibling work never done here: `⇄ PENDING for <repo>` + `⏸ blocked by <repo>`; the sibling's go-ahead (`ok, <name>`) picks it up; rule text is the one shared edit. Record IDs prefixed per repo |
| Reviews | Scope review before code (`review scope`), R-09 after close with a standing approval for one read-only CLI command, sub-tasks `<ID>.N`, Review coverage, Checks learned ([reviews.md](../core/reviews.md)) |
| Flow register | `docs/execution/flows/` — every user flow (F-IDs) and journey; a task names *Flows touched*; the close updates them (step 5b); L3 reviews read it |
| Evidence | UI captures through `.txt` briefs (R-01 GUARD · FILE · TIME); "before" capture on today's build first; a pilot build held for live checks; tests red before, green after; `.http` files for services |
| Close extras | Verification report `evidence/00-verification.md`; flow register; **sibling sync** — a change to something a sibling shows (palette, screens) leaves a `⇄ PENDING` line for it (step 5c) |
| Triage | After each close + review: look at the product whole before the next row; findings → open questions or an ANALYSIS, never straight onto the board |
| Live view | The heartbeat hook in every repo ([live-view](../core/live-view/README.md)) |
| Release | Deploys to the owner's cloud only with `approve live <ID>: <action>`; a store submission only by the owner |

Reference instance: `/Users/macbook/Documents/Work/Lintent/{Code,API,Landing}` — `AGENTS.md`, `Code/handoff/`, `Code/docs/execution/`
(pathway, playbook, flows), `Code/docs/setup/`. Read them; never copy their product data (file names, people, clients) into a new project.
