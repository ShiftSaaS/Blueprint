# Live view — which sessions are running — v2.0 (from Lintent Landing L0.3 / L0.4, 2026-11-16)

A Claude Code hook writes one heartbeat per session to `docs/status/.live/<tool>-<session>.json` and, on every prompt, prints a
summary of every repo in `LIVE_REPOS` into the agent's context. It never blocks (exit 0) and writes only its own repo's `.live/`.

| State | Means |
|---|---|
| RUNNING | seen in the last 10 minutes |
| STALE | no sign for 10 minutes — possibly unfinished; resuming needs the owner's word |
| ENDED — not confirmed | the turn failed (e.g. a usage limit) or ended while `IN_PROGRESS.md` was present |
| NO END RECORDED | the same session's next prompt came before any Stop (an interrupt, a crash) |
| UNKNOWN | no heartbeat file — no hook in that repo, or never run |

## Install (per repo)

1. Copy `live.mjs` to `<repo>/.claude/hooks/live.mjs`.
2. Merge `settings.snippet.json` into `<repo>/.claude/settings.json` (shared) or `settings.local.json` (when `.claude/` is git-ignored);
   keep any existing hooks beside it. Set `LIVE_REPOS` to the sibling folder names (they must sit side by side).
3. Add `docs/status/.live/` to `.gitignore`.
4. Check: a real prompt writes `claude-<session>.json`; a session killed mid-turn shows STALE after 10 minutes.

## Rule text for AGENTS.md

> **Live view** — before any work, read `docs/status/.live/*.json` of every repo: report each session RUNNING · STALE · ENDED — not
> confirmed · UNKNOWN. Resuming STALE or not-confirmed work needs the owner's word. A tool with no hook (e.g. Codex) writes
> `docs/status/IN_PROGRESS.md` (`RUNNING · <tool> · <command> · <start>`) as its first action on a writing command and removes it when done.

## Known gap

Every prompt that follows one without a Stop leaves a NO END record; they are kept (never removed by age) and pile up — prune by hand
after the owner confirms them.
