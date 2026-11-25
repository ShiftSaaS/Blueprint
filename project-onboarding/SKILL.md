---
name: project-onboarding
description: Start a new software project: on hi show usage and a load checklist (product, PAC-like client delivery, custom) and propose configuration; given folders, verify materials and generate the docs hub with the current Lintent-derived process (rules R-01–R-12, command register, action card, reviews, live view).
---

<!-- Copy of the saved skill (blueprint v2.0, 2026-11-18). The saved Claude skill is the one that runs; keep this copy in sync. -->

# Project onboarding blueprint (v2.0)

Distilled from two real workspaces: Lintent (product build, 3 own repos) and PAC Online (client delivery, legacy .NET on Windows,
operated from a Mac). Use it when the owner points at folders for a new project and asks "what do I need to set up / which tasks
will I do". Reply in the owner's language; write every record in English, marking the owner's words as translated.
Full templates and reference instances: `~/Workspaces/Blueprints/project-onboarding/`.

## Entry mode — greeting or no folders given

If the owner says "hi"/"hello"/"chào" with this skill, or invokes it without naming folders: change nothing; reply with
(1) one sentence on what this does, (2) the three ways to use it — "onboard <folders>", "checklist", "show profiles",
(3) the load checklist headings A–H and the decision matrix below, (4) the action card. On "checklist": ask A–H as
multiple-choice questions (unknown allowed → owner check), then recommend type + profiles + configuration and wait for approval.

| Checklist | Asks |
|---|---|
| A Identity | name + short code · who owns the repos (you/client) · who decides priorities |
| B Work origin | product ideas · client tickets/CRs · incidents · one-off; deadline/contract scope |
| C Materials | setup guide · architecture · source/snapshot · DB backups · role/SOW · backlog · credential names (never values) |
| D Runtime | stack + required OS · which machine runs it · machine limits (RAM, disk, admin, edition) |
| E Environments | local/DEV/UAT/PROD owners · who deploys, how, change windows |
| F Access | VCS (whose), VPN, licences, shared DBs |
| G Collaboration | other agents/tools, teammates, required reviews |
| H Records | hub location · git for the hub · records language |

| Decision matrix | Type | Configuration |
|---|---|---|
| you own repos + product ideas | Product (Lintent-like) | core + product-build |
| client owns repos + tickets + handover | Client delivery (PAC-like) | core + client-delivery |
| runs on another machine/OS | + multi-host | + multi-host-exec (exchange task X0.2) |
| small / one-off / internal / data / PoC | Custom | core-lite + custom |
| fits none | Custom | core-lite + a new profile drafted from the answers, approved first |

**core-lite:** short AGENTS.md, one status file, board (To Do/Doing/Done), one NOTES.md for findings and choices, gates
`implement`/`close`/`approve live`, evidence before done; Golden Thread only for changes to shared or production systems.

## Core principles (every project)

- **Documents are claims until checked against source.** Record each difference as a numbered finding with its evidence.
- **Never print secrets.** Detect keys/certificates by file header only (`BEGIN PRIVATE KEY`, `.pfx`); mask passwords in connection strings.
- **Gates move only on registered commands** — `core/commands.md` (verb first: `write <P>_ANALYSIS_N`, `approve <P>_DECISION_N`,
  `Golden Thread <ID>`, `review scope <ID>`, `implement <ID>`, `added`, `skip evidence <ID>: <item>`, `close <ID>`, `verify review <ID>`,
  `agree review <ID>`, `approve live <ID>: <action>`, `write SETUP_N`, `ok, <name>`). A question is not a waiver; unclear means not
  given; a repeated command a rule blocks stays blocked; an unanswered owner check is asked again, never filled by the AI.
- **Default rules R-01–R-12** (`core/rules.md`) go into the project's `AGENTS.md`: chat images are never evidence (R-01, briefs with
  GUARD · FILE · TIME), no evidence no tick (R-02), records in English (R-03), IDs in run order (R-04/05), close commits by kind (R-06),
  ROOT is a principle (R-07), open task = flat file (R-08), review by another agent after close (R-09), known commands + card (R-10),
  reviews name their level (R-11), names by meaning (R-12).
- **No evidence, no tick.** Evidence is a saved file or recorded check; chat-pasted output is saved verbatim and marked "pasted by owner".
- **Pause before the least reversible step**; anything outside the owner's machines needs `approve live`, one action per command.
- **Sibling work is never done from another repo's session** — a `⇄ PENDING for <repo>` line; process / tooling changes are SETUP_N, not
  ANALYSIS / DECISION; records laconic (`core/records-templates.md`).
- Every answer ends with the **action card** (`core/action-card.md`): bold quote line naming who acts · Task / Flow / Next · "Typed in" ·
  `Type | Who acts | Changes | Does` with every pending owner action as a row (⏸ when blocked) · one legend line.

## Step 1 — Intake (inventory and classify)

1. Request access to the folders the owner names; check exact folder names first (typos are common).
2. List each tree (skip node_modules, packages, bin/obj, .git); extract text from .docx/.pdf; note sizes and dates.
3. Classify every item by **source class** and use it as follows (materials differ per project — never assume a folder exists):

| Source class | Examples | Feeds |
|---|---|---|
| Setup / handover guide | "Local environment setup", runbooks | Setup tasks X0.x, prerequisites, guardrails |
| Architecture / design | diagrams, solution docs | docs/architecture (as-documented column) |
| Source snapshot or repos | zips, clones | Verification findings; layout and dependency map |
| Data | DB backups, seed data | Database route option (local restore vs shared server) |
| Role / contract | job description, SOW | Later initiatives (CRs, incidents, security, releases) |
| Backlog / tickets | JIRA export, issue list | Board rows for X1.x |
| Secrets | keys, pfx, passwords lists | Security findings only (header check), access-request list |
| Nothing usable | — | Interview the owner with the load checklist |

## Step 2 — Verify claims against source

Check at least: folder names vs relative references (HintPath, imports), config values (hosts, connection strings, feature flags),
framework/runtime versions, build output paths, commented-out code paths the guide relies on, backup headers/sizes, duplicate or stale
files, committed secrets. Produce findings F1..Fn: finding · evidence (file/line) · impact. State plainly what was NOT verified
(nothing built, nothing run).

## Step 3 — Classify the project and pick profiles

Use the load checklist answers and the decision matrix; ask only what is unclear.

| Profile | Signals | Adds |
|---|---|---|
| **product-build** | Owner owns the repos; work comes from product hypotheses | docs inside each repo, strategy register, stages, cross-repo handoff, review by a second agent |
| **client-delivery** | Client owns repos/environments; work comes from tickets/CRs; handover material | one hub BESIDE the client repos (never commit records into them), origin = ticket key, client branch/push rules, environment guardrails (never point local at UAT/PROD), handover errata list |
| **multi-host-exec** | Code must run on another OS/machine than the one holding records | exchange task (below), approval classes, runner/evidence standard |
| **custom** | Small, short or unusual work | core-lite; grow into full profiles when a second repo, client approvals, production or another host appears |

## Step 4 — Answer the owner first (chat)

Before generating files: a short answer to "what do I need to do" — the system in 3-5 lines, ordered setup steps, items to obtain from
the team, top findings that would break a literal follow-the-guide setup. Offer to generate the hub.

## Step 5 — Generate the hub (on request)

Location: inside the repo (product-build) or `<workspace>/Source/` beside client repos (client-delivery). Files:
- `AGENTS.md` (single rule source: what this is, every-agent table, guardrails, doc map, greeting steps) + `CLAUDE.md` = `@AGENTS.md`.
- `docs/README.md` (structure, workflow, naming, initiatives, what was kept/dropped from the reference model).
- `handoff/rules/` R-01–R-12 from `core/rules.md` (lite: R-01, R-02, R-03, R-10, R-12); `docs/execution/commands.md` from `core/commands.md`;
  the card from `core/action-card.md`; `docs/execution/reviews.md` from `core/reviews.md` (product-build / client-delivery).
- `docs/setup/README.md` (SETUP_N index) and the record templates from `core/records-templates.md`.
- Live view (when G3 = several sessions): `core/live-view/` → `.claude/hooks/live.mjs` + settings + `.gitignore`.
- `docs/execution/task-template.md`, `docs/execution/specs/board.md` (Backlog / To Do / In Progress / Blocked / Done).
- `docs/status/WAITING_FOR_YOUR_ACTION.md` + `docs/status/history/` from `core/status-template.md` (card, ROAD, PAST today + yesterday
  only, CURRENT, AGENTS, HANDOFFS, FUTURE; greeting steps).
- `docs/analysis/<P>_ANALYSIS_1_<date>.md` (Step 1-2 findings) + index; `docs/architecture/README.md`; `docs/open-questions.md`.
- `docs/decision/<P>_DECISION_1_<date>.md` + index — PROPOSED, Routes to TASKS, options, roadmap table, owner checks, hard stop.
For core-lite: AGENTS.md, CLAUDE.md, docs/status/, docs/board.md, docs/NOTES.md only.
Prefix records with a short project code (`PAC_ANALYSIS_1`); task IDs `<X>0.x` setup, `<X>1.x`+ later initiatives.
Run a relative-link + anchor check over all generated markdown before reporting.

## Step 6 — First roadmap (inside DECISION_1)

Each row: what becomes true (title = outcome) · Done when with the evidence file · runs on · depends on · estimate. Order: work that
the on-hand material allows first (tools, layout, local data, config, run each app), access-dependent work in parallel, a closing
baseline task, then a HARD STOP before tickets. Owner checks typically: which machine/OS/arch, DB route, source fallback if access is
late, where the hub lives vs the run copy, whether the hub gets git. Not-started tasks may be renumbered by `amend`; started ones never.

## Multi-host exchange pattern (profile multi-host-exec)

```text
Record host  <workspace>/shared/   <->  Execution host  mapped drive or synced folder
  lib/PacRun-style helper  |  outbox/<TaskId>/ scripts  |  inbox/<TaskId>/<yyyyMMdd-HHmmss>/ outputs + manifest.json
  APPROVALS.md queue of owner actions
```
- Manifest: task, script, machine, user, admin, start/finish, exit code, every file with SHA-256. On `added <ID>` the AI recomputes
  hashes, moves the run into the task's evidence/, reads every file. shared/ never holds source, backups, keys or passwords.
- Approval classes: AUTO (AI on the record host) · RUN (read-only script, owner runs) · OWNER (changes a machine or security setting,
  listed in APPROVALS.md) · LIVE (outside the machines, `approve live`).
- Transport: same LAN → SMB (create the share point explicitly, turn guest access off, enable the account for Windows file sharing,
  clear stale IPC$ sessions on error 1219); different networks → Tailscale/SSH; many hosts or OSes → SSH + a small runner + config
  management (e.g. Ansible) with the same manifest contract.

## Field lessons (Windows execution hosts)

- Check RAM/disk/edition first; Home editions can still enable IIS; Get-ComputerInfo may report Windows 11 as "Windows 10".
- `Get-WindowsOptionalFeature` State Disabled is enum 0 — test the object for null, not `-not $state`.
- winget can hang in elevated scripts; prefer vendor bootstrappers. VS bootstrapper exit 5008 after a feed timeout: retry.
- Run installers with `Start-Process -Wait -PassThru -NoNewWindow` (a separate console got interrupted: 0xC000013A); log before each
  long step; read installer logs (dd_bootstrapper_*.log, SQL Setup Bootstrap\Log) instead of guessing.
- Downloaded scripts trigger a security prompt — tell the owner to answer R; never ask for passwords in chat (hidden prompts only).
- Put literal commands only in the action card's command column; owners copy labels otherwise. Never bundle several rows into the YOU ACT line, and never list an already-done step as a command (PAC, 2026-10-16).
- Commands in chat are not run: if the owner pastes a command back, check whether it took effect before assuming it did.

## Output checklist

- [ ] Greeting/no folders: usage guide + checklist + decision matrix, nothing changed
- [ ] Chat answer: setup steps + items to obtain + top findings
- [ ] Findings with evidence and explicit not-verified list
- [ ] Hub generated (if asked) with links checked; AGENTS.md carries R-01–R-12 (or the lite set) and the card rule
- [ ] The project records the blueprint version it was onboarded with (v2.0)
- [ ] DECISION_1 PROPOSED with roadmap, owner checks, hard stop; status file pointing at the exact next command
