# DATA_PROCESSING_INVENTORY.md

<!--
  CANONICAL REPO PATH: /docs/DATA_PROCESSING_INVENTORY.md
  DOCUMENT TYPE: Pod A KVKK / product-data inventory
  OWNER / AUTHOR: Pod A — Product & Planning
  REVIEWER: Pod B — Architecture, Logic & Risk
  APPROVER: Kerem
  STATUS: v0.1 — Pod B-reviewed per follow-on handoff; Kerem-approved 2026-06-15
  AUTHORITY: This document inventories personal-data-bearing surfaces for Phase 1 planning.
             It does not establish legal basis, retention periods, schema, API contracts,
             security architecture, or implementation authority.
  IMPLEMENTATION AUTHORITY: This document does NOT authorize Pod C.
  DATA: Synthetic examples only. No real Adeks customer, staff, phone, transaction, wallet,
        loyalty, reservation, or audit data may be copied here.
-->

## Status

| Field | Value |
|---|---|
| Document | `DATA_PROCESSING_INVENTORY.md` |
| Project | Adeks Platform |
| Owner / Author | Pod A — Product & Planning |
| Reviewer | Pod B — Architecture, Logic & Risk |
| Approver | Kerem |
| Current status | **v0.1 — Pod B-reviewed per follow-on handoff; Kerem-approved 2026-06-15** |
| Scope class | KVKK / product-data inventory |
| Implementation status | **Does NOT authorize Pod C** |
| Build-gate effect | Satisfies the **data-processing-inventory artifact** prerequisite only; all other legal, retention, security, architecture, and issue-readiness gates still apply |
| Required next review | Future updates after legal/privacy advisor response and Pod B security/data review where affected |

---

## Purpose

This document inventories Phase 1 personal-data-bearing fields and processing surfaces that must be considered before authentication, wallet, loyalty, and audit features are built.

It exists because `/docs/PROJECT_METHODOLOGY.md` §20.2 requires every feature that collects, displays, stores, transmits, or modifies personal data to link to the data processing inventory. It also records the `/docs/SECURITY_REVIEW.md` requirement that the audit store's personal-data fields — especially `subject_ref` / customer linkage, `reason_note` content, and `source_ip` — must be inventoried before implementation.

[NEEDS KEREM APPROVAL] Resolved for v0.1 on 2026-06-15. Future material changes to data classes, access scope, legal basis, retention, cross-border transfer, provider processing, or customer-facing notice content require Kerem approval.

[REQUIRES POD B REVIEW] Pod B remains reviewer for any future change affecting auth, wallet, loyalty, audit, customer personal data, security review dependencies, pseudonymisation, retention impact, or processor/security posture.

---

## Scope

### In scope for v0.1

| Area | Included in this inventory |
|---|---|
| Authentication | Customer phone OTP identity, phone hash / customer UUID linkage, OTP/auth-event metadata, staff/admin accounts, session/security metadata where personal-data-bearing |
| Wallet | Customer-wallet linkage, wallet ledger references, F&B settlement/correction personal-data surfaces, cashier/admin actor linkage, correction reason-code and `reason_note` risk |
| Loyalty | Customer-loyalty linkage, loyalty-account references, system-derived accrual/reversal traceability to human actor |
| Audit store | `subject_ref`, actor/customer linkage, `source_ip`, `user_agent_digest`, `reason_note_ref`, `change_set` derived identifiers, event references, correlation identifiers |
| Role-based access | Which Phase 1 roles see or generate each data class |
| Build gating | What this inventory satisfies and what remains blocked before Pod C can receive implementation work |

### Out of scope for v0.1

| Out of scope | Owner / next artifact |
|---|---|
| Legal basis by data type | `/docs/KVKK_LEGAL_BASIS.md` — Kerem + legal/privacy advisor, with Pod A support |
| Retention periods | `/docs/DATA_RETENTION_POLICY.md` and OQ-LEGAL-005 — Kerem + legal/privacy advisor; Pod B data-impact review |
| Privacy notice legal text | `/docs/PRIVACY_NOTICE_TR.md` — Kerem + legal/privacy advisor |
| Data-subject rights workflow | `/docs/DATA_SUBJECT_RIGHTS_PROCESS.md` |
| Cross-border transfer assessment | `/docs/CROSS_BORDER_TRANSFER_ASSESSMENT.md` |
| Database schema, physical types, encryption/key management, API contracts | Pod B architecture/security deliverables |
| Implementation tasks, migrations, tests, CI | Pod C only after approved issues; **not authorized here** |

---

## Source Context

This v0.1 inventory is based on:

- `/docs/PROJECT_METHODOLOGY.md` §20.2 and §20.3
- `/docs/SECURITY_REVIEW.md` §4.1–§4.5, §6, §7, §8.3, §11
- `/docs/architecture/AUDIT_EVENT_SCHEMA.md` §5–§6.8
- `/docs/USER_ROLES_AND_PERMISSIONS.md` §3, §5, §6
- `/docs/adr/ADR-006-wallet-append-only-ledger.md`
- `/docs/adr/ADR-007-loyalty-append-only-ledger.md`
- `/docs/adr/ADR-015-authentication-strategy.md`
- `/docs/adr/ADR-009-pr-approval-policy.md`

If any source document conflicts with this inventory, the more authoritative source governs and this inventory must be updated.

---

## Inventory Principles

| ID | Principle |
|---|---|
| DPI-P-001 | Inventory does not equal legal basis. Legal basis remains a separate legal/KVKK artifact. |
| DPI-P-002 | Inventory does not equal retention policy. Retention periods remain unresolved until `/docs/DATA_RETENTION_POLICY.md` and OQ-LEGAL-005 are resolved. |
| DPI-P-003 | No raw phone numbers, OTPs, passwords, tokens, TOTP secrets, or unnecessary free text should appear in logs or audit records. |
| DPI-P-004 | Wallet and loyalty ledgers remain append-only; no direct balance overwrite is allowed. |
| DPI-P-005 | Audit records are append-only; `ADMIN` may read but may not edit or delete audit entries. |
| DPI-P-006 | Non-production data must be synthetic only. |
| DPI-P-007 | Personal data access should be minimized by role and workflow. |
| DPI-P-008 | Free-text fields are treated as personal-data risk surfaces and should be constrained. |

---

## Role Access Summary

| Role | Personal / sensitive data accessed or generated | Scope |
|---|---|---|
| `CUSTOMER` | Own phone number, own customer account identifiers, own wallet/loyalty status, own F&B orders, own reservations, own auth/session metadata | Own account only |
| `CASHIER` | Masked customer phone during permitted workflows, transaction-scoped wallet/loyalty records, F&B settlement/correction references, actor identity on audit/ledger entries | Operational, transaction-scoped |
| `FB_STAFF` | F&B order records, order status, seat/PC context where needed for delivery, staff action audit metadata | Order-management only; no wallet/loyalty/payment access |
| `ADMIN` | Customer identifiers, full phone where explicitly permitted, wallet/loyalty operational records, staff/admin account records, audit logs, security/admin action metadata | Full operational administration; all sensitive access must be auditable |
| `SYSTEM` / `SCHEDULED_JOB` | System-derived ledger/audit events, correlation references, on-behalf-of attribution | No human identity by itself; must link back to triggering human where required |

---

## Data Inventory by Area

### Authentication and account access

| Data element | Personal-data status | Generated / used by | Purpose | Notes / constraints |
|---|---|---|---|---|
| Customer phone number | Personal data | Customer PWA, OTP provider, backend auth | Customer identity and OTP delivery | Legal basis, notice text, provider assessment, and retention remain separate blockers |
| Customer UUID / account ID | Personal data by linkage | Backend auth, PWA, admin views | Stable customer reference | Must not expose unnecessary customer lookup to non-admin roles |
| Phone hash / derived identifier | Personal data by linkage | Backend auth, audit, logs where allowed | De-identified reference where raw phone is prohibited | Must not be treated as anonymous if re-linkable |
| OTP request metadata | Personal/security metadata | Customer PWA, backend, SMS provider | Fraud/rate-limit/security monitoring | No OTP plaintext in logs/audit; retention unresolved |
| Auth event metadata | Personal/security metadata | Backend audit/auth | Login success/failure, logout, session expiry, step-up/admin events | May include `source_ip`; retention unresolved |
| Staff/admin account ID | Staff personal data | Staff/admin console, backend, audit | Attribution of sensitive staff actions | Shared accounts prohibited |
| Staff/admin credential metadata | Sensitive security data | Backend auth | Login/security controls | Passwords/secrets never logged; TOTP secrets not inventoried as displayable data |
| Session/security metadata | Personal/security metadata | Backend auth | Session control, replay detection, incident response | No tokens in logs/audit; retention unresolved |

### Wallet

| Data element | Personal-data status | Generated / used by | Purpose | Notes / constraints |
|---|---|---|---|---|
| Wallet account ID | Personal data by customer linkage | Backend wallet module, PWA, cashier/admin views | Link customer to wallet ledger | No mutable balance column; displayed balance is derived |
| Wallet ledger entry ID | Personal data by linkage | Wallet ledger, audit | Immutable financial event reference | Append-only; correction by compensating entry only |
| F&B settlement reference | Personal/transaction data | Cashier/admin, wallet ledger, audit | Debit customer wallet for settled F&B order | Must link to order and actor without exposing unnecessary data |
| Correction reason code | Operational/personal context | Cashier/admin correction flow | Structured reason for correction | Use enum/structured reason where possible |
| Correction `reason_note` | High-risk free-text personal-data surface | Cashier/admin correction flow | Optional explanatory note when required | Must be constrained; see DPI-OQ-007 |
| Cashier/admin actor ID | Staff personal data | Wallet ledger, audit | Attribution and abuse detection | Individual credentials required |
| Derived balance snapshot | Personal/financial derived data | Wallet/audit reports | Investigator/customer support context | Not authoritative; ledger sum remains authority |

### Loyalty

| Data element | Personal-data status | Generated / used by | Purpose | Notes / constraints |
|---|---|---|---|---|
| Loyalty account ID | Personal data by customer linkage | Loyalty module, PWA, admin views | Link customer to points ledger | No direct manual point edit in Phase 1 |
| Loyalty ledger entry ID | Personal data by linkage | Loyalty ledger, audit | Immutable points event reference | Append-only; reversal linked to corrected source |
| Points delta / accrual / reversal | Personal/transaction data | Loyalty module, audit | Earn/reverse points from eligible settlement | System-derived, attributable to triggering human |
| `on_behalf_of_actor_id` | Staff personal data | Loyalty/audit | Link system-derived event to human action | Required for traceability of system-posted events |
| Order/settlement reference | Personal/transaction data | Loyalty/audit | Link loyalty to wallet/F&B event | Must use references, not duplicated PII |

### Audit store

| Audit field / surface | Personal-data status | Purpose | Rule / constraint |
|---|---|---|---|
| `actor_id` | Staff/customer personal data | Attribute action to authenticated principal | Individual credentials only; no shared staff accounts |
| `actor_type` | Role/authority metadata | Interpret actor identity | Closed role taxonomy |
| `on_behalf_of_actor_id` | Staff personal data | Preserve human attribution for system-derived events | Required where system-posted event originates from human action |
| `subject_ref` | Personal data by linkage | Identify affected customer/account/loyalty subject | Derived identifier only; never raw phone |
| `target_entity_id` | Personal/operational data by linkage | Identify affected domain row | Reference immutable rows; avoid duplicating PII |
| `references[]` | Personal/transaction linkage | Link related immutable rows | May reveal relationship graph; access must be controlled |
| `change_set` | May be personal data | Record derived before/after or domain changes | Never raw PII; never balance overwrite |
| `reason_code` | Operational data | Structured correction reason | Required for discretionary financial corrections |
| `reason_note_ref` | Link to high-risk free-text personal data | Point to canonical note, if present | Must support future pseudonymisation/minimization approach |
| `source_ip` | Personal data | Security review, incident response, abuse detection | Capture only where required; retention unresolved |
| `user_agent_digest` | Device/security metadata; may be personal data by linkage | Coarse device context | Not a high-entropy fingerprint |
| `correlation_id` | Personal/transaction linkage | Link events in one business transaction | Avoid exposing to customer-facing surfaces unless needed |
| `prev_hash` / `row_hash` | Integrity metadata | Tamper evidence | Pod B owns canonicalization and pseudonymization interaction |

---

## External Recipients / Processors to Assess

| Processor / external party | Data potentially processed | Status |
|---|---|---|
| SMS provider | Customer phone number, OTP delivery metadata, provider delivery logs | [OPEN QUESTION] Provider not selected; processor/cross-border assessment required |
| Hosting / infrastructure provider | Application database, audit store, logs, backups, source IPs, operational metadata | [OPEN QUESTION] Hosting model not locked; cross-border assessment may apply |
| Backup / monitoring / error tracking vendor, if any | Logs, incident data, source IPs, staff/admin identifiers, operational metadata | [OPEN QUESTION] Vendor and data minimization design pending Pod B review |
| Legal/privacy advisor | Inventory, legal-basis matrix, retention questions, notice text, VERBİS/cross-border assessment | [NEEDS KEREM APPROVAL — legal workflow] |

No new processor is approved by this inventory.

---

## Legal Basis and Retention Status

| Area | Legal basis status | Retention status |
|---|---|---|
| Customer phone / OTP identity | [OPEN QUESTION] `/docs/KVKK_LEGAL_BASIS.md` absent | [OPEN QUESTION] `/docs/DATA_RETENTION_POLICY.md` absent; OQ-LEGAL-005 |
| Auth/security event metadata | [OPEN QUESTION] Legal basis pending | [OPEN QUESTION] Retention pending; `source_ip` may require separate treatment |
| Staff/admin accounts and activity | [OPEN QUESTION] Legal basis pending | [OPEN QUESTION] Retention pending |
| Wallet ledger linked to customer | [OPEN QUESTION] Legal basis pending | [OPEN QUESTION] Retention pending; financial/legal-retention input required |
| Loyalty ledger linked to customer | [OPEN QUESTION] Legal basis pending | [OPEN QUESTION] Retention pending |
| Correction `reason_note` | [OPEN QUESTION] Legal basis pending; free-text minimization required | [OPEN QUESTION] Retention and pseudonymisation process pending |
| Audit store | [OPEN QUESTION] Legal basis pending | [OPEN QUESTION] Retention pending; OQ-LEGAL-005 / KD-D |
| Source IP / device digest | [OPEN QUESTION] Legal basis pending | [OPEN QUESTION] Retention pending; may differ from financial-entry retention |

[NEEDS KEREM APPROVAL] Kerem must route legal-basis and retention decisions through the legal/privacy advisor before production use.

---

## Build-Gating Rules

| Gate | Rule |
|---|---|
| DPI-GATE-001 | This v0.1 inventory artifact is approved at the inventory level by Kerem on 2026-06-15, following Pod B review as stated in the follow-on handoff. |
| DPI-GATE-002 | This approval satisfies the inventory-document prerequisite only; it does **not** approve legal basis, retention, privacy notice text, processors, schema, API contracts, or implementation. |
| DPI-GATE-003 | Auth, wallet, loyalty, and audit features that collect, store, transmit, display, or modify personal data still require separately approved GitHub issues before Pod C can work. |
| DPI-GATE-004 | Retention remains blocked by OQ-LEGAL-005 and `/docs/DATA_RETENTION_POLICY.md`. No retention period is invented here. |
| DPI-GATE-005 | Legal basis remains blocked by `/docs/KVKK_LEGAL_BASIS.md` and legal/privacy advisor input. |
| DPI-GATE-006 | Third-party SMS/provider processing remains blocked by provider selection, KVKK processor assessment, and cross-border assessment where applicable. |
| DPI-GATE-007 | Pod C is not authorized by this inventory. Pod C work requires separate approved GitHub issues that meet Definition of Ready and the ADR-009 / methodology review gates. |

---

## Open Questions

| ID | Question | Owner | Routing |
|---|---|---|---|
| DPI-OQ-001 | What legal basis applies to each auth, wallet, loyalty, and audit data element? | Kerem + legal/privacy advisor | `/docs/KVKK_LEGAL_BASIS.md` |
| DPI-OQ-002 | What retention period applies to each data class, especially source IP, audit events, wallet/loyalty ledgers, and correction notes? | Kerem + legal/privacy advisor; Pod B reviews data impact | `/docs/DATA_RETENTION_POLICY.md`; OQ-LEGAL-005 |
| DPI-OQ-003 | What exact privacy notice text must be displayed before OTP and what acknowledgement record must be stored? | Kerem + legal/privacy advisor | `/docs/PRIVACY_NOTICE_TR.md` |
| DPI-OQ-004 | What pseudonymisation process applies when a customer exercises erasure rights while append-only ledgers/audit must remain intact? | Pod B + Kerem + legal/privacy advisor | Future pseudonymisation / data-subject-rights artifact |
| DPI-OQ-005 | Should `ADMIN` audit views mask or suppress selected fields by default even though admin has audit-read permission? | Pod B + Kerem | Security/RBAC review |
| DPI-OQ-006 | Which external processors will handle phone numbers, logs, backups, monitoring, or audit metadata? | Kerem + Pod B | Provider/security/KVKK assessment |
| DPI-OQ-007 | How should `reason_note` free text be constrained in UI to reduce accidental personal-data entry? | Pod A + Pod B; Kerem approves product policy | Wallet correction UX / business rules |
| DPI-OQ-008 | How will hash-chain canonicalization and pseudonymization interact for audit records that later need personal-data redaction/pseudonymization? | Pod B | SR-002 follow-on design |

---

## Review Routing

- Ready for commit: Yes — v0.1 is Pod B-reviewed per follow-on handoff and Kerem-approved on 2026-06-15.
- Requires Kerem approval: Future legal-basis/retention routing; third-party processor decisions; material changes to inventory scope.
- Requires Pod B review: Future auth/wallet/loyalty/audit/customer-data changes; SR-002/SR-008/SR-009 dependencies; security/KVKK consistency.
- Requires Pod C implementation: No — **do not authorize Pod C from this document**.
- Requires Pod D prototype/audit/monitoring review: Later — audit completeness/hash-chain monitoring and possible admin audit-view UX review after Pod B design.

---

## Document History

| Version | Date | Author | Change |
|---|---|---|---|
| v0.1 | 2026-06-15 | Pod A | Initial data-processing inventory after `SECURITY_REVIEW.md` merge context. Inventories audit-store personal-data fields (`subject_ref`, customer linkage, `reason_note`, `source_ip`) and auth/wallet/loyalty PII surfaces. Pod B review reported complete in follow-on handoff; Kerem approval recorded 2026-06-15. No legal basis or retention periods set. No Pod C authorization. |
