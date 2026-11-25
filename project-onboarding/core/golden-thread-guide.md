<!-- Reference instance copied from Lintent/Code/docs/execution/golden-thread-template.md on 2026-10-15 (blueprint v1). Replace project-specific names (PAC, PAC_, P0.x, paths) when instantiating. -->

# Golden Thread — variant decision guide

> **What this file is**: a decision table for picking which Golden Thread *shape* fits the task
> in front of you — which nodes to include, in what order, named how.
> **What this file is not**: a fill-in-the-blank sentence template. Every node's actual content
> (the quoted claim + its child bullet) must still come from reading the real source or running
> a real test for *this* task. Copying wording from a precedent task instead of re-deriving it
> defeats the entire point of the exercise — the precedents below are cited by task ID so you can
> go read the real instance, not so their sentences get reused.

Built by reviewing all 12 Golden Threads written so far: `C1.1`–`C1.8` (UI ↔ Wedge
Alignment) and `C2.1`–`C2.4` (Audit Engine Correctness). Linked from `specs/board.md`.

---

## 1. The fixed skeleton — never varies

Every Golden Thread written so far has these 4 nodes, in this order, in this form. No task has
ever dropped or reordered one of these:

| Node | Form | Job |
|---|---|---|
| **ROOT** | 1-sentence abstract principle (quoted) + 1 child bullet applying it to this task — the request / DECISION goes in the child, never as ROOT ([R-07](../../handoff/rules/R-07-golden-thread-root-is-a-principle.md)) | State the general rule being violated — general enough that a reader who's never seen this codebase understands *why* this would be wrong anywhere, not just here |
| **LOCATE (src)** | Quoted claim naming exact file(s) + 1 child bullet of supporting code detail | Pure location — say *where*, not yet *why it's wrong*. (Repeated real mistake, caught across several tasks: LOCATE "concluding too soon" by stating the violation instead of just pointing at it — save that for VIOLATION IDENTIFIED) |
| **VIOLATION IDENTIFIED** | Quoted synthesis + 1 child bullet | The one node that's allowed to conclude — states what LOCATE + the evidence node together prove is wrong |
| **CONCRETE CHANGE** | Always exactly `see "## Change" above` | Never inline text. 12/12 tasks use this pointer, zero exceptions — implementation detail lives in `## Change`, not in the Golden Thread |

---

## 2. Decision table — where the variants are

Six points actually vary. Everything else in the skeleton above is fixed.

| # | Decision | Options | Pick based on |
|---|---|---|---|
| 1 | Evidence-node name | `AS-BUILT EVIDENCE (screenshots)` vs. `AS-BUILT EVIDENCE (live test)` | Does one static look at the current UI/state already show the flaw? → `(screenshots)`. Does the flaw only appear across a *sequence* of actions (scan → click → check; scan → close → reopen → check)? → `(live test)` |
| 2 | Evidence-node kind | `AS-BUILT EVIDENCE` vs. `INVESTIGATION / EVIDENCE TO ESTABLISH` vs. *none — folded into LOCATE* | Does reading the source *alone* already prove the violation exists (an early-return, a hardcoded `false`, a missing branch)? → `AS-BUILT EVIDENCE` — the live test then just *confirms* what code-reading already showed. Does the task itself read "confirm whether X can happen" — i.e. the violation's existence is genuinely unknown until tested? → `INVESTIGATION / EVIDENCE TO ESTABLISH`, and see decision 3. Was the violation already shown unambiguously by something the user handed you directly (a live screenshot, a direct quote) *before* the Golden Thread was written, so LOCATE's own job is just tracing that already-confirmed symptom to its exact code cause? → no separate node; fold the "confirmed by reading X, not assumed" evidence into LOCATE's own child bullet instead (see decision 6) |
| 3 | Branching | Linear (straight to VIOLATION IDENTIFIED) vs. insert a `DECISION GATE` node | Only relevant when decision 2 picked `INVESTIGATION`. If the task's own `## Done when` already has an "if yes / if no" shape, the Golden Thread must show that fork — don't let VIOLATION IDENTIFIED read as a certainty when the task file itself says it's conditional. A `DECISION GATE` isn't required to be a single binary split — when the task's own subject is a set of independent categories/files each needing their own yes/no (e.g. "confirm per category"), the gate may branch once per category, and a branch may itself nest a second gate (e.g. "theoretically reachable" → live-test → reproduces or doesn't) — as long as every branch still ends in its own evidence and its own outcome (a fix, or a documented no-op), not a shared assumption across categories |
| 4 | PROXY count | `PROXY 1` alone vs. `PROXY 1` + `PROXY 2` | Does the fix decompose into 2 independently-nameable parts, each needing its own concrete micro-example? → add `PROXY 2`. One unified fix → `PROXY 1` alone. No precedent yet for 3 — if a fix needs a 3rd, that's a signal the task may actually be 2 tasks |
| 5 | PROXY 1 body detail | Concrete (file/function names, literal before→after values) vs. abstract only | **Not a free choice** — a permanent convention, effective `C2.2` onward: PROXY 1's body must stay abstract/high-level, no file or function names. That detail belongs only in `## Change`. Tasks before `C2.2` (`C1.x`, `C2.1`) predate this and are concrete — don't backport the old style into new tasks, and don't backport the new constraint onto old, already-closed tasks |
| 6 | PROXY numbering | `PROXY (title)` (no number) vs. `PROXY 1 (title)` | Effective `C4.76` onward: a solo PROXY (no `PROXY 2`) drops the "1" — `PROXY (title)`. The number only earns its place once there's a second one to distinguish it from (`PROXY 1` + `PROXY 2`, decision 4 above) — a lone, permanently-solo node doesn't need an ordinal. Tasks before `C4.76` use `PROXY 1 (title)` even when solo — don't backport either direction onto already-closed tasks |

A 7th axis exists but isn't really a choice — it's fixed by which initiative the task belongs to:

| Initiative | LOCATE precision |
|---|---|
| `C1.x` (UI ↔ Wedge Alignment) | Names file(s)/component(s); line numbers not required |
| `C2.x` (Audit Engine Correctness) | Must cite exact line numbers — `specs/board.md`'s own stated rule: *"every finding must be traced to real code (file + line), not assumed"* |

---

## 3. Precedent index

Real instances, cited by task ID + path so you can read the actual node — not a quote bank to
copy from.

- **Evidence — `(screenshots)`**: `C1.2`–`.6`, `.8`
- **Evidence — `(live test)`**: `C1.1`, `.7`, `C2.1`, `.3`
- **`INVESTIGATION` + `DECISION GATE`**: `C2.4` — first/only instance, `## Done when` already
  phrased "confirm whether... if yes... if no..."
- **Two-part fix (`PROXY 1`+`2`)**: `C1.3` (stat-card labels + "AI" placement, 2 separately-
  fixable jargon issues), `C1.4` (idle-state copy + scanning-checklist logic, 2 states)
- **Concrete `PROXY 1` body (pre-`C2.2`)**: `C1.3`
- **Abstract `PROXY 1` body (`C2.2`+)**: `C2.2`, `.3`, `.4`
- **No evidence node, folded into LOCATE + unnumbered `PROXY` (`C4.76`+)**: `C4.76`–`.90`, all
  15, no gaps — every one raised from something the user handed over unambiguously (screenshot,
  direct quote), so LOCATE's own "confirmed by reading X" bullet does the evidence node's job;
  none needed a second PROXY.

---

## 4. Assembled shape (both branches)

**Known-bug shape** (source-reading alone already proves the violation):
```
ROOT → LOCATE → AS-BUILT EVIDENCE (screenshots|live test) → VIOLATION IDENTIFIED
     → PROXY 1 [→ PROXY 2] → CONCRETE CHANGE
```

**Uncertain-bug / investigation shape** (task itself asks "confirm whether..."):
```
ROOT → LOCATE → INVESTIGATION / EVIDENCE TO ESTABLISH → DECISION GATE
                                                            ├── NO  → document evidence; no code change
                                                            └── YES → VIOLATION IDENTIFIED
                                                                    → PROXY 1 [→ PROXY 2] → CONCRETE CHANGE
```

**Lean known-bug shape** (violation already unambiguously shown by something the user handed over
directly — a screenshot, a direct quote — before the Golden Thread was written; solo PROXY):
```
ROOT → LOCATE (src) → VIOLATION IDENTIFIED → PROXY (title) → CONCRETE CHANGE
```
No separate evidence node — LOCATE's own child bullet carries the "confirmed by reading X, not
assumed" evidence directly. No number on PROXY — there's only ever one. `C4.76`–`C4.90`, see
§3.

- Default: known-bug shape, unless the task file's own wording is already conditional ("confirm
  whether", "if yes/if no") — that phrasing is the signal, not a guess about difficulty.
- Default to *lean* specifically once the user already handed over unambiguous proof — restating
  it in its own node adds a step without adding rigor; fold it into LOCATE instead.

---

## 5. Maintenance

Living document, not a one-time snapshot. A future task needing a shape that doesn't fit §2 — new
evidence-node kind, new branch shape, anything structurally new — gets its own decision-table row
+ precedent entry, cited by task ID, same review as any other Golden Thread edit: propose the
row, don't append it silently.

- **Clarified during `C2.11`** (not a new shape): decision 3 covers a `DECISION GATE` branching
  by category/subject, not just one binary split, and nesting a second gate inside a branch.
  Same node, no new row — recorded since `C2.4`'s single-question precedent didn't make it obvious.
- **Added 2026-09-20, covering `C4.76`–`.90`** (genuinely new shape, 2 new rows): a lean
  variant — no evidence node (decision 2), unnumbered `PROXY` (decision 6) — for when the
  violation was already unambiguously proven by something handed over directly, fix stayed one
  PROXY. Found by audit, not proposed ahead of time — the 15 tasks are the precedent, not a plan
  that came first.
