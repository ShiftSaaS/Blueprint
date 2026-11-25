# Onboarding load checklist — v2.0

Asked at the start of every new project (or shown on "hi"). Answers decide the **type**, the **profiles** and the **configuration**.
Unknown is a valid answer — it becomes an owner check, never a guess.

## A. Identity
| # | Question | Why |
|---|---|---|
| A1 | Project name and a 2–5 letter **code** (e.g. PAC, LNT) | Record IDs `<CODE>_ANALYSIS_N`, task IDs `<X>0.x` |
| A2 | Who **owns the repositories**: you · a client · mixed? | product-build vs client-delivery |
| A3 | Who **decides priorities**: you · client lead/PO · both? | Origin of tasks (hypothesis vs ticket) |

## B. Where work comes from
| B1 | Product ideas / hypotheses · client tickets (JIRA, CR) · incidents · one-off job? | Analysis-first vs ticket-first |
| B2 | Is there a **deadline or contract scope** (SOW, role description)? | Initiatives and hard stop |

## C. Materials you have (each maps to a source class)
| C1 | Setup / handover guide | Setup tasks X0.x |
| C2 | Architecture / design docs | architecture/README |
| C3 | Source: repo access or a snapshot (zip) | Verification findings |
| C4 | Data: DB backups, sample data | DB route (local vs shared) |
| C5 | Role / contract / SOW | Later initiatives |
| C6 | Backlog / ticket export | Board X1.x |
| C7 | Credentials / keys list (names only — never paste secrets) | Access-request list, security findings |

## D. Runtime and machines
| D1 | Stack and OS it must run on (e.g. .NET 4.8 + IIS → Windows; Node → any) | multi-host-exec if ≠ your Mac |
| D2 | Which machine runs it: this Mac · another PC/VM · cloud · client server? | Transport, exchange task |
| D3 | Machine limits known (RAM, disk, admin rights, OS edition)? | Light vs full setup |

## E. Environments and release
| E1 | Environments: local · DEV · UAT · PROD — who owns each? | Guardrails |
| E2 | Who deploys, how (manual, CI), change windows? | X4 releases, `approve live` |

## F. Access
| F1 | VCS (GitHub/GitLab — whose?), VPN, licences, shared DBs | X0 access task |

## G. Collaboration
| G1 | Other agents/tools (Codex, Cursor), teammates, required reviews | Second-agent review (R-09) or not |
| G2 | May the other agent review automatically (one read-only CLI command, a standing approval), or does the owner run each review? | R-09 automatic vs manual; scope review before code |
| G3 | Several agent sessions at once (two repos, two tools)? | Live-view hook, `IN_PROGRESS.md`, `⇄` handoff lines |

## H. Records
| H1 | Where the hub lives (inside your repo · beside client repos · separate) | Hub location |
| H2 | Git for the hub? Records language (default English, chat in yours) | Commits, R-03 |
| H3 | Visual evidence: a UI to capture? Who captures (owner by hand · automatic)? | R-01 briefs (GUARD · FILE · TIME), `screenshots/` |
| H4 | Any third party's material (a client's designs, data) the agent must not send or copy? | R-11, FILE check, guardrails |

## Decision matrix

| Answers | Type | Configuration |
|---|---|---|
| A2 = you, B1 = ideas | **Product** (like Lintent) | core (full) + `product-build` |
| A2 = client, B1 = tickets, handover material | **Client delivery** (like PAC) | core (full) + `client-delivery` |
| …and D2 ≠ this Mac | + **multi-host** | + `multi-host-exec` (exchange task X0.2) |
| Small/one-off, internal tool, data analysis, script, < ~2 weeks | **Custom / lite** | core-lite + `custom` (see profiles/custom.md) |
| Fits none | **Custom** | core-lite + a new profile drafted from the answers, approved before use |
