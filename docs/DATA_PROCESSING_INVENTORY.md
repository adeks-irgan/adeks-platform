# DATA_PROCESSING_INVENTORY.md

<!--
  CANONICAL REPO PATH: /docs/DATA_PROCESSING_INVENTORY.md
  DOCUMENT TYPE: Pod A KVKK / product-data inventory
  OWNER / AUTHOR: Pod A — Product & Planning
  REVIEWER: Pod B — Architecture, Logic & Risk
  APPROVER: Kerem
  STATUS: v0.2 draft — Selcafe-derived data surface inventory + PI-1/PI-2 proposal;
          requires Pod B review and Kerem approval before merge
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
| Current status | **v0.2 draft — adds Selcafe-derived data surface inventory and PI-1/PI-2 product-position proposal; requires Pod B review and Kerem approval before merge** |
| Scope class | KVKK / product-data inventory |
| Implementation status | **Does NOT authorize Pod C** |
| Build-gate effect | Satisfies the **data-processing-inventory artifact** prerequisite only; all other legal, retention, security, architecture, and issue-readiness gates still apply |
| Required next review | Pod B review + Kerem approval for this v0.2 Selcafe/KVKK data-surface update before merge |

---

## Purpose

This document inventories Phase 1 personal-data-bearing fields and processing surfaces that must be considered before authentication, wallet, loyalty, and audit features are built.

It exists because `/docs/PROJECT_METHODOLOGY.md` §20.2 requires every feature that collects, displays, stores, transmits, or modifies personal data to link to the data processing inventory. It also records the `/docs/SECURITY_REVIEW.md` requirement that the audit store's personal-data fields — especially `subject_ref` / customer linkage, `reason_note` content, and `source_ip` — must be inventoried before implementation.

[NEEDS KEREM APPROVAL] Resolved for v0.1 on 2026-06-15. Future material changes to data classes, access scope, legal basis, retention, cross-border transfer, provider processing, or customer-facing notice content require Kerem approval.

[REQUIRES POD B REVIEW] Pod B remains reviewer for any future change affecting auth, wallet, loyalty, audit, customer personal data, security review dependencies, pseudonymisation, retention impact, or processor/security posture.

[REQUIRES POD B REVIEW] This v0.2 update inventories Selcafe-derived data surfaces from ADR-005. It is documentation-only and does not approve adapter implementation, SQL access, credentials, schema, API contracts, or runtime behavior.

[NEEDS KEREM APPROVAL] This v0.2 update includes Pod A's product-position proposal for ADR-005 PI-1/PI-2. It becomes durable only after Pod B review and Kerem approval/merge.

---

## Scope

### In scope for v0.2

| Area | Included in this inventory |
|---|---|
| Authentication | Customer phone OTP identity, phone hash / customer UUID linkage, OTP/auth-event metadata, staff/admin accounts, session/security metadata where personal-data-bearing |
| Wallet | Customer-wallet linkage, wallet ledger references, F&B settlement/correction personal-data surfaces, cashier/admin actor linkage, correction reason-code and `reason_note` risk |
| Loyalty | Customer-loyalty linkage, loyalty-account references, system-derived accrual/reversal traceability to human actor |
| Audit store | `subject_ref`, actor/customer linkage, `source_ip`, `user_agent_digest`, `reason_note_ref`, `change_set` derived identifiers, event references, correlation identifiers |
| Role-based access | Which Phase 1 roles see or generate each data class |
| Selcafe-derived data surfaces | ADR-005 bounded non-PII read surface, hard-excluded PII surfaces, and Pod A PI-1/PI-2 product-position proposal for Phase 1 data-surface minimization |
| Build gating | What this inventory satisfies and what remains blocked before Pod C can receive implementation work |

### Out of scope for v0.2

| Out of scope | Owner / next artifact |
|---|---|
| Legal basis by data type | `/docs/KVKK_LEGAL_BASIS.md` — Kerem + legal/privacy advisor, with Pod A support |
| Retention periods | `/docs/DATA_RETENTION_POLICY.md` and OQ-LEGAL-005 — Kerem + legal/privacy advisor; Pod B data-impact review |
| Privacy notice legal text | `/docs/PRIVACY_NOTICE_TR.md` — Kerem + legal/privacy advisor |
| Data-subject rights workflow | `/docs/DATA_SUBJECT_RIGHTS_PROCESS.md` |
| Cross-border transfer assessment | `/docs/CROSS_BORDER_TRANSFER_ASSESSMENT.md` |
| Database schema, physical types, encryption/key management, API contracts | Pod B architecture/security deliverables |
| Implementation tasks, migrations, tests, CI | Pod C only after approved issues; **not authorized here** |
| SelcafeAdapter implementation, SQL credential provisioning, query design, polling, caching, API contracts, schema, or runtime integration | Pod B architecture/security review + separately approved Pod C issue; not authorized by this inventory |

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
- `/docs/adr/ADR-005-selcafe-read-only-adapter.md`
- `/docs/PROJECT_BRIEF.md` §6 and §11
- `/docs/PROJECT_DECISION_INDEX.md` ADR-005 and related K-decision rows

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

### Selcafe-derived data surfaces (ADR-005 / OQ-SC-NEW-010)

[REQUIRES POD B REVIEW] This section inventories the Selcafe-derived data surfaces discovered through ADR-005 and the Selcafe spike. It records product-data scope and minimization posture only. It does not define query design, SQL credentials, adapter implementation, schemas, API contracts, retention, legal basis, or deployment.

[NEEDS KEREM APPROVAL] This v0.2 section includes Pod A's PI-1/PI-2 product-position proposal. It is not durable until Pod B review and Kerem approval/merge.

#### Inventory stance

| Rule | Position |
|---|---|
| Selcafe role in Phase 1 | Legacy read-only source behind `CafeManagementAdapter` / `SelcafeAdapter`; not the Adeks core domain |
| Data examples | Schema/table/column names only; no row values |
| PII posture | No Selcafe personal data should enter Adeks Phase 1 read models under ADR-005 |
| Financial truth | Selcafe values are not authoritative for Adeks wallet/loyalty; Adeks append-only ledgers remain authoritative |
| Adapter leakage | Selcafe object names and column names must not leak into Adeks domain models, DTOs, API contracts, or persisted Adeks rows |
| Implementation authority | None — this inventory does not authorize Pod C |

#### PI-1 / PI-2 product-position proposal

| ID | Question | Pod A position for review | Data-surface effect |
|---|---|---|---|
| PI-1 | Is real-time station/session status consumed by any Phase-1 feature? | **Deferred to Phase 2 as an active product consumer.** Phase 1 reservations remain staff-approved requests; automatic confirmation and PC-status-dependent confirmation stay deferred until reliable station/session state exists. | `dbo.masa` / `dbo._pc` remain ADR-005 permitted non-PII surfaces, but should not be treated as required Phase-1 build targets unless Kerem explicitly adds a staff-facing station-status consumer. |
| PI-2 | Is the Phase-1 customer menu sourced from Selcafe `urun`, or is it Adeks-native? | **Selcafe-sourced for Phase 1.** The customer menu/catalog should be sourced from `dbo.urun` / `dbo.menudetay` through vendor-neutral Adeks read models. | `dbo.urun` / `dbo.menudetay` become Phase-1 catalog read targets. Category filtering remains constrained until the Selcafe category-source gap is resolved. |

#### Included / permitted non-PII Selcafe-derived surfaces

| Selcafe object | Data-surface description | Neutral Adeks read model / use | Personal-data status | Constraints |
|---|---|---|---|---|
| `dbo.masa` | Station status / occupancy / session-start surface: `masa_no`, `tip`, `durum`, `baslangic_zaman`, `sure_limit` only | `StationStatus` | Non-PII if no member resolution occurs | PI-1 proposes deferring active Phase-1 consumption to Phase 2. Must not resolve `aktif_adisyon_no` to `adisyon` / `uye_no`; must not propagate `aktif_adisyon_no`; must not read device/client-config fields such as `mac`, `idle_exe*`, or `busy_exe*`. |
| `dbo._pc` | Station type / label / price reference: `tip`, `ad`, `fiyat` | `StationType` | Non-PII | Allowed only as station-type reference data. PI-1 proposes no required active Phase-1 consumer unless Kerem adds staff-facing station status to Phase 1. |
| `dbo.urun` | Menu/catalog item reference: `kod`, `ad`, `fiyat`, `birim`, `aktif`, `menu` | `CatalogItem` | Non-PII | PI-2 proposes Selcafe-sourced Phase-1 menu. Adeks must snapshot order-submission price separately under K-17; runtime catalog edits must not change submitted order settlement amount. |
| `dbo.menudetay` | Combo/menu component mapping: `menu_urun_kod`, `urun_kod`, `miktar` | `CatalogComboComponent` | Non-PII | Use only for catalog composition. Do not infer customer purchase history from this surface. |
| `dbo.uyesinif` | Membership-tier definitions only: `sinif`, `indirim_oran`, `kullanim_limit`, `on_odeme` | `MembershipTierDefinition` | Non-PII when read as tier definitions only | Must not join to `dbo.uye` or member rows. Must not become a source of Adeks wallet balance or loyalty balance. |
| `dbo.ayar` | Scoped open-hours key/value source, limited to confirmed non-sensitive open-hours keys | `OperatingHours` | Non-PII only if scoped to confirmed non-sensitive open-hours keys | Not enabled until Kerem authorizes the controlled `ayar.kod` key-name read under ADR-005 K-A3 / OQ-SC-NEW-005. Do not read unrelated settings or sensitive values. |

#### Hard-excluded Selcafe PII / sensitive surfaces

These surfaces are excluded from Phase 1 and must not appear in adapter queries, projections, read models, logs, or persisted Adeks rows.

| Excluded Selcafe object / column | Exclusion rationale |
|---|---|
| `dbo.uye` | Member master contains heavy customer PII such as name, email, phone/mobile, address/district, password-like fields, and mutable legacy balance. Reading it would create a new KVKK personal-data surface. |
| `dbo.basvuru` | Application records contain heavy PII and `sifre`; not required for Phase 1 non-PII catalog/status surface. |
| `dbo.kullanici` | Staff user table contains staff PII and `sifre`; not required for Phase 1 customer PWA/catalog/order scope and creates credential/security exposure. |
| Any `sifre` column, including `uye.sifre`, `basvuru.sifre`, and `kullanici.sifre` | Credential-storage risk. These columns must never be read, logged, synced, displayed, copied into fixtures, or used for authentication migration without a separate security/KVKK design. |
| `uye.bakiye` | Mutable legacy `float` balance. It is incompatible with Adeks append-only wallet principles and must never be exposed as the Adeks wallet balance. |
| `adisyon.uye_no`, `kasaislem.uye_no`, `kuyruk.uye_no` | Member-linkage columns create PII by linkage. They are not needed for the bounded non-PII Phase 1 read surface. |
| `dbo.adisyon` and `dbo.kasaislem` as member-linked transaction tables | These contain member linkage and SP-computed financial values. They are excluded from Phase 1 because Adeks financial truth must come from Adeks append-only wallet/loyalty ledgers, not Selcafe transaction tables. |
| Any `masa` → `adisyon` → `uye_no` resolution path | This would identify which member occupies a live station and would flip the KVKK/legal-advisor gate. Not authorized by ADR-005 or this inventory. |

#### Future-gate rule for excluded surfaces

Any future request to read Selcafe member, staff, credential, legacy-balance, or member-linked transaction/session data is a new personal-data/security surface and requires all of the following before implementation:

1. Kerem approval.
2. Pod B architecture/security/KVKK review.
3. Legal/privacy advisor review where personal data or cross-border processing is implicated.
4. Updated `DATA_PROCESSING_INVENTORY.md`.
5. Updated legal-basis, retention, privacy-notice, and cross-border-transfer artifacts where applicable.
6. A separate Pod B + Kerem-approved implementation issue meeting Definition of Ready.

This v0.2 inventory does not authorize such future reads.

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
| Selcafe-derived bounded non-PII read models | Not treated as customer personal data if ADR-005 hard exclusions and no-member-resolution rule hold; Pod B review required | Retention/cache policy for non-authoritative read models remains a Pod B implementation design topic |
| Selcafe PII/sensitive surfaces explicitly excluded from Phase 1 | Not processed in Phase 1 by Adeks; however, any pre-existing Selcafe→GCP replication pipeline creates a cross-border transfer obligation independent of Adeks adapter reads — see `CROSS_BORDER_TRANSFER_ASSESSMENT.md` (absent; required). Any future Adeks processing requires Kerem + legal/privacy advisor + Pod B review. | Not applicable while excluded from Adeks processing; future retention must be defined before any Adeks processing. Cross-border assessment is required if the pre-existing replication exists, independent of this adapter's Phase 1 read scope. |
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
| DPI-GATE-008 | This v0.2 Selcafe inventory update does **not** authorize SelcafeAdapter implementation, SQL credentials, polling, caching, schema, API contracts, or infrastructure. |
| DPI-GATE-009 | Any future Selcafe PII/member-linked read flips the Kerem + legal/privacy advisor + Pod B gate and requires inventory/legal-basis/retention/cross-border updates before implementation. Separately, the cross-border transfer obligation is independent of Adeks adapter read scope and applies now if the pre-existing Selcafe→GCP replication pipeline exists. |
| DPI-GATE-010 | PI-1/PI-2 are product-position proposals until Kerem approval/merge. They narrow product scope only; they do not change ADR-005 hard exclusions and do not authorize Pod C. |

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
| DPI-OQ-009 | Should Kerem authorize the controlled `ayar.kod` key-name read to confirm non-sensitive open-hours keys under ADR-005 K-A3 / OQ-SC-NEW-005? | Kerem + Pod B | Selcafe open-hours sourcing |
| DPI-OQ-010 | If the Phase-1 menu is Selcafe-sourced under PI-2, what is the Phase-1 source for customer-facing menu categories given the Selcafe product-category gap? | Pod A + Pod B; Kerem approves product behavior | OQ-SC-NEW-001 / catalog UX |

---

## Review Routing

- Ready for commit: Yes — as a v0.2 documentation draft on a PR branch; **not ready to merge** until Pod B review and Kerem approval.
- Requires Kerem approval: Yes — this v0.2 update changes documented Selcafe data-surface scope and records PI-1/PI-2 product-position proposals.
- Requires Pod B review: Yes — Selcafe integration, data minimization, KVKK/security boundary, read-surface exclusions, and implementation gating are affected.
- Requires Pod C implementation: No — **do not authorize Pod C from this document**.
- Requires Pod D prototype/audit/monitoring review: Later only if menu/catalog UX, station-status UX, or admin/audit monitoring scope changes.

---

## Document History

| Version | Date | Author | Change |
|---|---|---|---|
| v0.1 | 2026-06-15 | Pod A | Initial data-processing inventory after `SECURITY_REVIEW.md` merge context. Inventories audit-store personal-data fields (`subject_ref`, customer linkage, `reason_note`, `source_ip`) and auth/wallet/loyalty PII surfaces. Pod B review reported complete in follow-on handoff; Kerem approval recorded 2026-06-15. No legal basis or retention periods set. No Pod C authorization. |
| v0.2 draft | 2026-06-23 | Pod A | Adds Selcafe-derived data-surface inventory per ADR-005 / OQ-SC-NEW-010: bounded non-PII surfaces, hard-excluded PII/sensitive surfaces, future-gate rule, and PI-1/PI-2 product-position proposal. Requires Pod B review and Kerem approval before merge. No Pod C authorization. |
