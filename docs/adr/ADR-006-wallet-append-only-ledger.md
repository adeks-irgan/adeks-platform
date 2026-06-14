# ADR-006: Wallet Append-Only Ledger

<!--
  STATUS: Accepted — 2026-06-14 (Kerem + Pod B). Replaces the 2026-06-07 stub.
  AUTHOR: Pod B — Architecture, Logic & Risk
  REVIEWER: Kerem (§19 authorship — Security/KVKK-sensitive decision)
  APPROVER: Kerem + Pod B (§11.1 Wallet ledger logic; ADR-009 §3)
  CREATED (stub): 2026-06-07
  FULL DRAFT: 2026-06-14
  ACCEPTED: 2026-06-14
  CANONICAL REPO PATH: /docs/adr/ADR-006-wallet-append-only-ledger.md
  SUPERSEDES: the ADR-006 stub (decision direction only).
  RELATED:
    - PROJECT_METHODOLOGY.md §11.1 (approval gate), §19 (ADR template/authorship), §20.1 (abuse cases), §20.2 (KVKK), §20.3 (security review)
    - PROJECT_DECISION_INDEX.md (ADR-006 → Accepted; K-17/18/19 Locked — K-18 value correction routed to Pod A)
    - KEREM_DECISIONS.md K-17 (price source), K-18 (loyalty formula — see Status note), K-19 (correction policy + KD-FB-CORR-001/002/003)
    - reviews/FB_SETTLEMENT_DEPENDENCIES_REVIEW_v1.0.md (C-1…C-11, N-1, N-2)
    - architecture/FB_ORDER_LIFECYCLE_STATE_MODEL_v1.0.md (S1 FB_SETTLEMENT_DEBIT §8; §10.2; P-3/P-4/P-5)
    - ADR-004 (Prisma), ADR-008 (shared-schema tenancy + UUID), ADR-005 (Selcafe read-only)
    - ROLLBACK_POLICY.md (T-1 wallet integrity = non-discretionary rollback)
    - ADR-007 (loyalty ledger — separate ADR; correction reversal linkage; owns the loyalty formula)
-->

## Status

**Accepted** — 2026-06-14 (Kerem + Pod B). This document replaces the 2026-06-07 ADR-006 stub with the
full wallet append-only ledger design.

**Scope of acceptance.** The wallet ledger **design** is accepted and locked. Acceptance does **not**
authorize Pod C and does **not** discharge the manifest's Wallet-task file requirements. Implementation
remains blocked pending: ADR-007 (loyalty ledger); the audit event schema (OQ-AUDIT-001); retention /
legal basis (OQ-LEGAL-005) and the KVKK legal artifacts; the still-absent `/docs/SECURITY_REVIEW.md`
and `/docs/DATA_PROCESSING_INVENTORY.md`; and separate Pod B + Kerem approved implementation issues.
The KVKK section (§Decision 13) remains **provisional** pending legal advisor. *(This mirrors the
ADR-004 / ADR-008 posture: Accepted design, implementation blocked.)*

### Loyalty-rate decision (resolved by Kerem, 2026-06-14) — and a required record correction

The F&B loyalty accrual is **10% of the settled amount, rounded down to whole points**:

```
points = floor(0.10 × settled_amount_TRY) = floor(settled_kuruş / 1000)
```

Examples: **₺100 → 10 pts, ₺157 → 15 pts, ₺99 → 9 pts, ₺9 → 0 pts.**

> **Record-correction flag (high priority).** This **supersedes** the value currently recorded for **K-18**
> in `KEREM_DECISIONS.md` §18 and `PROJECT_DECISION_INDEX.md` §4, which read `floor(settled_amount_TRY)`
> (1 point per whole TRY). Until those records are corrected, the repo's K-18 value and this ADR diverge.
> The correction (K-18 → 10% round-down) is routed to **Pod A** with Kerem approval (see handoffs).
> ADR-006 (wallet) does **not** lock the loyalty rate — that is **ADR-007** — but its examples and the
> loyalty-linkage section (§Decision 8.3) use the 10% formula per this decision.

### Source freshness baseline

All sources read live from `main` at commit `4a83949af2d79e11f3a34d3fe720c340fe2264b3`
("docs(decisions): K-17/18/19 … (#62)", 2026-06-14). **The repository is the source of truth; `main`
wins on any conflict.** Re-verify these blob SHAs before any commit.

| Source (`/docs/…`) | blob SHA (first 12) |
|---|---|
| `reviews/FB_SETTLEMENT_DEPENDENCIES_REVIEW_v1.0.md` | `fb9b70a6e3a6` |
| `architecture/FB_ORDER_LIFECYCLE_STATE_MODEL_v1.0.md` | `91f21fea6eb1` |
| `adr/ADR-006-wallet-append-only-ledger.md` (stub) | `af09f8b7ba1a` |
| `KEREM_DECISIONS.md` | `5fb928767bb0` |
| `PROJECT_DECISION_INDEX.md` | `03c20010c1d8` |
| `BUSINESS_RULES.md` | `2621d5c945e4` |
| `OPEN_QUESTIONS.md` | `6ed9f7012ec9` |
| `PROJECT_METHODOLOGY.md` | `d3355d0ea5ee` |
| `AGENT_CONTEXT_MANIFEST.md` | `504c3d0de519` |
| `ROLLBACK_POLICY.md` | `3f1eadad8151` |
| `adr/ADR-008-schema-per-tenant-tenancy.md` | `a340391fdcd3` |
| `adr/ADR-004-orm-selection.md` | `d489e8e2fc6d` |
| `adr/ADR-005-selcafe-read-only-adapter.md` | `f51efe65838e` |
| `USER_ROLES_AND_PERMISSIONS.md` | `acc1f08cb423` |
| `adr/ADR-007-loyalty-append-only-ledger.md` (stub) | `6db5cf43e8e0` |

---

## Context

The Adeks wallet is a **prepaid customer balance** used (in Phase 1) to settle delivered F&B orders at
the cashier. The wallet must be a financial system of record: every monetary effect must be reproducible,
auditable, concurrency-safe, and resilient to KVKK erasure requests without losing financial integrity.

The decision direction was locked at stub time (`BR-WALLET-004`: *"Wallet must use append-only ledger
logic; no direct balance overwrite"*; locked principles in `PROJECT_METHODOLOGY.md` and
`PROJECT_DECISION_INDEX.md` §"Locked principles"). This ADR turns that locked *direction* into a full,
implementable *design*: entry taxonomy, money representation, balance derivation, concurrency/idempotency,
insufficient-balance policy, the F&B settlement and post-settlement correction surface, ledger-side audit
fields, abuse cases, and a provisional KVKK pattern.

### Inputs this ADR consumes

| Input | Source | What it fixes |
|---|---|---|
| Append-only / no-overwrite principle (P-3) | `BR-WALLET-004`; state model §2.3 P-3; ROLLBACK_POLICY | Balance is derived, never mutated |
| Settlement event **S1 `FB_SETTLEMENT_DEBIT`** | state model §8 (one per order; CASHIER/ADMIN; precond. sufficient balance) | The single debit entry per settled order |
| Post-settlement correction = compensating append (§10.2, P-4) | state model §10.2 | Corrections are new entries; lifecycle is never un-settled |
| **K-17** price source (submission snapshot) | `KEREM_DECISIONS.md` §17 | Settlement amount is the immutable submission-time price; no runtime lookup |
| **Loyalty formula** `floor(0.10 × settled_TRY)` (10% round-down) | Kerem 2026-06-14 (K-18 record correction routed to Pod A) | The base/precision the loyalty accrual (ADR-007) is computed from |
| **K-19** correction policy + KD-FB-CORR-001/002/003 + C-1…C-11 | `KEREM_DECISIONS.md` §19 | Cashier-executed, same-shift/own-only, minimized customer view, the constraint set |
| Money representation undefined (N-1) | review §4 N-1 | ADR-006 must fix the monetary type/precision |
| Tenancy + ORM + keys | ADR-008, ADR-004 | shared schema + `tenant_id` (UUID NOT NULL FK), UUID PKs, Prisma, `prisma migrate` |
| Selcafe read-only (no runtime dependency for the gate) | ADR-005; K-19 KD-FB-CORR-001; Kerem 2026-06-14 | The financial gate is self-contained |
| Rollback posture | ROLLBACK_POLICY (T-1) | Wallet integrity failure → non-discretionary rollback; compensating tx → Kerem + Pod B |

### What this ADR does **not** own

Loyalty ledger schema/entry taxonomy and the loyalty floor formula (**ADR-007**); wallet **top-up**
method taxonomy (**OQ-WAL-001**) and top-up correction policy (**BRD-WAL-002 / OQ-WAL-002**); the audit
**event storage/tamper/retention** schema (**OQ-AUDIT-001**); retention periods and legal basis
(**OQ-LEGAL-005**, legal advisor); F&B order entity/catalog schema; API contracts; migrations; and code.
These are referenced as constraints/dependencies, not designed or invented here.

---

## Decision

The Adeks wallet is implemented as a **single-table, append-only, signed-integer ledger**. Balance is a
pure derivation (sum of immutable entries). No row is ever updated or deleted to change a balance.

### 1. Entry taxonomy (wallet ledger only)

Entries share one table (`wallet_ledger_entry`) discriminated by `entry_type`. **Loyalty entries are
not in this ledger** — they live in the separate loyalty ledger (ADR-007). Phase 1 F&B-relevant types:

| `entry_type` | Sign | Cardinality | Actor | Notes |
|---|---|---|---|---|
| `FB_SETTLEMENT_DEBIT` | negative (−) | **exactly one per order** | `CASHIER`, `ADMIN` | State-model S1. Reduces balance by the settled amount. |
| `FB_SETTLEMENT_CORRECTION` | signed (±) | **at most one per settlement entry** | `CASHIER` (own, in-window), `ADMIN` | Compensating entry; see §8. References the original `FB_SETTLEMENT_DEBIT`. |

**Top-up entries are referenced, not designed here.** The ledger is extensible; positive top-up credit
entries (and any top-up correction type) will be added when **OQ-WAL-001** (top-up methods) and
**BRD-WAL-002 / OQ-WAL-002** (top-up correction) resolve. This ADR fixes only the *shared ledger
structure* those entries will use; it **does not invent top-up policy**. `[PRODUCT IMPLICATION — POD A
ALIGNMENT NEEDED]` for top-up method/copy when those OQs are taken up.

### 2. Money representation (resolves N-1)

- **Integer minor units (kuruş).** All monetary fields are signed integers of kuruş; **1 TRY = 100
  kuruş**. No floats, no decimals, no currency strings in arithmetic.
- **Storage type:** `BIGINT` (Prisma `BigInt`) for `amount_minor`. `BIGINT` is chosen over 32-bit `Int`
  for Phase 3 SaaS head-room; it is not a performance concern at café scale.
- **Currency:** Phase 1 is single-currency **TRY**; a `currency` field is recorded as a constant `'TRY'`
  for forward-compatibility and is not used in Phase 1 arithmetic.
- **Single-floor discipline.** Wallet arithmetic is *exact* integer arithmetic and never rounds. Any
  *derived* rounding (e.g., the loyalty accrual) rounds **once, at the end** of its computation. The
  loyalty floor itself lives in ADR-007: per Kerem's 2026-06-14 decision, `points = floor(0.10 ×
  settled_amount_TRY) = floor(settled_kuruş / 1000)` (10% round-down). ADR-006 only guarantees the exact
  kuruş base it is computed from.

### 3. Balance derivation (P-3, BR-WALLET-004)

- **Authoritative balance = `SUM(amount_minor)`** over all entries for a given `(tenant_id, wallet_id)`.
  This is the *only* source of truth for balance. There is no authoritative mutable balance column.
- **Sufficient-funds and negative-balance checks** read this derived sum inside the serialized append
  transaction (§4) so the precondition cannot be evaluated against stale state.
- **Optional read optimization (non-authoritative).** Each entry **may** persist a denormalized
  `balance_after_minor`, computed *within the same serialized append transaction* and **never updated
  after write**. It is a convenience for O(1) "current balance" reads and statement rendering; it is
  always reconstructable from the entries and is reconciled against `SUM(amount_minor)`. If it ever
  disagrees with the entry sum, the entry sum wins and a T-1 integrity incident is raised (ROLLBACK_POLICY).
- Aggregation/derivation queries may use Prisma `$queryRaw` for performance; per **ADR-004**, all
  `$queryRaw` on financial tables requires Pod B review.

### 4. Concurrency, idempotency, atomicity (no limbo)

- **Wallet anchor + serialization.** A `wallet` parent row exists per `(tenant_id, customer)`. Any
  balance-affecting append takes a row lock on that wallet (`SELECT … FOR UPDATE`, or equivalent
  serializable boundary) so concurrent settlements/corrections/top-ups on the *same* wallet are
  serialized and balance preconditions are evaluated consistently. Different wallets never contend.
- **Exactly one settlement per order (state model §8).** A partial unique index enforces at most one
  `FB_SETTLEMENT_DEBIT` per order: `UNIQUE (tenant_id, order_id) WHERE entry_type =
  'FB_SETTLEMENT_DEBIT'`. A replayed/duplicate settlement fails the constraint → **fail-closed**. The
  idempotency key is the `order_id`.
- **At most one correction per settlement (C-6).** A partial unique index enforces single-correction:
  `UNIQUE (tenant_id, corrects_entry_id) WHERE entry_type = 'FB_SETTLEMENT_CORRECTION'`. A second
  correction attempt fails-closed and **routes to ADMIN**. The idempotency key is the
  `corrects_entry_id` (the original settlement entry).
- **Atomic settlement (no limbo).** The wallet `FB_SETTLEMENT_DEBIT` and its triggered loyalty
  `FB_ACCRUAL` (ADR-007) are written in **one database transaction** — both commit or neither does. The
  accrual amount is deterministic from the settled kuruş (10% round-down), so it is computed and inserted
  in the same transaction; there is never a debit without its accrual or vice versa.
- **Atomic correction (no divergence, C-1/C-5).** The wallet `FB_SETTLEMENT_CORRECTION` and its linked
  loyalty `FB_ACCRUAL_REVERSAL` (ADR-007) are written in **one transaction**, so the wallet and loyalty
  effects of a correction cannot diverge.

### 5. Settlement event S1 — `FB_SETTLEMENT_DEBIT`

| Aspect | Specification |
|---|---|
| Actor | `CASHIER` or `ADMIN` only. `FB_STAFF` excluded (C-8, P-5, BR-ROLE-002, BR-PAY-001). |
| Preconditions | Order `DELIVERED`; settlement `UNSETTLED`; `derived_balance ≥ settled_amount_minor`. |
| Amount | `amount_minor = −settled_amount_minor`, where `settled_amount_minor` derives from the order's **submission-time price snapshot** (K-17; see §7). |
| Postconditions | One `FB_SETTLEMENT_DEBIT` entry; settlement → `SETTLED`; loyalty L1 triggered atomically. |
| Idempotency | Exactly one per order (partial unique index, §4). Second attempt fails-closed. |
| Insufficient balance | **Fail-closed** (see §6). No partial debit; no negative balance. |

### 6. Insufficient / negative-balance policy (C-7) — **Decided: Option A (no negatives in Phase 1)**

- **At settlement:** if `derived_balance < settled_amount_minor`, the settlement is **rejected
  (fail-closed)**. No partial debit is written; the wallet is prepaid and cannot go negative via
  settlement. The cashier resolves out-of-band (e.g., wallet top-up, then re-attempt; or another payment
  method). There is **no Phase 1 path** to settle against insufficient funds.
- **On correction:** an *upward* correction (additional debit) that would drive the derived balance
  negative **fails-closed at the cashier and routes to ADMIN** (C-7).
- **Decided (Kerem, 2026-06-14 — Option A):** **no negative balances in Phase 1.** ADMIN resolves an
  under-charge-on-a-spent-down-wallet out-of-band; there is **no** Phase 1 mechanism to *record* a
  negative-balance correction. (The customer balance is never driven negative by settlement or correction.)

### 7. Price snapshot at settlement (K-17 / N-2)

- Settlement uses the **price captured at order submission** (immutable snapshot); catalog edits after
  submission do **not** affect the settlement amount (K-17, Locked).
- The F&B **order** entity stores `unit_price_at_submission_minor` per line item (an order-schema concern;
  recorded here as the binding input). The settlement amount is the snapshot-derived order total in kuruş.
- Consequence: settlement is **reproducible** and independent of later catalog edits; there is **no
  runtime price lookup at settlement**. The submission price is never edited; any post-settlement change
  goes through the correction entry (§8), not by altering the snapshot.

### 8. Correction / reversal design — **single signed compensating entry** (chosen)

A correction is **one** `FB_SETTLEMENT_CORRECTION` entry carrying the signed delta needed to bring the
net settlement to the corrected amount, referencing the original `FB_SETTLEMENT_DEBIT`. The original
entry is **never** edited or deleted (C-1; P-3; BR-WALLET-004; BR-AUDIT-002).

**Sign convention.** Positive `amount_minor` increases the wallet balance (credit back to the customer);
negative decreases it (additional debit). To make the net settlement equal the corrected amount:

```
FB_SETTLEMENT_CORRECTION.amount_minor = original_settled_minor − corrected_settled_minor
```

| Case | Delta | Effect |
|---|---|---|
| Over-charge (corrected < original) | **positive** | Credit back to customer |
| Under-charge (corrected > original) | **negative** | Additional debit (subject to §6 — fails closed / ADMIN if it would go negative) |
| Full unwind (corrected = ₺0) | **+original** | Order's settlement fully offset; net wallet effect = 0 |

Full and partial corrections are expressed the **same way**; no separate "void" type is needed (full
unwind is the special case `corrected = 0`). The lifecycle is **not** touched: the order stays
`DELIVERED` + `SETTLED` (state model §10.2, P-4); the correction lives entirely in the ledger domain.

**Why single signed delta (not reversal + re-debit):** see Alternatives Considered.

#### 8.1 Correction eligibility window (K-19 / KD-FB-CORR-001) — **self-contained, daily-report-bound, no Selcafe runtime dependency**

A `CASHIER` may self-correct **only** when **all** hold; otherwise the path is **ADMIN-only**:

1. **Own settlement (C-2):** `original.actor_id == current_actor_id`. Cross-cashier correction is ADMIN-only.
2. **In-window (C-3):** the original settlement's `operating_day` equals the current operating day **and**
   the daily ADMIN correction report for that `operating_day` has **not** been closed/finalized.
3. **Single correction (C-6):** no prior `FB_SETTLEMENT_CORRECTION` references this settlement.

`operating_day` is a **self-contained** café business-day value recorded on each entry at creation,
aligned to the **daily correction-report cycle**; the daily-report close is the hard boundary.

**Decided (Kerem, 2026-06-14).** The gate is **not** bound to Selcafe. The **daily ADMIN correction
report is the control**, and that is sufficient. **No runtime Selcafe call** gates the financial decision
(ADR-005). Any Selcafe-side adjustment in Phase 1 is performed **manually by ADMIN/operator outside
Adeks** (Adeks remains read-only to Selcafe); it is **not** an Adeks runtime write and is **not** part of
this gate. No separate cutover configuration is required for Phase 1 — the `operating_day` boundary
follows the daily-report run.

#### 8.2 Mandatory structured reason (C-4, fail-closed) — reason-code enum (canonical home per K-19)

Every correction records a structured reason; **absence fails the correction closed**. This ADR is the
**canonical home** for the enum (K-19 "Reason-Code Home"):

| Code | Meaning |
|---|---|
| `OVER_CHARGE` | Customer was charged more than the correct amount |
| `UNDER_CHARGE` | Customer was charged less than the correct amount |
| `ITEM_RETURNED` | Item returned after settlement |
| `OPERATIONAL_OTHER` | Other operational reason — **free-text note required** |

Recorded with the reason: `actor_id` (UUID), `corrects_entry_id`, `corrected_amount` (a **derived**
value, never an overwrite), `reason_code`, optional `reason_note`, `timestamp`, `workflow_source`.

#### 8.3 Loyalty reversal linkage (C-5) — designed in ADR-007, mirrored here

The loyalty `FB_ACCRUAL_REVERSAL` is **recomputed from the corrected settled amount** (single floor,
10% round-down: `corrected_points = floor(0.10 × corrected_TRY) = floor(corrected_kuruş / 1000)`), posted
as the delta `corrected_points − original_points`, **structurally linked** to the wallet
`FB_SETTLEMENT_CORRECTION` and written in the same transaction (§4). It is never a free-standing point
edit. Detailed loyalty entry taxonomy and recomputation are **ADR-007**.

### 9. Roles & authority (USER_ROLES; C-2, C-8)

| Action | `CUSTOMER` | `CASHIER` | `FB_STAFF` | `ADMIN` |
|---|---|---|---|---|
| `FB_SETTLEMENT_DEBIT` (S1) | ❌ | ✅ | ❌ | ✅ |
| `FB_SETTLEMENT_CORRECTION` (own, in-window) | ❌ | ✅ | ❌ | ✅ (any) |
| `FB_SETTLEMENT_CORRECTION` (cross-cashier / out-of-window) | ❌ | ❌ | ❌ | ✅ |

Individual credentials only — every write is attributable to a specific human `actor_id` (USER_ROLES:
shared accounts prohibited). `FB_STAFF` never touches payment/wallet/loyalty under any reading (P-5).

### 10. Ledger-side audit fields (C-10) — storage/retention deferred to OQ-AUDIT-001

Each settlement and each correction emits an **immutable** audit record (BR-AUDIT-001/002; §20.3 wallet
ledger writes + audit log logic → Pod B review). **Ledger-side** fields this ADR specifies:

`actor_id`, `entry_id`, `entry_type`, `corrects_entry_id` (corrections), `order_id`, `customer_id`,
`amount_minor` (signed), `derived corrected_amount` (never an overwrite), `reason_code`/`reason_note`
(corrections), `operating_day`, `timestamp`, `workflow_source`.

Before/after values are expressed as **derived** values only — never as balance overwrites. The audit
**event schema** (storage, tamper-evidence, retention, workflow-source taxonomy) is **OQ-AUDIT-001 —
open** and is **not** designed here; it must build on the Accepted auth threat-model baseline.

### 11. ADMIN reporting (C-9, compensating control)

Every cashier correction surfaces in a **daily ADMIN correction report** (parallel to the daily top-up
report, BR-WALLET-005). The report shows a **masked last-4** customer identifier only (BR-WALLET-006),
the reason code, the value delta, and the actor — never a full phone number. Retention is **pending legal
advisor** (OQ-LEGAL-005). The daily-report **close** is the boundary that ends the cashier self-correction
window (§8.1) and is the agreed control for the correction surface (Kerem, 2026-06-14).

### 12. Abuse cases (§20.1) — required coverage

| Abuse case | Primary mitigations (this ADR) |
|---|---|
| **Skim via correction** (cashier corrects own settlement to move value) | Own-only (C-2) + mandatory reason (C-4) + single-correction (C-6) + in-window-only (C-3) + immutable audit (C-10) + daily ADMIN report w/ masked id + reason (C-9) + corrections appear in the **customer's** wallet history (a credit lands in the customer's balance, not the cashier's — detectable). Residual collusion risk (controlled customer account) is mitigated, not eliminated, by the daily report + audit. |
| **Correction churn** (repeated corrections to obscure) | Structurally prevented: single-correction discipline (C-6); any further change → ADMIN. |
| **Correct after window** | Fail-closed: window check (C-3) rejects; ADMIN-only thereafter. |
| **Correct another cashier's settlement** | Fail-closed: actor-match (C-2); cross-cashier is ADMIN-only. |
| **Duplicate / replayed entry** (double settle or double correct) | Idempotency: partial unique indexes (one debit per order; one correction per settlement); replays fail-closed (§4). |
| **Staff unauthorized adjustment** (FB_STAFF / others writing wallet) | Authorization: only CASHIER (own, in-window) + ADMIN may write; FB_STAFF fully excluded (C-8, P-5); every write attributed to `actor_id`; enforced below business logic. |

Carried from §20.1 generically: **admin self-privilege escalation** is out of wallet scope (auth/RBAC —
ADR-015, §11.1 admin-privilege gate); **missing audit for a sensitive action** is itself a detectable
control failure — audit on settlement/correction is mandatory and immutable.

### 13. KVKK — **PROVISIONAL** (pseudonymize-without-delete; retention/legal basis PENDING)

- **Append-only vs. erasure tension → pseudonymization.** Correction `reason_note` free-text and the
  `customer_id` linkage are personal data (review FB-010). On an Art. 11 erasure request, the resolution
  is **pseudonymization, not deletion**: replace the `customer_id` linkage with a pseudonymous token and
  tombstone PII in `reason_note`, **without** deleting or mutating the immutable ledger/audit rows. The
  monetary entries (now de-linked) remain for financial integrity and audit. No direct writes to ledger
  rows; this preserves P-3 and the T-1 rollback guarantee.
- **Customer-visible correction history (K-19 / KD-FB-CORR-003) — confirmed (Kerem, 2026-06-14):**
  minimized — **neutral description + value delta only**; **no** internal reason codes, free-text notes,
  or cashier identity exposed to the customer. The customer-facing copy itself is `[PRODUCT IMPLICATION —
  POD A ALIGNMENT NEEDED]`.
- **PENDING legal advisor / open dependencies:** retention periods (**OQ-LEGAL-005**), legal basis
  (`KVKK_LEGAL_BASIS.md`), and the mandatory data-inventory linkage every personal-data feature requires
  (§20.2, `DATA_PROCESSING_INVENTORY.md`) are **not resolved here**; `DATA_PROCESSING_INVENTORY.md`,
  `DATA_RETENTION_POLICY.md`, and `KVKK_LEGAL_BASIS.md` are absent / in legal review. A confirmed T-2
  (personal-data exposure) starts the **72-hour** KVKK breach clock (ROLLBACK_POLICY).

### 14. Tenancy, keys, ORM (ADR-008, ADR-004)

- Every ledger/anchor table carries `tenant_id UUID NOT NULL` FK → `tenants.id`; all PKs are **UUID**.
- The mandatory **Prisma Client Extension** injects `tenant_id` filtering on every query (ADR-008/004);
  `$queryRaw` balance aggregation on these financial tables requires Pod B review (ADR-004).
- All schema changes go through `prisma migrate` (reviewed; Pod B + Kerem per ADR-009 §3). Phase 1 is
  single-tenant with a static `TenantContext`.

### Synthetic worked example (Customer A — synthetic data only)

Customer A (`+90 555 000 00 01`) tops up and orders. Delivered order settles at **₺157**:

- `FB_SETTLEMENT_DEBIT  amount_minor = −15700`  (one entry; order `SETTLED`)
- linked `FB_ACCRUAL +15` in the loyalty ledger (10% round-down: `floor(15700 / 1000)`) — ADR-007

One item is returned within the correction window; cashier corrects the settled amount to **₺100**:

- `FB_SETTLEMENT_CORRECTION amount_minor = 15700 − 10000 = +5700`  (credit back), `reason_code =
  ITEM_RETURNED`, references the debit entry
- linked `FB_ACCRUAL_REVERSAL = floor(10000 / 1000) − 15 = 10 − 15 = −5` — ADR-007

Derived wallet effect for the order = `−15700 + 5700 = −10000 = −₺100`. Net loyalty = `15 − 5 = 10`.
**No row overwritten.** Full unwind (corrected ₺0) → `FB_SETTLEMENT_CORRECTION +15700`, loyalty
`−15`; order retains no value and no points.

---

## Consequences

### Easier / safer

- Financial integrity by construction: balance is a pure sum of immutable entries; no lost updates, no
  in-place mutation, full audit trail. Preserves the ROLLBACK_POLICY T-1 guarantee (nothing to "un-write").
- Idempotent, fail-closed settlement and single-correction discipline make replay and churn structurally hard.
- KVKK erasure is satisfiable (pseudonymize-without-delete) without breaking append-only or audit.
- Self-contained correction gate removes any runtime coupling to Selcafe for a financial decision.

### Harder / constrained

- Balance is **derived**, so hot read paths need the optional `balance_after_minor` cache or a reviewed
  `$queryRaw` aggregation; the cache adds a reconciliation obligation (entries always win).
- Per-wallet serialization (anchor-row lock) is required for correct balance preconditions; this bounds
  concurrent writes *per wallet* (acceptable at café scale; revisit for Phase 3 hotspots).
- No negative balances in Phase 1 (Option A) means under-charge corrections on a spent-down wallet must
  route to ADMIN / out-of-band.
- Storage grows monotonically (append-only). Acceptable; archival/retention is an OQ-LEGAL-005 concern.

### Risks accepted / residual

- **Insider skim via collusion** (cashier + controlled customer account) is mitigated (own-only,
  single-correction, mandatory reason, immutable audit, daily masked ADMIN report, customer-visible
  credit) but not eliminated; the daily report + audit are the compensating detective controls.
- **Cache/sum divergence** is treated as a **T-1** integrity incident (non-discretionary rollback).
- **Cross-tenant leakage** is governed by ADR-008's binding Prisma Client Extension requirement (out of
  scope here; inherited).

### Rollback interaction (ROLLBACK_POLICY)

Incorrect wallet balances/events are a **T-1 non-discretionary** trigger. Corrections of incorrect ledger
state are **compensating transactions** (never row removal) and are **wallet-ledger-class PRs requiring
Kerem + Pod B** (§11.1, ADR-009 §3).

---

## Alternatives Considered

### A. Correction as **reversal + re-debit** (rejected)

Post a full `FB_SETTLEMENT_REVERSAL` (= +original) then a fresh debit for the corrected amount.
**Rejected** because: (1) a re-debit re-introduces a settlement-debit-type entry, conflicting with the
state-model invariant of **exactly one `FB_SETTLEMENT_DEBIT` per order** (§8) and its unique index;
(2) two entries per correction complicate the single-correction/idempotency check (C-6) and the
loyalty-reversal linkage (C-5); (3) it is harder to audit "the one correction that changed this
settlement." The single signed compensating entry expresses the same economics with one immutable entry,
a clean 1:1 correction↔entry mapping, and a simpler idempotency key (`corrects_entry_id`).

### B. **Mutable balance** column with a side audit log (rejected)

A `wallets.balance` updated in place, with a separate audit trail. **Rejected**: violates the locked
append-only principle (`BR-WALLET-004`, P-3), reintroduces lost-update/race risk, breaks the T-1 rollback
guarantee (a mutated balance has no immutable source to reconstruct from), and makes KVKK erasure and
financial reconciliation fragile.

### C. **Decimal / float** money type (rejected)

Store amounts as `DECIMAL`/`NUMERIC` or floating point. **Rejected**: floats are non-exact for money;
`DECIMAL` invites implicit rounding and mixed-precision bugs across the settlement/correction/loyalty
chain. Integer kuruş with a single explicit floor (10% round-down, in ADR-007) is exact and audit-clean (N-1).

### D. **Per-order ledger isolation** (one ledger per order) (rejected)

Keeping per-order mini-ledgers. **Rejected**: balance is a per-*customer* property; per-order isolation
fragments balance derivation, complicates the negative-balance guard across orders, and does not fit
top-up/redemption entries that are not order-scoped.

### E. **Separate physical tables** for settlement vs. correction (deferred, not chosen for Phase 1)

A discriminated single table is chosen for simpler balance derivation and a single append path. Splitting
by physical table is a possible Phase 3 optimization; not warranted in Phase 1.

---

## Approval

- **Author:** Pod B — Architecture, Logic & Risk
- **Reviewer:** Kerem (§19 authorship — Security/KVKK-sensitive decision). `[PRODUCT IMPLICATION — POD A
  ALIGNMENT NEEDED]` on customer-visible correction-history copy and any future top-up entry copy.
- **Approver:** **Kerem + Pod B** (§11.1 *Wallet ledger logic*; ADR-009 §3)
- **Date proposed:** 2026-06-14
- **Date accepted:** **2026-06-14 (Kerem + Pod B)**

### Decisions recorded (Kerem, 2026-06-14)

1. **Accepted** as the wallet ledger design (implementation still blocked — see Status).
2. **Loyalty formula = 10% round-down** `floor(0.10 × settled_TRY) = floor(settled_kuruş / 1000)`
   — **supersedes the recorded K-18 value** (`floor(settled_amount_TRY)`); correction routed to Pod A.
3. **Negative-balance policy = Option A** — no negative balances in Phase 1 (§6).
4. **Correction gate = self-contained, daily-report-bound, not Selcafe-bound** (§8.1); manual Selcafe
   reconciliation is an out-of-system ADMIN action.
5. **Customer-visible correction history = minimized** (neutral description + value delta only) (§13).

### Remaining dependencies (block Pod C / acceptance-as-implementable)

ADR-007 (loyalty ledger); **OQ-AUDIT-001** (audit event schema); **OQ-LEGAL-005** +
`DATA_PROCESSING_INVENTORY.md` / `DATA_RETENTION_POLICY.md` / `KVKK_LEGAL_BASIS.md` (KVKK, legal
advisor); `SECURITY_REVIEW.md` (absent — manifest reconciliation); **OQ-WAL-001 / BRD-WAL-002 /
OQ-WAL-002** (top-up methods + correction, referenced not designed); and the **K-18 record correction**
(Pod A). Pod C remains blocked pending these plus separate Pod B + Kerem approved implementation issues.

*Produced by Pod B — Architecture, Logic & Risk. Accepted design; implementation blocked. The repository
is the source of truth; re-verify `main` blob SHAs before commit. This ADR does not design
schema/migrations/code, does not resolve KVKK/audit-storage questions, and does not authorize Pod C.*
