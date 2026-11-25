# Profile — multi-host-exec

**Use when:** code must run on a machine/OS other than the one that holds the records (reference: PAC — records on a Mac, runs on Windows).

## Roles

| Role | Machine | Holds |
|---|---|---|
| Record / control host | where the AI session is linked | hub, `shared/` (lib, outbox, inbox, APPROVALS.md), ingest |
| Execution host(s) | Windows / Linux / macOS | run copy of the source, tools, services; runs scripts from `outbox/` |
| Owner | — | 🔴 OWNER / ⛔ LIVE approvals |

## Exchange contract (v1 — see `../multi-host/`)

- `outbox/<TaskId>/` scripts → `inbox/<TaskId>/<yyyyMMdd-HHmmss>/` outputs + `manifest.json` (task, script, machine, user, admin,
  start/finish, exit, files + SHA-256) → on `added <TaskId>` the AI verifies hashes and moves the run into the task's `evidence/`.
- Approval classes: 🟢 AUTO · 🟡 RUN · 🔴 OWNER · ⛔ LIVE; pending 🔴/⛔ rows in `APPROVALS.md`.
- `shared/` never holds source, backups, keys, certificates or passwords — those travel by a channel the client allows.

## Transport choice

| Situation | Transport | Notes from PAC |
|---|---|---|
| One Windows host, same Wi-Fi | SMB share on the record host, mapped drive | create the share point explicitly; guest access off; enable the account for Windows File Sharing; error 1219 → delete stale `IPC$` |
| Hosts on different networks | Tailscale + SMB/SSH | |
| Several hosts / OSes | SSH (OpenSSH on Windows) + small runner (PowerShell 7) + config management (Ansible) | keep the same manifest contract |

## Execution-host lessons (Windows)

winget may hang in elevated scripts → vendor bootstrappers; VS bootstrapper 5008 after a feed timeout → retry; run installers with
`-Wait -PassThru -NoNewWindow`; feature State Disabled is enum 0; log before each long step; read installer logs; RAM/disk/edition first.
