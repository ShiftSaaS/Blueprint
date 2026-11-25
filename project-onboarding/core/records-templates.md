# Record templates — ANALYSIS · DECISION · SETUP — v2.0 (from Lintent, 2026-11-17)

**Laconic, every record:** header and At a glance as tables, one fact per cell (≤ 2 lines); findings and options in tables; everything
else short bullets — no paragraph over two lines. Every finding carries its source (file:line, URL, quote, "owner said"); no source →
marked an assumption. History / Outcome are append-only. Options are named by meaning (R-12), each with plan · effort · protects ·
gaps, and a recommendation up front.

## ANALYSIS — `docs/strategy/analysis/<P>_ANALYSIS_N_<date>.md`

```markdown
# <P>_ANALYSIS_N — <date> — <the question, as a title>

| | |
|---|---|
| **Kind** | <emoji Kind> |
| **Evidence** | <what was read or run, labelled honestly — a spot-check is said so> |
| **Lifecycle** | RAISED / IN_USE / ARCHIVED — cited by <DECISION> |
| **Scope** | what was checked, and what was not |

## At a glance          ← Question · Answer (one line) · Confidence (+ why) · Routes to (TASKS / VALIDATION / STRATEGY / NONE)
## Origin and method    ← who asked what, when; what was read or run
   … middle, by Kind …
## Options              ← table: option (by meaning) · plan · effort · protects · gaps
## Limits and unknowns
## Outcome              ← which DECISION used it and what it chose (dated, append-only)
```

| Kind | Middle |
|---|---|
| 🏁 Market | Competitors table · where we differ |
| 🧩 Product model | current vs proposed shape · a real example · what would have to be true |
| 👤 User needs | signals (source · says · verified?) · what users did · converging vs conflicting |
| 🔒 Protection & release | assets and exposure · threats · options |
| 🧪 Code quality | claims checked (claim · where · true?) · what a newcomer meets |
| 📜 Platform rules | rule · quote · source · applies? · risk |
| 📣 Messaging | claims (source · verified?) · can say / can't say yet |

Findings get IDs (F1, F2…) when a decision will cite them.

## DECISION — `docs/strategy/decision/<P>_DECISION_N_<date>.md`

```markdown
# <P>_DECISION_N — <date> — <the choice, as a title>

| | |
|---|---|
| **Kind** | <emoji Kind> |
| **Routes to** | TASKS / VALIDATION / STRATEGY / NONE |
| **Records** | tasks / stage files it produced |
| **Lifecycle** | RAISED / IN_USE / ARCHIVED |
| **Sources** | every ANALYSIS / DECISION it draws on |

## At a glance          ← Choice · Status (+ priority) · Next (who does what)
## Sources              ← small diagram: sources ──→ DECISION
   … middle, by Kind …
## Limits
## History              ← dated bullets, oldest first, never deleted; owner quotes kept as said (translated, marked)
```

| Kind | Middle |
|---|---|
| 🔧 Scope work | tasks scoped (ID · what · why now · estimate) + hard stop + "approved by the owner" line · not scoped, and why |
| 🚧 Gate / sequencing | question · options (cost / risk / verdict) · gate criteria · what it changes |
| 💤 Defer with trigger | why not now · trigger and test · boundary |
| 📦 Release scope | in / out · precondition · what it changes |

## SETUP — `docs/setup/SETUP_N_<date>.md` (how the repos are run; never an ANALYSIS)

```markdown
# SETUP_N — <what becomes true>

| | |
|---|---|
| **Found in** | <task / review / owner's question> |
| **Status** | RAISED / ✅ approved (option) / ⏸ |

## 1 Problem     ← ≤ 3 bullets
## 2 Decision    ← options by meaning, the recommended one first, ≤ 3 bullets each
## 3 Scope       ← which files / repos change, ≤ 3 bullets
## 4 Impact      ← what the owner and the agents do differently, ≤ 3 bullets
```

`write SETUP_N` → `approve SETUP_N` → one `chore(SETUP_N)` commit, or a setup task (`<X>0.x` / `<X>8.x`) when it needs a build and evidence.
Index: `docs/setup/README.md` (ID · subject · found in · status). A small setup change may skip the file: a short proposal in chat,
the owner's `ok, <name>`, a PAST line.
