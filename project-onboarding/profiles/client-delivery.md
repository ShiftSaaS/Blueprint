# Profile — client-delivery

**Use when:** the client owns the repositories and environments; work comes from tickets/CRs; there is handover material (reference: PAC Online).

| Adds to core | Detail |
|---|---|
| Hub beside the client repos | `<workspace>/Source/{AGENTS.md, docs/}` next to the cloned repos; never commit records into client repos |
| Handover analysis first | ANALYSIS_1 = handover documents vs source snapshot; numbered findings; errata list for the team |
| Origin of work | Ticket key (e.g. JIRA `MDDIPAC-123`) on the task's Origin line; an analysis only when options/sizing are needed |
| Client process | Their branch model (`CR/<KEY>` from the release line, `--no-ff`), no push without the lead's approval, shared-copy projects changed in every repo |
| Guardrails | Never point local at UAT/PROD; no mass updates on a shared DEV DB; no e-mail-sending jobs before recipients are the owner's; secrets never in records |
| Initiatives | X0 setup · X1 CRs · X2 incidents · X3 security · X4 releases — later ones open only with an assigned work item (hard stop after X0) |

Reference instance: `/Users/macbook/Workspaces/Work/Temus/PAC/Source/` (AGENTS.md, docs/, PAC_ANALYSIS_1, PAC_DECISION_1, P0.1–P0.2 closed).
