<!-- v1 reference (PAC instance, 2026-10-15/16). Superseded in v2.0 by commands.md (register), rules.md (R-01–R-12), action-card.md and reviews.md — read those first; keep this file for its §§ on Golden Thread, evidence and closing order. -->
<!-- Reference instance copied from PAC/Source/docs/execution/conventions.md on 2026-10-15 (blueprint v1). Replace project-specific names (PAC, PAC_, P0.x, paths) when instantiating. -->

# Conventions — how a PAC task moves from idea to commit

| | |
|---|---|
| **Kind** | 📐 Process — the steps every task follows and the phrase that moves each gate |
| **Adapted from** | Lintent `Code/handoff/conventions.md`, `Code/docs/execution/task-flow/README.md` v1.3 and rules R-01–R-10 |
| **Last verified** | 2026-10-15 |

## At a glance

| § | Rule | One line |
|---|---|---|
| [0](#0-gates-move-only-on-an-explicit-phrase) | Gates move only on an explicit phrase | A question is not a waiver; unclear = not given |
| [1](#1-golden-thread-before-any-change) | Golden Thread before any change | Scope in writing, then build |
| [2](#2-read-the-source-before-scoping) | Read the source before scoping | `repo/path:line`; the handover doc is a claim until checked |
| [3](#3-one-proxy-per-task) | One PROXY per task | Adjacent findings → open-questions or a new task |
| [4](#4-live-progress) | Live progress | Status file + task file in the same turn; pause before the least reversible step |
| [5](#5-evidence-before-done) | Evidence before done | No evidence, no tick |
| [6](#6-closing-a-task) | Closing a task | Checklist; stop at the first unmet step |
| [7](#7-commits) | Commits | Hub: by kind, `type(ID): message`. Client repos: the client's branch rules |
| [8](#8-the-action-card) | Action card | Every answer ends with who acts next and the exact command |

## 0. Gates move only on an explicit phrase

**Known commands** — nothing else moves a gate:

| Command | In phase | Moves to / does |
|---|---|---|
| `write PAC_ANALYSIS_N` · `write PAC_DECISION_N` | IDLE | DISCUSSING — the record is written |
| `approve PAC_DECISION_N[, option]` | DISCUSSING | READY — rows move from Backlog to To Do |
| `amend PAC_DECISION_N: <change>` | READY (no task of the decision started, or the change spares started ones) | Changes an accepted decision's roadmap (reorder / cut / add): dated History bullet, roadmap table, board and status in one change; not-started IDs renumbered, every citation updated |
| `Golden Thread <ID>` | READY | DISCUSSING — scope + owner checks written; no source/config/machine change |
| `implement <ID>` | DISCUSSING (checks answered) | EXECUTING → VERIFYING |
| `approve live <ID>: <action>` | EXECUTING · VERIFYING | No phase change; authorizes exactly one named action outside the workstation (e.g. a query on the shared DEV DB that writes data) |
| `added` | VERIFYING | The AI reads the evidence files the owner saved |
| `skip evidence for <ID>: <item>` | VERIFYING | One evidence item waived, quoted in the task |
| `close <ID>` | VERIFYING | CLOSING — README, records, commit plan |
| `commit` | any | Commits exactly the listed files (hub only) |
| `review <ID>` | after close | Optional second-agent review, read-only |

Rules: (1) a question is not a waiver — answer it, then give the exact phrase; (2) unclear = not given, ask once and name the gate;
(3) one gate, one task, one time — approval never carries over; (4) before writing a Done row, a closed README or a commit, name
the gate and the phrase that passed it; (5) a gate passed without its phrase → say so and correct it with a new change.

**Setup tasks (P0.x) on the owner's Windows machine:** the AI cannot reach that machine. "implement" there means the AI gives the
exact steps/commands for the next step, the owner runs them, and saves the output/screenshots as evidence; the AI reads them.

## 1. Golden Thread before any change

Every task file has the shape in [task-template.md](task-template.md). The Golden Thread is a visible chain:

```text
ROOT                    a general principle (the owner's request goes in the child line, never as ROOT)
LOCATE (src)            exact locations — where, not yet why it's wrong
AS-BUILT EVIDENCE       what was observed (or INVESTIGATION / EVIDENCE TO ESTABLISH + DECISION GATE when unknown)
VIOLATION IDENTIFIED    only what the evidence establishes
PROXY (title)           the intended behavior, no implementation detail
CONCRETE CHANGE         always: see "## Change" above
```

Use the lean shape (no evidence node) when the owner handed over unambiguous proof. Use INVESTIGATION + DECISION GATE when
`## Done when` is conditional ("confirm whether …"). Setup tasks are usually investigations: the outcome is not known until run.

## 2. Read the source before scoping

Read the relevant file before proposing; cite `repo/path:line`. The handover document (`01-Local-Environment-Setup.docx`) and the
source snapshot can disagree — PAC_ANALYSIS_1 already lists such cases. When they disagree, the cloned repository on the branch in
use wins, and the difference is recorded.

## 3. One PROXY per task

Don't fold adjacent issues in. Record them in [open-questions.md](../open-questions.md) (or a follow-up task if already proven and
in scope of an approved decision) and cross-reference them under *Explicitly deferred*.

## 4. Live progress

The status file and the task's `## Live progress` change in the same turn. Pause before the least reversible step (restoring over an
existing database, creating IIS sites, publishing over a running site, running any job that writes data or sends e-mail).

## 5. Evidence before done

- **No evidence, no tick.** A `[x]` needs a saved file (screenshot, command output, log excerpt) or a recorded check.
- Evidence lives in the task folder: `specs/tasks/<ID>-<slug>/evidence/` (command output, `NN-what-it-proves.txt`) and
  `screenshots/` (`NN-what-it-proves.png`). The owner saves files there and says `added`; the AI reads every file before citing it.
- Images pasted in chat are not saved evidence. A waiver needs `skip evidence for <ID>: <item>`.
- **Never** save a secret in evidence: mask passwords in connection strings, never copy key files.

## 6. Closing a task

Stop at the first unmet step:

| # | Step |
|---|---|
| 0 | `evidence/00-verification.md` — one table: each Done-when item · how checked · result (✓ / ✗ / not proven) · evidence file · where it ran |
| 1 | Evidence saved, read, renamed `NN-…` in Done-when order |
| 2 | Flat `PX.Y-slug.md` → `PX.Y-slug/README.md` (content unchanged + `[x]` only where backed + `## As-built evidence` + `## Live progress (closed <date>)` + `**Status: Done.**`); delete the flat file |
| 3 | Repair links (`grep -rln "PX.Y-slug.md" docs/`) |
| 4 | Board row → 🟢 Done (link text = the finalized ROOT); reconcile the source decision (Records, Status, Next, History) |
| 5 | Status reset: next task's `WAITING_FOR_YOUR_ACTION.md` or `WAITING_FOR_NEW_TASK.md` |
| 6 | Report: items ticked, what was confirmed without a file, commits, next per the board |

## 7. Commits

- **Hub (`Source/docs`, `Source/AGENTS.md`)** — only if the hub is a git repository (an owner check in PAC_DECISION_1). Stage an explicit
  file list, never `git add -A`. Close commits by kind: `docs(<ID>): evidence`, `chore(<ID>): records`. Message `type(ID): message`.
- **Client repositories** — branch `CR/<JIRA-KEY>` from `production_v4`; merge `--no-ff` after review/UAT sign-off; **no push without the
  project lead's approval**. `Pac.Admin/PAC.Admin.csproj` is git-ignored in migration-pac-admin: verify project-file edits explicitly.
  Shared projects exist as copies (`PAC.SharedFunctions`, `Pac.Business`, `PAC.Reporting.Business`): change every copy.
- Attribution from your own tool's session only; never a Claude line from a tool that isn't Claude.

## 8. The action card

Every answer ends with (Markdown, not a code block), **in this order**:

1. **Child — 👤 YOU ACT** (or **⚙️ AGENT ACTS · <tool>**). One command: a single line. Several steps: the header names the row of the
   parent table it expands, then numbered sub-steps of **that row only**, done ones kept with ✓, then what to send back.

> **👤 YOU ACT — ▶ Row N: <what this row does>**
> N.1 ✓ <done sub-step>
> N.2 <next sub-step — one action, where, what to click or type>
> **Send back:** <what the AI needs, without personal data>

2. **Task · Flow · Next**

| | |
|---|---|
| **Task** | `<ID>` or None |
| **Flow** | ● <P>_ANALYSIS_N ── ● <P>_DECISION_N ── ● Board ▸ ● … ── ◉ **current** ── ○ ahead (● passed · ◉ current · ○ ahead) |
| **Next** | from → to, and its condition |

3. **Parent — the command table**, rows in execution order, literal commands only (never a label or a description in the command
   column). Status: ✓ done · ▶ current (the row the child expands) · ○ ahead.

| # | Status | Where | Command |
|---|:---:|---|---|
| 1 | ▶ | <host / app> | `<literal command or URL>` |
| 2 | ○ | Chat | `<known command>` |

When the current row is done, the next answer moves ▶ to the next row and the child expands that row.

## History

- **2026-10-15** — Created from the Lintent conventions at the owner's request ("learn how Lintent keeps docs for each repo and apply it to
  PAC/Source/docs", translated from Vietnamese). Strategy register, stages and mandatory cross-agent review left out (see docs/README.md).
- **2026-10-15** — `amend PAC_DECISION_N: <change>` added to the register (owner: `amend PAC_DECISION_1: local-first order`), as the PAC form of
  Lintent's "approve roadmap, change: …".
