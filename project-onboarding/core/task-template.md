<!-- v2.0 (2026-11-18), from Lintent handoff/conventions.md §1 (laconic task file). Replace <P>, <X>, paths when instantiating. v1 (PAC instance) is in _archive/. -->

# <ID> — <title: a compressed statement of the ROOT>

| | |
|---|---|
| **Strategy · Stage** | <S-number> · <STAGE_N or —> · Initiative <X.x (name)> |
| **Flows touched** | <F-IDs from the flow register, or "none"> |
| **Source** | <<P>_ANALYSIS_N (F#) → <P>_DECISION_N (item)>, a ticket key, or the parent's review finding |
| **Kind** | <functional / defect / tooling> · Golden Thread under R-07 |
| **Estimate** | <days> |
| **Evidence** | `<ID>-<slug>/screenshots/`, `<ID>-<slug>/evidence/` (R-08) |

Open as `tasks/<ID>-<slug>.md` (flat). The close moves it into the folder as `README.md` (R-08).

**Files**

| File | What changes |
|---|---|
| `<path>` | <one line> |

**Re-read whole at the live check (R-07):** <screen> · <screen>

## Change

### What's wrong
| # | Problem | Seen as |
|---|---|---|
| W1 | <one line> | <the owner's words (translated, marked) or what the screen shows> |

### Confirmed before building
| Area | Fact | Where |
|---|---|---|
| <area> | <what reading the code / running it showed> | `<file>:<line>` |

### Scope — one PROXY
> *<the single change, one sentence>*

**S1 · <part>** (check a) — <one fact per bullet, precise enough to implement from>

### Explicitly deferred
| Item | Where / why |
|---|---|
| <adjacent thing> | <task ID, open question, or reason> |

## Why
Two or three sentences: the underlying principle.

## Golden Thread (ROOT → Change)
```
ROOT
"<one principle sentence — general enough to be wrong anywhere, not just here>"
    │  — <the request / DECISION / ticket that raised it>
    ▼
LOCATE (src)
"<where — exact files; no conclusion yet>"
    │  — <confirmed by reading X, not assumed>
    ▼
VIOLATION IDENTIFIED
"<what LOCATE + evidence prove is wrong>"
    ▼
PROXY (title)
"<the one change, as a title>"
    ▼
CONCRETE CHANGE
see "## Change" above
```

## Owner checks
| Check | Options | Recommended · **Answer** |
|---|---|---|
| (a) <question> | **a1** <by meaning; plan, effort> · a2 <…> | a1 · *(unanswered — asked again, never filled by the agent)* |

## Task path
> Pathway <version> · Variants <V1…V6>
> Origin: <ANALYSIS → DECISION → board, or review of <parent> (finding)>
> Planned: READY → DISCUSSING (checks) → [scope review] → EXECUTING (tests first) → VERIFYING (00 before the fix, then 01…) → CLOSING → REVIEW
> Actual: <written as it happens; finished at the close>

## How to test
**Unit, first** — <cases; red on today's code, green after>
**Live** — one `.txt` brief per capture in `screenshots/` (R-01: GUARD · FILE · TIME)

| # | Capture | Shows |
|---|---|---|
| 00 | `00-before-<what>.png` | the bug on today's build |
| 01 | `01-<what>.png` | the fix |

## Done when
- [ ] <observable criterion> — evidence: <file>
- [ ] Unit tests green; whole suite green; type check = the known baseline
- [ ] Limitations explicit

## Status
Scoped <date>, not implemented. Type `implement <ID>` to authorize.
