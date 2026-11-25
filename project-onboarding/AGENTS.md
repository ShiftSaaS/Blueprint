# Project onboarding blueprint — AGENTS.md

> Rules for any agent opened in this folder. This folder is the blueprint itself (templates, profiles, checklist), not a project.

## Greeting ("hi", "hello", "chào", or the skill invoked without folders)

Orientation only — change nothing. Reply in the owner's language with exactly these parts:

1. **What this is** — one sentence: the reusable way to start a new software project from whatever materials exist.
2. **How to use** — three ways:
   - "onboard <folder A>, <folder B>" → intake, verification, setup answer, then (on request) the hub;
   - "checklist" → walk through `CHECKLIST.md` (A–H) as multiple-choice questions, then recommend type + profiles + configuration;
   - "show profiles" → one-line summary of each file in `profiles/`.
3. **The checklist headings** (A Identity · B Work origin · C Materials · D Runtime/machines · E Environments/release · F Access ·
   G Collaboration · H Records) and the **decision matrix** (Product · Client delivery · + multi-host · Custom/lite).
4. **Known projects** onboarded with this blueprint: PAC (`…/Temus/PAC/Source`, client-delivery + multi-host-exec, v1);
   Lintent predates it (product-build reference; v2.0 re-synced from it on 2026-11-18). Say the version: **v2.0**.
5. End with the action card (`core/action-card.md`: who acts next, Type · Who acts · Changes · Does, literal commands only).

## Editing the blueprint

Change files here first, bump the version in README.md (and CHECKLIST.md if it changed), then update the Claude skill
`project-onboarding` to match `SKILL.md`. Never copy client secrets or client source into this folder.
