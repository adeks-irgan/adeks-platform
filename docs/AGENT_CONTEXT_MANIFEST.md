# AGENT_CONTEXT_MANIFEST.md

**Owner:** Pod A — Product & Planning  
**Reviewer:** Pod B — Architecture, Logic & Risk  
**Approver:** Kerem  
**Status:** Active — live context-routing index (ADR-013 PR-3 merged 2026-06-05)  
**Canonical repo path:** `/docs/AGENT_CONTEXT_MANIFEST.md`

---

## Purpose

This manifest routes pods to the repository files they should load or request before acting on a given task type.

It is a context-routing index only. It does not define methodology, governance, review gates, approval gates, or decision authority. If this manifest conflicts with `/docs/PROJECT_METHODOLOGY.md`, `/docs/PROJECT_DECISION_INDEX.md`, or an accepted ADR, those sources govern and this manifest must be corrected.

---

## Status Vocabulary

| Status | Meaning |
|---|---|
| `exists` | File is present in the repository after this bundle lands. |
| `planned` | File is expected but not yet created. |
| `missing` | File should exist for current work but is absent and not yet scheduled. |
| `unknown` | File existence or currentness has not been verified. |
| `mixed` | The row references more than one file and their statuses differ. |

---

## Context Routing Matrix

| Task Type | Required Files | File Status | Fallback if Absent | Affected Pods | Required Review | Freshness Required |
|---|---|---|---|---|---|---|
| Wallet | `/docs/PROJECT_METHODOLOGY.md`; `/docs/PROJECT_DECISION_INDEX.md`; `/docs/MVP_SCOPE.md`; `/docs/BUSINESS_RULES.md`; `/docs/DOMAIN_MODEL.md`; `/docs/USER_ROLES_AND_PERMISSIONS.md`; `/docs/CORE_USER_FLOWS.md`; `/docs/adr/ADR-006-wallet-append-only-ledger.md`; `/docs/SECURITY_REVIEW.md`; `/docs/DATA_PROCESSING_INVENTORY.md` | mixed: `PROJECT_METHODOLOGY.md` and `PROJECT_DECISION_INDEX.md` exist; product docs and ADR/security/KVKK docs are planned | If ledger ADR, security review, or KVKK files are absent, produce product draft or review note only; mark output `Needs repo reconciliation`; do not issue Pod C implementation work. | A, B, C | Pod B + Kerem | Yes |
| Loyalty | `/docs/PROJECT_METHODOLOGY.md`; `/docs/PROJECT_DECISION_INDEX.md`; `/docs/MVP_SCOPE.md`; `/docs/BUSINESS_RULES.md`; `/docs/DOMAIN_MODEL.md`; `/docs/USER_ROLES_AND_PERMISSIONS.md`; `/docs/CORE_USER_FLOWS.md`; `/docs/adr/ADR-007-loyalty-append-only-ledger.md`; `/docs/SECURITY_REVIEW.md`; `/docs/DATA_PROCESSING_INVENTORY.md` | mixed: `PROJECT_METHODOLOGY.md` and `PROJECT_DECISION_INDEX.md` exist; product docs and ADR/security/KVKK docs are planned | If ledger ADR, security review, or KVKK files are absent, produce product draft or review note only; mark output `Needs repo reconciliation`; do not issue Pod C implementation work. | A, B, C | Pod B + Kerem | Yes |
| F&B ordering | `/docs/PROJECT_BRIEF.md`; `/docs/MVP_SCOPE.md`; `/docs/BUSINESS_RULES.md`; `/docs/CORE_USER_FLOWS.md`; `/docs/USER_ROLES_AND_PERMISSIONS.md`; `/docs/DOMAIN_MODEL.md`; `/docs/NON_FUNCTIONAL_REQUIREMENTS.md`; `/docs/OPEN_QUESTIONS.md`; `/docs/architecture/API_CONTRACTS.md` | planned | If product docs are absent, draft the missing product document first. If API contracts are absent, do not create implementation issue until Pod B provides or approves interface direction. | A, B, C, D | Pod B if order state, audit, customer data, or integration is affected; Kerem for workflow/policy approval | Yes, if audit/customer-data/payment/session impact exists |
| Reservations | `/docs/PROJECT_BRIEF.md`; `/docs/MVP_SCOPE.md`; `/docs/BUSINESS_RULES.md`; `/docs/CORE_USER_FLOWS.md`; `/docs/USER_ROLES_AND_PERMISSIONS.md`; `/docs/DOMAIN_MODEL.md`; `/docs/RESERVATION_STATE_MACHINE.md`; `/docs/OPEN_QUESTIONS.md` | planned | If reservation state machine is absent, draft business flow only and route state-machine design to Pod B before Pod C implementation. | A, B, C, D | Pod B + Kerem | Yes |
| Auth | `/docs/PROJECT_METHODOLOGY.md`; `/docs/PROJECT_DECISION_INDEX.md`; `/docs/USER_ROLES_AND_PERMISSIONS.md`; `/docs/SECURITY_REVIEW.md`; `/docs/architecture/SECURITY_VIEW.md`; relevant auth ADR if created | mixed: methodology and decision index exist; role/security architecture files are planned | If role/permission or security files are absent, do not create implementation issue; request Pod B review and produce missing product-role input first. | A, B, C | Pod B; Kerem if customer-data or admin-policy impact exists | Yes |
| Selcafe integration | `/docs/PROJECT_METHODOLOGY.md`; `/docs/PROJECT_DECISION_INDEX.md`; `/docs/SELCAFE_SPIKE_REPORT.md`; `/docs/adr/ADR-005-selcafe-read-only-phase-1-adapter.md`; `/docs/architecture/INTEGRATION_VIEW.md`; `/docs/DATA_PROCESSING_INVENTORY.md` | mixed: methodology and decision index exist; spike, ADR, integration view, and KVKK files are planned | If spike or ADR is absent, perform documentation/spike planning only; do not approve writes; keep Phase 1 posture read-only unless Kerem explicitly approves a later change. | A, B, C | Pod B + Kerem | Yes |
| Schema/migration | `/docs/PROJECT_METHODOLOGY.md`; `/docs/PROJECT_DECISION_INDEX.md`; `/docs/DOMAIN_MODEL.md`; `/docs/architecture/DATA_VIEW.md`; `/docs/schema/`; relevant ADRs; `/docs/ROLLBACK_POLICY.md` | mixed: methodology and decision index exist; domain/data/schema/rollback files are planned | If schema or migration ADR context is absent, stop implementation handoff and request Pod B schema direction. Do not infer schema from product notes alone. | B, C, A | Pod B + Kerem for production-impacting or sensitive schema changes | Yes |
| Methodology change | `/docs/PROJECT_METHODOLOGY.md`; `/docs/PROJECT_DECISION_INDEX.md`; `/docs/adr/ADR-013-repository-controlled-pod-context.md`; `/docs/adr/ADR-009-pr-approval-policy.md`; `/docs/templates/`; affected pod instruction snapshots; `/CLAUDE.md` if Pod C behavior is affected | mixed: methodology, decision index, ADR-009, ADR-013, and templates exist; all four pod instruction snapshots now exist (`POD_A_CHATGPT_INSTRUCTIONS.md`, `POD_B_CLAUDE_PROJECT_INSTRUCTIONS.md`, `POD_D_GEMINI_GEM_INSTRUCTIONS.md`, `/CLAUDE.md` — updated 2026-06-06) | If any affected template or snapshot is absent, list the missing file and produce a proposal or patch only; do not mark behavior-changing PR complete without Pod Impact Matrix and Instruction Update Packet. | A, B, C, D | Pod B + Kerem | Yes |

---

## Notes

- Files marked `planned` are intentionally allowed to be absent until their owning pod produces them.
- This manifest should be updated when new task types, canonical files, or ADRs are added.
- A future CI check may validate that paths marked `exists` are present and that paths marked `planned` are allowed to be absent.
