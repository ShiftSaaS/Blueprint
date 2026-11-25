# Action card — v2.0 (from Lintent playbook v2.7, 2026-11-12)

Every answer the agent gives ends with this card, in the owner's language, in markdown (not a code block). The status file carries the
same card under its header; when they differ, the status file's CURRENT wins and the card is fixed.

## Shape

```markdown
> **👤 YOU ACT** — **<plain action + the exact command>**
   (or: > **⚙️ AGENT ACTS · <tool> (<repo>)** — **<what it does now>** · You: nothing needed right now)

| | |
|---|---|
| **Task** | <ID> · <variant(s)> — <one-line gloss> |
| **Flow** | Decide: ● <P>_ANALYSIS_N ── ● <P>_DECISION_N ── ● Board ▸ Do: ● Golden Thread ── ● checks ── ◉ **<current>** ── ○ close ── ○ review |
| **Next** | <from> → <to> — <its condition or command> |

Typed in: **<tool> · <this repo>**

| Type | Who acts | Changes | Does |
|---|---|---|---|
| **`<command>`** | 👤 → ⚙️ | <repo> | ③ Build — <when to type it> |
| **`<command>`** | ⚙️ | <repo> | ① Decide — ⏸ blocked by <what> |

👤 owner · ⚙️ Claude · 🔁 Codex — ⇄ a handoff line in that repo · ↗ outside (`approve live`) · — reads only
```

## Rules

| Part | Rule |
|---|---|
| Quote line | Names who acts, in bold. One action, never a bundle of steps |
| Flow | The task's whole path as linked circles: ● passed · ◉ **current** (bold) · ○ ahead · ↺N a loop. Always both lanes, Decide ▸ Do. No active task → a **Chain** row (the dependency path), then the next task's Flow |
| Typed in | One line naming the session every row is typed in. A card lists only commands that work in **this** repo's session; another repo's commands stay on its own card |
| Type | One typeable phrase only, in bold code: a registered command, a short answer (`1`, `a`) or a named go-ahead `ok, <name>`. Never a description |
| Who acts | 👤 owner · ⚙️ Claude · 🔁 Codex (or the project's tools); a chain with `→` (`⚙️ → 🔁` = close, then the other agent's review) |
| Changes | The repo written · `⇄ <repo>` (only a handoff line there) · `↗ <what>` (outside — needs `approve live`) · `—` (reads only), joined with ` · ` |
| Does | Opens with the stage — ① Decide · ② Scope · ③ Build · ④ Close · ⑤ Runs, or **Setup** for a setup go-ahead — then when to type it, or `⏸ blocked by …` |
| Row order | (1) the command the quote line names, recommended; (2) **every pending owner action** — `commit`, each open `⇄` go-ahead, a setup go-ahead — each ready or ⏸ blocked, never only in prose; (3) waiting offers (review runs) |
| ⏸ blocked by a sibling | Names that repo's current ticket and finding in brackets (`⏸ blocked by API A0.3 (F5)`), re-read from its board at every card |
| Legend | One line under the table |

## Why

- The owner reads the card, not the prose: one glance answers who acts, what to type, and what it will change.
- Listing every pending action as a row (blocked ones marked) stops a forgotten commit or handoff from living only in a paragraph.
- "Changes" makes outside effects (a send, a deploy, a third party's file) visible before the owner types the command.
