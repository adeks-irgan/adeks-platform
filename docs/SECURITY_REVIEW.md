# Security Review — Phase 1 (Authentication, RBAC, Wallet/Loyalty Ledgers, Customer Data, Audit, Selcafe Ingestion, Admin, Third-Party)

<!--
  CANONICAL REPO PATH: /docs/SECURITY_REVIEW.md
  DOCUMENT TYPE: Pod B Security Artifact (Security Review)
  AUTHOR: Pod B — Architecture, Logic & Risk
  REVIEWER / APPROVER: Pod B (self) + Kerem
  AUTHORITY: Pod B review artifact. It DERIVES FROM and does NOT modify the Accepted
             ADR-006 (wallet), ADR-007 (loyalty), ADR-015 (auth), the Accepted
             AUTH_THREAT_MODEL.md, the Kerem-accepted AUDIT_EVENT_SCHEMA.md, USER_ROLES_AND_PERMISSIONS.md,
             and ROLLBACK_POLICY.md. Those sources are authoritative; this review
             references them and adds a security assessment on top. It establishes
             no decision. If this review and any of those sources disagree, the
             source wins and this review is stale until corrected.
  MERGE GATE: Pod B + Kerem (strictest §11.1 / ADR-009 §3 trigger). Kerem is sole merge authority.
  REPO RECONCILIATION: DATA_PROCESSING_INVENTORY.md present and updated in the P16 compliance PR;
             /docs/KVKK_LEGAL_BASIS.md, /docs/DATA_RETENTION_POLICY.md,
             /docs/PRIVACY_NOTICE_TR.md, /docs/CROSS_BORDER_TRANSFER_ASSESSMENT.md,
             and /docs/P16_PILOT_RISK_REGISTER.md are drafted in the same P16 package.
             This artifact reconciles ADR-005 v1.2 SR-003-5…13 and SR-006 regression-test evidence at review level.
  IMPLEMENTATION AUTHORITY: This document does NOT authorize Pod C. It creates no issues,
             designs no endpoints, writes no migrations, and invents no retention periods.
  STABILITY: Pending Pod B + Kerem review. Update only via ADR-009-compliant PR.
  DATA: Synthetic data only (Customer A, +90 555 000 00 01, cashier-01). No real Adeks data appears.
-->

## Status

| Field | Value |
|---|---|
| Document | `SECURITY_REVIEW.md` |
| Project | Adeks Platform |
| Owner / Author | Pod B — Architecture, Logic & Risk |
| Reviewer / Approver | Pod B (self-review) + Kerem |
| Current status | **Draft for Pod B + Kerem review. Updated for P16 ADR-005 v1.2 reconciliation: SR-003-5…13, QR access-control constraints, DB/query-layer deny enforcement, minimized logging, rate-limit expectations, and SR-006 regression-test evidence. Implementation remains blocked.** |
| Scope class | Architecture / security review. **Not** an ADR, **not** a DB migration, **not** an API contract, **not** a Pod C issue. |
| Repo reconciliation | P16 compliance artifacts are drafted in this PR. This file reconciles P16 security/access-control documentation required by issue #133 and ADR-005 v1.2. |
| Implementation status | **Does NOT authorize Pod C.** Creates no issues, designs no endpoints, writes no migrations, sets no retention periods. |
| Merge gate | **Pod B + Kerem** (strictest applicable §11.1 / ADR-009 §3 trigger). Kerem is sole merge authority. |

### Source freshness baseline

Baseline pinned to current HEAD `c4832ab30cf8131df2ed26390cc2f995fba9332e`. In this session (`gitpkm` IR-25 reconciliation) only `architecture/AUTH_THREAT_MODEL.md` and this file were re-read live from `main` at HEAD; the remaining source rows retain their 2026-06-15 read at commit `7374adf464ec18f7210d63b763653ff5b186896c` (full clone; blob SHAs via `git ls-tree`) and were **not** re-verified this session. **The repository is the source of truth; `main` wins on any conflict. Re-verify these blob SHAs before any commit.**

| Source (`/docs/…`) | blob SHA (first 12) | Use in this review |
|---|---|---|
| `PROJECT_METHODOLOGY.md` | `d3355d0ea5ee` | §11.1 approval triggers; §16/§16.1 handoff; §20.1 secure SDLC + abuse cases; §20.2 KVKK process; §20.3 mandatory review areas; §21 test minimums; §23 incident response. |
| `PROJECT_DECISION_INDEX.md` | `435d02ef4f78` | Locked decision state (ADR-006/007/015 Accepted; locked principles; rollback triggers; SMS provider Not locked). |
| `AGENT_CONTEXT_MANIFEST.md` | `504c3d0de519` | Context routing; Wallet/Loyalty/Auth rows require `SECURITY_REVIEW.md`; "absent security/KVKK files → review only, no Pod C work, mark *Needs repo reconciliation*". |
| `architecture/AUTH_THREAT_MODEL.md` | `bb1f270c4019` | **v0.5 Accepted (BL-2 closed; IR-25 app-side SMS ceiling resolved at design level — §15).** Threats T-C1…T-P5; mitigations; IR-01…IR-25; blockers BL-1…BL-6; residual-risk summary §11; §15 IR-25 addendum. Auth/session backbone of this review. |
| `architecture/AUDIT_EVENT_SCHEMA.md` | `bf9d4310d2a9` | **Kerem-accepted (design) 2026-06-15.** Envelope §5; hard rules R-1…R-4; workflow-source taxonomy §6.5; IP/device KD-B; pseudonymization §6.12; KD-C hash chain §7; consequences/residual §10. Audit backbone of this review. |
| `adr/ADR-006-wallet-append-only-ledger.md` | `4a9a33993880` | **Accepted.** Correction discipline §8/§8.1/§8.2; roles §9; ledger-side audit §10; ADMIN report §11; abuse cases §12; KVKK §13. |
| `adr/ADR-007-loyalty-append-only-ledger.md` | `42ffd1a83756` | **Accepted.** Recompute-from-corrected reversal §6; system-derived attribution §8; ledger-side audit §9; abuse cases §10; KVKK §11. |
| `adr/ADR-015-authentication-strategy.md` | `39e900785e06` | **Accepted.** Security requirements (binding); KVKK requirements; audit consequences; risks accepted. |
| `USER_ROLES_AND_PERMISSIONS.md` | `acc1f08cb423` | v0.2 RBAC matrix §3; shared-credentials prohibition §4; audit requirement §5; KVKK data-access flags §6; masked-phone §6.1; minimization §6.2. |
| `ROLLBACK_POLICY.md` | `3f1eadad8151` | T-1/T-2 non-discretionary triggers; SEV classification; 72-hour KVKK breach clock; post-rollback record; open `[NEEDS KEREM APPROVAL]` operational items. |
| `adr/ADR-005-selcafe-read-only-adapter.md` | re-read in P16 package | **Accepted v1.2.** P16 QR-linked live-bill conditional read surface; SR-003-5…13; hard exclusions; read-only posture preserved; no Pod C authorization. |
| `legal/P16_Final_KVKK_Position.md` | re-read in P16 package | Final legal residual position for P16: live bill personal data; contract-performance basis; guest mismatch acceptable only under pilot controls; no in-app guest payment; cross-border conditional on infra facts. |
| `P16_PILOT_RISK_REGISTER.md` | new in P16 package | Pilot residual-risk register for shared-session, mis-link, transfer/merge, over-retention, discount-code, age-restricted item, and cross-border risks. |
| `legal/LEGAL_ADVISOR_KVKK_basis_and_notice_FINAL.md` | `d18fe6cfd210` | Proposed legal-basis matrix P1–P15; notice-content recommendations; retention floors named as legal input (5651 2-yr log floor; VUK/TTK financial). **Advisor question set, `[NEEDS KEREM APPROVAL]`, not policy.** |
| `adr/ADR-009-pr-approval-policy.md` | `082270d26590` | PR gates; §3 risk categories (strictest governs); §4 behavior-change classification (§10 of this review). |
| `adr/ADR-013-repository-controlled-pod-context.md` | `9605241f724f` | Repo-as-source-of-truth; snapshot authority. |
| `BUSINESS_RULES.md` | `c8c00ad447e4` | BR-AUDIT-001 (coverage), BR-AUDIT-002 (immutability), BR-AUDIT-003 (auth baseline) — referenced via AUDIT_EVENT_SCHEMA §2. |
| `OPEN_QUESTIONS.md` | `70bfe6aeddd0` | OQ-LEGAL-005 (retention); OQ-CUF-AUTH-001 (notice text); OQ-WAL-001/002/003 (top-up); OQ-LOY-001/004 (top-up earning / redemption). |
| `SECURITY_REVIEW.md` | — | **This file.** Reconciled in the P16 package for ADR-005 v1.2 SR-003-5…13 and SR-006 expectations at review level. |
| `DATA_PROCESSING_INVENTORY.md` | — | **PRESENT; v0.3 draft in the P16 package.** Inventory-artifact prerequisite remains review-gated for P16. Personal-data implementation remains blocked by retention, legal basis, cross-border assessment, SMS/provider gates (BL-1), legal sign-off, and separately approved Pod C issues. |
| `DATA_RETENTION_POLICY.md` | — | **DRAFTED in the P16 package.** P16 retention schedule requires legal advisor sign-off, Pod B review, and Kerem approval; not final policy. |
| `KVKK_LEGAL_BASIS.md` | — | **DRAFTED in the P16 package.** P16 legal-basis rows require legal advisor sign-off and Kerem approval; not final policy. |
| `architecture/SECURITY_VIEW.md` | — | **ABSENT (planned)** — named by the manifest Auth row. A separate architecture security-view artifact; **this review is not that file** (see SR-008). |
| `SECURE_SDLC.md` | — | **ABSENT (referenced by §20.1).** Separate detailed-process file; this review covers the SDLC *posture*, not the process doc (SR-009). |

---

## 1. Purpose and Scope

This is the Pod B security review required by `PROJECT_METHODOLOGY.md` §20.3 ("the following code areas require Pod B security review before merge") and named as a binding dependency by `AGENT_CONTEXT_MANIFEST.md` (Wallet, Loyalty, Auth rows). It is a **standing, design-level security review of the Phase 1 security corpus** — it assesses the security posture established by the Accepted ledger ADRs, the Accepted authentication strategy/threat model, the Kerem-accepted audit event schema, the RBAC document, and the rollback policy, and it consolidates the abuse-case coverage and the open security/legal gates.

It does **not** re-decide anything those sources already decide; it **references** their controls (so a private copy cannot drift, per §16.1) and adds a security verdict, identifies cross-cutting gaps, and lists the items that still gate implementation.

**In scope (this artifact):**

- The §20.1 secure-SDLC posture, stage by stage, and where Adeks currently sits (§3).
- A security review of each §20.3 mandatory review area, plus database/schema-migration security as a cross-cutting area (§4).
- The consolidated cross-domain abuse-case register (§5).
- The KVKK/privacy review and the gating legal artifacts (§6).
- The review's own cross-cutting findings and gaps, marked as recommendations/open items (§7).
- The consolidated approval/blocker register (§8), residual-risk summary (§9), merge gate + ADR-009 assessment (§10), and routing (§11).
- P16 security/access-control reconciliation for ADR-005 v1.2: SR-003-5…13, QR token controls, DB/query-layer deny enforcement, logging minimization, rate-limit expectations, staff revocation, and SR-006 regression-test evidence.

**Out of scope (designed elsewhere or pending):**

| Out of scope here | Owner / where |
|---|---|
| The decisions themselves (ledger taxonomy, balance derivation, auth mechanisms, audit envelope, RBAC matrix, rollback triggers) | ADR-006/007/015 (Accepted), AUTH_THREAT_MODEL (Accepted), AUDIT_EVENT_SCHEMA (Kerem-accepted), USER_ROLES (v0.2), ROLLBACK_POLICY (Authoritative). Referenced, never redefined. |
| API endpoints, request/response shapes, DB migrations, DDL, physical types | Pod B API/schema deliverables → Pod C **after** approved issues. **Not designed here.** |
| Retention periods (any audit/ledger/PII class) | **OQ-LEGAL-005** (Kerem + legal advisor + Pod B). **Not invented here.** |
| KVKK legal-basis determination; data-inventory entries; notice legal text | `KVKK_LEGAL_BASIS.md` / `DATA_PROCESSING_INVENTORY.md` / `PRIVACY_NOTICE_TR.md` (P16 drafts in this package; legal review and Kerem approval still required; OQ-CUF-AUTH-001 remains where broader notice work is not covered). |
| SMS provider selection and provider-side OTP/KVKK assessment | **BL-1** — separate Pod B SMS provider report + Kerem decision. **No provider endorsed here.** |
| CI security-tool selection (SAST/DAST/dep-scan/secret-scan vendors) | Pod B + Pod C, with Kerem approval where vendor/data-processing impact exists (§20.1). Open (SR-007). |
| Hash-chain canonical serialization, covered-field set, and pseudonymization-vs-hash interaction detail | Pod B schema/migration deliverable (AUDIT_EVENT_SCHEMA §7 explicitly leaves this as an implementation constraint). Open (SR-002). |
| F&B order-status and reservation per-event audit trigger points | F&B state model / reservation state machine (planned). They **consume** the audit envelope; not re-derived here (SR-004). |

**Synthetic data only.** All examples use synthetic references (`Customer A`, `+90 555 000 00 01`, `cashier-01`). No real Adeks data appears anywhere in this document (§20.2).

---

## 2. Method

- Grounded in `PROJECT_METHODOLOGY.md` §20.1 (secure SDLC), §20.3 (mandatory review areas), and the wallet/loyalty abuse-case discipline (§20.1).
- Each §20.3 area is assessed for: (a) **existing controls** — referenced by their canonical IDs (ADR-006 §X, ADR-007 §X, ADR-015 §X, `IR-xx`, `R-x`, `KD-x`, USER_ROLES §X); (b) **residual risk** after those controls; (c) a **review verdict**; and (d) **open / blocking items**.
- The review's own findings and gaps are given `SR-xx` identifiers (§7) and are flagged as **recommendations or open questions**, never as unilateral decisions.
- Markers used: `[NEEDS KEREM APPROVAL]`, `[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]`, `[ASSUMPTION]`, `[LOCKED PRINCIPLE CONFLICT]` (none found — see §9).

**Verdict vocabulary (per area):**

| Verdict | Meaning |
|---|---|
| **Design-complete** | The area's security design is Accepted/Kerem-accepted and self-consistent; residual risks are identified and (where applicable) accepted. |
| **Design-complete, blocked** | As above, but named blockers prevent implementation. |
| **Partial** | Core controls exist; an identified security sub-area is not yet designed and is routed (not invented). |
| **Dependent** | The area's correctness depends on an absent artifact or open legal item. |

---

## 3. Secure-SDLC posture (§20.1)

This maps the §20.1 stages to the current Adeks position. **Status reflects where the design corpus stands at the freshness baseline; the repo is authoritative.**

| Stage | Required security activity (§20.1) | Current Adeks position | Verdict |
|---|---|---|---|
| Discovery & scope | Identify sensitive workflows, customer data, money-like value, staff permissions, abuse cases | Sensitive surfaces enumerated: wallet/loyalty value, phone-as-PII, staff/admin authority, audit. Abuse cases enumerated per ADR-006 §12 / ADR-007 §10 / AUTH_THREAT_MODEL §4–§7. | **Design-complete** |
| Architecture | Pod B threat model for high-risk features | Auth threat model **Accepted** (BL-2 closed); audit event schema **Kerem-accepted**; ledger ADRs **Accepted**. F&B/reservation audit trigger points pending in their state models (SR-004). | **Design-complete (auth/ledger/audit); Partial (F&B/reservation audit points)** |
| Issue readiness | Risk category recorded before Pod C starts | **Not reached.** No Pod C issues exist; each future issue must carry its §11.1 risk category and be separately Pod B + Kerem approved (auth: BL-6; ledger: ADR-006/007 dependencies). | **Blocked (by design)** |
| Build | Secure coding, least privilege, input validation, safe error handling | Not started. Requirements pre-stated as binding IRs (e.g. IR-04 token validation, IR-11 uniform errors, IR-06 deny-by-default guards). | **Pending implementation** |
| CI | SAST, dependency scanning, tests, build gates | **Open:** tool selection not made; SAST/DAST + dependency scanning (e.g. Trivy/Snyk) + secret scanning named in §20.1 but unselected and unconfigured (SR-007). | **Open** |
| Review | Pod B review for mandatory trigger areas | This document is the standing §20.3 security review; each future behavior-changing PR still triggers its own §11.1 gate. | **In place (this artifact)** |
| Release | Monitoring, rollback, incident path, access-control verification | Rollback policy **Authoritative** (T-1/T-2). Several release-time operational items remain open `[NEEDS KEREM APPROVAL]` (notification channel, out-of-hours escalation, rollback execution method, downtime threshold) — §8. | **Dependent (operational open items)** |
| Operate | Security-regression tracking, incident review, dependency-update cadence | Incident response defined (§23). Pod D audit-log completeness + hash-chain verification monitoring is the operate-stage consumer (AUDIT_EVENT_SCHEMA §6.10); dependency-update cadence undefined (SR-007). | **Partial** |

**SDLC summary.** The *architecture* and *review* stages are well covered for the Phase 1 high-risk features (auth, ledgers, audit). The principal SDLC gaps are at **CI** (security tooling unselected, SR-007), **issue readiness** (intentionally blocked until separate approved Pod C issues exist), and several **release-time operational** decisions still owned by Kerem (§8). `/docs/SECURE_SDLC.md` (the detailed-process file named by §20.1) is absent (SR-009); this review covers the posture, not that process document.

---

## 4. Security review by mandatory area (§20.3)

### 4.1 Authentication and session management

- **Existing controls (referenced).** AUTH_THREAT_MODEL §4–§7 (STRIDE across customer OTP/JWT/refresh, staff sessions, admin TOTP + step-up, logout, failed-login, audit, phone privacy); ADR-015 binding security requirements 1–8; IR-01…IR-25. Key properties: OTP rate-limit by IP **and** phone + per-number cap/cooldown (IR-01/IR-02/IR-25); enumeration-safe responses (ADR-015 §2); tokens in `httpOnly`+`Secure`+`SameSite` cookies, never `localStorage` (IR-05); no PII in claims/logs (IR-03); refresh rotation with reuse detection / invalidation on logout (IR-08/IR-19); session-id regeneration anti-fixation (IR-12); deny-by-default route guards rejecting customer JWT on staff/admin routes (IR-06); admin required TOTP + step-up bound to action with nonce/TTL (IR-13…IR-18); failed-login progressive backoff + temporary lockout + admin/Kerem unlock, no indefinite hard lockout (IR-10, Kerem-approved 2026-06-10).
- **Residual risk.** SMS interception/SIM-swap (Med, **accepted** — no customer self-service balance mutation), single-factor staff login (Med, **accepted**, compensating controls), TOTP phishing vs hardware key (Med, **accepted**, WebAuthn = Phase 2), short-lived access-token replay (Low–Med, bounded by ~15-min lifetime + TLS), staff session hijack on shared terminals (Med, mitigated by timeout + shift-end logout). All per AUTH_THREAT_MODEL §11.
- **Open / blocking items.** BL-1 (SMS provider not selected — provider-side OTP + KVKK/cross-border assessment cannot close); BL-3 (refresh + account retention undefined — ADR-015 ties refresh lifetime to `DATA_RETENTION_POLICY.md`); BL-4 (phone legal basis); BL-5 (Aydınlatma Metni legal text, OQ-CUF-AUTH-001); BL-6 (no approved Pod C auth issues). `[NEEDS KEREM APPROVAL]`: IR-24 initial-admin bootstrap **procedure** — now the only open auth approval item. IR-25 SMS app-side ceiling **values** + operational response-path owner (= `ADMIN`) are **decided** (Kerem 2026-06-19) — see AUTH_THREAT_MODEL.md v0.5 §15; no longer an open approval item.
- **Verdict: Design-complete, blocked.** The authentication design is Accepted and self-consistent; implementation is gated by BL-1/BL-3/BL-4/BL-5/BL-6 and the one open `[NEEDS KEREM APPROVAL]` item (IR-24 bootstrap procedure). No new auth weakness identified by this review.

### 4.2 Authorization and RBAC

- **Existing controls (referenced).** USER_ROLES §3 permission matrix (four Phase-1 roles); `FB_STAFF` is order-management-only and **cannot** touch payment/wallet/loyalty under any reading (USER_ROLES §2.3/§6.2, ADR-006 §9, ADR-007 §8, P-5); `CASHIER` wallet/loyalty access is **transaction-scoped** (visible only during an active top-up/redemption for the customer being served — not all-customer browse, USER_ROLES §3); audit read-only for `ADMIN`, write/edit/delete denied for **all** roles (USER_ROLES §3/§5, R-1, B3). Enforcement: deny-by-default route guards (IR-06) **plus** below-business-logic checks (ADR-006 §12). Tenant scoping by the mandatory Prisma Client Extension on all tenant-scoped tables (IR-22, ADR-004/008).
- **Residual risk.** Low for the modelled matrix. The matrix is enforced server-side and is independent of the auth mechanism; the main residual is implementation drift (a route added without a guard) — caught by IR-06 deny-by-default + the §20.3 review gate on each PR.
- **Open / blocking items.** USER_ROLES open question (whether `CASHIER` gets an own-actions transaction view) is routed to `BUSINESS_RULES.md` and does not block this review. `MANAGER` split is a Phase-2 candidate. Admin inactivity-timeout value is recorded as "shorter than 40-min staff" and fixed in ADR-015 (15-min).
- **Verdict: Design-complete.** The RBAC model is coherent, least-privilege, and attribution-preserving (individual credentials only, §4.7). No conflict found.

### 4.3 Wallet and loyalty ledger writes

- **Existing controls (referenced).** Append-only ledgers; **no mutable balance column** (balance = SUM of immutable entries, ADR-006 §3 / ADR-007 §3). Corrections = **single signed compensating entry** referencing the original, never an edit/delete (ADR-006 §8). Cashier self-correction gated own-only **and** in-window (daily-report-bound, no Selcafe runtime dependency) **and** single-correction; otherwise ADMIN-only (ADR-006 §8.1). Mandatory structured reason, **fail-closed**, from the ADR-006 §8.2 enum (`OVER_CHARGE`/`UNDER_CHARGE`/`ITEM_RETURNED`/`OPERATIONAL_OTHER`). Loyalty reversal = **recompute-from-corrected**, single signed `FB_ACCRUAL_REVERSAL`, structurally linked and **atomic** with the wallet correction in one DB transaction (ADR-007 §6, ADR-006 §4). Loyalty entries are **system-derived** — no role creates/edits/deletes them; no free-standing manual point edit exists in Phase 1 (ADR-007 §8). Idempotency via partial unique indexes (one debit per order; one correction per settlement; one accrual per order; one reversal per accrual). Negative-balance guard = Option A fail-closed (ADR-006 §6). Every write emits an immutable audit event (ADR-006 §10 / ADR-007 §9 → AUDIT_EVENT_SCHEMA §6.11). Daily masked-last-4 ADMIN correction report as the compensating detective control (ADR-006 §11).
- **Residual risk.** **Insider skim via collusion** (a cashier correcting in favour of a controlled customer account) is **mitigated, not eliminated** — by own-only/in-window/single-correction/mandatory-reason/immutable-audit/daily-masked-ADMIN-report/customer-visible-balance-change, and now further by the KD-C hash chain (AUDIT_EVENT_SCHEMA §10). Cache/sum divergence is a **T-1** non-discretionary rollback trigger. Cross-tenant leakage inherited from ADR-008's Prisma extension.
- **Open / blocking items.** Wallet **top-up** events are intentionally not finalized (OQ-WAL-001/002/003); loyalty **redemption** and **top-up earning** are out of Phase-1 accrual scope (OQ-LOY-004/OQ-LOY-001). Ledger implementation is blocked pending OQ-LEGAL-005 + the absent KVKK artifacts + `SECURITY_REVIEW.md` (this file) + separately approved Pod C issues (ADR-006/007 dependencies). Customer-facing correction wording is `[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]`.
- **Verdict: Design-complete, blocked.** Strong abuse-case coverage; the append-only + atomic + recompute-bound design closes the enumerated ledger abuse paths. Implementation gated as above.

### 4.4 Customer personal-data access or mutation

- **Existing controls (referenced).** Phone number is the primary PII anchor (§20.2). `CASHIER` sees masked last-4 only during top-up (`+90 555 *** ** 01`, IR-21, USER_ROLES §6.1); full phone is limited to `CUSTOMER` (own) and `ADMIN` (USER_ROLES §3). Every `ADMIN` full-phone access produces an audit record; bulk access is a step-up action (IR-09/IR-17, T-P2). No raw phone/OTP/secret in claims, logs, or audit records — UUID / phone hash only (IR-03, R-2, ADR-015 §4). Aydınlatma Metni displayed and acknowledged **before** OTP send — before any PII is committed (ADR-015 KVKK §1, T-P3; K-14/15/16). Data minimization: `FB_STAFF` sees no wallet/loyalty/payment data (USER_ROLES §6.2). Erasure-vs-immutability resolved by **pseudonymize-without-delete** (ADR-006 §13 / ADR-007 §11 / AUDIT_EVENT_SCHEMA §6.12). Confirmed PII exposure = **T-2** → immediate rollback + 72-hour KVKK clock (T-P5, ROLLBACK_POLICY §3.1).
- **Residual risk.** Low for the modelled access paths given masking + audit + minimization. The main residual sits at the *legal* layer (basis/retention) and at *mutation flow completeness* (SR-005), not the access controls.
- **Open / blocking items.** `DATA_PROCESSING_INVENTORY.md` is present and v0.3 is drafted for P16 in this package. Personal-data implementation remains blocked by: retention sign-off (`DATA_RETENTION_POLICY.md`, OQ-LEGAL-005, KD-D), legal-basis sign-off (`KVKK_LEGAL_BASIS.md`), cross-border assessment, SMS/provider gates (BL-1), legal advisor/Kerem approval, and separately approved Pod C issues. Customer **profile mutation** flow + its audit trigger (e.g. phone-number change) is not yet fully specified at the per-event level (SR-005). K-15 acknowledgment-persistence touches the consent-capture surface and is **pending K-08 legal-advisor confirmation** before Pod C propagation.
- **Verdict: Dependent.** Access controls are design-complete and consistent; the area is **dependent** on the absent KVKK artifacts and OQ-LEGAL-005, and on SR-005. No real customer data is used anywhere.

### 4.5 Audit-log logic

- **Existing controls (referenced).** One canonical, cross-domain, append-only `audit_event` store (KD-A) with the §5 envelope. Hard rules **R-1** (append-only; app role `INSERT`+`SELECT` only; no role incl. `ADMIN` may edit/delete), **R-2** (no raw phone/OTP/password/token/TOTP secret — UUID/hash only), **R-3** (no balance overwrite — derived/referenced only), **R-4** (completeness — every BR-AUDIT-001 action emits exactly one event; a missing event is a detectable control failure). Tamper-evidence = DB-grant append-only baseline (IR-20, Kerem-approved 2026-06-10) **plus** the adopted **KD-C Option B per-row hash chain** with periodic external anchoring (AUDIT_EVENT_SCHEMA §7). Closed `workflow_source` taxonomy, **fails closed** on unknown (§6.5). Scoped IP/device capture (KD-B). System-derived events attributed to the triggering human via `on_behalf_of_actor_id` (§6.4). Pod D consumes seq-gap / missing-event / hash-chain verification signals (§6.10).
- **Residual risk.** A DB superuser who recomputes the **entire** chain — **mitigated** by periodic external anchoring of the head hash + Pod D completeness/chain-verification monitoring (AUDIT_EVENT_SCHEMA §10). Otherwise Low–Med (DB-grant append-only) reduced by the hash chain.
- **Open / blocking items.** **SR-002** — the exact canonical serialization, the covered-field set for `row_hash`, and the pseudonymization-vs-hash interaction are left to the Pod B schema/migration deliverable (AUDIT_EVENT_SCHEMA §7 calls this an implementation constraint, not re-decided here). Audit store retention is OQ-LEGAL-005 (KD-D); the audit store is itself a personal-data store (IP, reason notes, linkage) and implementation remains blocked by retention sign-off, legal-basis sign-off, cross-border assessment, and separately approved Pod C issues. (`DATA_PROCESSING_INVENTORY.md` present; v0.3 P16 update drafted in this package.) Any `DROP`/`ALTER` of the audit table is a Pod B + Kerem schema-migration gate (§4.9).
- **Verdict: Design-complete, blocked.** The audit design (envelope + R-1…R-4 + KD-C chain) is Kerem-accepted and adopted by this review per AUDIT_EVENT_SCHEMA §6.13. Implementation gated by the absent KVKK artifacts and SR-002.

### 4.6 Selcafe ingestion / adapter read path, including P16 QR-linked live bill

- **Existing controls (referenced).** ADR-005 is Accepted and governs the Selcafe read-only Phase 1 adapter. Selcafe remains a read-only source behind `CafeManagementAdapter` / `SelcafeAdapter`; Adeks issues no direct writes to Selcafe. The P16 amendment in ADR-005 v1.2 conditionally permits a QR-session-scoped, memberless projection of the active bill/order lines/discount reflection under SR-003-5…13. Adeks native ledgers remain authoritative for Adeks value records.

- **SR-003-1…4 status.** The original Selcafe read-path controls are formalized in ADR-005: parameterized least-privilege read access, adapter-boundary validation/sanitization, credential handling through the secrets-management approach, and PII/member-linkage hard exclusion for the non-P16 read surface.

- **P16 SR-003-5 — QR token as authorization factor.** P16 access depends on a crypto-random, non-guessable, short-TTL QR token, bound to one station/session-link, burned on first scan, and staff-revocable. The QR token is the access-control factor for the current physical session, not a general member-account authorization.

- **P16 SR-003-6 — DB/query-layer deny enforcement.** Member, staff, credential, balance, and free-text identity-risk exclusions must be enforced by column-deny grants on the dedicated Selcafe read-only login at the DB grant/query layer, not by UI-only filtering. The login must physically be unable to select the hard-excluded ADR-005 §5A.3 surfaces.

- **P16 SR-003-7 — QR-session-scoped selector.** The selector resolves only the directly linked active bill server-internally. No raw bill number is exposed to the client, and no customer-supplied raw bill-number lookup is allowed.

- **P16 SR-003-8 — Read-as-display only.** P16 reads are display/reconciliation inputs only. The adapter must coerce and sanity-check numeric values and must not recompute Selcafe pricing.

- **P16 SR-003-9 — Discount reflection discipline.** Discount reflection uses a dedicated Adeks transaction type, pseudorandom one-time code, fixed format, amount, and timestamp. Mapping remains in Adeks only. Fail closed on mismatch. Do not put Adeks account identity, Selcafe member identity, phone, name, email, profile, or avoidable coupon identity into Selcafe.

- **P16 SR-003-10 — Logging minimization.** Logs should use metadata only where possible, avoid full order-line persistence, avoid member identity, and pseudonymize Adeks references where feasible.

- **P16 SR-003-11 — Current bill only.** Guest mode must not display historical bills.

- **P16 SR-003-12 — No transfer/merge-link following.** P16 pilot resolves only the directly linked active bill. Transfer/merge targets are not followed automatically.

- **P16 SR-003-13 — Age-restricted ordering.** Guest mode must block age-restricted F&B items or require staff confirmation. PI-3 remains open because no confirmed catalog attribute for age-restricted `urun` items is yet recorded.

- **Residual risk / review observations.** P16 remains personal-data processing. The accepted residual risk is limited to a QR-linked physical session participant viewing the current active bill/order lines under the controls above. If member identity/profile/history, transferred/historical bills, raw bill lookup, full order-line persistence, or guest in-app payment are introduced, the P16 legal/security position must be reassessed.

- **Open / blocking items.**
  - `KVKK_LEGAL_BASIS.md`, `DATA_PROCESSING_INVENTORY.md` v0.3, `PRIVACY_NOTICE_TR.md`, `DATA_RETENTION_POLICY.md`, `CROSS_BORDER_TRANSFER_ASSESSMENT.md`, and `P16_PILOT_RISK_REGISTER.md` must be reviewed/signed off/approved as required.
  - `detay` / `siparis` projection remains provisional until targeted elicitation.
  - PI-3 age-restricted item handling remains open.
  - PI-4 current active bill definition under transfers/merges remains open.
  - Cross-border status remains blocked on infrastructure facts.
  - No Pod C work is authorized.

- **Verdict: Design-partial, blocked.** P16 security controls are now documented at review level and align with ADR-005 v1.2, but implementation remains blocked by compliance artifacts, risk-register approval, legal sign-off, cross-border fact-finding, `detay` / `siparis` elicitation, and later separately approved DoR issue.

### 4.7 Admin privilege (escalation)

- **Existing controls (referenced).** `ADMIN` requires individual credentials + **required TOTP MFA** + step-up re-auth immediately before each high-sensitivity action (create/suspend/reactivate staff, reset credentials, change roles/permissions, disable/re-enroll MFA, export/bulk-access customer PII) — independent of session age (ADR-015 §3, IR-17/IR-18). Step-up proof is action-bound, single-use (nonce+TTL), **not** a reusable elevated mode. MFA recovery = manual break-glass / admin-assisted reset, Kerem-approved + audited; **no self-service recovery codes** in Phase 1 (IR-16). Initial-admin bootstrap is a controlled one-time path, disabled after first use, audited (IR-24, T-A10…T-A12). Admin privilege changes require Kerem approval (§11.1 *Admin privilege changes → Kerem*). Audit can be **read** by `ADMIN` but never edited/deleted (R-1, B3). Every admin full-phone access and every step-up event is audited (IR-09, T-P2/T-A9).
- **Residual risk.** Admin TOTP phishing/real-time relay (Med, **accepted** for Phase 1; WebAuthn = Phase 2). Insider-collusion residual on ledger corrections (covered in §4.3). Self-privilege-escalation is **out of wallet/loyalty scope** and lives here in auth/RBAC — structurally constrained by step-up + Kerem-gated privilege changes + immutable audit.
- **Open / blocking items.** `[NEEDS KEREM APPROVAL]` — the initial-admin bootstrap **procedure** (who creates the first `ADMIN`, how the first TOTP secret is delivered/confirmed; IR-24/§6.3). Bootstrap **events** already have a home in the audit envelope (AUDIT_EVENT_SCHEMA §4 AUTH/IR-24).
- **Verdict: Design-complete, blocked.** Strong privilege controls; the one open gate is the IR-24 bootstrap procedure (`[NEEDS KEREM APPROVAL]`).

### 4.8 Third-party integrations

- **Existing controls (referenced).** AUTH_THREAT_MODEL §8 treats the SMS provider as an **external, untrusted data processor** handling customer phone numbers; the provider integration credential is a secrets-configuration concern, **not** a platform user actor (ADR-015 §4). A provider webhook/callback, if any, introduces a **new inbound auth surface requiring a separate Pod B auth review** (ADR-015 §4). App-side SMS abuse/cost controls (IR-25) are implementable **without** waiting for provider selection, and their ceiling values + `ADMIN`-owned operational response path are now **decided at design level** (AUTH_THREAT_MODEL.md v0.5 §15).
- **Residual risk / review observations.** Provider-side OTP delivery integrity, sender authentication, the provider's own abuse handling, API-credential storage, the provider's **KVKK data-processor** status, and any **cross-border transfer** **cannot be assessed until a provider is named** (BL-1). Payment provider is **Phase 2** (ADR-011 backlog; Phase-1 payment is cashier-only) — out of Phase-1 scope. Any other processor (hosting/backup, per the legal advisor package §2) is subject to the same data-processor / cross-border assessment (K-08).
- **Open / blocking items.** **BL-1** — SMS provider Not locked, blocked by the separate Pod B provider report; selection remains `[NEEDS KEREM APPROVAL]` **after** the report (the report informs, it does not constitute the decision). Cross-border assessment (`CROSS_BORDER_TRANSFER_ASSESSMENT.md`, OQ-LEGAL-006) absent. IR-25 app-side ceiling value + operational response-path owner (= `ADMIN`) are **decided** (AUTH_THREAT_MODEL.md v0.5 §15) and are no longer an open approval item here; provider-side OTP/KVKK/cross-border exposure remains open until a provider is named.
- **Verdict: Dependent.** No third-party integration can be security-cleared until its processor is named and assessed; the app-side controls (IR-25) reduce but do not remove the dependency. No provider is endorsed by this review.

### 4.9 Database / schema-migration security (cross-cutting)

Included because schema/migration is a §11.1 trigger and the audit/ledger stores impose schema-level security obligations.

- **Existing controls (referenced).** All tenant-scoped tables carry `tenant_id UUID NOT NULL`; UUID PKs; the **mandatory** Prisma Client Extension enforces tenant scoping on every query (ADR-004/008, IR-22). `$queryRaw` over financial/audit data requires Pod B review (ADR-004, ADR-006 §14, AUDIT_EVENT_SCHEMA §6.14). A **separate DB role** for audit writes (INSERT-only); the general app role cannot mutate the audit table (R-1, AUDIT_EVENT_SCHEMA §7). All schema changes go through `prisma migrate`, reviewed, **Pod B + Kerem** (§11.1 *Database / schema migration*, ADR-009 §3). Any migration that would `DROP`/`ALTER` the audit table is an explicit schema-migration gate to call out in CI/review (AUDIT_EVENT_SCHEMA §7). Schema rollback is a separate, higher-severity operation requiring explicit separate Kerem authorization and must not violate Expand-and-Contract (ROLLBACK_POLICY §2).
- **Residual risk.** Migration that silently weakens an append-only grant or drops a unique index (idempotency) — mitigated by the Pod B + Kerem migration gate + the explicit audit-table DROP/ALTER call-out + CI verification of grants.
- **Verdict: Design-complete (constraints), Partial (CI verification).** The schema-security constraints are specified; their **CI enforcement** (verifying grants, indexes, and the DROP/ALTER gate) is part of the open CI tooling item (SR-007).

---

## 5. Cross-domain abuse-case register (§20.1)

Consolidates the §20.1 mandated abuse cases plus the per-domain abuse tables. **Each control is referenced, not restated.** Per **R-4**, a *missing* audit event for any of these is itself a detectable control failure (surfaced by AUDIT_EVENT_SCHEMA §6.10 monitoring), and the KD-C hash chain makes silent post-hoc deletion detectable.

| Abuse case (§20.1 / domain) | Primary mitigations (referenced) | Coverage |
|---|---|---|
| Staff attempts unauthorised balance adjustment | RBAC deny-by-default (IR-06); only `CASHIER` (own/in-window) + `ADMIN` write wallet; `FB_STAFF` fully excluded; loyalty has **no** manual-edit entry type (ADR-006 §9/§12, ADR-007 §8/§10) | **Covered** |
| Skim / inflate / deflate value via correction | Own-only + in-window + single-correction + mandatory fail-closed reason + immutable audit + daily masked ADMIN report + customer-visible balance change + recompute-bound atomic loyalty reversal + KD-C chain (ADR-006 §8/§11/§12, ADR-007 §6/§10, AUDIT §10) | **Mitigated, not eliminated** (insider collusion residual) |
| Duplicate / replayed top-up or settlement event | Partial unique indexes (one debit/order; one correction/settlement); replays fail-closed (ADR-006 §4/§12) | **Covered** |
| Replay / double-accrue or double-reverse loyalty | `UNIQUE` on accrual-per-order and reversal-per-accrual; fail-closed → ADMIN (ADR-007 §4/§10) | **Covered** |
| Accrue on un-settled / cancelled / rejected order | **Structural** — accrual derives from S1 only; CANCELLED/REJECTED never reach S1 (ADR-007 §5/§7) | **Covered (structural)** |
| Customer attempts to redeem more value than allowed | **Out of Phase-1 scope** — redemption is OQ-LOY-004; referenced for future redemption design, not solved here | **Deferred (OQ-LOY-004)** |
| Ledger event replayed (generic) | Idempotency + append-only + atomic single-transaction wallet↔loyalty (ADR-006 §4, ADR-007 §4) | **Covered** |
| Admin role grants itself extra privileges | Step-up before privilege change (IR-17), Kerem-gated admin-privilege changes (§11.1), immutable audit (IR-09); out of ledger scope, lives in auth/RBAC | **Covered** |
| OTP brute force / replay / interception | Verify-side attempt limit + short TTL + single-use + no recoverable plaintext (IR-02/IR-23); SIM-swap **accepted** for Phase 1 (T-C5) | **Covered (interception accepted)** |
| Credential stuffing / session fixation / hijack (staff/admin) | Memory-hard hashing (ADR-015 §8); progressive lockout (IR-10); session-id regeneration (IR-12); `httpOnly` cookies + timeout + shift-end logout (IR-05, T-S4) | **Covered (shared-terminal residual Med)** |
| Token forgery / exfiltration / role confusion | Pinned alg + reject `none` + iss/aud/exp (IR-04); `httpOnly` storage (IR-05); audience/role-bound, customer JWT rejected on staff routes (IR-06/IR-11) | **Covered** |
| Audit log altered or deleted to hide activity | Append-only DB grant (R-1/IR-20) + KD-C hash chain + external anchoring + Pod D verification (AUDIT §7/§6.10) | **Covered (full-chain-recompute residual mitigated)** |
| Audit log missing for a sensitive action | Mandatory single event per action (R-4); missing event is a detectable control failure (AUDIT §6.10) | **Covered (detective)** |
| `FB_STAFF` reaches payment/wallet/loyalty | Excluded under all readings (P-5, USER_ROLES §6.2, ADR-006 §9, ADR-007 §8) | **Covered (structural)** |
| Cross-tenant read of customer/auth/ledger records | Mandatory Prisma Client Extension + `tenant_id NOT NULL` (IR-22, ADR-004/008); single tenant in Phase 1, seam must hold | **Covered** |
| Confirmed PII exposure | **T-2** → immediate rollback + incident record + 72-hour KVKK clock (T-P5, ROLLBACK_POLICY §3.1) | **Covered (incident path)** |
| Ingested Selcafe data trusted / injection on read path | Read-only posture (ADR-005) + boundary validation + parameterized least-privilege read access (**SR-003 — recommendation**) | **Partial (SR-003)** |
| QR token guessed, reused, or replayed | SR-003-5: crypto-random, short TTL, bound to one station/session-link, burned on first scan, staff-revocable | **Covered at design level; implementation blocked** |
| Customer attempts raw bill-number enumeration | SR-003-7: no raw bill number to client; no customer-supplied raw bill lookup | **Covered at design level; implementation blocked** |
| Wrong QR scan / mis-link exposes current shared bill | Staff revocation, current-bill-only, metadata-only evidence, pilot risk register | **Mitigated, not eliminated** |
| Transfer/merge following exposes unrelated bill | SR-003-12: no transfer/merge-link following in pilot; PI-4 remains open | **Blocked until product definition confirmed** |
| Member identity leaks through query/log/join | ADR-005 §5A.3 hard exclusions + SR-003-6 DB/query-layer deny + SR-006 tests | **Must be regression-tested** |
| Full order-line persistence creates over-retention | SR-003-10 logging minimization + `DATA_RETENTION_POLICY.md` TTLs | **Policy target; implementation blocked** |
| Guest minor orders age-restricted item | SR-003-13; PI-3 catalog/product gap | **Open** |
| Discount code becomes durable cross-system identifier | SR-003-9 one-time pseudorandom fixed-format code; mapping in Adeks only; retention 90–180 days | **Mitigated, not eliminated** |

---

## 6. KVKK / privacy review (§20.2)

| §20.2 obligation | Artifact / action | Status at baseline |
|---|---|---|
| VERBİS registration | Kerem + legal advisor | `[NEEDS KEREM APPROVAL — legal]`; advisor to determine (legal package §3). |
| Data processing inventory | `DATA_PROCESSING_INVENTORY.md` (Pod A drafts, Pod B reviews, Kerem approves) | **PRESENT; v0.3 draft in the P16 package.** Personal-data implementation remains blocked by retention, legal basis, cross-border assessment, SMS/provider gates (BL-1), legal sign-off, Kerem approval, and separately approved Pod C issues. |
| Legal basis per data type | `KVKK_LEGAL_BASIS.md` (Kerem + advisor) | **DRAFTED in the P16 package.** P16 rows require legal advisor sign-off and Kerem approval before they become policy. |
| Privacy notice (Aydınlatma Metni) | `PRIVACY_NOTICE_TR.md` + PWA copy | **DRAFTED in the P16 package for P16; not approved for customer display.** Flow side resolved (K-14 build-time embedded; K-15 persisted on verified OTP; K-16 same-session reuse). |
| Data-subject rights (Art. 11) | `DATA_SUBJECT_RIGHTS_PROCESS.md` | Pending; erasure resolved at design via **pseudonymize-without-delete** (ADR-006 §13 / ADR-007 §11 / AUDIT §6.12). |
| 72-hour breach notification | `BREACH_NOTIFICATION_PROCESS.md`; Pod B defines incident criteria | **T-2** criteria defined (ROLLBACK_POLICY §3.1); the standalone process file is pending; several operational items `[NEEDS KEREM APPROVAL]` (§8). |
| Data retention policy | `DATA_RETENTION_POLICY.md` (Kerem approves, Pod B reviews) | **DRAFTED in the P16 package.** P16 retention schedule requires legal advisor sign-off, Pod B review, and Kerem approval. |
| Cross-border transfer | `CROSS_BORDER_TRANSFER_ASSESSMENT.md` | **STATUS SHELL drafted in the P16 package.** Final determination remains blocked on infrastructure/vendor/logging/support/replication facts and legal advisor/Kerem approval. |
| Phone as primary PII | In inventory + notice | Masked last-4 to `CASHIER` (IR-21); full-phone audited for `ADMIN` (IR-09/T-P2); never in claims/logs/audit plaintext (IR-03/R-2). |

**Privacy posture summary.** The privacy-by-design controls in the design corpus are strong and self-consistent (minimization, masking, pseudonymization, audited full-phone access, notice-before-OTP). P16 compliance artifacts are drafted in this package, but they are **not** final policy and do **not** authorize implementation. The remaining privacy **gating gap** is at the **legal/sign-off** layer: `DATA_RETENTION_POLICY.md`, `KVKK_LEGAL_BASIS.md`, `PRIVACY_NOTICE_TR.md`, `CROSS_BORDER_TRANSFER_ASSESSMENT.md`, and `DATA_PROCESSING_INVENTORY.md` v0.3 require the reviews, legal advisor sign-off where applicable, and Kerem approval stated in those files. Per the manifest fallback, **no personal-data feature may be built** — and this review issues no Pod C work — until retention, legal basis, privacy notice, cross-border status, security review, pilot-risk acceptance, and separately approved Pod C issues are complete.

---

## 7. Cross-cutting findings & gaps (this review's own additions)

These are Pod B security-review observations. They are **recommendations / open questions**, not decisions, and they create no Pod C work.

| ID | Finding | Recommendation / routing | Marker |
|---|---|---|---|
| **SR-001** | **Secrets management is implied but not consolidated.** Multiple high-value secrets exist or will exist: JWT signing key (IR-04), TOTP secret encryption key (IR-14), the SMS provider API credential (ADR-015 §4), the Selcafe read-only DB credential (SR-003), and the audit hash-chain anchoring signing material (AUDIT §7). No single secrets-management approach is documented. | Pod B to define a secrets-management approach (storage, rotation, least-privilege, no secrets in logs/repo) as a future design item; do **not** invent it here. | recommendation |
| **SR-002** | **Hash-chain implementation detail is deferred.** The exact canonical serialization, the covered-field set for `row_hash`, the anchoring cadence/format, and the pseudonymization-vs-hash interaction are open. | Pod B schema/migration deliverable to specify, per AUDIT_EVENT_SCHEMA §7 (called out there as an implementation constraint). | open (Pod B) |
| **SR-003** | **Selcafe read-path ingestion controls are now formalized in ADR-005, with P16 extensions in v1.2.** Read-only removes write-side risk but not: injection on read, trust of ingested data, credential handling, QR-session-scoped P16 access control, DB/query-layer deny enforcement, logging minimization, retention, and cross-border risk. | Treat §4.6 and ADR-005 §5A as the P16 review baseline. Implementation remains blocked until compliance artifacts, SR-006 expectations, `detay`/`siparis` elicitation, legal sign-off, and a separate approved DoR issue are complete. | design-partial, blocked |
| **SR-004** | **F&B order-status and reservation per-event audit trigger points are not yet designed.** They consume the audit envelope but their trigger catalogs live in the (planned) F&B state model / reservation state machine. | Define in those Pod B deliverables; not re-derived here (AUDIT_EVENT_SCHEMA §6.11). | gap (routed) |
| **SR-005** | **Customer profile-mutation flow + its audit trigger are not fully specified at the per-event level** (e.g. a phone-number change records the *fact* with derived identifiers, never raw old/new PII — AUDIT §6.7 — but the flow itself is not designed). | Pod A flow + Pod B audit-point review when customer-data mutation is specified. | gap (routed) |
| **SR-006** | **Security-regression test coverage** is named in §21 (audit-on-sensitive-action tests; RBAC per-role tests; ledger/audit tests) but no test plan exists. | `QA_STRATEGY.md` / `UAT_PLAN.md` (referenced by §21) are absent; security-regression tests must exist before the relevant Pod C work is accepted. | gap (routed) |
| **SR-007** | **CI security gates are unselected.** SAST/DAST, dependency scanning (e.g. Trivy/Snyk), secret scanning, and the append-only-grant / unique-index / audit-table-DROP-ALTER verification (§4.9) are not configured. | Pod B + Pod C select tooling; Kerem approves where vendor/data-processing impact exists (§20.1). | open |
| **SR-008** | **`SECURITY_VIEW.md` (architecture security view) is named by the manifest Auth row but absent.** This review (`SECURITY_REVIEW.md`) is the §20.3 *security review*, not the architecture security *view*. | Reconcile: either produce `SECURITY_VIEW.md` (Pod B) or update the manifest Auth row if the two are intended to be one artifact (Pod A owns the manifest, Pod B reviews). | reconciliation |
| **SR-009** | **`SECURE_SDLC.md` (detailed process, named by §20.1) is absent.** This review covers the SDLC *posture* (§3), not the process document. | Pod A/Pod B to produce if the detailed process file is wanted; not a blocker for this review. | reconciliation |

### SR-006 P16 regression-test expectations

[REQUIRES POD B REVIEW] [NO POD C AUTHORIZATION]

For P16, SR-006 must include regression-test expectations that prove the controls in ADR-005 §5A and this review do not regress. These are review-level expectations only; they do not create implementation issues.

| Test expectation | Required evidence |
|---|---|
| Hard-excluded columns cannot be selected | Test/verification plan confirms the dedicated read-only login cannot select ADR-005 §5A.3 excluded surfaces |
| No member identity in P16 projection/logs | Projection/log review shows no member profile, member number, member balance, member points, member history, or staff identity |
| No raw bill number exposed to client | Client-facing API/DTO/log review proves raw bill identifiers are not exposed |
| No customer-supplied raw bill lookup | Route/API review proves P16 access only follows QR-session selector |
| QR token single-use / short TTL / bound to station-session | Test plan covers burn-on-first-use, expiry, station/session binding, and staff revocation |
| No historical bill access in guest mode | Test plan covers closed/historical bill denial |
| No transfer/merge following | Test plan covers transfer/merge target non-following |
| Logging minimization | Logs contain metadata only where possible and no full order-line persistence unless separately approved |
| Discount reflection fixed format | Test plan covers dedicated transaction type, pseudorandom one-time code, fixed format, amount, timestamp, fail-closed mismatch |
| Age-restricted item control | Test plan covers block or staff-confirmation rule once PI-3 is resolved |
| Retention/TTL enforcement | Test plan covers session-only order-line cache, bill-close deletion where detectable, and hard TTL fail-safe |
| Cross-border payload minimization | Test plan/review confirms logs/monitoring/backups/support/AI tooling do not process P16 data outside approved assessment |

---

## 8. Consolidated approval / blocker register

### 8.1 `[NEEDS KEREM APPROVAL]` items

| Item | Source | Note |
|---|---|---|
| Initial-admin **bootstrap procedure** (who creates first `ADMIN`; how first TOTP secret is delivered/confirmed) | AUTH_THREAT_MODEL §6.3 / IR-24 | Security-sensitive one-time operation; events already have an audit home. |
| **SMS provider selection** | AUTH_THREAT_MODEL §8 / BL-1; Decision Index §2 | Remains `[NEEDS KEREM APPROVAL]` *after* the separate Pod B provider report. |
| Rollback **operational items** | ROLLBACK_POLICY §3.1/§5/§7 | T-2 legal-advisor contact responsibility; SEV-1/2 notification channel; out-of-hours escalation; rollback execution method; max cumulative downtime threshold; post-rollback record format. |
| KVKK **legal-basis matrix + notice content** acceptance as the **advisor question set** | legal package §3 | Confirmed product intent, **not** policy; advisor is the authority. |
| Authorize opening the **Consent & Communications Model** ADR and extending the **KVKK pseudonymisation** ADR to cover minor data | legal package §3 | Per advisor addendum. |

### 8.2 Legal / advisor-owned items

OQ-LEGAL-005 (retention periods, **KD-D**), legal basis per data type (**BL-4**, K-08), Aydınlatma Metni legal text (OQ-CUF-AUTH-001 / **BL-5**), cross-border assessment (OQ-LEGAL-006), VERBİS determination, minor-data treatment + İYS/ETK boundary + consent-record requirements (legal package §3). The K-08 advisor is the authority on all KVKK / 5651 / ETK / İYS conclusions.

### 8.3 Merge / implementation blockers (not cleared by this review)

| Blocker | Effect |
|---|---|
| `DATA_PROCESSING_INVENTORY.md` (**KD-E**) | **Present, Kerem-approved 2026-06-15.** Inventory-artifact prerequisite satisfied. Personal-data implementation remains blocked by the items below (retention, legal basis, cross-border, BL-1, approved Pod C issues). |
| `DATA_RETENTION_POLICY.md` drafted for P16 + OQ-LEGAL-005 open (**KD-D**) | P16 retention schedule requires legal advisor sign-off, Pod B review, and Kerem approval; broader retention remains unresolved where not covered. |
| `KVKK_LEGAL_BASIS.md` drafted for P16 (**BL-4 remains until sign-off**) | P16 legal-basis rows require legal advisor sign-off and Kerem approval before policy/implementation use. |
| BL-1 (SMS provider), BL-5 (notice text) | Customer OTP + registration notice cannot complete. |
| BL-6 / ADR-006/007 dependencies | No separately Pod B + Kerem approved Pod C issues exist; **none created here.** |

**This review existing satisfies the manifest's named `SECURITY_REVIEW.md` dependency for the Wallet / Loyalty / Auth rows, but it does NOT by itself unblock implementation.** The KVKK artifacts, OQ-LEGAL-005, the `[NEEDS KEREM APPROVAL]` items above, and separately approved Pod C issues all remain required.

---

## 9. Residual-risk summary

Consolidated from the per-area assessments; accepted residuals reference their Accepted source.

| Residual risk | Status | Reference |
|---|---|---|
| SMS interception / SIM-swap on customer OTP | **Accepted for Phase 1** (no customer self-service balance mutation) | ADR-015; T-C5 |
| Single-factor staff login | **Accepted for Phase 1** with compensating controls | ADR-015; T-S8 |
| Admin TOTP phishing vs hardware-key MFA | **Accepted for Phase 1**; WebAuthn = Phase 2 | ADR-015; T-A2 |
| Short-lived access-token replay window | Low–Med; bounded by ~15-min lifetime + TLS | T-C12 |
| Staff session hijack on shared terminals | Med; mitigated by timeout + shift-end logout (operational) | T-S4 |
| Insider skim/collusion via ledger correction | **Mitigated, not eliminated**; daily masked ADMIN report + immutable audit + customer-visible change + KD-C chain | ADR-006 §12; ADR-007 §10; AUDIT §10 |
| Full audit-chain recompute by a DB superuser | **Mitigated** by periodic external anchoring + Pod D chain verification | AUDIT §7/§10 |
| Provider-side OTP / KVKK / cross-border exposure | **Open — cannot be assessed until BL-1 resolved** | AUTH §8 |
| Selcafe read-path ingestion and P16 QR live-bill access | **Design-partial, blocked (SR-003 / SR-003-5…13)**; read-only posture removes write-side risk, but implementation remains blocked by compliance artifacts, deny-grant evidence, SR-006 expectations, legal sign-off, and approved DoR issue | ADR-005 v1.2; SR-003; SR-006 |
| Personal-data processing without inventory/basis/retention | **Open — dependent on absent KVKK artifacts + OQ-LEGAL-005** (inventory-artifact prerequisite now satisfied) | §6; KD-D |

**`[LOCKED PRINCIPLE CONFLICT]`: none identified.** Every control and observation in this review is consistent with the locked principles (append-only wallet & loyalty ledgers; all admin actions auditable; KVKK required; human approval for wallet/payment/refund/security/customer-data; Selcafe read-only Phase 1; synthetic data only), with ADR-004/008, and with the Accepted ADRs and threat model.

---

## 10. Merge gate & ADR-009 behavior-change assessment

- **PR class (ADR-009 §2): Documentation-only.** This adds one file under `/docs/`. It records a Pod B security review derived from already-Accepted ADR-006/007/015, the Accepted auth threat model, and the Kerem-accepted audit schema; it establishes no decision and changes no gate.
- **§4 behavior-change gate: does NOT fire.** No pod behavior, review/approval gate, locked/deferred decision-state, methodology, template, or external-instruction change is introduced. **No Pod Impact Matrix and no `INSTRUCTION_UPDATE_PACKET.md` are required.**
- **§3 risk categories / §11.1 triggers:** the subject matter spans *Authentication or authorization* (Pod B), *Audit log schema or logic* (Pod B), *Wallet/loyalty ledger logic* (Kerem + Pod B), *Customer personal data handling* (Pod B + Kerem), and *Security-sensitive* (Pod B + Kerem). Under **ADR-009 §3 the strictest applicable trigger governs**, so **Pod B + Kerem review/approval is required before merge.**
- **Manifest reconciliation (post-merge, follow-on — not a gate):** once this file is on `main`, the `AGENT_CONTEXT_MANIFEST.md` Wallet/Loyalty/Auth rows' `SECURITY_REVIEW.md` status moves from *planned* → *exists*. The manifest is **Pod A-owned, Pod B-reviewed**; updating those status rows is a Pod A action (Pod B review), routed in the handoffs. This does not change the manifest's text or any gate.
- **Net:** Documentation-only PR; §4 gate not triggered; **Pod B + Kerem approval required before merge** per the strictest §3 trigger. Kerem is sole merge authority.

---

## 11. Review routing and status

- **Status:** **Draft for Pod B + Kerem review.** Resolves the manifest's `SECURITY_REVIEW.md` dependency at the review level; implementation remains blocked (§8.3).
- **Pod B:** author/reviewer (self-review complete). Owns SR-001/SR-002/SR-003 follow-on design items and the ADR-005 full text. Owns the `PROJECT_DECISION_INDEX` mirror only if a status row changes (no decision-state change here).
- **Kerem:** **review/approval required before merge** (§10); **sole merge authority.** The `[NEEDS KEREM APPROVAL]` items in §8.1 and the legal items in §8.2 remain open and are **not** resolved by approving this review.
- **Pod A:** on merge — update the `AGENT_CONTEXT_MANIFEST.md` Wallet/Loyalty/Auth row file-status for `SECURITY_REVIEW.md` (Pod B review). Owns `DATA_PROCESSING_INVENTORY.md` drafting (Pod B + Kerem review) and the SR-008/SR-009 reconciliation decision on the manifest.
- **Pod C:** **Not authorized.** This review creates no issues, designs no endpoints, writes no migrations. The §20.3 areas become Pod C work only via separately Pod B + Kerem approved issues, **after** `DATA_PROCESSING_INVENTORY.md` + OQ-LEGAL-005 + the relevant ADR/threat-model blockers are cleared.
- **Pod D:** later — audit-log completeness/gap + hash-chain verification monitoring (AUDIT §6.10); failed-login threshold + anomalous OTP-volume monitoring (AUTH §13).

*This is a Pod B architecture/security artifact. It derives from and does not modify ADR-006, ADR-007, ADR-015, the auth threat model, the audit event schema, USER_ROLES, or ROLLBACK_POLICY. No item is implemented until those remain Accepted, this review is merged, the absent security/KVKK files exist, OQ-LEGAL-005 is resolved, and separate Pod B + Kerem approved Pod C issues exist. Repository is the source of truth; re-verify the §Status SHAs before commit. Synthetic data only.*

---

## 12. Document history

| Version | Date | Author | Change |
|---|---|---|---|
| v0.1 | 2026-06-15 | Pod B | Initial draft. Covers §20.1 SDLC posture (§3); §20.3 mandatory review areas + schema-migration security (§4); cross-domain abuse-case register (§5); KVKK/privacy review (§6); cross-cutting findings SR-001…SR-009 (§7); consolidated approval/blocker register (§8); residual-risk summary (§9); ADR-009 assessment (§10). Adopts AUDIT_EVENT_SCHEMA R-1…R-4 / IR-03/IR-20 alignment / KD-C hash chain / §10 residual risks per its §6.13. Marked **Needs repo reconciliation** (DATA_PROCESSING_INVENTORY.md / DATA_RETENTION_POLICY.md / KVKK_LEGAL_BASIS.md absent). No retention periods invented; no Pod C authorization; no issues; no endpoints/migrations; synthetic data only. Merge gate Pod B + Kerem. |
| v0.2 | 2026-06-16 | Pod B | B-2 status reconciliation (Kerem-authorized). `DATA_PROCESSING_INVENTORY.md` now **present, Kerem-approved 2026-06-15** — updated REPO RECONCILIATION header, Status table, freshness baseline, §4.4/§4.5/§6/§8.3 references, and §6 privacy-posture summary. `DATA_RETENTION_POLICY.md`, `KVKK_LEGAL_BASIS.md` remain absent and remain blockers. Three genuinely absent legal files (DATA_RETENTION_POLICY.md, KVKK_LEGAL_BASIS.md, CROSS_BORDER_TRANSFER_ASSESSMENT.md) not altered. Pod C gate unchanged. Status-only correction; no new decisions. Merge gate Pod B + Kerem. |
| v0.3 | 2026-06-19 | Pod B | IR-25 mirror reconciliation (Kerem-authorized, `gitpkm`). Removed stale IR-25 open-item language now resolved at design level by AUTH_THREAT_MODEL.md v0.5 §15 (app-side SMS ceiling values + operational response-path owner = `ADMIN`): §4.1 (`[NEEDS KEREM APPROVAL]` open-items trimmed to IR-24 only; verdict “two→one”), §4.8 (open-items no longer lists the IR-25 value/owner, points to v0.5 §15; provider-side OTP/KVKK/cross-border + BL-1 remain open), §8.1 (removed the IR-25 SMS spend/volume ceiling value + response-path owner row). Corrected the Source freshness baseline `AUTH_THREAT_MODEL.md` row to v0.5 / blob `bb1f270c4019` and pinned the baseline to current HEAD `c4832ab3`; other source rows retain their 2026-06-15 (`7374adf4`) read and were not re-verified this session. No new K-xx; no `PROJECT_DECISION_INDEX.md` change; no SMS provider selected; no Pod C authorization. BL-1/BL-3/BL-4/BL-5/BL-6 remain open; Pod C remains blocked. Synthetic data only. Merge gate Pod B + Kerem. |
| v0.2 draft | 2026-07-01 | Pod B / Pod A package | Reconciles P16 ADR-005 v1.2 security/access-control requirements: SR-003-5…13, DB/query-layer deny enforcement, QR token controls, logging minimization, and SR-006 regression-test expectations. No Pod C authorization. |
