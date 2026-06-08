# PROJECT_DECISION_INDEX.md

**Owner:** Pod B — Architecture, Logic & Risk
**Reviewer:** Pod A (rows marked product/business-impacting)
**Approver:** Kerem (any status transition **into or out of "Locked"** on a product/business-impacting decision)
**Canonical methodology:** `/docs/PROJECT_METHODOLOGY.md`
**Intended repo path:** `/docs/PROJECT_DECISION_INDEX.md`
**Last updated:** 2026-06-08 (K-12: tenancy + ORM decisions locked; ADR-004 and ADR-008 Accepted)

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
| Integration pattern | Locked (ADR pending) | ADR-005 | B, C | `CafeManagementAdapter` |
| Current adapter | Locked (ADR pending) | ADR-005 | B, C | `SelcafeAdapter` — temporary legacy bridge, not the core domain |
| Future native engine | Locked (direction) | PROJECT_METHODOLOGY.md | B, C | `AdeksNativeCafeEngine` (Phase 2–3) |
| Phase 2 PC client | Locked as Phase 2 candidate | PROJECT_METHODOLOGY.md | B, C, D | Electron + TypeScript |
| Local gateway | Locked as Phase 2 candidate | PROJECT_METHODOLOGY.md | B, C | TypeScript/Node.js inside Adeks local network |
| ORM | Locked | ADR-004 — Accepted 2026-06-08 | B, C | Prisma. Schema-first, generated client. Prisma Client Extensions mandatory for global `tenant_id` enforcement. |
| Tenancy strategy | Locked | ADR-008 — Accepted 2026-06-08 | A, B, C | Shared schema + mandatory non-null `tenant_id` on all tenant-scoped tables. Long-term model. No schema-per-tenant or database-per-tenant planned. |
| Primary keys | Locked | ADR-008 — Accepted 2026-06-08 | B, C | UUID on all entity tables. Resolves UUID-vs-bigint open question. |

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
| ADR-005 | Selcafe read-only Phase 1 adapter | High | Backlog — decision locked, ADR to write |
| ADR-006 | Wallet append-only ledger | High | Backlog — principle locked, ADR to write |
| ADR-007 | Loyalty append-only ledger | High | Backlog — principle locked, ADR to write |
| ADR-008 | Tenancy strategy — shared schema + `tenant_id` (long-term) | Done | **Accepted** — 2026-06-08 (Kerem approval). Shared schema + non-null `tenant_id`, long-term. Filename kept for link stability. Implementation blocked pending separate approved issues. |
| ADR-009 | PR approval policy | High | **Accepted** — 2026-06-05 (Kerem approval); merged to `main` (PR #17). Canonical home: `/docs/adr/ADR-009-pr-approval-policy.md`. Absorbs `POD_TRAFFIC_WORKFLOW.md` §14 + the conditional PR Pod Impact Matrix gate (MD-6). **Enforcement live:** PR-template §3 triggers + §4 behavior-change gate reconciled in PR-4. |
| ADR-010 | Real-time transport selection | Phase 2 | Backlog (Phase 2) |
| ADR-011 | Payment provider | Phase 2 | Backlog (Phase 2) |
| ADR-012 | Feature flag tool selection | Before Phase 1 go-live | Backlog — **assigned to Pod B** (K-04) |
| ADR-013 | Repository-Controlled Pod Context (methodology consolidation) | High | **Accepted** — 2026-06-05 (Kerem approval). Supersedes `POD_TRAFFIC_WORKFLOW.md` as an active methodology source. |
| ADR-014 | PWA-first customer application | High | Backlog — decision locked, ADR to write |

---

## 4. Related Decision Records (canonical homes — not duplicated here)

| Decision set | Canonical source | Notes |
|---|---|---|
| Kerem interview decisions **K-01 … K-10** | `/docs/KEREM_DECISIONS.md` | Vision/North Star, cadence, rollback threshold, feature flag (→ADR-012), product metrics, feedback capture, VERBİS, KVKK advisor, pilot selection, Selcafe spike. |
| **K-11 — BC-2 approval-gate alignment** | `/docs/KEREM_DECISIONS.md` §11 | **Locked — Kerem-approved 2026-06-07** (BC-2 Option A; PR #27, Issue #26). Corrects §11.1 and §15 conflicts with ADR-009 §3. Effective gates: **Selcafe adapter or Selcafe integration changes → Pod B + Kerem required before merge**; **Database / schema migration → Pod B + Kerem required before merge**; **Security-sensitive PR (incl. security-sensitive admin actions) → Pod B + Kerem required before merge**. Stale embedded PR template removed from §15; live template at `.github/PULL_REQUEST_TEMPLATE.md`. Authoritative source for all gates: ADR-009 §3. |
| **K-12 — Tenancy model + ORM decision** | `/docs/KEREM_DECISIONS.md` §12 | **Locked — Kerem-approved 2026-06-08**. Tenancy: shared schema + mandatory non-null `tenant_id`, long-term (ADR-008 Accepted). ORM: Prisma (ADR-004 Accepted). Binding design requirement: global Prisma Client Extension for `tenant_id` enforcement. UUID primary keys on all entity tables. Implementation remains blocked pending separate Pod B + Kerem approved issues. |
| Governance decisions **PQ-001 … PQ-005** | Canonical homes (mapped) | Migrated from archived `POD_TRAFFIC_WORKFLOW.md` §17. PQ-001 → `PROJECT_METHODOLOGY.md` §11.1/§20.3 + ADR-009 §3; PQ-002 → `PROJECT_METHODOLOGY.md` §2.5 (Pod D mandatory audit cadence) + §8.4; PQ-003 → `/docs/templates/` + ADR-013; PQ-004 → ADR-009 §2; PQ-005 → `PROJECT_METHODOLOGY.md` §27 + `/docs/templates/CONTEXT_FRESHNESS.md`. |
| Confirmed Phase 1 product decisions **D-001 … D-011** | Product docs / instruction files (to migrate into `MVP_SCOPE.md`) | Login-gated core, public catalog, cashier top-up, no self top-up Phase 1, automatic loyalty earning, cashier redemption, staff-approved reservations, cashier-only payment Phase 1, online payment Phase 2. |
| Locked principles | `PROJECT_METHODOLOGY.md` (Locked Principles) + ADR-005/006/007 | Append-only wallet & loyalty ledgers; all admin actions auditable; no direct commits to `main`; KVKK required; human approval for wallet/payment/refund/security/customer-data; Selcafe read-only Phase 1; synthetic data only. |
| Mandatory rollback triggers | `/docs/ROLLBACK_POLICY.md` (Pod B to write per K-03) | (1) wallet/loyalty integrity failure; (2) customer personal-data exposure → immediate non-discretionary rollback. |
| Kerem methodology decisions **MD-2 … MD-6** | `/docs/PROJECT_METHODOLOGY.md` §28.4 | Approved 2026-06-04. MD-2: methodology-consolidation direction. MD-3: ADR-013 + §28 revision. MD-4: decision-index ownership = Pod B sole owner, Pod A reviewer on product/business-impacting rows. MD-5: workflow stub + archive at `/docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md`. MD-6: conditional Pod Impact Matrix gate. |

---

## 5. Maintenance Rule for This Index

Update this file whenever any PR or recorded decision changes a row's status. The `INSTRUCTION_UPDATE_PACKET.md` verification checklist must confirm this index was updated when decision state changes. A status transition into or out of **Locked** on a product/business-impacting row requires Kerem's approval before it is recorded here.
