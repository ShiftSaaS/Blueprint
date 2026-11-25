<!-- Reference instance copied from PAC/Source/docs/execution/windows-scripts.md on 2026-10-15 (blueprint v1). Replace project-specific names (PAC, PAC_, P0.x, paths) when instantiating. -->

# Windows script standard — v1

| | |
|---|---|
| **Kind** | 📐 Process — how every script that runs on the owner's Windows laptop is written, where its output goes, how it reaches the hub |
| **Origin** | P0.2 (PAC_DECISION_1, second amendment); lessons from P0.1's eight manual transfers |
| **Last verified** | 2026-10-15 (written; round trip pending) |

## Where things live

| Mac (AI reads/writes) | Windows (owner runs) | Holds |
|---|---|---|
| `/Users/macbook/Workspaces/Work/Temus/PAC/shared/lib/` | `Z:\lib\` | `PacRun.psm1` — the only helper; every script imports it |
| `…/shared/outbox/<TaskId>/` | `Z:\outbox\<TaskId>\` | Scripts and short instructions the AI publishes for that task |
| `…/shared/inbox/<TaskId>/<yyyyMMdd-HHmmss>/` | `Z:\inbox\<TaskId>\<run>\` | One run's outputs + `run-log.txt` + `manifest.json` |
| `…/shared/APPROVALS.md` | `Z:\APPROVALS.md` | Queue of 🔴/⛔ actions waiting for the owner |

Transport: Mac File Sharing (SMB) on the same Wi-Fi; Windows maps `\\<Mac IP>\shared` as `Z:` (P0.2 check T = T1).
`shared/` **never** holds source code, database backups, private keys, `sp.pfx`, passwords or licence files.

## Every script

1. Lives in `outbox\<TaskId>\`, named `<TaskId>-<what>.ps1`; first lines say what it does, whether it changes the machine, and the exact run command.
2. Imports the helper: `Import-Module (Join-Path (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) 'lib\PacRun.psm1') -Force`.
3. `$run = Start-PacRun -TaskId '<TaskId>' -Script $PSCommandPath` → creates the run folder.
4. Each evidence item: `Save-PacOutput $run 'NN-what-it-proves.txt' { … }` — numbered in the task's Done-when order.
5. Progress lines: `Write-PacLog $run '…'` (logged before each long step, so a hang shows where it stopped).
6. Ends with `Complete-PacRun $run <exitCode>` → writes `manifest.json` (task, script, machine, user, admin, start/finish, exit code,
   steps, every file with SHA-256) and prints `added <TaskId>`.
7. Anything that may contain a connection string or password goes through `Protect-PacText` (done automatically by `Save-PacOutput`
   and `Write-PacLog`). Passwords are typed at `Read-Host -AsSecureString` prompts and never written.
8. Installers run with `Start-Process … -Wait -PassThru -NoNewWindow` and their exit code is logged (lesson: P0.1 SQL attempt 1).
   Do not rely on `winget` on this laptop (hung twice in P0.1); download from the vendor URL instead.

## Approval classes

Owner's direction, 2026-10-15 (translated from Vietnamese): "it should be automatic, but actions that need approval go to a queue".

| Class | What | Who acts | Approval |
|---|---|---|---|
| 🟢 **AUTO** | On the Mac: create `shared/` folders, publish scripts to `outbox/`, ingest runs after `added <TaskId>`, update records | AI, immediately | None beyond the task's own gate (`implement <TaskId>`) |
| 🟡 **RUN** | A **read-only** script on Windows (checks, round trips) | Owner runs it | Running it; then `added <TaskId>` |
| 🔴 **OWNER** | Anything that changes Windows or the Mac: installs, IIS sites, hosts, certificates, DB restore, connection strings, sharing / firewall / security settings, stored credentials | Owner | Listed in `shared/APPROVALS.md` with the exact action; the owner does it (or runs the script) — never inferred from silence or a question |
| ⛔ **LIVE** | Anything outside the two machines (shared DEV DB writes, GitLab push, UAT/PROD) | Owner | `approve live <TaskId>: <action>` per action (conventions §0) |

Every script's header states its class. `APPROVALS.md` lists only 🔴/⛔ items still pending; the AI moves a row to ✓ when the evidence arrives.

## Ingest (`added <TaskId>`)

The AI, on the Mac: lists `inbox/<TaskId>/`, takes runs not yet ingested, recomputes every SHA-256 against `manifest.json` (mismatch →
stop and report), moves the run folder to `docs/execution/specs/tasks/<TaskId>-<slug>/evidence/<run>/` (creating the task's folder if
needed), reads every file, then updates the task's Live progress and the status file. A run is evidence only after this step (R-02).

## History

- **2026-10-15** — v1 written under P0.2 (`implement P0.2`, T1, U = PAC/shared).
- **2026-10-15** — Approval classes + `APPROVALS.md` queue added at the owner's direction.
