# DATA_PROCESSING_INVENTORY.md

<!--
  CANONICAL REPO PATH: /docs/DATA_PROCESSING_INVENTORY.md
  DOCUMENT TYPE: Pod A KVKK / product-data inventory
  OWNER / AUTHOR: Pod A — Product & Planning
  REVIEWER: Pod B — Architecture, Logic & Risk
  APPROVER: Kerem
  STATUS: v0.3 draft — adds P16 QR-linked live-bill / guest-flow processing surfaces after ADR-005 v1.2;
          preserves v0.2 ADR-005 §4.1 non-PII Selcafe inventory content and supersedes only
          P16-relevant live-bill treatment; requires Pod B review,
          legal advisor sign-off where legal content is implicated, and Kerem approval before merge/checkpoint pass.
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
| Current status | **v0.3 draft — adds P16 QR-linked live-bill / guest-flow processing surfaces after ADR-005 v1.2; preserves v0.2 ADR-005 §4.1 non-PII Selcafe inventory content and supersedes only P16-relevant live-bill treatment; requires Pod B review, legal advisor sign-off where legal content is implicated, and Kerem approval before merge/checkpoint pass** |
| Scope class | KVKK / product-data inventory |
| Implementation status | **Does NOT authorize Pod C** |
| Build-gate effect | Satisfies the **data-processing-inventory artifact** prerequisite only; all other legal, retention, security, architecture, and issue-readiness gates still apply |
| P16 implementation status | **Does NOT authorize Pod C, schema/API work, live Selcafe reads, direct Selcafe writes, or pilot operation** |
| Required next review | Pod B review + legal advisor sign-off where legal content is implicated + Kerem approval for this v0.3 P16 data-surface update before merge/checkpoint pass |

---

## Purpose

This document inventories Phase 1 personal-data-bearing fields and processing surfaces that must be considered before authentication, wallet, loyalty, and audit features are built.

It exists because `/docs/PROJECT_METHODOLOGY.md` §20.2 requires every feature that collects, displays, stores, transmits, or modifies personal data to link to the data processing inventory. It also records the `/docs/SECURITY_REVIEW.md` requirement that the audit store's personal-data fields — especially `subject_ref` / customer linkage, `reason_note` content, and `source_ip` — must be inventoried before implementation.

[NEEDS KEREM APPROVAL] Resolved for v0.1 on 2026-06-15. Future material changes to data classes, access scope, legal basis, retention, cross-border transfer, provider processing, or customer-facing notice content require Kerem approval.

[REQUIRES POD B REVIEW] Pod B remains reviewer for any future change affecting auth, wallet, loyalty, audit, customer personal data, security review dependencies, pseudonymisation, retention impact, or processor/security posture.

[REQUIRES POD B REVIEW] This v0.2 update inventories Selcafe-derived data surfaces from ADR-005. It is documentation-only and does not approve adapter implementation, SQL access, credentials, schema, API contracts, or runtime behavior.

[NEEDS KEREM APPROVAL] This v0.2 update includes Pod A's product-position proposal for ADR-005 PI-1/PI-2. It becomes durable only after Pod B review and Kerem approval/merge.

### v0.2 Review-Debt Note

This v0.3 update is a true P16 addendum to the v0.2 Selcafe inventory. It preserves the ADR-005 §4.1 non-PII Selcafe inventory rows and the PI-1 / PI-2 product-position proposal table. Only P16 live-bill / active-order-line treatment is superseded by ADR-005 v1.2 and the v0.3 P16 sections after Pod B review and Kerem approval.

[REQUIRES POD B REVIEW] This avoids compounding v0.2 review debt into the P16 artifact set.

---

## Scope

### In scope for v0.3

| Area | Included in this inventory |
|---|---|
| Authentication | Customer phone OTP identity, phone hash / customer UUID linkage, OTP/auth-event metadata, staff/admin accounts, session/security metadata where personal-data-bearing |
| Wallet | Customer-wallet linkage, wallet ledger references, F&B settlement/correction personal-data surfaces, cashier/admin actor linkage, correction reason-code and `reason_note` risk |
| Loyalty | Customer-loyalty linkage, loyalty-account references, system-derived accrual/reversal traceability to human actor |
| Audit store | `subject_ref`, actor/customer linkage, `source_ip`, `user_agent_digest`, `reason_note_ref`, `change_set` derived identifiers, event references, correlation identifiers |
| Role-based access | Which Phase 1 roles see or generate each data class |
| Selcafe-derived data surfaces | ADR-005 bounded non-PII read surface, hard-excluded PII surfaces, and Pod A PI-1/PI-2 product-position proposal for Phase 1 data-surface minimization |
| Build gating | What this inventory satisfies and what remains blocked before Pod C can receive implementation work |

### Out of scope for v0.3

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

### Selcafe-derived data surfaces (ADR-005 / P16)

[REQUIRES POD B REVIEW] This section inventories Selcafe-derived data surfaces after ADR-005 v1.2. It records product-data scope and minimization posture only. It does not define query design, SQL credentials, adapter implementation, schema, API contracts, grant DDL, retention mechanics, deployment, or runtime integration.

[NEEDS KEREM APPROVAL] This v0.3 section becomes durable only after Pod B review and Kerem approval/merge.

#### Inventory stance

| Rule | Position |
|---|---|
| Selcafe role in Phase 1 | Legacy read-only source behind `CafeManagementAdapter` / `SelcafeAdapter`; not the Adeks core domain |
| P16 status | QR-linked live-bill / guest-flow projection is personal data, not anonymous data |
| Data examples | Schema/table/column names only; no row values |
| Financial truth | Selcafe remains the settlement source of truth for this operating spine; Adeks append-only wallet/loyalty ledgers remain authoritative for Adeks value records |
| Adapter leakage | Selcafe object names and column names must not leak into Adeks domain models, DTOs, API contracts, or persisted Adeks rows except where explicitly documented as internal adapter mapping references |
| Read posture | Phase 1 remains read-only toward Selcafe; no Adeks direct writes to Selcafe |
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

#### P16 — QR-linked live-bill / guest-flow processing surfaces

| Surface | Data processed | Personal-data status | Purpose | Key constraints |
|---|---|---|---|---|
| QR session-link management | QR token metadata; station/session reference; session-link state; used/expired/revoked status; timestamps | Personal data by linkage | Bind the PWA session to the physical station/session and authorize current active-bill access | One-time, short TTL, staff-revocable; no raw bill number exposed to client; no customer-supplied bill lookup |
| Live bill projection | Active bill total/status; station/session context | Personal data | Display the current active bill to the QR-linked physical session participant | No persistence; read/display only; current bill only |
| Order-line visibility | Current active F&B item references; quantities; line amounts | Personal data | Show current active order lines | Session-only cache; delete at bill close where detectable; hard TTL 15–60 min; no full order-line logs |
| Discount reflection verification | Dedicated Adeks transaction type; pseudorandom one-time code; discount amount; timestamp; reconciliation status | Personal data on Adeks side by mapping | Verify cashier-entered Adeks discount reflected in Selcafe | Mapping stays in Adeks; no account/member/coupon identity in Selcafe if avoidable; fail closed on mismatch |
| Security/audit metadata | Pseudonymized session/account reference where applicable; event timestamps; outcome metadata; revocation/mis-link evidence | Personal/security metadata | Security, abuse prevention, complaint handling, and audit | Metadata-only where possible; no member identity; no full order-line persistence; pseudonymize where feasible |

#### P16 hard-excluded Selcafe surfaces

The P16 deny-list below mirrors ADR-005 §5A.3 and must not be shortened in downstream artifacts.

| Hard-excluded surface | Rule |
|---|---|
| `adisyon.uye_no`, `kasaislem.uye_no`, `kuyruk.uye_no` | Never read, derive, log, display, use for matching, or expose through P16 |
| Entire `dbo.uye`, `dbo.basvuru`, `dbo.kullanici` | Excluded from P16; no member profile, application, or staff-user table reads |
| Any `sifre` column | Never read, logged, copied, synced, displayed, or used |
| `uye.bakiye` and `uyesinif` credit/balance fields | Never used as Adeks wallet/loyalty balance or customer value source |
| Staff FKs such as `kullanici_no`, `iptal_kullanici_no` | Excluded from P16 projection and logs |
| Member points, balance, history, and profile data | Excluded from guest QR flow; account-linked Adeks benefits require Adeks account |
| Free-text identity-risk fields such as `adisyon.aciklama`, `adisyon.iptal_aciklama`, and `kasaislem.aciklama` beyond the fixed discount-code format | Excluded to prevent incidental personal-data leakage |
| Stub/retired discount fields such as `adisyon.uye_indirim`, `adisyon.uye_indirim_oran`, `adisyon.ek_indirim` | Not used for P16 discount logic or display |
| `adisyon.kasaislem_no` as a stub | Not used for discount reflection joining |
| `masa.aktif_adisyon_no` as a propagated FK | Server-internal selector only; never propagated to client/domain/API/persisted Adeks rows |
| Transfer/merge targets and historical bills | Not followed or displayed in guest mode; pilot resolves only the directly linked current active bill |

#### P16 enforcement mechanism

[REQUIRES POD B REVIEW]

The exclusions above must be enforced through **column-deny grants on the dedicated read-only Selcafe login at the DB grant/query layer, not through UI-only filtering**. The read-only login must physically be unable to select excluded member, staff, credential, balance, and free-text identity-risk fields. This section must remain consistent with `SECURITY_REVIEW.md` P16 reconciliation and ADR-005 §5A.3.

#### P16 role access summary

| Role / actor | P16 data accessed or generated | Scope |
|---|---|---|
| QR-linked guest / customer PWA session | Current active bill projection and current active order lines for the linked station/session | Current bill only; no account benefits, no history, no in-app guest payment |
| Account customer | P16 current bill plus account-linked discounts/coupons/points if logged in | Account-linked benefits require Adeks account |
| Cashier / staff-mediated payment | Operational handling, discount reflection entry, dispute/mis-link handling where authorized | Staff-mediated only; no direct Adeks write to Selcafe |
| Admin | Pseudonymized logs, incident/risk records, reconciliation status where authorized | Minimized and auditable |
| System | QR token state, session-link metadata, security/audit metadata, discount-code mapping | No member identity; metadata minimized |

#### Product implications carried forward

| ID | Product implication | Status / routing |
|---|---|---|
| PI-3 | No confirmed catalog attribute flags age-restricted `urun` items. Guest mode must block age-restricted items or require staff confirmation. | [PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED] Pod A + Pod B + Kerem; legal advisor sign-off where needed |
| PI-4 | “Current active bill” must be defined for Selcafe transfer/merge conditions. Pilot default remains no automatic transfer/merge following. | [PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED] Pod A + Pod B + Kerem |

#### Future-gate rule for excluded surfaces

Any future request to read Selcafe member, staff, credential, legacy-balance, historical-bill, transfer/merge, or member-linked transaction/session data is a new personal-data/security surface and requires all of the following before implementation:

1. Kerem approval.
2. Pod B architecture/security/KVKK review.
3. Legal/privacy advisor review where personal data or cross-border processing is implicated.
4. Updated `DATA_PROCESSING_INVENTORY.md`.
5. Updated legal-basis, retention, privacy-notice, security-review, pilot-risk, and cross-border-transfer artifacts where applicable.
6. A separate Pod B + Kerem-approved implementation issue meeting Definition of Ready.

This v0.3 inventory does not authorize such future reads.

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
| P16 QR-linked active bill display | Draft legal basis in `KVKK_LEGAL_BASIS.md`: KVKK Art. 5/2(c) contract performance; requires legal advisor sign-off and Kerem approval | Live projection: no persistence; order-line cache session-only + 15–60 min TTL; final policy in `DATA_RETENTION_POLICY.md` |
| P16 QR session-link / view evidence | Draft basis: contract performance + legitimate interest / rights protection depending on record purpose; requires legal advisor sign-off and Kerem approval | Session-link metadata and live-bill view evidence: 30 days metadata-only |
| P16 discount reflection verification | Draft basis: contract performance + rights protection; legal obligation where fiscal record applies; requires legal/accounting confirmation | Adeks discount mapping 90–180 days; Selcafe fiscal/commercial record per applicable accounting/tax/commercial rule |
| P16 security/audit metadata | Draft basis: legitimate interest + rights protection; requires legal advisor sign-off and Kerem approval | 6–12 months, pseudonymized where feasible; no full order-line persistence |
| Selcafe-derived bounded non-PII read models | Not treated as customer personal data if ADR-005 hard exclusions and no-member-resolution rule hold; Pod B review required | Retention/cache policy for non-authoritative read models remains a Pod B implementation design topic |
| Selcafe PII/sensitive surfaces explicitly excluded from Phase 1 | Not processed in Phase 1 by Adeks; however, any pre-existing Selcafe→GCP replication pipeline creates a cross-border transfer obligation independent of Adeks adapter reads — see `CROSS_BORDER_TRANSFER_ASSESSMENT.md` (absent; required). Any future Adeks processing requires Kerem + legal/privacy advisor + Pod B review. | Not applicable while excluded from Adeks processing; future retention must be defined before any Adeks processing. Cross-border assessment is required if the pre-existing replication exists, independent of this adapter's Phase 1 read scope. |
| Customer phone / OTP identity | [OPEN QUESTION] P16 rows drafted in `/docs/KVKK_LEGAL_BASIS.md`; broader auth/OTP legal-basis coverage still requires legal advisor sign-off and Kerem approval | [OPEN QUESTION] P16 schedule drafted in `/docs/DATA_RETENTION_POLICY.md`; broader retention still requires legal advisor sign-off and Kerem approval |
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
| DPI-GATE-011 | P16 live-bill / active-order-line processing is customer personal data and cannot be implemented until `KVKK_LEGAL_BASIS.md`, `DATA_RETENTION_POLICY.md`, `PRIVACY_NOTICE_TR.md`, `CROSS_BORDER_TRANSFER_ASSESSMENT.md` status, `SECURITY_REVIEW.md` reconciliation, and `P16_PILOT_RISK_REGISTER.md` are reviewed/signed off/approved as required. |
| DPI-GATE-012 | P16 hard exclusions must mirror ADR-005 §5A.3 exactly and must be enforced at the DB grant/query layer, not UI-only filtering. |
| DPI-GATE-013 | P16 guest mode remains current-bill-only, no historical bills, no transfer/merge following, no member profile/history/points/balance, no raw bill-number lookup, and no in-app guest payment. |
| DPI-GATE-014 | P16 implementation remains blocked by `detay` / `siparis` schema elicitation and a later separately approved Definition-of-Ready issue. |
| DPI-GATE-015 | PI-3 and PI-4 remain product implications and must not be silently resolved by implementation assumptions. |

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
| DPI-OQ-P16-001 | How should guest mode identify or block age-restricted `urun` items if no catalog attribute is confirmed? | Pod A + Pod B + Kerem + legal advisor where needed | PI-3 / SR-003-13 |
| DPI-OQ-P16-002 | What is the precise product definition of “current active bill” where Selcafe transfer/merge conditions exist? | Pod A + Pod B + Kerem | PI-4 / SR-003-12 |
| DPI-OQ-P16-003 | What infrastructure/logging/monitoring/backups/support/AI footprint determines P16 cross-border status? | Pod B + legal advisor + Kerem | `CROSS_BORDER_TRANSFER_ASSESSMENT.md` |
| DPI-OQ-P16-004 | What fiscal/accounting retention rule applies to Selcafe-side discount reflection records? | Legal/accounting advisor + Kerem | `DATA_RETENTION_POLICY.md` |

---

## Review Routing

- Ready for commit: Yes — as a v0.3 documentation draft on a PR branch; **not ready to merge** until Pod B review, legal advisor sign-off where applicable, and Kerem approval.
- Requires Kerem approval: Yes — this v0.3 update changes documented P16 Selcafe data-surface scope and records personal-data processing surfaces.
- Requires Pod B review: Yes — Selcafe integration, data minimization, KVKK/security boundary, read-surface exclusions, DB/query-layer deny enforcement, and implementation gating are affected.
- Requires Pod C implementation: No — **do not authorize Pod C from this document**.
- Requires Pod D prototype/audit/monitoring review: Later only if menu/catalog UX, station-status UX, or admin/audit monitoring scope changes.

---

## Document History

| Version | Date | Author | Change |
|---|---|---|---|
| v0.1 | 2026-06-15 | Pod A | Initial data-processing inventory after `SECURITY_REVIEW.md` merge context. Inventories audit-store personal-data fields (`subject_ref`, customer linkage, `reason_note`, `source_ip`) and auth/wallet/loyalty PII surfaces. Pod B review reported complete in follow-on handoff; Kerem approval recorded 2026-06-15. No legal basis or retention periods set. No Pod C authorization. |
| v0.2 draft | 2026-06-23 | Pod A | Adds Selcafe-derived data-surface inventory per ADR-005 / OQ-SC-NEW-010: bounded non-PII surfaces, hard-excluded PII/sensitive surfaces, future-gate rule, and PI-1/PI-2 product-position proposal. Requires Pod B review and Kerem approval before merge. No Pod C authorization. |
| v0.3 draft | 2026-07-01 | Pod A | Adds P16 QR-linked live-bill / guest-flow processing surfaces after ADR-005 v1.2 as an addendum; preserves ADR-005 §4.1 non-PII Selcafe inventory rows and PI-1/PI-2 table; mirrors §5A.3 hard exclusions; names DB/query-layer column-deny enforcement; carries PI-3/PI-4; supersedes only P16-relevant live-bill treatment. Requires Pod B review, legal advisor sign-off where applicable, and Kerem approval. No Pod C authorization. |
