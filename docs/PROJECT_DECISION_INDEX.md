# PROJECT_DECISION_INDEX.md

**Owner:** Pod B — Architecture, Logic & Risk
**Reviewer:** Pod A (rows marked product/business-impacting)
**Approver:** Kerem (any status transition **into or out of "Locked"** on a product/business-impacting decision)
**Canonical methodology:** `/docs/PROJECT_METHODOLOGY.md`
**Intended repo path:** `/docs/PROJECT_DECISION_INDEX.md`
**Last updated:** 2026-06-23 (ADR-016 Accepted — Secrets Management Strategy; §3 ADR-016 row added; K-S1/K-S2/K-S3 recorded. Prior same-day entry: ADR-005 Accepted — Selcafe read-only adapter full text; §3 ADR-005 row and §1 integration-pattern/current-adapter rows updated; K-A1/K-A2 recorded)

> **This file mirrors ADRs, methodology, and recorded Kerem decisions. It does not *establish* decisions.** The authoritative record of any decision is its ADR (in `/docs/adr/`) plus Kerem's approval. If this index and an ADR ever disagree, the ADR wins and this index is stale until corrected. If an external platform-instruction file says a decision is locked but this index and the ADRs do not, **treat the instruction file as stale** until reconciled.

---

## Status Vocabulary

| Status | Meaning |
|---|---|
| **Locked** | Decision is firm and authoritative. Do not reopen without a flagged business/security/legal/implementation conflict. |
| **Locked (ADR pending)** | The decision is firm (made by Kerem / locked in instructions), but the durable ADR record is still in the §19 backlog and has not been written/`Accepted` yet. |
| **Not locked** | Open. Candidates exist; no decision made. |
| **Deferred** | Consciously postponed by Kerem to a later point. Not "open for debate now," not "locked." |
| **Conflicting** | Sources disagree; requires reconciliation. *(No rows currently in this state.)* |
| **Superseded** | Replaced by a later ADR; retained for history. *(None yet.)* |

---

## 1. Locked Technical Decisions

| Decision Area | Status | Canonical Source | Affected Pods | Notes |
|---|---|---|---|---|
| Language | Locked (ADR pending) | ADR-002 | A, B, C, D | TypeScript throughout |
| Backend framework | Locked (ADR pending) | ADR-002 | B, C | NestJS |
| Frontend framework | Locked (ADR pending) | ADR-002 | A, C, D | Next.js |
| Architecture | Locked (ADR pending) | ADR-001 | B, C | Modular monolith — not microservices |
| Customer app | Locked | PROJECT_METHODOLOGY.md / PROJECT_BRIEF.md | A, C, D | PWA first |
| Database family | Locked (ADR pending) | ADR-003 | B, C | PostgreSQL |
| Integration pattern | Locked | ADR-005 — Accepted 2026-06-23 | B, C | `CafeManagementAdapter` |
| Current adapter | Locked | ADR-005 — Accepted 2026-06-23 | B, C | `SelcafeAdapter` — temporary legacy bridge, not the core domain |
| Future native engine | Locked (direction) | PROJECT_METHODOLOGY.md | B, C | `AdeksNativeCafeEngine` (Phase 2–3) |
| Phase 2 PC client | Locked as Phase 2 candidate | PROJECT_METHODOLOGY.md | B, C, D | Electron + TypeScript |
| Local gateway | Locked as Phase 2 candidate | PROJECT_METHODOLOGY.md | B, C | TypeScript/Node.js inside Adeks local network |
| ORM | Locked | ADR-004 — Accepted 2026-06-08 | B, C | Prisma. Schema-first, generated client. Prisma Client Extensions mandatory for global `tenant_id` enforcement. |
| Tenancy strategy | Locked | ADR-008 — Accepted 2026-06-08 | A, B, C | Shared schema + mandatory non-null `tenant_id` on all tenant-scoped tables. Long-term model. No schema-per-tenant or database-per-tenant planned. |
| Primary keys | Locked | ADR-008 — Accepted 2026-06-08 | B, C | UUID on all entity tables. Resolves UUID-vs-bigint open question. |
| Authentication strategy | Locked | ADR-015 — Accepted 2026-06-09 | A, B, C, D | Phase 1. CUSTOMER: Phone OTP (SMS); JWT access (~15 min) + refresh (~7–30 d) in `httpOnly` cookie; customer UUID in claims, not phone. CASHIER/FB_STAFF: individual username/password; server-side session; 40-min inactivity timeout. ADMIN: username/password + required TOTP MFA; 15-min inactivity timeout; step-up re-auth for high-sensitivity actions. No shared accounts. Decisions locked via K-13 (KD-A…KD-H). |
| Loyalty ledger design | Locked | ADR-007 — Accepted 2026-06-14 | A, B, C | Append-only loyalty ledger. Formula: `floor(0.10 × settled_TRY) = floor(settled_kuruş / 1000)` (K-18, 10% round-down). Separate table from wallet. Balance derived (SUM). Reversal = single signed `FB_ACCRUAL_REVERSAL`, recomputed from corrected amount. Atomic with wallet via single DB transaction. KVKK provisional (pending legal advisor). Implementation blocked. |

---

## 2. Not Locked / Deferred — Pod B to Decide or Recommend

| Decision Area | Status | Canonical Source | Affected Pods | Notes |
|---|---|---|---|---|
| Caching layer | Not locked | TBD | B, C | — |
| Queue system | Not locked | TBD | B, C | — |
| Real-time transport | Not locked (Phase 2) | ADR-010 (Phase 2) | B, C | WebSocket is the Phase 2 candidate; Pod B selects before Phase 2. Not required Phase 1. |
| Payment provider | Not locked (Phase 2) | ADR-011 (Phase 2) | B, C | Not required Phase 1 (D-010/D-011: Phase 1 payment is cashier-only). |
| SMS / email / push provider | Not locked | TBD | B, C | — |
| Hosting / deployment model | Not locked | TBD | B, C | Constrained by 99.9% SLO (K-05) and KVKK cross-border assessment (K-08). |
| Feature flag tool | **Deferred to Pod B** | ADR-012 — before Phase 1 go-live | B, C | Per K-04. Pod B intent: DB-driven flags for Phase 1 → managed service (e.g. Unleash) before Phase 3. |

---

## 3. ADR Backlog Status (mirror of PROJECT_METHODOLOGY.md §19)

| ID | Decision | Priority | Status |
|---|---|---|---|
| ADR-001 | Modular monolith architecture | High | Backlog — decision locked, ADR to write |
| ADR-002 | TypeScript / NestJS / Next.js stack | High | Backlog — decision locked, ADR to write |
| ADR-003 | PostgreSQL database family | High | Backlog — decision locked, ADR to write |
| ADR-004 | ORM selection — Prisma              | Done | **Accepted** — 2026-06-08 (Kerem approval). Prisma selected. Implementation blocked pending separate Pod B + Kerem approved issues. |
| ADR-005 | Selcafe read-only Phase 1 adapter | Done | **Accepted** — 2026-06-23 (Kerem approval). Full ADR text: read-only Selcafe Phase 1 via `CafeManagementAdapter`/`SelcafeAdapter`; bounded PII-free read surface + hard-exclusion list; SR-003-1—4 read-path controls. K-A1 decided (direct live SQL; replica/BigQuery deferred); K-A2 authorized (dedicated least-privilege read-only login); K-A4/K-A5 gate any future PII/cross-border expansion. Does NOT authorize Pod C; implementation blocked pending separately approved issues + (for PII/cross-border) `KVKK_LEGAL_BASIS.md` / `DATA_RETENTION_POLICY.md` / `CROSS_BORDER_TRANSFER_ASSESSMENT.md`. |
| ADR-006 | Wallet append-only ledger | Done | **Accepted** — 2026-06-14 (Kerem approval). Append-only wallet ledger, correction entry discipline, and reason-code enum locked in ADR-006. Implementation blocked pending separate Pod B + Kerem approved issues. |
| ADR-007 | Loyalty append-only ledger | Done | **Accepted** — 2026-06-14 (Kerem approval; PR #65). Append-only loyalty ledger, loyalty formula (`floor(settled_kuruş / 1000)`, 10% round-down), reversal/recompute design, and abuse controls locked in ADR-007. KVKK section provisional (pending legal advisor). Implementation blocked pending: OQ-LEGAL-005 + `DATA_RETENTION_POLICY.md` / `KVKK_LEGAL_BASIS.md`; separate Pod B + Kerem approved implementation issues. (`DATA_PROCESSING_INVENTORY.md` present, Kerem-approved 2026-06-15; `SECURITY_REVIEW.md` present at review level, Kerem-approved.) (OQ-AUDIT-001 resolved at design level by `/docs/architecture/AUDIT_EVENT_SCHEMA.md`, Kerem-accepted 2026-06-15, PR #66; KD-D retention remains open under OQ-LEGAL-005.) |
| ADR-008 | Tenancy strategy — shared schema + `tenant_id` (long-term) | Done | **Accepted** — 2026-06-08 (Kerem approval). Shared schema + non-null `tenant_id`, long-term. Filename kept for link stability. Implementation blocked pending separate approved issues. |
| ADR-009 | PR approval policy | High | **Accepted** — 2026-06-05 (Kerem approval); merged to `main` (PR #17). Canonical home: `/docs/adr/ADR-009-pr-approval-policy.md`. Absorbs `POD_TRAFFIC_WORKFLOW.md` §14 + the conditional PR Pod Impact Matrix gate (MD-6). **Enforcement live:** PR-template §3 triggers + §4 behavior-change gate reconciled in PR-4. |
| ADR-010 | Real-time transport selection | Phase 2 | Backlog (Phase 2) |
| ADR-011 | Payment provider | Phase 2 | Backlog (Phase 2) |
| ADR-012 | Feature flag tool selection | Before Phase 1 go-live | Backlog — **assigned to Pod B** (K-04) |
| ADR-013 | Repository-Controlled Pod Context (methodology consolidation) | High | **Accepted** — 2026-06-05 (Kerem approval). Supersedes `POD_TRAFFIC_WORKFLOW.md` as an active methodology source. |
| ADR-014 | PWA-first customer application | High | Backlog — decision locked, ADR to write |
| ADR-015 | Authentication strategy | Done | **Accepted** — 2026-06-09 (Kerem approval). Phase 1 auth: Phone OTP customer (JWT + refresh, `httpOnly`); individual staff credentials, server-side session, 40-min timeout; required admin TOTP MFA, 15-min timeout. Decisions locked via K-13 (KD-A…KD-H). Implementation blocked pending Pod B authentication threat model + separate Pod B + Kerem approved issues. |
| ADR-016 | Secrets management strategy | Done | **Accepted** — 2026-06-23 (Kerem approval). Homes SECURITY_REVIEW.md SR-001; supplies the secrets mechanism ADR-005 SR-003-3/§8.4 defers to SR-001 (Selcafe credential) and governs the JWT key (IR-04), TOTP KEK (IR-14), and audit anchor key (AUDIT §7). Locks SM-1…SM-10 + a vendor-neutral SecretsProvider abstraction (K-S1); concrete backend deferred to the hosting decision (K-S2, Not locked / K-05 / K-08); secret-rotation events in infra logs only, not audit_event, reopenable (K-S3). Does NOT authorize Pod C; implementation gated on the §4.3 backend selection + separately approved issues. |

---

## 4. Related Decision Records (canonical homes — not duplicated here)

| Decision set | Canonical source | Notes |
|---|---|---|
| Kerem interview decisions **K-01 … K-10** | `/docs/KEREM_DECISIONS.md` | Vision/North Star, cadence, rollback threshold, feature flag (→ADR-012), product metrics, feedback capture, VERBİS, KVKK advisor, pilot selection, Selcafe spike. |
| **K-11 — BC-2 approval-gate alignment** | `/docs/KEREM_DECISIONS.md` §11 | **Locked — Kerem-approved 2026-06-07** (BC-2 Option A; PR #27, Issue #26). Corrects §11.1 and §15 conflicts with ADR-009 §3. Effective gates: **Selcafe adapter or Selcafe integration changes → Pod B + Kerem required before merge**; **Database / schema migration → Pod B + Kerem required before merge**; **Security-sensitive PR (incl. security-sensitive admin actions) → Pod B + Kerem required before merge**. Stale embedded PR template removed from §15; live template at `.github/PULL_REQUEST_TEMPLATE.md`. Authoritative source for all gates: ADR-009 §3. |
| **K-12 — Tenancy model + ORM decision** | `/docs/KEREM_DECISIONS.md` §12 | **Locked — Kerem-approved 2026-06-08**. Tenancy: shared schema + mandatory non-null `tenant_id`, long-term (ADR-008 Accepted). ORM: Prisma (ADR-004 Accepted). Binding design requirement: global Prisma Client Extension for `tenant_id` enforcement. UUID primary keys on all entity tables. Implementation remains blocked pending separate Pod B + Kerem approved issues. |
| **K-13 — Authentication decisions (KD-A through KD-H)** | `/docs/KEREM_DECISIONS.md` §13 | **Locked — Kerem-approved 2026-06-09 (PR #37)**. Customer: Phone OTP. Staff: individual credentials. Admin: TOTP MFA required. F&B Staff: orders only, no payment. Cashier timeout: 40 min. Phone display: masked last 4 digits. SMS provider: deferred pending Pod B provider report. ADR-015 drafting is next Pod B deliverable. |
| **K-14 / K-15 / K-16 — Customer registration privacy-notice flow decisions** | `/docs/KEREM_DECISIONS.md` §14–16 | **Locked — Kerem-approved 2026-06-10.** Resolves CORE_USER_FLOWS.md OQ-CUF-AUTH-002/003/004. **K-14:** Aydınlatma Metni text canonical in `/docs/PRIVACY_NOTICE_TR.md`, build-time embedded; no CMS in Phase 1. **K-15:** acknowledgment ephemeral pre-verification, persisted only on successful OTP verification (**touches the KVKK consent-capture surface; pending K-08 legal-advisor confirmation before Pod C propagation**). **K-16:** same-session acknowledgment reuse valid for OTP resend; re-acknowledge on session break or phone-number change. Notice **legal text** (OQ-CUF-AUTH-001) and **SMS provider** (OQ-CUF-AUTH-005) remain open. |
| **K-17 — F&B price source for settlement** | `/docs/KEREM_DECISIONS.md` §17 | **Locked — Kerem-approved 2026-06-14.** Settlement uses price captured at order submission (immutable snapshot); catalog edits after submission do not affect settlement amount. Resolves dependency D-4. Pod C remains blocked (ADR-006 Accepted; ADR-007 Accepted 2026-06-14). |
| **K-18 — F&B loyalty accrual formula** | `/docs/KEREM_DECISIONS.md` §18 | **Locked — Kerem-approved 2026-06-14; formula corrected 2026-06-14.** Formula: `floor(0.10 × settled_amount_TRY)` = `floor(settled_kuruş / 1000)`, 10% of settled F&B amount, rounded down to whole points. Examples: ₺100→10, ₺157→15, ₺99→9. Accrual trigger = cashier recording payment settlement. Resolves dependency D-3. Pod C remains blocked (ADR-006 Accepted 2026-06-14; ADR-007 Accepted 2026-06-14; `DATA_RETENTION_POLICY.md` / `KVKK_LEGAL_BASIS.md` absent; separate approved Pod C issues required). (`DATA_PROCESSING_INVENTORY.md` present, Kerem-approved 2026-06-15; `SECURITY_REVIEW.md` present at review level.) (OQ-AUDIT-001 resolved at design level — see ADR-007 row.) |
| **K-19 — F&B post-settlement correction policy** | `/docs/KEREM_DECISIONS.md` §19 | **Locked — Kerem-approved 2026-06-14.** Cashier same-shift self-correction permitted (own settlements only); executor = cashier-executed (V-SAFE declined); customer-visible history = minimized (neutral label + value delta). Follow-up decisions resolved 2026-06-14: correction window = cashier same-shift with daily-report control (in-system bound finalized in ADR-006, no runtime Selcafe dependency); executor = cashier-executed (V-SAFE declined); customer-visible history = minimized (neutral label + value delta). Reason-code enum home: ADR-006 (Accepted 2026-06-14) — correction reason-code enum is now locked there. Pod C remains blocked (ADR-006 Accepted 2026-06-14; ADR-007 Accepted 2026-06-14; `DATA_RETENTION_POLICY.md` / `KVKK_LEGAL_BASIS.md` absent; separate approved Pod C issues required). (`DATA_PROCESSING_INVENTORY.md` present, Kerem-approved 2026-06-15; `SECURITY_REVIEW.md` present at review level.) (OQ-AUDIT-001 resolved at design level — see ADR-007 row.) |
| Governance decisions **PQ-001 … PQ-005** | Canonical homes (mapped) | Migrated from archived `POD_TRAFFIC_WORKFLOW.md` §17. PQ-001 → `PROJECT_METHODOLOGY.md` §11.1/§20.3 + ADR-009 §3; PQ-002 → `PROJECT_METHODOLOGY.md` §2.5 (Pod D mandatory audit cadence) + §8.4; PQ-003 → `/docs/templates/` + ADR-013; PQ-004 → ADR-009 §2; PQ-005 → `PROJECT_METHODOLOGY.md` §27 + `/docs/templates/CONTEXT_FRESHNESS.md`. |
| Confirmed Phase 1 product decisions **D-001 … D-011** | Product docs / instruction files (to migrate into `MVP_SCOPE.md`) | Login-gated core, public catalog, cashier top-up, no self top-up Phase 1, automatic loyalty earning, cashier redemption, staff-approved reservations, cashier-only payment Phase 1, online payment Phase 2. |
| Locked principles | `PROJECT_METHODOLOGY.md` (Locked Principles) + ADR-005/006/007 | Append-only wallet & loyalty ledgers; all admin actions auditable; no direct commits to `main`; KVKK required; human approval for wallet/payment/refund/security/customer-data; Selcafe read-only Phase 1; synthetic data only. |
| Mandatory rollback triggers | `/docs/ROLLBACK_POLICY.md` | (1) wallet/loyalty integrity failure; (2) customer personal-data exposure → immediate non-discretionary rollback. Authoritative home: `/docs/ROLLBACK_POLICY.md` (K-03). |
| Kerem methodology decisions **MD-2 … MD-6** | `/docs/PROJECT_METHODOLOGY.md` §28.4 | Approved 2026-06-04. MD-2: methodology-consolidation direction. MD-3: ADR-013 + §28 revision. MD-4: decision-index ownership = Pod B sole owner, Pod A reviewer on product/business-impacting rows. MD-5: workflow stub + archive at `/docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md`. MD-6: conditional Pod Impact Matrix gate. |
| **Command Keyword Gate (pod output-mode gate) — MD-7** | `PROJECT_METHODOLOGY.md` §16.2 + `/docs/POD_EDIT_WORKFLOW.md`; routed via `/docs/AGENT_CONTEXT_MANIFEST.md` | **Locked — Kerem-approved 2026-06-17 (PR #81).** Pods must obtain a valid command keyword from Kerem before producing executable repo-edit/write material; otherwise stop and ask. No keyword overrides ADR-009, DoR, DoD, Kerem approval, required Pod B review, legal/KVKK blockers, synthetic-data-only, merge-is-Kerem-only, or no-direct-`main`. No keyword authorizes Pod C feature implementation. Snapshot-pointer follow-up tracked (separate behavior-changing PR). |
| **K-S1 — Secrets-management requirements + SecretsProvider abstraction** | `docs/adr/ADR-016-secrets-management-strategy.md` | **Locked — Kerem-approved 2026-06-23.** SM-1…SM-10 binding requirements + vendor-neutral `SecretsProvider` port abstraction locked. Concrete backend deferred to hosting decision (K-S2). |
| **K-S2 — Concrete secrets backend** | `docs/adr/ADR-016-secrets-management-strategy.md` §4.3 | **Not locked** — dependent on hosting decision (K-05/K-08). Options O-1…O-3 documented; O-4 rejected. Pod B recommendation: O-1 or O-3 for self-hosted Phase 1, O-2 attractive if cloud-hosted with Turkey-region posture. |
| **K-S3 — Secret rotation events in audit_event vs infra logs** | `docs/adr/ADR-016-secrets-management-strategy.md` §9 | **Kerem decision recorded 2026-06-23:** infra/secrets-backend log only (not `audit_event`); reopenable if Pod D wants a domain signal. |

---

## 5. Maintenance Rule for This Index

Update this file whenever any PR or recorded decision changes a row's status. The `INSTRUCTION_UPDATE_PACKET.md` verification checklist must confirm this index was updated when decision state changes. A status transition into or out of **Locked** on a product/business-impacting row requires Kerem's approval before it is recorded here.
