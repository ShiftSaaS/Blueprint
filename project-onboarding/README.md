# Project onboarding blueprint — v2.0

| | |
|---|---|
| **What** | The reusable procedure for starting work on a new software project from whatever materials exist, plus the templates it uses |
| **Called by** | Claude skill `project-onboarding` (`~/.claude/skills/project-onboarding/SKILL.md`; say "use project-onboarding for <folders>") — the skill holds the procedure; this folder holds the full templates and reference instances |
| **Built from** | Lintent (product build) and PAC Online (client delivery + multi-host execution) |
| **Version** | v2.0 · 2026-11-18 — re-synced from Lintent (pathway v1.11, playbook v2.7, rules R-01–R-12, SETUP_1–6, live view L0.4). Projects record the version they were onboarded with; change this folder first, bump the version, then the skill |
| **v1.1** | `_archive/project-onboarding-v1.1-2026-10-16.tar.gz` |

## Layout

```text
project-onboarding/
├── README.md                       this file
├── AGENTS.md / CLAUDE.md           greeting rule when a session is opened here ("hi" → usage guide + checklist)
├── CHECKLIST.md                    load checklist A–H + decision matrix (Product · Client · multi-host · Custom/lite)
├── SKILL.md                        copy of the skill text (the saved skill is the one that runs)
├── core/                           every project
│   ├── rules.md                    R-01–R-12 + the "every agent" rows for AGENTS.md            (v2.0)
│   ├── commands.md                 the known-command register, ① Decide … ⑤ Runs               (v2.0)
│   ├── action-card.md              the card every answer ends with (Type · Who acts · Changes · Does) (v2.0)
│   ├── reviews.md                  levels L1–L5 + perf, scope review, R-09, Checks learned, L5 checklist (v2.0)
│   ├── records-templates.md        ANALYSIS · DECISION · SETUP, laconic                         (v2.0)
│   ├── task-template.md            the laconic task file                                         (v2.0)
│   ├── status-template.md          status blocks, history rule, greeting steps                  (v2.0)
│   ├── live-view/                  heartbeat hook: live.mjs, settings snippet, README            (v2.0)
│   ├── golden-thread-guide.md      shapes of the Golden Thread (Lintent)
│   ├── AGENTS.reference.md         rule file (PAC instance, v1)
│   ├── docs-README.reference.md    docs tree, workflow, naming (PAC instance, v1)
│   └── conventions.reference.md    v1 conventions (PAC instance) — superseded by rules / commands / action-card / reviews
├── profiles/
│   ├── product-build.md            Lintent-style (v2.0)
│   ├── client-delivery.md          PAC-style
│   ├── multi-host-exec.md          record host ≠ execution host
│   └── custom.md                   core-lite and how to draft a new profile (v2.0)
├── multi-host/                     PacRun helper, script standard, approvals, examples (unchanged)
└── _archive/                       earlier versions, as tarballs
```

## Use

0. Say "hi" (in a session opened in this folder, or by invoking the skill without folders) → usage guide + checklist.
1. Owner: "use project-onboarding for <folder A>, <folder B>" (any materials — the skill classifies them by source class).
2. The skill answers "what do I need to set up" in chat, then offers to generate the hub from `core/` + the chosen `profiles/`.
3. Reference instances stay where they are: PAC `…/Temus/PAC/Source/`, Lintent `…/Documents/Work/Lintent/`. Read them; never copy
   their product or client data into a new project.

## Keeping it in sync with Lintent

Lintent keeps changing its process. When Lintent's pathway, playbook or a rule changes version, re-run this sync: compare the versions
in the row above with Lintent's `docs/execution/pathway/README.md`, `docs/execution/playbook/README.md`, `handoff/rules/` and
`docs/setup/README.md`.

## Not yet

- No git here yet: run `git init` in this folder yourself if you want history.
- `client-delivery.md`, `multi-host-exec.md` and the PAC reference files are v1 — PAC's own changes since 2026-10-16 were not read.

## History

- **2026-10-15** — v1 created at the owner's request (translated from Vietnamese: "this analysis should be a blueprint kept apart,
  somewhere on the MacBook to call up, because when I started configuring PAC I asked two questions … future projects will have
  different documents").
- **2026-10-15** — v1.1: greeting shows the usage guide; CHECKLIST.md (A–H + decision matrix); profiles/custom.md (core-lite) —
  owner (translated): "when I say 'hi', just show me how to use it; list a load checklist so I know how to onboard — product, PAC-like
  or custom — and propose the configuration".
- **2026-11-18** — v2.0: re-synced from Lintent at the owner's request (translated from Vietnamese: "this is old — what new processes
  from Lintent can be synced to make a blueprint to onboard other projects?"; then `ok, Blueprints v2`). New core files: rules.md,
  commands.md, action-card.md, reviews.md, records-templates.md, live-view/; task and status templates rewritten; product-build and
  custom profiles updated; CHECKLIST G2, G3, H3, H4; skill re-saved. v1.1 archived.
