# Profile — custom (and core-lite) — v2.0

**Use when:** the project is small, short or unusual — a one-off script, an internal tool, a data analysis, an infra change,
a proof of concept — and the full process would cost more than it protects.

## core-lite (instead of the full core)
| Keep | Drop or defer |
|---|---|
| `AGENTS.md` (short) + `CLAUDE.md` | strategy register, stages, cross-repo sync |
| `docs/status/` one file (PAST → CURRENT → FUTURE) | separate analysis/decision folders — one `NOTES.md` with dated findings and choices instead |
| `docs/board.md` (To Do / Doing / Done) | Golden Thread on every task — required only for changes to shared/production systems |
| Gates: `implement <ID>`, `close <ID>`, `skip evidence <ID>: <item>`, `approve live` | scope review, sub-task review chains, flow register |
| The [action card](../core/action-card.md) at the end of every answer (rows: Type · Who acts · Changes · Does) | stage tags ①–⑤ (optional) |
| R-01 (chat images never count), R-02, R-03, R-10, R-12 from [rules.md](../core/rules.md) | R-04 – R-09, R-11 until the project grows |
| Evidence before done (files or recorded checks) | four-commit close (one commit per task is fine) |

## Growing out of lite
When a lite project gains a second repository, a client approval chain, a production environment or another execution host, run the
checklist again and switch to the matching full profiles; keep the existing IDs.

## A new profile
If the checklist answers fit no profile, draft `profiles/<name>.md` from them (what it adds to core, what it drops, evidence type,
guardrails), show it to the owner, and use it only after approval. Record it in README History with a version bump.
