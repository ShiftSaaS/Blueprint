# Default rules R-01 – R-12 — v2.0 (from Lintent `handoff/rules/`, 2026-11-17)

Copy this table into the project's `AGENTS.md` ("Default rules, always loaded"); keep one file per rule in `handoff/rules/` when the
project is product-build or client-delivery. Each row: when it applies · what to do · what never to do.

| Rule | When | Do | Never |
|---|---|---|---|
| **R-01** Screenshots are manual | A task needs visual evidence; a live check | Create `tasks/<ID>-<slug>/screenshots/` (evidence only). The owner saves files there and says `added`; the agent reads, verifies and renames them. For a longer list, first write one `<name>.txt` **brief** per capture, checked before the owner reads it: **GUARD** a source line for every button the brief says to press · **FILE** only a file the owner named, never one a sibling task holds, never a third party's · **TIME** the capture file's saved time is the clock. A `.txt` left = not captured | Treat an image pasted in chat as evidence (even one showing a path); copy, convert or move chat images into `screenshots/`; say "send it here and I'll save it" |
| **R-02** No evidence, no tick | Ticking an item, writing "verified", closing | Only with saved, re-checkable evidence. Skipping needs `skip evidence <ID>: <item>` | Accept `close <ID>` or a question as that phrase |
| **R-03** Records in English | Writing anything into a repo | English; the owner's words rendered in English, marked "(translated from <language>)". Chat stays in the owner's language | Paste the owner's language verbatim into a record |
| **R-04** Task IDs follow execution order | A DECISION inserts or re-orders tasks | Renumber the not-yet-started candidates so the next task after the last started one takes the next number; log old → new | Renumber a started or Done task |
| **R-05** Stage IDs follow execution order | A DECISION opens, inserts or re-orders stages | `STAGE_1 … STAGE_n` = run order; renumber only not-yet-started stages; log it | Renumber a running or closed stage |
| **R-06** Close commits by kind | Closing a task | Four commits: code + tests (green at that commit) · the task folder · the records · the README link to the code commit; messages `type(ID): message` | One commit per file; author or stage in the message; `git add -A` |
| **R-07** ROOT is a principle | Writing a Golden Thread; its live check | ROOT = one principle sentence; the request / DECISION goes in its child line; at the live check re-read the touched screens whole against it | Use the owner's request as ROOT |
| **R-08** Open task = flat file | Golden Thread → close | Keep an open task as `tasks/<ID>-<slug>.md`; the folder holds only `screenshots/` / `evidence/` until the close moves the file in as `README.md`; a sub-task lives inside its parent's folder | Write an open task as `<ID>-<slug>/README.md` (a README there means closed) |
| **R-09** Review after close, by another agent | A numbered task is closed | The other agent reviews read-only (`review/R-09-review.md`); `verify review` reproduces every finding; reproduced in-scope defects → sub-tasks `<ID>.N`, built before the next task after `agree review`; then `## Review coverage` in the parent. Run *Checks learned* before every close | Review your own task as the reviewer; start the next Golden Thread before the review is agreed (unless `skip review <ID>`); turn an unreproduced finding into a task |
| **R-10** Known commands; Task path | The owner writes anything; every answer | Move a gate only on a registered command ([commands.md](commands.md)); ask an unanswered check again; write `## Task path`; end every answer with the [action card](action-card.md) | Invent a command in chat; take your own proposal as the owner's answer |
| **R-11** Reviews name their level | Any review | State the level and its source first ([reviews.md](reviews.md): L1 task · L2 parent ↔ child · L3 flow · L4 people · L5 code · performance); anything sent outside only per `approve live` | Answer another level's question; send captures of a third party's design |
| **R-12** Name things by meaning | Records, cards, replies | Name options by what they mean ("Figma-first, then code"); a code may follow the name, never replace it | Offer "A / B / C" with no meaning attached (the owner's literal commands and record IDs excepted) |

## Also in every AGENTS.md (the "every agent" table)

| | |
|---|---|
| **Start** | Read the hub (`handoff/README.md`) and the one file in `docs/status/` |
| **Another session?** | `docs/status/IN_PROGRESS.md` present, a RUNNING / STALE heartbeat ([live-view](live-view/README.md)), or uncommitted edits you didn't make → don't start overlapping work; say so. Resuming STALE work needs the owner's word |
| **Record IDs** | `<P>_ANALYSIS_N` / `<P>_DECISION_N`; each repo numbers its own from 1 and prefixes its own |
| **Sibling work** | Work that belongs to another repo is never done from this repo's session: a `⇄ PENDING for <repo>` line in HANDOFFS, this step `⏸ blocked by <repo>`. A proposal said only in chat is not a handoff. The one exception: rule text, edited in every repo in the same change |
| **ANALYSIS / DECISION** | Only for the product and business (incl. its code, quality and release). Repo setup, workflow and agent tooling → SETUP_N, never an ANALYSIS. Laconic: tables and short bullets, History append-only |
| **Changing a rule** | Edit `AGENTS.md` (and the rule file) in every repo in one change; a check script (`check:agents`) passes before the commit |
| **Commits** | Each tool commits under its own identity; only on `commit` or as part of a close |
| **Never** | Distribute a build, submit to a store, send anything to an outside party, or touch production without `approve live` each time; drafts (emails, listing text) stay drafts — the owner sends them |
