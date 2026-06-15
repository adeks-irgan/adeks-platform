# Audit Event Schema — Phase 1

<!--
  CANONICAL REPO PATH: /docs/architecture/AUDIT_EVENT_SCHEMA.md
  AUTHOR: Pod B — Architecture, Logic & Risk
  RESOLVES: OQ-AUDIT-001 (audit fields / schema — Pod B, then Kerem)
  AUTHORITY: Pod B design artifact. Builds on the Accepted auth threat model
             (AUTH_THREAT_MODEL.md §7) and the Accepted ledger ADRs (ADR-006 §10,
             ADR-007 §9), which both explicitly defer the audit EVENT SCHEMA to
             OQ-AUDIT-001. Kerem accepted the design + decisions KD-A/B/C/F/G on
             2026-06-15. Merge gate is Pod B + Kerem (strictest §11.1). Kerem is
             sole merge authority.
  STABILITY: Kerem-accepted (design). Pending merge. Update only via ADR-009-compliant PR.
-->

## Status

| Field | Value |
|---|---|
| Document | `AUDIT_EVENT_SCHEMA.md` |
| Project | Adeks Platform |
| Owner / Author | Pod B — Architecture, Logic & Risk |
| Reviewer / Approver | Kerem |
| Current status | **Kerem-accepted (design), 2026-06-15.** Decisions KD-A / KD-B / KD-C / KD-F / KD-G resolved with Pod B recommendations (§7). Resolves OQ-AUDIT-001 at the **design** level. **Pending merge of this PR**; implementation remains blocked. |
| Scope class | Architecture / audit-log schema design. **Not** an ADR, not a DB migration, not an API contract, not a Pod C issue. |
| Repo reconciliation | **Needs repo reconciliation** — `/docs/SECURITY_REVIEW.md` and `/docs/DATA_PROCESSING_INVENTORY.md` are absent from `main`. Per `AGENT_CONTEXT_MANIFEST.md` (Wallet/Loyalty/Schema rows), output is design/review only and **must not** issue Pod C work. |
| Implementation status | **Does NOT authorize Pod C.** Creates no issues, designs no endpoints, writes no migrations. |

### Source freshness baseline

All sources read **live from `main`** at commit `684877b02c58d6c7dc43b4e6ae0e8dc49f098fc0` on 2026-06-15 (raw fetch; sizes cross-checked against the GitHub contents API). **The repository is the source of truth; `main` wins on any conflict. Re-verify these blob SHAs before any commit.**

| Source (`/docs/…`) | blob SHA (first 12) | Use in this design |
|---|---|---|
| `adr/ADR-006-wallet-append-only-ledger.md` | `4a9a33993880` | **Accepted** wallet ledger. §10 ledger-side audit fields; §8/§8.2 correction + reason-code enum; §13 KVKK. Defers event schema here. |
| `adr/ADR-007-loyalty-append-only-ledger.md` | `42ffd1a83756` | **Accepted** loyalty ledger. §9 ledger-side audit fields; §5/§6 accrual/reversal; §8 system-derived attribution; §11 KVKK. Defers event schema here. |
| `architecture/AUTH_THREAT_MODEL.md` | `df9b30b19d59` | **v0.4 Accepted (BL-2 closed)**. §3.3 trust boundary B3; §7.2/§7.3/§7.4 audit baseline; IR-03/IR-09/IR-20/IR-21. The baseline this schema builds on (BR-AUDIT-003). |
| `ROLLBACK_POLICY.md` | `3f1eadad8151` | T-1/T-2 triggers; compensating-transaction model; incident-record fields; 72-hour KVKK clock; ISO-8601+offset house style. |
| `PROJECT_METHODOLOGY.md` | `d3355d0ea5ee` | §11.1 approval triggers; §16.1 handoff rule; §20.1 abuse cases; §20.2 KVKK process; §20.3 security-review triggers. |
| `AGENT_CONTEXT_MANIFEST.md` | `504c3d0de519` | Context routing + "absent security/KVKK files → design/review only, no Pod C work, mark *Needs repo reconciliation*" fallback. |
| `reviews/FB_SETTLEMENT_DEPENDENCIES_REVIEW_v1.0.md` | `fb9b70a6e3a6` | Pod B blocker-reconciliation note (KD-F confirmed). §9 audit/KVKK implications; §10 C-1…C-11 constraints. |
| `OPEN_QUESTIONS.md` | `6ed9f7012ec9` | OQ-AUDIT-001 (this resolution); OQ-LEGAL-005 (retention); OQ-LEGAL-006 (cross-border). |
| `PROJECT_DECISION_INDEX.md` | `468c5b4d32d2` | Locked state: ADR-006/007 Accepted; append-only principle; "all admin actions auditable"; synthetic-data-only. |
| `BUSINESS_RULES.md` | `c8c00ad447e4` | BR-AUDIT-001 (coverage), BR-AUDIT-002 (immutability), BR-AUDIT-003 (auth baseline). |
| `USER_ROLES_AND_PERMISSIONS.md` | `acc1f08cb423` | Actor set; individual credentials (no shared accounts); masked-phone rule §6.1; audit no-edit §5. |
| `adr/ADR-009-pr-approval-policy.md` | `082270d26590` | PR approval gates / §4 behavior-change classification (see §8). |
| `adr/ADR-013-repository-controlled-pod-context.md` | `9605241f724f` | Repo-as-source-of-truth; snapshot authority. |
| `SECURITY_REVIEW.md` | — | **ABSENT (planned).** Triggers manifest fallback. Natural next Pod B deliverable (see §6.13, §9). |
| `DATA_PROCESSING_INVENTORY.md` | — | **ABSENT (planned).** Required (§20.2) before any personal-data feature, including this audit store, is built. |

> **Note on "the latest Pod B blocker reconciliation note" (KD-F — confirmed by Kerem 2026-06-15).** No repository file carries that literal name. The most recent Pod B note that reconciles the settlement/wallet/loyalty **blocker set** and is reconciliation-flagged is `FB_SETTLEMENT_DEPENDENCIES_REVIEW_v1.0.md` (2026-06-13, "Needs repo reconciliation," "these decisions reduce the blocker set; they do not clear it"); it is the blocker-reconciliation input here. That note predates the 2026-06-14 acceptance of ADR-006/007, so where it calls those ADRs "Proposed stubs," that observation is **stale** — both are now Accepted full designs.

---

## 1. Purpose and Scope

This document answers **OQ-AUDIT-001**:

> *"Are minimum audit fields enough, or must reason/comment, IP/device, before/after derived values, and workflow source also be captured?"*

It defines the **audit event schema** that ADR-006 §10 and ADR-007 §9 explicitly deferred here — specifically the parts both ADRs named as out of their scope: **storage, tamper-evidence, retention, IP/device, and workflow-source taxonomy** — and extends the Accepted auth threat-model audit baseline (BR-AUDIT-003) into a single cross-domain schema.

**In scope (this artifact):** the auditable-event set (BR-AUDIT-001); the common audit-event envelope (fields); actor attribution; the workflow-source taxonomy; the IP/device capture recommendation; before/after / derived-value recording rules; the storage model; tamper-evidence requirements; the wallet / loyalty / F&B-correction audit events; retention **dependency** notes; security-review **dependency** notes; and the unresolved Kerem/legal questions.

**Out of scope (designed elsewhere or pending):**

| Out of scope here | Owner / where |
|---|---|
| Wallet/loyalty **ledger** table design (entry taxonomy, balance derivation, concurrency) | ADR-006 / ADR-007 (Accepted). This doc only references the audit-bearing fields. |
| The correction **reason-code enum** | **ADR-006 §8.2** is the canonical home (K-19). Referenced, never redefined here. |
| The loyalty **formula** | **ADR-007 §2** (K-18). Referenced only. |
| **API endpoints**, request/response shapes, **DB migrations** | Pod B API/schema deliverables → Pod C **after** approved issues. Not designed here. |
| **Retention periods** | **OQ-LEGAL-005** (Kerem + legal advisor + Pod B). **Not invented here.** |
| KVKK **legal basis**, data inventory entries | `KVKK_LEGAL_BASIS.md`, `DATA_PROCESSING_INVENTORY.md` (§20.2). Absent / legal review. |
| F&B **order-status** audit points, **reservation** audit points, full **auth** event detail | F&B state model / reservation state machine (planned) / AUTH_THREAT_MODEL §7 + IR-09. They **consume** this schema; detailed per-domain points are not redesigned here (§6.11). |

---

## 2. Inputs this schema consumes (binding)

- **BR-AUDIT-001** — auditable coverage: wallet, loyalty, payment (Phase 2+), customer-data access/mutation, F&B order-status, reservation approval/rejection, staff-account actions, **sensitive admin access**.
- **BR-AUDIT-002** — immutability: **no Phase 1 role may edit or delete audit logs.**
- **BR-AUDIT-003** — auth audit must build on the Accepted auth threat-model baseline.
- **Auth threat model §7.3 / IR-20** *(Kerem-approved 2026-06-10)* — **DB-grant-level append-only is sufficient for Phase 1**; hash-chaining / WORM was **deferred to "the audit-log ADR"** (i.e. this work) — **now adopted as KD-C Option B (§7)**. §3.3 **B3**: no role, including `ADMIN`, may write/edit/delete audit entries.
- **Auth threat model IR-03 / T-G3 / T-F6** — **no raw phone, OTP, password, token, or TOTP secret** in audit records; customer records use UUID / phone hash.
- **Auth threat model IR-09 / T-P2** — auth events and **admin full-phone access** are auditable (actor UUID + timestamp).
- **ADR-006 §10 / ADR-007 §9** — ledger-side audit fields (enumerated); **before/after expressed as derived values only, never as balance overwrites**; schema (storage/tamper/retention/IP-device/workflow-source) deferred here.
- **ADR-006 §13 / ADR-007 §11** — KVKK: append-only-vs-erasure → **pseudonymize-without-delete**; no direct writes to immutable rows; T-2 starts the 72-hour clock.
- **Methodology §11.1** — *Audit log schema or logic* → **Pod B**; *Customer personal data handling* and *Security-sensitive* → **Pod B + Kerem**. **Strictest trigger governs** (ADR-009 §3) → **Pod B + Kerem** (§8).
- **Methodology §20.2 / §20.3** — every personal-data feature links to the data inventory; **audit-log logic requires Pod B security review before merge**; **synthetic data only**.
- **ROLLBACK_POLICY** — compensating-transaction model; T-1/T-2; incident record; ISO-8601+offset.

---

## 3. OQ-AUDIT-001 — direct answer

**Minimum fields (actor UUID + timestamp + event type) are NOT sufficient** for the events that carry money-like value, discretionary authority, or personal data. The schema **requires** a richer common envelope plus an event-type payload. Each element OQ-AUDIT-001 asks about:

| Element | Required? | Rule (summary) | Caveat |
|---|---|---|---|
| **Reason / comment** | **Required** for discretionary financial actions (corrections), **fail-closed** | Reason **code** from the ADR-006 §8.2 enum + optional `reason_note`; absence fails the correction closed. Canonical store is the ledger entry; the audit event **references** it. | `reason_note` is personal data → pseudonymizable (§6.12). |
| **IP / device** | **Required** on client-originated security-relevant events (KD-B, §6.6) | Capture `source_ip` + coarse `user_agent_digest`; omit on system-derived/scheduled events. | `source_ip` is personal data; **retention legal-dependent (OQ-LEGAL-005)**; capture scope **decided (KD-B)**. |
| **Before / after (derived)** | **Required**, as **derived/referenced values only** | Never store a mutable "before/after" of a balance (no balance column exists). Use immutable entry refs + signed delta + a clearly-labelled `derived_balance_after` snapshot. Non-financial fields record domain before/after **without raw PII**. | Per ADR-006 §10 / ADR-007 §9. |
| **Workflow source** | **Required**, closed enum | `workflow_source` ∈ the §6.5 taxonomy; unknown value **fails closed**. | New surface → enum extension via Pod B + Kerem. |

**Conclusion:** the answer to OQ-AUDIT-001 is **"more than the minimum,"** with the specific rules in §6. This is resolved at the **design** level: Kerem accepted the §7 decision set on 2026-06-15 (KD-A/B/C/F/G); the remaining gates are **legal** (KD-D retention / KD-E inventory) and Pod C, mirroring the ADR-006/007 posture (*design accepted, implementation blocked*).

---

## 4. Auditable event scope (BR-AUDIT-001)

The schema is **one canonical, cross-domain audit log** (KD-A). Every BR-AUDIT-001 category writes the **same envelope** (§5); domain specifics live in a typed payload and in references to the immutable domain rows.

| Domain | Event classes (illustrative) | Detailed design home |
|---|---|---|
| Wallet ledger | settlement debit; settlement correction; (top-up — pending OQ-WAL-001/002) | **§6.11**, ADR-006 |
| Loyalty ledger | accrual; accrual reversal | **§6.11**, ADR-007 |
| F&B order status | submitted/accepted/preparing/ready/delivered/**rejected**/**cancelled** transitions + reason | F&B state model (consumes this schema) |
| Reservation | request, **approval/rejection**, cancellation, no-show | Reservation state machine (planned) |
| Customer personal data | **ADMIN full-phone access** (T-P2); customer-data mutation | AUTH_THREAT_MODEL §7.4 / IR-09 |
| Authentication | login success/failure (all 4 channels), logout, session expiry, password change, suspension/reactivation, MFA + step-up, **initial-admin bootstrap** | AUTH_THREAT_MODEL §7 / IR-09 / IR-24 |
| Staff/admin account | create/suspend/reactivate, role change, credential reset | AUTH_THREAT_MODEL / USER_ROLES |

> **Locked principle reinforced:** *"all admin actions auditable"* (PROJECT_DECISION_INDEX, Locked principles). A **missing** audit record for a sensitive action is itself a detectable control failure (§20.1; ADR-006 §12; ADR-007 §10).

This document **fully specifies the envelope and the wallet/loyalty/F&B-correction events**. The other domains reuse the same envelope; their **per-event trigger points** are defined in their own Pod B deliverables (F&B state model, reservation state machine, auth IRs) and are not re-derived here.

---

## 5. Common audit-event envelope

Every audit event carries the following fields. (This is a logical field model, **not** a DDL/migration; physical types are an ADR-008/ADR-004 schema concern handled in a later Pod B schema deliverable.)

| Field | Description | Notes / constraints |
|---|---|---|
| `audit_event_id` | UUID primary key | UUID (ADR-008/004). |
| `tenant_id` | Tenant scope | `NOT NULL`; Prisma extension enforces scoping (ADR-008/004); single tenant in Phase 1, seam must hold. |
| `occurred_at` | Event time | ISO-8601 with UTC offset (ROLLBACK_POLICY house style). |
| `recorded_at` | Persist time | Set server-side; `occurred_at ≤ recorded_at`. |
| `seq_no` | Monotonic insert order | Gap-free per tenant; supports completeness checks (§6.10), ordering (§6.9), and the hash chain (§7). |
| `event_type` | Closed enum (e.g. `WALLET_FB_SETTLEMENT_CORRECTION`) | Unknown value **fails closed**. |
| `domain` | `WALLET` / `LOYALTY` / `FB_ORDER` / `RESERVATION` / `CUSTOMER_DATA` / `AUTH` / `ACCOUNT` | Coarse partition key. |
| `workflow_source` | §6.5 taxonomy | Required; unknown **fails closed**. |
| `actor_type` | `CUSTOMER` / `CASHIER` / `FB_STAFF` / `ADMIN` / `SYSTEM` / `SCHEDULED_JOB` | §6.4. |
| `actor_id` | UUID of the authenticated principal (or `SYSTEM` sentinel) | Individual credentials only — never a shared account (USER_ROLES). |
| `on_behalf_of_actor_id` | Human attributed for `SYSTEM`-posted derivations | e.g. loyalty accrual → the settlement actor (ADR-007 §5/§8). Null for direct human actions. |
| `subject_ref` | Affected subject as a **derived identifier** | Customer UUID / `loyalty_account_id`; **never raw phone** (IR-03). |
| `target_entity` / `target_entity_id` | What was acted on | e.g. `wallet_entry` + `entry_id`; `order` + `order_id`. |
| `references[]` | Immutable domain-row references | e.g. `corrects_entry_id`, `reverses_entry_id`, `settlement_entry_ref`, `wallet_correction_ref`. |
| `change_set` | Derived before/after per §6.7 | **Derived/referenced only**; **never** raw PII; **never** a balance overwrite. |
| `reason_code` | Discretionary-action reason (enum) | From **ADR-006 §8.2** (referenced). Required where the domain mandates it (corrections), else null. |
| `reason_note_ref` | Pointer to the personal-data-bearing free-text note | Canonical store is the ledger entry; pseudonymizable (§6.12). |
| `operating_day` | Café business-day value | Self-contained, aligned to the daily-report cycle (ADR-006 §8.1). |
| `source_ip` | Client IP (when applicable) | §6.6; **personal data**; retention legal-dependent. Null for system/scheduled events. |
| `user_agent_digest` | Coarse UA/device digest (not a full fingerprint) | §6.6. Null for system/scheduled events. |
| `outcome` | `SUCCESS` / `FAILURE` / `DENIED` | Failures (e.g. failed login, denied step-up) are audited (IR-09, T-F7). |
| `correlation_id` | Request/transaction correlation | Links the wallet correction + loyalty reversal written in one transaction (ADR-006 §4). |
| `prev_hash` / `row_hash` | Tamper-evidence chain (**adopted, KD-C Option B**) | `row_hash = H(prev_hash ‖ canonical_serialization(row))`; head hash periodically anchored (§7). |

**Hard rules on the envelope**

- **R-1 (immutability, BR-AUDIT-002 / T-G1 / B3):** the audit store is **append-only**; the application role has **INSERT + SELECT only** — no `UPDATE`/`DELETE`/`TRUNCATE`. No role, including `ADMIN`, may edit or delete.
- **R-2 (no secrets/PII, IR-03 / T-G3):** **never** store raw phone, OTP, password/hash, token, or TOTP secret. Customer/subject identity is a UUID / phone hash only.
- **R-3 (no balance overwrite, ADR-006 §10 / ADR-007 §9):** before/after for ledgers is the immutable entry + signed delta + a labelled derived snapshot — never a stored mutable balance pair.
- **R-4 (completeness, T-G2):** every BR-AUDIT-001 action emits exactly one audit event; a missing event is a control failure surfaced by §6.10 monitoring.

---

## 6. Schema specification

### 6.1 Storage model

- **One canonical append-only `audit_event` store** for all domains (auth, wallet, loyalty, F&B, reservation, customer-data, account). Rationale: BR-AUDIT-002 immutability, tamper-evidence, and completeness checks are simplest and strongest to enforce on a **single** spine; the auth threat model already speaks of "the append-only auth audit log" as one log. **Decided (KD-A, Kerem 2026-06-15): unified store.**
- **No PII duplication of financial entries.** For ledger events the audit event **references** the immutable ledger `entry_id` (which already carries the ADR-006 §10 / ADR-007 §9 fields). The audit store is the cross-domain **spine**; the ledger entry remains the canonical financial record.
- **Tenancy/keys:** `tenant_id NOT NULL`, UUID PKs, Prisma Client Extension scoping (ADR-008/004).
- **Partitioning:** time-partition (e.g. monthly by `occurred_at`) to enable class-based, retention-aligned purge **once OQ-LEGAL-005 sets periods** — purge is **not** designed to delete rows before retention expiry (§6.12). Partition boundaries must not break the hash chain (chain spans partitions; §7).

### 6.2 Relationship to ledger-side audit fields (ADR-006 §10 / ADR-007 §9)

The ledger-side fields are **retained on the immutable ledger entries** (already specified and Accepted). This schema does **not** move or duplicate them; it adds the **cross-domain envelope** (§5) that references them, plus the storage/tamper/retention/IP-device/workflow-source decisions the ADRs deferred. Wallet and loyalty entries written in one transaction (ADR-006 §4) share a `correlation_id` so their audit events are provably the same correction.

### 6.4 Actor attribution

- **Human actions:** `actor_type ∈ {CUSTOMER, CASHIER, FB_STAFF, ADMIN}`, `actor_id` = the authenticated principal UUID. **Individual credentials only; shared accounts prohibited** (USER_ROLES) — every write traces to a specific human.
- **System-derived events** (e.g. `LOYALTY_FB_ACCRUAL`, `LOYALTY_FB_ACCRUAL_REVERSAL`, session-expiry): `actor_type = SYSTEM`, `actor_id` = SYSTEM sentinel, **`on_behalf_of_actor_id` = the human whose action triggered the derivation** (the S1 settlement actor for accrual; the correction actor for reversal — ADR-007 §5/§8). This preserves "every loyalty write is traceable to a specific human" even though it is system-posted.
- **Scheduled/batch:** `actor_type = SCHEDULED_JOB` (e.g. daily-report close, token-expiry sweeps); `on_behalf_of_actor_id` null.
- **Customers:** `actor_id`/`subject_ref` are UUID / phone hash — **never raw phone** (IR-03/T-F6).

### 6.5 Workflow-source taxonomy

`workflow_source` is a **closed enum** identifying the originating workflow/surface (distinct from *who* — `actor_type`):

| Value | Meaning |
|---|---|
| `CUSTOMER_PWA` | Customer-initiated via the PWA (OTP auth, F&B ordering, reservation request). |
| `CASHIER_CONSOLE` | Cashier web console (settlement, top-up, in-window corrections). |
| `FB_STAFF_CONSOLE` | F&B staff order console (order-status transitions). |
| `ADMIN_CONSOLE` | Admin web (admin actions, sensitive-data access, reports, account management). |
| `SYSTEM_DERIVATION` | System-posted derivation from another committed event (loyalty accrual/reversal from settlement). |
| `SCHEDULED_JOB` | Scheduled/batch process (daily-report close, session/OTP expiry sweeps). |

Rules: unknown `workflow_source` **fails closed**. Adding a surface (new console, new integration) requires an **enum extension via Pod B + Kerem** (audit-log schema change → §11.1; new surface is behaviour-relevant).

### 6.6 IP / device capture — decided (KD-B)

**Decided (KD-B, Kerem 2026-06-15):**

- **Capture `source_ip` + coarse `user_agent_digest`** on **client-originated, security-relevant** events: all **auth** events (4 channels, success/failure), **ADMIN sensitive-data access** (full-phone view, T-P2), and **all wallet/loyalty financial writes and corrections**.
- **Do NOT capture** IP/device on `SYSTEM_DERIVATION` / `SCHEDULED_JOB` events (no client request) — carry the originating event `correlation_id`/reference instead.
- `user_agent_digest` is a **coarse** normalized UA / device class, **not** a high-entropy fingerprint (minimization).

**KVKK treatment:** `source_ip` is **personal data** (and, for a customer, an additional identifier beyond the phone). It is subject to the same **pseudonymization + retention** strategy as other personal data (§6.12). Its retention period is **OQ-LEGAL-005-dependent** and may be **shorter** than financial-entry retention. **Access-log retention obligations may impose a floor** — this is **legal-advisor input** and **is not asserted here** (no period invented). → **KD-D (legal).**

### 6.7 Before/after and derived-value recording rules

- **No balance overwrite, ever.** Wallet and loyalty have **no mutable balance column** — balance is a derived `SUM` of immutable entries (ADR-006 §3 / ADR-007 §3). Therefore:
  - The **"change"** is fully represented by the immutable signed entry (`amount_minor` / `points_delta`) plus references (`corrects_entry_id` / `reverses_entry_id`).
  - The audit event MAY carry `derived_balance_after` as a **clearly-labelled, point-in-time derived snapshot** for investigator convenience — it is **not** an authoritative store, and the authority remains the SUM of entries. "Before" is the same derivation excluding this entry.
  - `corrected_amount` is recorded as a **derived** value (ADR-006 §8.2/§10), never as an overwrite of the original.
- **Non-financial mutable fields** (e.g. account suspension, role change, order-status transition, config change): record `field`, `prev_value`, `new_value` as **domain values** (enums/flags) — these are legitimately before/after because they are not balances.
- **Personal-data fields are special:** a change to a personal-data field (e.g. a phone-number update) records the **fact** of change with **derived identifiers**, **never** the raw old/new PII value (R-2 / IR-03).

### 6.8 Reason / comment capture

- Discretionary financial corrections **must** carry a `reason_code` from the **ADR-006 §8.2 enum** (`OVER_CHARGE`, `UNDER_CHARGE`, `ITEM_RETURNED`, `OPERATIONAL_OTHER`); `OPERATIONAL_OTHER` **requires** free-text. **Absence fails the correction closed** (ADR-006 §8.2; C-4). This schema **references** that enum — **ADR-006 is its canonical home; it is not redefined here.**
- The free-text note is personal-data-bearing → stored canonically on the ledger entry, **referenced** by the audit event via `reason_note_ref`, and **pseudonymizable** on erasure (§6.12).

### 6.9 Ordering and integrity

- `seq_no` is **gap-free per tenant** (DB sequence or equivalent), giving total order and enabling completeness/gap detection (§6.10) and the hash chain (§7).
- The wallet correction and loyalty reversal of a single correction share one `correlation_id` and are written in one DB transaction (ADR-006 §4) — both audit events commit or neither.

### 6.10 Completeness monitoring (Pod D consumer)

- `seq_no` gaps, missing-expected-event checks (e.g. a `SETTLED` order with no settlement audit event), hash-chain verification, and audit-write failures are **monitoring signals** for **Pod D** (audit-log completeness checks — AUTH_THREAT_MODEL §13; methodology §2.5 Pod D mandatory audit cadence). Pod D **monitors**; it does not write or decide.

### 6.11 Wallet / loyalty / F&B-correction audit events (in-scope catalog)

| `event_type` | Trigger (Accepted ADR) | `actor_type` / attribution | Key fields beyond the envelope |
|---|---|---|---|
| `WALLET_FB_SETTLEMENT_DEBIT` | S1 — cashier records wallet settlement (ADR-006 §5) | `CASHIER`/`ADMIN` | `target=wallet_entry`; `references=[order_id]`; signed `amount_minor`; `operating_day`; `correlation_id`. No reason (not discretionary). |
| `WALLET_FB_SETTLEMENT_CORRECTION` | Single signed compensating entry (ADR-006 §8) | `CASHIER` (own/in-window) or `ADMIN` (any) | `references=[corrects_entry_id, order_id]`; signed delta; **`reason_code` + `reason_note_ref` (fail-closed)**; `operating_day`; `correlation_id`; eligibility-window outcome. |
| `LOYALTY_FB_ACCRUAL` | Derived from committed S1 (ADR-007 §5) | `SYSTEM`, `on_behalf_of`=settlement actor | `references=[order_id, settlement_entry_ref]`; signed `points_delta`; `correlation_id`. No IP/device (system-derived). |
| `LOYALTY_FB_ACCRUAL_REVERSAL` | Recompute-from-corrected, atomic with wallet correction (ADR-007 §6) | `SYSTEM`, `on_behalf_of`=correction actor | `references=[reverses_entry_id, wallet_correction_ref]`; signed `points_delta`; `correlation_id`. No reason note of its own (lives on the wallet correction — ADR-007 §9). |

**Abuse-case coverage (consistent with ADR-006 §12 / ADR-007 §10 / §20.1):** skim-via-correction, correction churn, correct-after-window, cross-cashier correction, replay/duplicate, `FB_STAFF` writes, manual point edits, wallet/loyalty divergence — each is mitigated by the ledger controls **plus** the mandatory immutable audit event recorded here. **A missing audit event for any of these is itself a detectable control failure** (R-4 / §6.10), and the hash chain (§7) makes silent post-hoc deletion detectable.

> **Wallet top-up** audit events are intentionally **not** finalized: top-up methods and correction mechanism are **open Kerem questions** (OQ-WAL-001/002/003). When locked, they reuse this envelope; Pod B will extend the catalog then. No top-up event is designed here.

### 6.12 KVKK / pseudonymization & retention dependency

- **Append-only vs. erasure → pseudonymize-without-delete** (ADR-006 §13 / ADR-007 §11). On an Art. 11 erasure request, replace the `subject_ref` / `customer_id` linkage with a pseudonymous token and tombstone PII in `reason_note`, **without deleting or mutating** the immutable audit/ledger rows. De-linked records remain for integrity. **No direct writes to immutable rows.** Same pattern for Selcafe data (ADR-005). *(Pseudonymization replaces the linkage value; it does not edit other fields, so the hash chain is preserved — see §7.)*
- **Personal-data fields in the audit store:** `subject_ref`/`customer_id` linkage, `reason_note_ref` content, and `source_ip`. Each must be **inventoried** in `DATA_PROCESSING_INVENTORY.md` (§20.2) before Pod C builds the store — **that file is absent (KD-E).**
- **Retention:** periods are **OQ-LEGAL-005** (Kerem + legal + Pod B) and may differ by class (IP/device possibly shortest; financial-linked audit possibly longest; access-log floor a legal question). `DATA_RETENTION_POLICY.md` is absent. **No period is set or invented here (KD-D).** Partitioning (§6.1) supports class-based purge once periods exist.
- **Breach:** a confirmed personal-data exposure in the audit store is **ROLLBACK_POLICY T-2** → immediate rollback + incident record + **72-hour KVKK clock**.

### 6.13 Security-review dependency

- *Audit log logic* requires **Pod B security review before merge** (§20.3). The dedicated `/docs/SECURITY_REVIEW.md` is **absent (planned)**. Per the manifest fallback, this artifact is **design only**, marked **Needs repo reconciliation**, and **issues no Pod C work**.
- This schema is a **prerequisite input** to `SECURITY_REVIEW.md`: the security review should adopt the security properties stated here (R-1…R-4, IR-03/IR-20 alignment, the KD-C hash chain) and the residual risks in §10. **`SECURITY_REVIEW.md` can be drafted next** (see §9).

### 6.14 Tenancy, keys, ORM

- `tenant_id UUID NOT NULL` on the audit store; UUID PKs; mandatory Prisma Client Extension scoping; `$queryRaw` over audit data requires Pod B review (ADR-004). All schema changes go through `prisma migrate` (reviewed; **Pod B + Kerem** per ADR-009 §3 and §11.1 *Database / schema migration*). Phase 1 single-tenant with a static `TenantContext`; the cross-tenant seam must still hold.

---

## 7. Tamper-evidence requirements (KD-C — Option B adopted)

**Phase 1 baseline (Accepted — do not reopen):** **DB-grant-level append-only** — the app role has **INSERT + SELECT only**; **no `UPDATE`/`DELETE`/`TRUNCATE`**; no role including `ADMIN` may edit/delete (IR-20 / T-G1 / B3, **Kerem-approved 2026-06-10**). Confirmed **sufficient as a baseline**; KD-C layers on top of it.

**Decision (KD-C, Kerem-accepted 2026-06-15): Option B — adopt a per-row hash chain** on top of the accepted DB-grant baseline. This **adds** to the accepted baseline; it reopens nothing.

| Option | What | Status |
|---|---|---|
| A — DB-grant-only | Keep the accepted Phase-1 baseline as-is. | Superseded by B (B includes A). |
| **B — per-row hash chain (ADOPTED)** | Each audit row stores `prev_hash` + `row_hash = H(prev_hash ‖ canonical_serialization(row))`; the head hash is **periodically anchored** outside the audit store (e.g. a signed daily head-hash record). Materially raises tamper-evidence: silent back-dating/deletion becomes detectable. | **Adopted (KD-C).** Chain spans the unified store across partitions; applies at minimum to wallet/loyalty/admin-class events. |

**Phase-1 tamper-evidence requirements (DB-grant baseline + KD-C chain):**

- A **separate DB role** for audit writes (INSERT-only); the general app role cannot mutate the audit table.
- **Per-row hash chain (KD-C)** with **periodic external anchoring** of the head hash; chain continuity must be preserved across partition boundaries (§6.1) and across pseudonymization (which replaces a linkage value, not the hashed canonical content of unrelated fields — §6.12). *(Pod B to specify the exact canonical serialization and which fields the row hash covers in the schema/migration deliverable; pseudonymization-vs-hash interaction is called out as an implementation constraint, not re-decided here.)*
- Any migration that would `DROP`/`ALTER` the audit table is a **schema-migration gate** (Pod B + Kerem, §11.1) — call it out explicitly in CI/review.
- Backups of the audit store are retained and treated as immutable for the (legal-dependent) retention window.
- **Pod D completeness + chain-verification monitoring** (§6.10).

### Consolidated decision/open-item status (Kerem 2026-06-15)

| ID | Item | Status |
|---|---|---|
| **KD-A** | Unified single audit store vs per-domain | **Decided: unified store.** |
| **KD-B** | IP/device capture scope | **Decided:** capture `source_ip` + coarse UA digest on auth + admin-sensitive-access + financial writes; omit on system/scheduled. |
| **KD-C** | Tamper-evidence: Option A vs Option B | **Decided: Option B** — per-row hash chain + periodic anchoring, on the accepted DB-grant baseline. |
| **KD-D** | Retention periods per audit class, incl. IP/device; access-log floor | **OPEN — legal (OQ-LEGAL-005).** Periods not invented. |
| **KD-E** | Data-inventory linkage for audit personal-data fields | **OPEN — Pod A drafts / legal input (§20.2).** `DATA_PROCESSING_INVENTORY.md` must exist before Pod C. |
| **KD-F** | Blocker-reconciliation note mapping | **Confirmed:** `FB_SETTLEMENT_DEPENDENCIES_REVIEW_v1.0.md`. |
| **KD-G** | Accept this schema as the OQ-AUDIT-001 resolution | **Accepted (Kerem 2026-06-15).** Merge gate Pod B + Kerem; pending merge. |

> Cross-reference: the auth threat model's still-open `[NEEDS KEREM APPROVAL]` items — **IR-24** (initial-admin bootstrap; **its events are auditable here**) and **IR-25** (SMS spend ceiling/response-path owner) — are auth-side and **not re-decided here**; bootstrap events simply use this envelope (`event_type` under `AUTH`).

---

## 8. ADR-009 behavior-change assessment

- **PR class (§2):** **Documentation-only.** Adds one file under `/docs/architecture/`. It records a Pod B audit-schema design derived from already-Accepted ADR-006/007 and the Accepted auth threat model; the §7 decisions are recorded Kerem decisions, not a behavior/gate change.
- **§4 behavior-change gate: does NOT fire.** No pod behavior, review/approval gate, locked/deferred decision-state, methodology, template, or external-instruction change is introduced. **No Pod Impact Matrix and no `INSTRUCTION_UPDATE_PACKET.md` required.**
- **§3 risk categories / §11.1 triggers:** the subject matter is *Audit log schema or logic* (**Pod B**), *Customer personal data handling* (**Pod B + Kerem**), and *Security-sensitive* (**Pod B + Kerem**). Under **ADR-009 §3 the strictest applicable trigger governs**, so **Pod B + Kerem review/approval is required before merge.**
- **Net:** Documentation-only PR; §4 gate not triggered; **Pod B + Kerem approval required before merge** per the strictest §3 trigger. Acceptance is also what lets `SECURITY_REVIEW.md` and the wallet/loyalty implementation issues proceed (OQ-AUDIT-001 is one of their named blockers).

---

## 9. Resolution of OQ-AUDIT-001

**OQ-AUDIT-001 is resolved at the design level by this artifact. Kerem accepted the resolution and decisions KD-A/B/C/F/G on 2026-06-15** (KD-A unified store; KD-B scoped IP/device capture; KD-C Option B per-row hash chain; KD-F note mapping confirmed; KD-G accepted). The answer is: **minimum fields are insufficient**; reason/comment (fail-closed, by ADR-006 §8.2 reference), IP/device (required, scoped, KVKK-caveated), before/after as **derived/referenced** values (never balance overwrites), and a closed `workflow_source` taxonomy are **all required**, under the rules in §§5–6. Storage = one append-only canonical store (KD-A); tamper-evidence = DB-grant append-only **plus the adopted per-row hash chain (KD-C, Option B)**; retention is **legal-dependent (OQ-LEGAL-005)** and not invented here.

**What this does NOT do:** authorize Pod C; create issues; design endpoints; write migrations; redefine the reason-code enum or loyalty formula; or set retention periods. **`SECURITY_REVIEW.md` and `DATA_PROCESSING_INVENTORY.md` remain absent**, so the manifest fallback holds: design only, **Needs repo reconciliation**, no Pod C work.

**Next Pod B deliverable:** `/docs/SECURITY_REVIEW.md` **can be drafted next** — this schema is a prerequisite input to it. Drafting it does not require any new Kerem decision; merging it carries its own §11.1 (Pod B + Kerem) gate.

---

## 10. Consequences

**Easier / safer:** one completeness-checkable audit spine across domains; immutability and "no PII overwrite" enforced uniformly; corrections and system-derived events fully attributable to a human; KVKK erasure handled by pseudonymization without breaking integrity or the T-1 rollback guarantee; the KD-C hash chain makes silent deletion/back-dating detectable.

**Harder / constrained:** the audit store becomes a personal-data store (IP, reason notes, linkage) → it **cannot** be built until `DATA_PROCESSING_INVENTORY.md` exists and OQ-LEGAL-005 sets retention; the append-only DB-grant posture plus hash chain constrains operational tooling (no ad-hoc edits/deletes — by design) and adds an anchoring/verification process.

**Risks accepted / residual:** insider collusion (cashier correcting in favour of a controlled customer account) is **mitigated, not eliminated**, by daily masked ADMIN report + immutable audit + customer-visible balance change (ADR-006 §12); the hash chain further raises tamper-evidence. Residual: a DB superuser who recomputes the **entire** chain — mitigated by **periodic external anchoring** of the head hash and Pod D completeness/chain-verification monitoring (§6.10).

**Rollback interaction (ROLLBACK_POLICY):** the audit store is append-only; an application rollback does not delete audit rows. A confirmed personal-data exposure in the audit store is **T-2** (immediate rollback, incident record, 72-hour clock).

---

## 11. Alternatives considered

- **A — Per-domain audit tables instead of one store** (rejected, KD-A): weaker completeness guarantees, duplicated immutability/chain machinery, harder cross-domain investigation.
- **B — Store mutable before/after of a balance** (rejected): violates ADR-006 §3 / §10 and the append-only principle; balances are derived sums, not stored values.
- **C — Capture full device fingerprint / always capture IP** (rejected, KD-B): excess personal-data collection; conflicts with data minimization. Coarse digest + scoped capture chosen (§6.6).
- **D — Duplicate the full ledger entry into the audit store** (rejected): duplicates financial PII and creates divergence risk; the audit event **references** the immutable entry instead.
- **E — Hash-chain from day one** (adopted via KD-C, Option B): Pod B routed this as a Kerem decision rather than silently reopening the 2026-06-10 DB-grant baseline; Kerem accepted Option B on 2026-06-15, so the chain is now a Phase-1 requirement layered on the accepted baseline.

---

## 12. Review routing and status

- **Status:** **Kerem-accepted (design), 2026-06-15** — KD-A/B/C/F/G resolved. Pending merge (gate: Pod B + Kerem). Implementation blocked.
- **Pod B:** author/reviewer. Owns the design; owes `SECURITY_REVIEW.md` next; owes the PROJECT_DECISION_INDEX mirror (Pod B-owned, MD-4) on merge.
- **Kerem:** **accepted the design + KD-A/B/C/F/G on 2026-06-15**; **sole merge authority** for this PR. KD-D (legal/OQ-LEGAL-005) and KD-E (data inventory) remain open and legal/Pod-A-owned.
- **Pod A:** on merge — record the OQ-AUDIT-001 resolution in `OPEN_QUESTIONS.md` (Pod A-owned). The legal items remain legal-advisor-owned.
- **Pod C:** **Not authorized.** No issues created; §6.11 events become Pod C work only via separately Pod B + Kerem approved issues, after `SECURITY_REVIEW.md` + `DATA_PROCESSING_INVENTORY.md` + OQ-LEGAL-005.
- **Pod D:** later — audit-log completeness/gap + hash-chain verification monitoring (§6.10).

*This is a Pod B architecture artifact. It derives from and does not modify ADR-006, ADR-007, or the auth threat model. No item is implemented until those remain Accepted, this schema is merged, the absent security/KVKK files exist, OQ-LEGAL-005 is resolved, and separate Pod B + Kerem approved Pod C issues exist. Repository is the source of truth; re-verify the §Status SHAs before commit. Synthetic data only.*

---

## 13. Document history

| Version | Date | Author | Change |
|---|---|---|---|
| v0.1 | 2026-06-15 | Pod B | Initial draft resolving OQ-AUDIT-001 (design level). Builds on auth threat model §7 (BR-AUDIT-003) and ADR-006 §10 / ADR-007 §9 deferrals. KD-A…KD-G open. |
| v0.2 | 2026-06-15 | Pod B | Kerem accepted the design and decisions KD-A/B/C/F/G (KD-A unified store; KD-B scoped IP/device capture; KD-C **Option B per-row hash chain adopted**; KD-F note mapping confirmed; KD-G accepted). KD-D (retention) and KD-E (data inventory) remain legal/Pod-A-owned. Ready to merge (Pod B + Kerem). |
