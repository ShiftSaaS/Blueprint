<!-- Reference instance copied from PAC/Source/AGENTS.md on 2026-10-15 (blueprint v1). Replace project-specific names (PAC, PAC_, P0.x, paths) when instantiating. -->

# PAC Online workspace — AGENTS.md

> Root index — **the single source of rules for every agent** in this workspace (Claude Code loads it through `CLAUDE.md`).
> Adapted from the Lintent workspace convention (`/Users/macbook/Documents/Work/Lintent/{Code,API,Landing}`), trimmed for a
> client-owned, three-repository .NET project. Last verified: 2026-10-15.

---

## What this workspace is

`Source/` is the **parent folder** that holds the three PAC repositories side by side, plus this documentation hub:

```text
Source/
├── AGENTS.md / CLAUDE.md      rules for every agent (this file)
├── docs/                      the hub: status, board, analyses, decisions, architecture, task records
├── migration-pac-admin/       GitLab mddi-pac-admin      (PAC Admin + shared Telerik DLLs)   — not cloned yet
├── migration-pac/             GitLab mddi-pac-online     (PAC Online public portal)          — not cloned yet
└── migration-pac-schedule/    GitLab mddi-pac-scheduled  (PAC Scheduled console jobs)        — not cloned yet
```

PAC Online is the Press Accreditation Card system of MDDI, Singapore: .NET Framework 4.8, ASP.NET Web Forms / MVC 5, EF6,
IIS, SQL Server. It **builds and runs on Windows only**. System map: [docs/architecture/README.md](docs/architecture/README.md).

**Why one hub instead of `docs/` in each repo (as Lintent does):** the three repositories belong to the client (Decision Science
GitLab, group `mci/sitefinity`). Our working records must not be pushed into them. The folder names `migration-pac*` are fixed by
the cross-repository Telerik references, so the hub sits beside them, not inside them.

## Every agent (Claude, Codex, any AGENTS.md-aware tool)

| | |
|---|---|
| **First thing, every session** | Read `docs/status/` (exactly one status file + `history/`). It names what is pending now and who acts next |
| **Another session?** | `docs/status/IN_PROGRESS.md` present, or uncommitted edits you didn't make → don't start overlapping work; say so |
| **Record IDs** | `PAC_ANALYSIS_N`, `PAC_DECISION_N` (numbered from 1) · tasks `PX.Y` (`P0.x` = environment setup; later initiatives in [docs/README.md](docs/README.md#naming)) · sub-tasks `PX.Y.N` |
| **Language** | Records in English; the owner's words translated and marked "(translated from Vietnamese)"; chat in the owner's language (Vietnamese) |
| **Gates** | Move only on an explicit known command ([conventions §0](docs/execution/conventions.md#0-gates-move-only-on-an-explicit-phrase)) — a question is not a waiver; unclear means not given, so ask |
| **Code facts** | Read the source before stating a fact; cite `repo/path:line`. Never "presumably". The handover document is a claim until checked against source |
| **Every answer ends with** | The action card ([conventions §8](docs/execution/conventions.md#8-the-action-card)): who acts next in bold, then Task · Flow · Next, then the exact commands |

## Release and safety guardrails (PAC-specific — never relaxed by an earlier approval)

| Never, without the owner's explicit approval each time | Why |
|---|---|
| Point a local build, IIS site or scheduled job at the **UAT or PROD** databases (`rds-mcis-uatiz-…`, `rds-mcis-prdiz-…`) | Those strings sit commented-out in the same config files; a wrong `data source=` touches government data |
| **Push** to the client GitLab, or merge into `production_v4` | Pushing requires the project lead's approval (handover doc §4.1) |
| Deploy to UAT / PROD, or change anything on a server | Out of scope for the local environment; separate procedure (handover doc 3, not yet received) |
| Run a scheduled job other than `100` before every recipient e-mail key points at the owner's own mailbox | Reminder jobs send real e-mails to addresses in the DEV data |
| Run mass updates or the reporting full rebuild (`PAC.Reporting.Scheduled.exe 2`) on the **shared** DEV database `192.168.80.218` | Shared by the whole team |
| Commit or copy into `docs/` any secret: passwords, `sp.pfx`, private keys, connection strings with credentials | Records are plain text and may be shared |
| Commit local config (paths, passwords, publish profiles, the local `PacPublicLogin.ascx` variant) | Use `git update-index --skip-worktree <file>` |

Approval form for a live action: `approve live <ID>: <action>` — one action per command, recorded in the task.

## Detailed docs

| Topic | File |
|---|---|
| Structure, workflow (analysis → decision → board → task → verification), naming | [docs/README.md](docs/README.md) |
| Current status — one file, the pending action and the exact command | [docs/status/](docs/status/) |
| Task board — the only task table | [docs/execution/specs/board.md](docs/execution/specs/board.md) |
| How a task moves: gates, Golden Thread, evidence, closing, commits, action card | [docs/execution/conventions.md](docs/execution/conventions.md) |
| Task file template | [docs/execution/task-template.md](docs/execution/task-template.md) |
| System landscape, config map, verified cross-repo dependencies | [docs/architecture/README.md](docs/architecture/README.md) |
| Evidence records / decisions — index tables show which decision drives action | [docs/analysis/README.md](docs/analysis/README.md), [docs/decision/README.md](docs/decision/README.md) |
| Raised ideas and findings that are not tasks yet | [docs/open-questions.md](docs/open-questions.md) |

## Source material (outside this folder, read-only)

| What | Where (owner's Mac) |
|---|---|
| Handover document 1 — Local Development Environment Setup (v1.0, 17 Sep 2026) | `/Users/macbook/Workspaces/Work/Temus/PAC/PAC-Local-Environment-Setup/01-Local-Environment-Setup.docx` |
| Source snapshot of the three repos (zip + extracted, **no `.git`**) | `…/PAC-Local-Environment-Setup/Source Code/mddi-pac-{admin,online,scheduled}-production_v4` |
| Database backups of DEV, 2026-09-21 | `…/PAC-Local-Environment-Setup/DB Backup/*.bak` |
| Role description (Senior .NET Developer, on-site) | `/Users/macbook/Workspaces/Work/Temus/PAC/KnowlegeBase/Resume.html` (folder name is spelled `KnowlegeBase`) |

## Greeting and session resumption

On "Hi", a return after an interruption, or a resume without a task — orientation only, never code, builds or deployment:

1. **Read** the status file, the board, and `git log -5 --oneline` / `git status --short` in any cloned repo that exists.
2. **Drift check** — CURRENT in the status file matches the board; the action card matches CURRENT. Fix record drift only, log it in PAST.
3. **Parked items** — list each `⏸ PARKED until <date or trigger>` whose date arrived or whose trigger was mentioned.
4. **Reply** in Vietnamese: project, last milestone, CURRENT and its owner, the next action, a link to the status file, any drift fixed.
   Distinguish recorded evidence from a fresh check; don't ask "what next?" when the records say it. End with the action card.
