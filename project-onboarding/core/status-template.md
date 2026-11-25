<!-- v2.0 (2026-11-18), from Lintent playbook v2.7 (README + template.md). Replace {placeholders}; drop AGENTS / HANDOFFS for a single-repo project. v1.7 is in _archive/. -->

# Status template — v2.0

Exactly one live file in `docs/status/`: `WAITING_FOR_YOUR_ACTION.md` · `WAITING_FOR_NEW_TASK.md` · `IN_PROGRESS.md` (advisory, while a
writing command runs). Older PAST days live in `docs/status/history/`.

| Block | Must show | Rule |
|---|---|---|
| Header | Updated (time + zone) · `Pattern:` version | The version makes drift visible at the greeting |
| Action card | [action-card.md](action-card.md), in markdown | A summary of CURRENT, rewritten the same turn CURRENT changes |
| ROAD | Stages in run order (= the stage index), ▶ you are here, 🛑 hard stop (who set it, how often moved, how to move), ⏸ waiting, ◆ decision points | A view of records, never a source |
| PAST | Per milestone: date · 👤 HUMAN and ⚙️ AI separately · RESULT · RECORD | **Today and yesterday only.** Older whole days move **verbatim** to `history/PAST_<first>_to_<last>.md`; a history file is never edited again |
| CURRENT | STOP (if any) · PHASE · TASK · ACTIVITY · NEXT ACTOR · NEXT ACTION · 👤 HUMAN · ⚙️ AI · ADVANCE WHEN | PHASE one of IDLE · READY · DISCUSSING · EXECUTING · VERIFYING · CLOSING · REVIEW · WAITING |
| AGENTS | One line per repo: agent · PHASE · task → next actor: action | A view of every repo's status file, refreshed at every update |
| HANDOFFS | Open cross-repo lines only: `⇄ PENDING for <repo>: <what> — <source> · since <date>` · `⇄ picked up as <ID>` | Each names its go-ahead in backticks (`ok, <name>`) or ends `— waits on <trigger>`. Done → PAST |
| FUTURE | trigger → actor + action → outcome · `⏸ PARKED until <date/trigger> — <what>. Resume: <first step>` | Conditional; nothing here is authorized by being listed |

~~~~markdown
# Waiting for your action

> Updated: {timestamp, zone} · Pattern: blueprint status v2.0

{action card — action-card.md}

```text
{PROJECT} · SESSION HANDOFF
ROAD · {strategy}
 ✓ {done stage}    {what it delivered}
 ● {open stage}    {progress}
 ▶ YOU ARE HERE
 🛑 HARD STOP      {what is blocked} — set by {decision} · moved {N}× · to move: {who, how}
 ⏸ {waiting}       {for what · until}
 Legend: ✓ done · ● open · ▶ here · 🛑 hard stop · ⏸ waiting · ◆ decision · ○ not yet

PAST
├─ ✓ {milestone} · {date}
│  👤 HUMAN: {what the owner did / typed}
│  ⚙️ AI:    {what the agent did}
│  RESULT:  {observed result, limits included}
│  RECORD:  {task / evidence path, commit}
│
├─ Older entries, moved verbatim: [history/](history/) — {file list}
▼
╔══════════════════════════════════════════════════════════════╗
║ CURRENT — {plain action title}
╚══════════════════════════════════════════════════════════════╝
│  PHASE:        {value}
│  TASK:         {ID or none}
│  ACTIVITY:     {RUNNING / WAITING_USER / WAITING_EXTERNAL / IDLE}
│  NEXT ACTOR:   {HUMAN / AI / external}
│  NEXT ACTION:  {one concrete action}
│  ADVANCE WHEN: {observable condition}
▼
AGENTS — all repos (a view of their status files)
│  {repo}  {agent} · {PHASE} · {task} → {actor}: {action}
▼
HANDOFFS — open cross-repo work only (done → PAST)
│  ⇄ PENDING for {repo}: {what} — {source} · since {date} — `ok, {name}` | waits on {trigger}
▼
FUTURE — trigger conditions, not scheduled
└─ {condition} → {actor + action} → {outcome}
```
~~~~

## Greeting steps (on "hi", after a usage interruption, or a resume without a task) — orientation only

1. **History** — PAST days older than yesterday → `history/`, verbatim.
2. **Drift check** — fix record-keeping only, log it in PAST: `Pattern:` version · ROAD vs stage index · CURRENT vs board · every
   `AGENTS.md` cites the same rules (`check:agents`) · ⏸ dates vs their decisions · the card vs CURRENT · AGENTS / HANDOFFS vs siblings.
3. **Read** — the status file · board · `git log -5` · `git status --short` · the hub · the rules index · the live view ([live-view](live-view/README.md)).
4. **Cross-repo** — rows waiting on a sibling's ID → read its board; a sibling's `⇄ PENDING for <this repo>` → offer its go-ahead, then put
   the work on this board and mark the line picked up.
5. **Parked** — ⏸ items whose date is within 3 days or whose trigger was mentioned → offer to resume.
6. **Reply** — where/when · since last time · each repo one bullet · drift fixed · open questions · status link · action card. Short
   bullets, no paragraph; recorded evidence told apart from a fresh check.
