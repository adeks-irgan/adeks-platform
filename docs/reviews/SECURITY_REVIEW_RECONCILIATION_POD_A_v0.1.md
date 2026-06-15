# SECURITY_REVIEW_RECONCILIATION_POD_A_v0.1.md

<!--
  SUGGESTED REPO PATH: /docs/reviews/SECURITY_REVIEW_RECONCILIATION_POD_A_v0.1.md
  DOCUMENT TYPE: Pod A reconciliation packet
  OWNER / AUTHOR: Pod A — Product & Planning
  REVIEWER: Pod B — Architecture, Logic & Risk
  APPROVER: Kerem where approval-sensitive items are marked
  STATUS: v0.1 draft for Pod B review
  IMPLEMENTATION AUTHORITY: This document does NOT authorize Pod C.
-->

## Status

| Field | Value |
|---|---|
| Document | `SECURITY_REVIEW_RECONCILIATION_POD_A_v0.1.md` |
| Owner / Author | Pod A — Product & Planning |
| Reviewer | Pod B — Architecture, Logic & Risk |
| Approver | Kerem for approval-sensitive items |
| Current status | v0.1 draft for Pod B review |
| Implementation status | **Does NOT authorize Pod C** |

---

## Purpose

This packet reconciles the merged `/docs/SECURITY_REVIEW.md` against `/docs/AGENT_CONTEXT_MANIFEST.md` and records Pod A's decision on SR-008 and SR-009.

It is documentation-only. It does not modify decision state, create implementation issues, approve security architecture, set legal basis, set retention periods, or clear Pod C.

---

## Inputs

- `/docs/AGENT_CONTEXT_MANIFEST.md`
- `/docs/SECURITY_REVIEW.md`
- `/docs/PROJECT_METHODOLOGY.md`
- `/docs/adr/ADR-009-pr-approval-policy.md`
- `/docs/architecture/AUDIT_EVENT_SCHEMA.md`
- `/docs/USER_ROLES_AND_PERMISSIONS.md`
- `/docs/adr/ADR-006-wallet-append-only-ledger.md`
- `/docs/adr/ADR-007-loyalty-append-only-ledger.md`
- `/docs/adr/ADR-015-authentication-strategy.md`

---

## 1. Manifest Reconciliation

### Decision

Update the Wallet, Loyalty, and Auth rows in `/docs/AGENT_CONTEXT_MANIFEST.md` so the File Status text records `/docs/SECURITY_REVIEW.md` as `exists`.

### Proposed exact status edits

| Manifest row | Current issue | Proposed status treatment |
|---|---|---|
| Wallet | Row still groups security review with planned files | Mark `SECURITY_REVIEW.md` as exists; keep `DATA_PROCESSING_INVENTORY.md` as planned/missing until this inventory is reviewed and approved |
| Loyalty | Row still groups security review with planned files | Mark `SECURITY_REVIEW.md` as exists; keep `DATA_PROCESSING_INVENTORY.md` as planned/missing until this inventory is reviewed and approved |
| Auth | Row names both `SECURITY_REVIEW.md` and `/docs/architecture/SECURITY_VIEW.md`; only the review exists | Mark `SECURITY_REVIEW.md` as exists; keep `/docs/architecture/SECURITY_VIEW.md` as planned |

### Behavior-change assessment

[ASSUMPTION] This is a context-status correction only. It does not change pod responsibilities, approval gates, context-loading rules, methodology, templates, or decision state.

[REQUIRES POD B REVIEW] Pod B should confirm that this is not behavior-changing under ADR-009 §4. If Pod B classifies the manifest text change as behavior-changing because it alters context-routing semantics, then the PR must include the ADR-009 §4 Pod Impact Matrix and Instruction Update Packet.

---

## 2. SR-008 Decision — `SECURITY_VIEW.md`

### Decision

Keep `/docs/architecture/SECURITY_VIEW.md` as a separate planned Pod B architecture artifact.

Do **not** reconcile the Auth row by replacing `/docs/architecture/SECURITY_VIEW.md` with `/docs/SECURITY_REVIEW.md`.

### Rationale

`SECURITY_REVIEW.md` is the §20.3 security review artifact. It assesses the existing security corpus and records review verdicts, blockers, residual risks, and follow-on gaps.

`/docs/architecture/SECURITY_VIEW.md` is a broader architecture security view named by the methodology architecture viewpoints. It should describe the security architecture viewpoint: authentication, RBAC, audit, data protection, trust boundaries, key security flows, and cross-cutting architecture constraints.

Collapsing the architecture view into the review would mix two artifact types:
- a review artifact that evaluates readiness and gaps;
- an architecture view artifact that describes the intended architecture.

### Routing

[REQUIRES POD B REVIEW] Pod B should produce or plan `/docs/architecture/SECURITY_VIEW.md`.

[NEEDS KEREM APPROVAL] Kerem approval is required if the security view introduces or changes security/customer-data/admin-policy decisions.

---

## 3. SR-009 Decision — `SECURE_SDLC.md`

### Decision

Keep `/docs/SECURE_SDLC.md` as a separate planned process artifact unless Pod B and Kerem decide to remove the methodology reference in a future behavior-changing methodology PR.

Do **not** treat `/docs/SECURITY_REVIEW.md` as a substitute for `/docs/SECURE_SDLC.md`.

### Rationale

`SECURITY_REVIEW.md` covers the current security review posture. It does not define the detailed secure-SDLC process, tool expectations, dependency-update cadence, security regression workflow, or CI security gate policy.

`PROJECT_METHODOLOGY.md` §20.1 explicitly refers to `/docs/SECURE_SDLC.md` for the detailed process. Removing or replacing that reference would affect methodology/process documentation and should be handled under ADR-009 if pursued.

### Routing

[REQUIRES POD B REVIEW] Pod B should review the target ownership/scope of `/docs/SECURE_SDLC.md`, especially for secure coding, SAST/DAST, dependency scanning, secrets scanning, audit-grant verification, and security-regression expectations.

[REQUIRES POD C IMPLEMENTATION] Only after Pod B and Kerem approve concrete CI/security-tooling requirements, Pod C may implement CI/security gates through separate approved issues.

[NEEDS KEREM APPROVAL] Kerem approval is required for vendor/data-processing-impacting security tooling or process decisions.

---

## 4. DATA_PROCESSING_INVENTORY.md Decision

### Decision

Create `/docs/DATA_PROCESSING_INVENTORY.md` as a Pod A v0.1 draft.

The first version must inventory at minimum:
- audit store personal-data fields:
  - `subject_ref`;
  - customer/account linkage;
  - `reason_note` / `reason_note_ref`;
  - `source_ip`;
  - `user_agent_digest`;
  - actor and `on_behalf_of_actor_id` linkage;
  - correlation/event references that link customer and staff/admin activity;
- auth PII:
  - customer phone number;
  - phone hash / customer UUID;
  - OTP/auth event metadata;
  - staff/admin account identifiers;
  - session/security metadata where personal-data-bearing;
- wallet PII:
  - wallet account/customer linkage;
  - wallet ledger references;
  - F&B settlement/correction linkage;
  - cashier/admin actor linkage;
  - correction reason code and free-text note;
- loyalty PII:
  - loyalty account/customer linkage;
  - loyalty ledger references;
  - points delta/accrual/reversal linkage;
  - human attribution for system-derived loyalty events.

### Status

[REQUIRES POD B REVIEW] The v0.1 inventory must be reviewed by Pod B before being treated as complete.

[NEEDS KEREM APPROVAL] Kerem must approve the inventory before it satisfies the build prerequisite.

[OPEN QUESTION] Legal basis, retention, cross-border transfer, and privacy notice text remain unresolved and belong to the relevant legal/KVKK artifacts.

---

## 5. Pod C Authorization

No Pod C authorization is granted.

The merged `SECURITY_REVIEW.md` satisfies the manifest's named security-review dependency only at the review level. Implementation remains blocked by:
- `/docs/DATA_PROCESSING_INVENTORY.md` review + Kerem approval;
- `/docs/DATA_RETENTION_POLICY.md` and OQ-LEGAL-005;
- `/docs/KVKK_LEGAL_BASIS.md`;
- SMS provider / cross-border / privacy notice open items where applicable;
- separate Pod B + Kerem approved GitHub issues.

---

## Review Routing

- Ready for commit: The manifest status patch and this reconciliation packet are ready for Pod B review, not final approval.
- Requires Kerem approval: `DATA_PROCESSING_INVENTORY.md`; any decision that changes legal/KVKK/security/customer-data policy; vendor/data-processing-impacting security tooling.
- Requires Pod B review: Manifest reconciliation, SR-008/SR-009 decision, `DATA_PROCESSING_INVENTORY.md`, and any future security/KVKK/process artifact scope.
- Requires Pod C implementation: None.
- Requires Pod D prototype/audit/monitoring review: Later for audit completeness/hash-chain monitoring and possible admin audit-view UX.

---

## Handoff Prompt — Pod B

```md
## Handoff Summary

Pod A reconciled the merged `/docs/SECURITY_REVIEW.md` against `/docs/AGENT_CONTEXT_MANIFEST.md`, made the SR-008/SR-009 artifact-scope decision, and drafted `/docs/DATA_PROCESSING_INVENTORY.md` v0.1. Review is required before commit/approval. This does not authorize Pod C.

## Source Pod

Pod A — Product & Planning

## Target Pod

Pod B — Architecture, Logic & Risk

## Trigger

`/docs/SECURITY_REVIEW.md` was merged as a documentation-only Pod B security review and changes no decision state. The manifest still needed security-review status reconciliation, and the security review states that `/docs/DATA_PROCESSING_INVENTORY.md` is absent and blocks personal-data features.

## Relevant Links

Attach these repository files / drafts:
- `/docs/AGENT_CONTEXT_MANIFEST.md`
- `/docs/SECURITY_REVIEW.md`
- `/docs/PROJECT_METHODOLOGY.md`
- `/docs/adr/ADR-009-pr-approval-policy.md`
- `/docs/architecture/AUDIT_EVENT_SCHEMA.md`
- `/docs/USER_ROLES_AND_PERMISSIONS.md`
- `/docs/adr/ADR-006-wallet-append-only-ledger.md`
- `/docs/adr/ADR-007-loyalty-append-only-ledger.md`
- `/docs/adr/ADR-015-authentication-strategy.md`
- Draft: `/docs/DATA_PROCESSING_INVENTORY.md`
- Draft/patch: `/docs/AGENT_CONTEXT_MANIFEST.md` Wallet/Loyalty/Auth File Status update
- Optional review packet: `/docs/reviews/SECURITY_REVIEW_RECONCILIATION_POD_A_v0.1.md`

## Decision or Review Needed

Please review:
1. Manifest status patch: Wallet, Loyalty, and Auth rows should mark `/docs/SECURITY_REVIEW.md` as `exists`, while keeping `/docs/DATA_PROCESSING_INVENTORY.md`, `/docs/DATA_RETENTION_POLICY.md`, `/docs/KVKK_LEGAL_BASIS.md`, and `/docs/architecture/SECURITY_VIEW.md` unresolved/planned as applicable.
2. SR-008: Pod A recommends keeping `/docs/architecture/SECURITY_VIEW.md` as a separate Pod B architecture security-view artifact, not replacing it with `/docs/SECURITY_REVIEW.md`.
3. SR-009: Pod A recommends keeping `/docs/SECURE_SDLC.md` as a separate detailed process artifact, not replacing it with `/docs/SECURITY_REVIEW.md`.
4. `DATA_PROCESSING_INVENTORY.md` v0.1: review for security/KVKK/data-impact consistency, especially audit-store personal-data fields (`subject_ref`, customer linkage, `reason_note`, `source_ip`), auth PII, wallet PII, and loyalty PII.

## Assumptions

- The manifest patch is a documentation/status correction and not behavior-changing under ADR-009 §4.
- `SECURITY_REVIEW.md` satisfies only the manifest's security-review dependency at the review level and does not unblock implementation.
- Legal basis and retention periods remain unresolved and are not invented in the inventory.

## Open Questions

- Does Pod B agree that `/docs/architecture/SECURITY_VIEW.md` should remain a separate artifact?
- Does Pod B agree that `/docs/SECURE_SDLC.md` should remain a separate artifact?
- Does the inventory need additional fields for auth/session metadata, staff personal data, audit hash-chain linkage, or future data-subject-rights pseudonymisation?
- Does the manifest patch require ADR-009 §4 behavior-change handling, or is it a status-only reconciliation?

## Risk / Sensitivity

High. This touches authentication, wallet, loyalty, audit, customer personal data, security-sensitive review artifacts, and KVKK blockers. Pod C is not authorized.

## Expected Output

Return a written Pod B review with blocking / non-blocking / advisory findings and any required Kerem decisions. Confirm whether the manifest patch can proceed as a non-behavior-changing documentation/status reconciliation.
```

## Handoff Prompt — Kerem

```md
## Handoff Summary

Pod A prepared a v0.1 `/docs/DATA_PROCESSING_INVENTORY.md` for the personal-data surfaces that block auth, wallet, loyalty, and audit implementation. Pod B review is required first. After Pod B review, Kerem approval is required before this inventory can satisfy the build prerequisite.

## Source Pod

Pod A — Product & Planning

## Target

Kerem

## Trigger

`/docs/SECURITY_REVIEW.md` identifies `/docs/DATA_PROCESSING_INVENTORY.md` as absent and a hard prerequisite before personal-data features can be built.

## Decision or Review Needed

After Pod B review, approve or request changes to `/docs/DATA_PROCESSING_INVENTORY.md`.

## Assumptions

- This inventory does not decide legal basis or retention.
- Legal basis, retention, privacy notice, VERBİS, and cross-border transfer still require legal/privacy advisor input.
- No Pod C work is authorized by this inventory.

## Open Questions

- Should correction free-text `reason_note` be allowed at all in Phase 1, or should it be constrained to structured reasons as much as possible?
- Should admin audit views mask customer/staff identifiers by default even for admin users?
- Which legal/privacy advisor decisions should be recorded before Kerem approves the inventory?

## Risk / Sensitivity

Customer personal data, staff/admin identifiers, wallet/loyalty linkage, audit logs, source IPs, free-text correction notes, and third-party/SMS processing.

## Expected Output

A GitHub-visible approval, rejection, or requested-change comment after Pod B review. Do not route to Pod C until approval and remaining legal/KVKK blockers are resolved.
```
