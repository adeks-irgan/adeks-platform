# ADR-007: Loyalty Append-Only Ledger

<!--
  STATUS: Accepted — 2026-06-14 (Kerem approval; PR #65)
  AUTHOR: Pod B — Architecture, Logic & Risk
  REVIEWER: Kerem (§19 authorship — Security/KVKK-sensitive decision)
  APPROVER: Kerem + Pod B (§11.1 Loyalty ledger logic; ADR-009 §3)  [stub said "Approver: Pod B" — corrected per review N-3]
  CREATED (stub): 2026-06-07
  FULL DRAFT: 2026-06-14
  ACCEPTED: 2026-06-14
  CANONICAL REPO PATH: /docs/adr/ADR-007-loyalty-append-only-ledger.md
  SUPERSEDES: the ADR-007 stub (decision direction only).
  RELATED:
    - PROJECT_METHODOLOGY.md §11.1 (approval gate), §19 (ADR template/authorship), §20.1 (abuse cases), §20.2 (KVKK), §20.3 (security review)
    - PROJECT_DECISION_INDEX.md (ADR-007 → Backlog→Proposed→Accepted; K-17/18/19 Locked; K-18 formula = 10% round-down, corrected 2026-06-14)
    - KEREM_DECISIONS.md K-18 (loyalty formula), K-17 (price source), K-19 (correction policy + KD-FB-CORR-001/002/003)
    - reviews/FB_SETTLEMENT_DEPENDENCIES_REVIEW_v1.0.md (§7 ADR-007 implications; C-5 reversal linkage; recompute-from-corrected; single-floor; N-1; N-3)
    - architecture/FB_ORDER_LIFECYCLE_STATE_MODEL_v1.0.md (L1 FB_ACCRUAL §9; derived-from-S1; exclusions; P-3/P-5)
    - adr/ADR-006-wallet-append-only-ledger.md (wallet ledger — bootstrap source; correction reversal linkage §8.3; atomic transaction §4)
    - ADR-004 (Prisma), ADR-008 (shared-schema tenancy + UUID), ADR-005 (Selcafe read-only)
    - ROLLBACK_POLICY.md (T-1 wallet/loyalty integrity = non-discretionary rollback)
    - USER_ROLES_AND_PERMISSIONS.md (CASHIER/ADMIN/FB_STAFF; FB_STAFF never touches loyalty)
-->

## Status

**Accepted** — 2026-06-14 (Kerem approval; PR #65). Full loyalty append-only ledger design is locked.
Implementation remains blocked — see remaining dependencies below.

**Scope of this ADR.** ADR-007 designs the **loyalty ledger**: entry taxonomy, point precision and
the loyalty formula, balance derivation, concurrency/idempotency, the accrual-on-settlement event, the
post-correction recompute/reversal mechanics, ledger-side audit fields, abuse cases, and a provisional
KVKK pattern. It is the **separate** loyalty ledger (separate table, separate entry types) and is the
**canonical home of the F&B loyalty accrual formula**. Acceptance does **not** authorize Pod C and does
**not** discharge the manifest's Loyalty-task file requirements. Implementation remains blocked pending:
the audit event schema (OQ-AUDIT-001); retention / legal basis (OQ-LEGAL-005) and the KVKK legal
artifacts; the still-absent `/docs/SECURITY_REVIEW.md` and `/docs/DATA_PROCESSING_INVENTORY.md`; and
separate Pod B + Kerem approved implementation issues. The KVKK section (§Decision 11) remains
**provisional** pending legal advisor. *(This mirrors the ADR-006 posture: design accepted,
implementation blocked.)*

### Loyalty formula (authoritative here) — K-18, 10% round-down

ADR-006 explicitly does **not** lock the loyalty rate; **ADR-007 is its canonical home.** The Locked value
(K-18, Kerem-approved 2026-06-14, *formula corrected 2026-06-14*) is **10% of the settled F&B amount,
rounded down to whole points**:

```
points = floor(0.10 × settled_amount_TRY) = floor(settled_kuruş / 1000)
```

Examples: **₺100 → 10 pts, ₺157 → 15 pts, ₺99 → 9 pts, ₺9 → 0 pts.** This is consistent with ADR-006's
worked examples and §8.3 loyalty linkage, with `KEREM_DECISIONS.md §18`, `PROJECT_DECISION_INDEX.md §4`
(K-18 row), and `BUSINESS_RULES.md` BR-LOYALTY-FB-001 — all of which record the same 10% round-down
formula. No source requires correction.

### Source freshness baseline

All sources read live from `main` at commit `7e6e6e9cd452199f780f6babe315afd187e361aa`. Local blob SHAs
were cross-checked against the GitHub tree (the four ADR SHAs matched exactly, validating content
integrity). **The repository is the source of truth; `main` wins on any conflict. Re-verify these blob
SHAs before any commit** (the three sources that changed since ADR-006's baseline — `KEREM_DECISIONS.md`,
`BUSINESS_RULES.md`, `PROJECT_DECISION_INDEX.md` — are exactly those that received the K-18 → 10%
correction).

| Source (`/docs/…`) | blob SHA (first 12) |
|---|---|
| `adr/ADR-006-wallet-append-only-ledger.md` (full, Accepted) | `4a9a33993880` |
| `adr/ADR-007-loyalty-append-only-ledger.md` (stub being replaced) | `6db5cf43e8e0` |
| `reviews/FB_SETTLEMENT_DEPENDENCIES_REVIEW_v1.0.md` | `fb9b70a6e3a6` |
| `architecture/FB_ORDER_LIFECYCLE_STATE_MODEL_v1.0.md` | `91f21fea6eb1` |
| `KEREM_DECISIONS.md` | `5999d9a384d0` |
| `PROJECT_DECISION_INDEX.md` | `66dafa859e83` |
| `BUSINESS_RULES.md` | `c8c00ad447e4` |
| `OPEN_QUESTIONS.md` | `6ed9f7012ec9` |
| `PROJECT_METHODOLOGY.md` | `d3355d0ea5ee` |
| `AGENT_CONTEXT_MANIFEST.md` | `504c3d0de519` |
| `ROLLBACK_POLICY.md` | `3f1eadad8151` |
| `adr/ADR-008-schema-per-tenant-tenancy.md` (shared-schema + `tenant_id`) | `a340391fdcd3` |
| `adr/ADR-004-orm-selection.md` (Prisma) | `d489e8e2fc6d` |
| `USER_ROLES_AND_PERMISSIONS.md` | `acc1f08cb423` |

---

## Context

The Adeks loyalty program awards **points** to customers for eligible activity. In Phase 1 the **only**
earning event is **F&B accrual on settlement**: when the cashier records the wallet payment for a
delivered F&B order (state-model event **S1**), the system accrues loyalty points (state-model event
**L1**). Points are a **monetary-like value** — they must be reproducible, auditable, concurrency-safe,
and resilient to KVKK erasure requests without losing integrity — and so receive the same append-only
treatment as the wallet (ADR-006), in a **separate ledger** with **separate entry types**.

The decision direction was locked at stub time (`BR-LOYALTY-005`: *"Loyalty must use append-only ledger
logic; no direct balance overwrite"*; locked principles in `PROJECT_METHODOLOGY.md` and
`PROJECT_DECISION_INDEX.md`). This ADR turns that locked *direction* into a full, implementable *design*,
and — because ADR-006 deliberately deferred it — fixes the loyalty **formula and precision** here.

### Inputs this ADR consumes

| Input | Source | What it fixes |
|---|---|---|
| Append-only / no-overwrite principle (P-3) | `BR-LOYALTY-005`; state model §2.3 P-3; ROLLBACK_POLICY | Loyalty balance is derived, never mutated |
| **Loyalty formula** `floor(0.10 × settled_TRY)` (10% round-down) — **Locked K-18** | `KEREM_DECISIONS.md §18`; `PROJECT_DECISION_INDEX.md §4`; `BUSINESS_RULES.md` BR-LOYALTY-FB-001 | The accrual amount and its precision |
| Accrual event **L1 `FB_ACCRUAL`** (derived from S1; one per settled order; CANCELLED/REJECTED never accrue) | state model §9 (L1); §3 transition table; BR-FB-011 | The single accrual entry per settled order, and its exclusions |
| Settlement event **S1 `FB_SETTLEMENT_DEBIT`** + base amount (gross settled, kuruş; K-17 snapshot) | ADR-006 §5/§2/§7; state model §8; K-17 | The exact kuruş base the 10% floor is computed from |
| Post-settlement correction = compensating append; **recompute loyalty from corrected amount** (C-5; Q3) | review §7/§8/§10 (C-1, C-5); ADR-006 §8.3 | The reversal entry and the recompute-not-proportion rule |
| Atomic settlement and atomic correction (one DB transaction, no divergence) | ADR-006 §4 | Wallet and loyalty effects never diverge |
| Roles: cashier/admin settle; **FB_STAFF never touches loyalty**; accrual is system-derived | state model §4/§9.1 (L1 = SYSTEM); USER_ROLES; BR-ROLE-002; KD-E; P-5 | Authority and attribution of loyalty entries |
| Money/point representation: integer minor units; **single floor at the end** (N-1) | review §7 (N-1); ADR-006 §2 | Integer points; round once; no double-rounding |
| Tenancy + ORM + keys | ADR-008 (shared schema + `tenant_id` UUID NOT NULL FK), ADR-004 (Prisma; `$queryRaw` on financial tables → Pod B review) | Schema/ORM constraints |
| Rollback posture | ROLLBACK_POLICY (T-1) | Loyalty integrity failure → non-discretionary rollback; compensating tx → Kerem + Pod B |

### What this ADR does **not** own

The **non-F&B** loyalty earning eligibility, formula, and exclusions (**OQ-LOY-001 / OQ-LOY-002 /
OQ-LOY-003** for purchase types beyond F&B; **BRD-LOY-001/002/003**); loyalty **redemption** rules,
limits, targets, and cashier override (**OQ-LOY-004**, **BRD-LOY-004…006/008**); loyalty **expiry**
(**OQ-LOY-005**, **BRD-LOY-007**); the audit **event storage/tamper/retention** schema
(**OQ-AUDIT-001**); retention periods and legal basis (**OQ-LEGAL-005**, legal advisor); the F&B order
entity/catalog schema; the wallet ledger (**ADR-006**); API contracts; migrations; and code. These are
referenced as constraints/dependencies, **not** designed or invented here. In particular, **redemption
and expiry entry types are out of scope** and are only referenced, not defined.

---

## Decision

The Adeks loyalty program is implemented as a **single-table, append-only, signed-integer points ledger**,
**separate** from the wallet ledger (ADR-006). Loyalty balance is a pure derivation (sum of immutable
entries). No row is ever updated or deleted to change a balance.

### 1. Entry taxonomy (loyalty ledger only)

Entries share one table (`loyalty_ledger_entry`) discriminated by `entry_type`. **Wallet entries are not
in this ledger** — they live in the separate wallet ledger (ADR-006). Phase 1 F&B-relevant types:

| `entry_type` | Sign | Cardinality | Actor | Notes |
|---|---|---|---|---|
| `FB_ACCRUAL` | non-negative (+) | **exactly one per settled order** | `SYSTEM` (derived from S1, attributed to the settlement actor) | State-model L1. Accrues `floor(0.10 × settled_TRY)` points. References the order and the wallet `FB_SETTLEMENT_DEBIT`. |
| `FB_ACCRUAL_REVERSAL` | signed (±) | **at most one per accrual entry** | `SYSTEM` (derived from the wallet `FB_SETTLEMENT_CORRECTION`) | Compensating adjustment; see §6. Carries the signed delta `corrected_points − original_points`. References the original `FB_ACCRUAL` **and** the wallet `FB_SETTLEMENT_CORRECTION`. |

**Redemption and expiry entries are referenced, not designed here.** Redemption entry types and rules are
**OQ-LOY-004 (open)**; expiry entry types and policy are **OQ-LOY-005 (open)**; non-F&B earning entry
types depend on **OQ-LOY-001/002/003 (open for non-F&B)**. This ADR fixes only the *shared ledger
structure* those future entries will use; it **does not invent redemption, expiry, or non-F&B earning
policy**. `[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]` for those when the OQs are taken up.

### 2. Point precision and the loyalty formula (resolves the loyalty side of N-1; Locked K-18)

- **Integer points.** Points are whole integers; there are **no fractional points**. `FB_ACCRUAL` is
  **non-negative**; `FB_ACCRUAL_REVERSAL` carries a **signed** integer delta.
- **Loyalty formula (Locked K-18 — authoritative here):**
  `points = floor(0.10 × settled_amount_TRY) = floor(settled_kuruş / 1000)` — 10% of the settled F&B
  amount, rounded down. Examples: ₺100→10, ₺157→15, ₺99→9, ₺9→0.
- **Single floor at the end (N-1).** The computation rounds **exactly once**, at the end. The **base** is
  the **exact settled amount in kuruş** taken from the wallet `FB_SETTLEMENT_DEBIT` (ADR-006 §2/§5/§7) —
  never a pre-rounded amount. The base is the **gross settled amount** (no F&B-level discounts exist in
  Phase 1; discounts/campaigns are excluded from earning per K-FB-LOY-001), so gross settled = the base.
- **Storage type:** `points_delta` is a signed integer. `INTEGER` (Prisma `Int`) is sufficient at café and
  Phase 3 SaaS scale (points are bounded and an order of magnitude smaller than kuruş). `BIGINT` is an
  available option for storage-type parity with the wallet (ADR-006 §2) if Pod C/Kerem prefer uniformity —
  a reviewable Pod C implementation choice with no product implication.

### 3. Balance derivation (P-3, BR-LOYALTY-005)

- **Authoritative loyalty balance = `SUM(points_delta)`** over all entries for a given
  `(tenant_id, loyalty_account_id)`. This is the *only* source of truth for the points balance. There is
  no authoritative mutable balance column.
- **Non-negative by construction (Phase 1).** Because every `FB_ACCRUAL` is `floor(...) ≥ 0`, and every
  `FB_ACCRUAL_REVERSAL` recomputes to a non-negative corrected total (the per-order net is
  `corrected_points ≥ 0`, never below zero), the derived balance is **≥ 0** in Phase 1 (there is no
  redemption — OQ-LOY-004 — that could draw it down). Redemption, when designed, must preserve a
  non-negative-balance guard analogous to the wallet's (ADR-006 §6).
- **Optional read optimization (non-authoritative).** Each entry **may** persist a denormalized
  `balance_after_points`, computed *within the same serialized append transaction* and **never updated
  after write**. It is a convenience for O(1) "current points" reads and statement rendering; it is always
  reconstructable from the entries and is reconciled against `SUM(points_delta)`. If it ever disagrees
  with the entry sum, the entry sum wins and a T-1 integrity incident is raised (ROLLBACK_POLICY).
- Aggregation/derivation queries may use Prisma `$queryRaw` for performance; per **ADR-004**, all
  `$queryRaw` on financial/loyalty tables requires Pod B review.

### 4. Concurrency, idempotency, atomicity (no limbo, no divergence)

- **Loyalty anchor + serialization.** A `loyalty_account` parent row exists per `(tenant_id, customer)`.
  Any points-affecting append takes a row lock on that account (`SELECT … FOR UPDATE`, or equivalent
  serializable boundary) so concurrent accruals/reversals on the *same* account are serialized and the
  derived balance is consistent. Different accounts never contend.
- **Exactly one accrual per settled order (state model §9.1).** A partial unique index enforces at most
  one `FB_ACCRUAL` per order: `UNIQUE (tenant_id, order_id) WHERE entry_type = 'FB_ACCRUAL'`. A
  replayed/duplicate accrual fails the constraint → **fail-closed**. The idempotency key is the
  `order_id`. (Because S1 is itself one-per-order in ADR-006 §4, this is consistent with the
  one-accrual-per-settlement invariant.)
- **At most one reversal per accrual (mirrors wallet C-6).** A partial unique index enforces
  single-reversal: `UNIQUE (tenant_id, reverses_entry_id) WHERE entry_type = 'FB_ACCRUAL_REVERSAL'`. A
  second reversal attempt fails-closed and **routes to ADMIN**. The idempotency key is the
  `reverses_entry_id` (the original `FB_ACCRUAL`). This is tied to the wallet single-correction discipline:
  there is at most one `FB_SETTLEMENT_CORRECTION` per settlement (ADR-006 §4 C-6), and each correction
  produces exactly one linked reversal.
- **Atomic accrual (no limbo).** The `FB_ACCRUAL` is written in the **same database transaction** as the
  wallet `FB_SETTLEMENT_DEBIT` (ADR-006 §4) — both commit or neither does. The accrual amount is
  deterministic from the settled kuruş (10% round-down), so it is computed and inserted in that same
  transaction; there is never a debit without its accrual or vice versa.
- **Atomic reversal (no divergence, C-1/C-5).** The `FB_ACCRUAL_REVERSAL` is written in the **same
  transaction** as the wallet `FB_SETTLEMENT_CORRECTION` (ADR-006 §4) — both commit or neither — so the
  wallet and loyalty effects of a correction cannot diverge. A loyalty reversal exists **if and only if**
  its wallet correction commits.

### 5. Accrual event L1 — `FB_ACCRUAL` (mirrors state model §9.1)

| Aspect | Specification |
|---|---|
| Trigger | **Derived from S1.** Accrual fires when, and only when, the cashier-recorded wallet payment/settlement (S1) commits (BR-FB-011: trigger = CASHIER records wallet payment/settlement). |
| Not on Delivered alone | `DELIVERED` does **not** accrue. Accrual is bound to settlement (S1), preserving the Delivered≠Paid separation (FB-009). |
| Preconditions | S1 committed (order `SETTLED`); order not cancelled/rejected (**structurally guaranteed** — those never reach S1); loyalty formula = K-18 (available, §2). |
| Amount | `points = floor(0.10 × settled_amount_TRY) = floor(settled_kuruş / 1000)`, single floor (§2), on the gross settled kuruş from the wallet `FB_SETTLEMENT_DEBIT`. |
| Postconditions | **One** `FB_ACCRUAL` entry referencing the `order_id` and the wallet `FB_SETTLEMENT_DEBIT` (`settlement_entry_ref`). |
| Actor / attribution | `SYSTEM`, **derived** from S1 and **attributed** (audit) to the S1 settlement actor (`CASHIER`/`ADMIN`). No human directly writes a loyalty entry. |
| Idempotency | Exactly one per order (partial unique index, §4). Second attempt fails-closed. |
| Exclusions | `CANCELLED` / `REJECTED` orders **never** accrue (BR-FB-011) — structurally, because they never reach S1. |

### 6. Reversal design — recompute-from-corrected, single signed `FB_ACCRUAL_REVERSAL` (C-5, Q3)

When a wallet correction (`FB_SETTLEMENT_CORRECTION`, ADR-006 §8) changes the settled amount, the loyalty
accrual is **recomputed from the corrected settled amount** and a **single** `FB_ACCRUAL_REVERSAL` entry
posts the delta. The original `FB_ACCRUAL` is **never** edited or deleted (C-1; P-3; BR-LOYALTY-005;
BR-AUDIT-002).

**Recompute rule (single floor):**

```
corrected_points = floor(0.10 × corrected_amount_TRY) = floor(corrected_kuruş / 1000)
FB_ACCRUAL_REVERSAL.points_delta = corrected_points − original_points
```

The reversal is **recomputed from the corrected amount** — it is **never** derived as a *proportion of the
originally-rounded points* (which can leave a rounding residual). It is **structurally linked** to both the
original `FB_ACCRUAL` (`reverses_entry_id`) and the wallet `FB_SETTLEMENT_CORRECTION` (`wallet_correction_ref`),
and is written in the **same transaction** as that wallet correction (§4). It is **never** a free-standing
point edit.

| Case | `corrected_points − original_points` | Effect on loyalty |
|---|---|---|
| Over-charge corrected down (corrected < original) | negative or zero | Points reduced to the corrected total |
| Under-charge corrected up (corrected > original) | positive | Additional points to the corrected total (gated by the wallet side — see below) |
| Full unwind (corrected = ₺0) | `0 − original` = **−original** | Order retains **no** points |

**Bidirectional and wallet-gated.** Corrections can be downward or upward. An **upward** wallet correction
(additional debit) is subject to the wallet's negative-balance guard (ADR-006 §6, C-7) and may fail-closed
/ route to ADMIN; if the wallet correction does not commit, **no** loyalty reversal is posted (atomicity,
§4). The loyalty side simply follows whatever wallet correction commits. Full and partial reversals are
expressed the **same way** (full unwind is the special case `corrected = 0`); no separate "void" type is
needed.

### 7. Exclusions (structural)

- **`CANCELLED` / `REJECTED` orders never accrue** — they never reach S1, so L1 never fires (BR-FB-011;
  state model §9.1). This is **structural**, not a runtime check that could be bypassed.
- **Reversed/corrected amounts retain only the corrected points** — by the recompute rule (§6); a full
  unwind retains zero points.
- **No other Phase 1 earning event.** Phase 1 has exactly **one** earning event type (`FB_ACCRUAL` on F&B
  settlement). Wallet top-ups do **not** earn (high double-earning risk; OQ-LOY-001/BRD-LOY-001 — open);
  PC/session usage does not earn pending the Selcafe spike and a Kerem decision (OQ-LOY-001). Discounts,
  campaigns, refunded/cancelled purchases, and manual adjustments are excluded from earning (OQ-LOY-003).
  These exclusions are recorded; they are largely moot in Phase 1 because F&B accrual is the only earning
  path.

### 8. Roles & authority (USER_ROLES; P-5)

Loyalty entries are **system-derived**; **no role directly creates, edits, or deletes a loyalty entry.**

| Loyalty action | `CUSTOMER` | `CASHIER` | `FB_STAFF` | `ADMIN` |
|---|---|---|---|---|
| `FB_ACCRUAL` (L1) | ❌ | ❌ (derives from the cashier's S1 settlement) | ❌ | ❌ (derives from the admin's S1 settlement) |
| `FB_ACCRUAL_REVERSAL` | ❌ | ❌ (derives from the wallet correction) | ❌ | ❌ (derives from the wallet correction) |
| Direct / manual point edit | ❌ | ❌ | ❌ | ❌ — **no such entry type in Phase 1** |

- Accrual derives from S1 and is **attributed** to the settlement actor; the reversal derives from the
  wallet correction and is attributed to that correction's actor (audit). Every loyalty write is therefore
  traceable to a specific human `actor_id` even though it is system-posted.
- **`FB_STAFF` never touches loyalty under any reading** (P-5, BR-ROLE-002, KD-E).
- **No free-standing manual point adjustment exists in Phase 1.** A future manual-adjustment entry type
  (e.g., goodwill credit, or a cashier override per BRD-LOY-008) would be a **gated** capability requiring
  **Kerem + Pod B** (§11.1) and is out of scope here.

### 9. Ledger-side audit fields (BR-AUDIT-001/002) — storage/retention deferred to OQ-AUDIT-001

Each accrual and each reversal emits an **immutable** audit record (§20.3: loyalty ledger writes + audit
log logic → Pod B review). **Ledger-side** fields this ADR specifies:

`entry_id`, `entry_type`, `points_delta` (signed), `order_id`, `customer_id`, `loyalty_account_id`,
`settlement_entry_ref` (the wallet `FB_SETTLEMENT_DEBIT`, for `FB_ACCRUAL`), `reverses_entry_id` (the
original `FB_ACCRUAL`, for a reversal), `wallet_correction_ref` (the wallet `FB_SETTLEMENT_CORRECTION`, for
a reversal), `derived corrected_points` (never an overwrite), `settlement_actor_id` (the human on whose S1
action the entry derived), `operating_day`, `timestamp`.

Before/after values are expressed as **derived** values only — never as balance overwrites. The audit
**event schema** (storage, tamper-evidence, retention, IP/device, workflow-source taxonomy) is
**OQ-AUDIT-001 — open** and is **not** designed here; it must build on the Accepted auth threat-model
baseline. The loyalty entry has **no free-text PII of its own** (no reason note) — the human-entered reason
lives on the wallet `FB_SETTLEMENT_CORRECTION` (ADR-006 §8.2), not duplicated here.

### 10. Abuse cases (§20.1) — required coverage

| Abuse case | Primary mitigations (this ADR) |
|---|---|
| **Inflate loyalty via correction** (correct a settlement to mint extra points) | Reversal is **recomputed from the corrected amount** (C-5, §6), **structurally linked** to the wallet correction, and posted **atomically** with it; single-reversal per accrual (§4). The wallet correction that drives it is itself own-only / in-window / single / mandatory-reason / immutable-audit / daily-ADMIN-report (ADR-006 §8/§11/§12). Points land in the **customer's** loyalty balance (not the cashier's) — detectable. No free-standing point edit exists. |
| **Deflate loyalty via correction** (strip a customer's points) | Same controls; the reversal is recompute-bound, so points cannot be arbitrarily zeroed except via a genuine ₺0 wallet correction, which is itself gated and audited. |
| **Replay accrual** (double-accrue one settlement) | `UNIQUE (tenant_id, order_id) WHERE entry_type='FB_ACCRUAL'`; replays fail-closed (§4). |
| **Replay / duplicate reversal** | `UNIQUE (tenant_id, reverses_entry_id) WHERE entry_type='FB_ACCRUAL_REVERSAL'`; second attempt fails-closed → ADMIN (§4). |
| **Accrue on un-settled / cancelled / rejected order** | **Structural**: accrual derives from S1 only; CANCELLED/REJECTED never reach S1; no S1 → no accrual (§5, §7). Fail-closed. |
| **Unauthorized / manual point edit** (any role mints or edits points directly) | No entry type for free-standing point edits in Phase 1; all entries **derive** from the wallet settlement/correction; append-only (no `UPDATE`/`DELETE`); every write attributed to the settlement actor; `FB_STAFF` fully excluded (P-5). A future manual-adjustment type is gated (Kerem + Pod B). |
| **`FB_STAFF` touches loyalty** | Excluded under all readings (P-5, BR-ROLE-002, KD-E). |
| **Wallet/loyalty divergence** | Atomic single-transaction with the wallet entry (ADR-006 §4); both commit or neither. |

Carried from §20.1 generically: **admin self-privilege escalation** is out of loyalty scope (auth/RBAC —
ADR-015, §11.1 admin-privilege gate); **missing audit for a sensitive action** is itself a detectable
control failure — audit on accrual/reversal is mandatory and immutable. The §20.1 examples
**"customer redeems more value than allowed"** and **"duplicate top-up event"** are **out of Phase 1
loyalty-accrual scope** (redemption is OQ-LOY-004; top-up earning is OQ-LOY-001) and are referenced for the
future redemption/earning design, not solved here. Residual insider-collusion risk (a cashier correcting
in favour of a controlled customer account) is **mitigated, not eliminated**, by the same controls as the
wallet (daily masked ADMIN report + immutable audit + customer-visible balance change).

### 11. KVKK — **PROVISIONAL** (pseudonymize-without-delete; retention/legal basis PENDING)

- **Append-only vs. erasure tension → pseudonymization.** The personal-data element of a loyalty entry is
  the **`customer_id` linkage** (the loyalty balance is attached to an identified customer; BR-LOYALTY-001).
  On an Art. 11 erasure request, the resolution is **pseudonymization, not deletion**: replace the
  `customer_id` linkage with a pseudonymous token, **without** deleting or mutating the immutable
  ledger/audit rows. The points entries (now de-linked) remain for integrity and audit. **No direct writes
  to ledger rows;** this preserves P-3 and the T-1 rollback guarantee. The same pattern applies to Selcafe
  data: no direct writes (ADR-005).
- **Minimal PII surface.** Loyalty entries carry **no free-text PII** of their own (no reason note; that
  lives on the wallet correction, ADR-006 §8.2/§13), so the loyalty ledger's erasure surface is limited to
  the `customer_id` linkage and any denormalized identifier — smaller than the wallet's.
- **Customer-visible loyalty.** Customers can view their own loyalty status (BR-LOYALTY-001), and a
  correction changes the visible points balance. Whether the customer sees an individual loyalty-adjustment
  line (and its wording) or only an updated balance is `[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]`,
  consistent with the minimized correction-history posture (ADR-006 §13). The "₺9 → 0 points" / "₺157 → 15
  points" round-down is customer-visible behaviour; its customer-facing framing is also
  `[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]`.
- **PENDING legal advisor / open dependencies:** retention periods (**OQ-LEGAL-005**), legal basis
  (`KVKK_LEGAL_BASIS.md`), and the mandatory data-inventory linkage every personal-data feature requires
  (§20.2, `DATA_PROCESSING_INVENTORY.md`) are **not resolved here**; `DATA_PROCESSING_INVENTORY.md`,
  `DATA_RETENTION_POLICY.md`, and `KVKK_LEGAL_BASIS.md` are absent / in legal review. A confirmed T-2
  (personal-data exposure) starts the **72-hour** KVKK breach clock (ROLLBACK_POLICY). No real customer
  data is used anywhere (§20.2); examples here are synthetic.

### 12. Tenancy, keys, ORM (ADR-008, ADR-004)

- Every loyalty/anchor table carries `tenant_id UUID NOT NULL` FK → `tenants.id`; all PKs are **UUID**.
  ADR-008's decision is **shared schema with mandatory non-null `tenant_id`** (the `schema-per-tenant`
  filename is a retained link-stability artifact; the content is shared-schema).
- The mandatory **Prisma Client Extension** injects `tenant_id` filtering on every query (ADR-008/004);
  `$queryRaw` points-aggregation on these financial/loyalty tables requires Pod B review (ADR-004).
- All schema changes go through `prisma migrate` (reviewed; **Pod B + Kerem** per ADR-009 §3 and §11.1
  *Database / schema migration*). Phase 1 is single-tenant with a static `TenantContext`.

### Synthetic worked example (Customer A — synthetic data only)

Customer A (`+90 555 000 00 01`) has a delivered F&B order settled at **₺157** (this continues ADR-006's
worked example; both ledgers are written in **one transaction**):

- wallet `FB_SETTLEMENT_DEBIT  amount_minor = −15700` (ADR-006) **and** loyalty
  `FB_ACCRUAL  points_delta = +15` (`floor(15700 / 1000)`), referencing the settlement entry — one
  transaction, order `SETTLED`.

One item is returned within the correction window; the cashier corrects the settled amount to **₺100**:

- wallet `FB_SETTLEMENT_CORRECTION amount_minor = +5700` (credit back; `reason_code = ITEM_RETURNED`;
  ADR-006) **and** loyalty `FB_ACCRUAL_REVERSAL points_delta = floor(10000 / 1000) − 15 = 10 − 15 = −5`,
  linked to both the original `FB_ACCRUAL` and the wallet correction — one transaction.

Derived loyalty for the order = `15 − 5 = 10` points (matching `floor(0.10 × 100)`). **No row overwritten.**
Full unwind (corrected ₺0) → `FB_ACCRUAL_REVERSAL = floor(0) − 15 = −15`; the order retains **no** points,
satisfying "reversed/corrected amounts retain only the corrected points."

---

## Consequences

### Easier / safer

- Financial-like integrity by construction: loyalty balance is a pure sum of immutable entries; no lost
  updates, no in-place mutation, full audit trail. Preserves the ROLLBACK_POLICY T-1 guarantee (nothing to
  "un-write").
- **Wallet/loyalty alignment is guaranteed** by writing the loyalty entry in the *same* transaction as its
  wallet entry — the two ledgers can never disagree about a settlement or a correction.
- Idempotent, fail-closed accrual and single-reversal discipline make replay and double-accrual
  structurally hard; exclusions are structural (no S1 → no points).
- The **recompute-from-corrected** rule eliminates rounding residue that a proportional clawback would
  leave; each accrual and each reversal is its own immutable, auditable entry.
- KVKK erasure is satisfiable (pseudonymize-without-delete) without breaking append-only or audit, and the
  loyalty ledger's PII surface is minimal (linkage only; no free-text).

### Harder / constrained

- Balance is **derived**, so hot read paths need the optional `balance_after_points` cache or a reviewed
  `$queryRaw` aggregation; the cache adds a reconciliation obligation (entries always win).
- Per-account serialization (anchor-row lock) is required for correct balance derivation; this bounds
  concurrent writes *per loyalty account* (acceptable at café scale; revisit for Phase 3 hotspots).
- Integer points mean sub-point fractions never accrue (₺9 → 0 pts; ₺157 → 15 pts). This is a
  product-visible round-down behaviour, consistent with the Locked K-18 examples — not a defect, but its
  customer-facing framing is a Pod A copy concern.
- Storage grows monotonically (append-only). Acceptable; archival/retention is an OQ-LEGAL-005 concern.

### Risks accepted / residual

- **Insider skim via collusion** (cashier + controlled customer account moving points through corrections)
  is mitigated (recompute-bound reversal, single-reversal, atomic link to a gated wallet correction,
  immutable audit, daily masked ADMIN report, customer-visible balance change) but **not eliminated** — the
  daily report + audit are the compensating detective controls, same as the wallet.
- **Cache/sum divergence** is treated as a **T-1** integrity incident (non-discretionary rollback).
- **Cross-tenant leakage** is governed by ADR-008's binding Prisma Client Extension requirement (out of
  scope here; inherited).

### Rollback interaction (ROLLBACK_POLICY)

Incorrect loyalty balances/events are a **T-1 non-discretionary** trigger ("wallet or loyalty
balance/events appear incorrect"). Corrections of incorrect ledger state are **compensating transactions**
(never row removal) and are **loyalty-ledger-class PRs requiring Kerem + Pod B** (§11.1, ADR-009 §3).

---

## Alternatives Considered

### A. **Single combined wallet + loyalty ledger** (rejected)

Put loyalty and wallet entries in one table. **Rejected** because `BR-LOYALTY-005` and ADR-006 §1 mandate a
**separate** loyalty ledger with **separate entry types**; the two have different units (points vs kuruş),
different balances, different cardinality invariants (one accrual per order vs one debit per order), and
different KVKK/retention profiles. Combining them fragments balance derivation and complicates the unique
indexes. The separate-ledger / same-transaction design keeps the books clean **and** guarantees alignment.

### B. **Mutable points balance column** with a side audit log (rejected)

A `loyalty_accounts.points` updated in place, with a separate audit trail. **Rejected**: violates the
locked append-only principle (`BR-LOYALTY-005`, P-3), reintroduces lost-update/race risk, breaks the T-1
rollback guarantee (a mutated balance has no immutable source to reconstruct from), and makes KVKK erasure
and reconciliation fragile.

### C. **Proportional clawback** of originally-rounded points on correction (rejected)

On a correction, scale the original (already-rounded) points by `corrected/original` and post the
difference. **Rejected**: this leaves a **rounding residual** — e.g., scaling 15 pts by 100/157 ≈ 9.55 ≠
`floor(0.10 × 100) = 10`. The **recompute-from-corrected** rule (`corrected_points − original_points`,
§6) is exact, audit-clean, and matches the wallet's compensating-delta discipline (review §7, Q3; C-5).

### D. **Decimal / fractional points** (rejected)

Store points as a decimal/fraction. **Rejected**: loyalty points are discrete, immutable **integer** earn
events (BRD-LOY-002 framing); a single explicit floor (10% round-down) is exact and avoids mixed-precision
bugs across the accrual/reversal chain (N-1). Fractions simply never accrue.

### E. **Reversal + re-accrual pair** instead of a single signed delta (rejected)

Post a full `FB_ACCRUAL_REVERSAL` (= −original) then a fresh `FB_ACCRUAL` for the corrected amount.
**Rejected** for the same reasons ADR-006 rejected reversal+re-debit (ADR-006 Alternatives A): a second
accrual-type entry conflicts with the **exactly one `FB_ACCRUAL` per order** invariant (§4) and its unique
index; two entries per correction complicate the single-reversal/idempotency check and the C-5 linkage; and
it is harder to audit "the one adjustment that changed this accrual." The single signed delta expresses the
same economics with one immutable entry and a clean 1:1 accrual↔reversal mapping.

---

## Approval

- **Author:** Pod B — Architecture, Logic & Risk
- **Reviewer:** Kerem (§19 authorship — Security/KVKK-sensitive decision). `[PRODUCT IMPLICATION — POD A
  ALIGNMENT NEEDED]` on customer-visible loyalty / adjustment display copy, round-down framing, and any
  future redemption / expiry / non-F&B earning copy.
- **Approver:** **Kerem + Pod B** (§11.1 *Loyalty ledger logic*; ADR-009 §3)
- **Date proposed:** 2026-06-14
- **Date accepted:** 2026-06-14
- **Status:** **Accepted** — Kerem approval recorded 2026-06-14 (PR #65).

### Acceptance notes

1. ADR-007 accepted as the loyalty ledger design. Implementation remains blocked — see remaining dependencies below.
2. Loyalty formula confirmed: `floor(0.10 × settled_TRY) = floor(settled_kuruş / 1000)` (K-18, 10% round-down). All sources consistent; no correction required.
3. KVKK section (§11) remains **provisional** pending legal advisor.

### Remaining dependencies (block Pod C / acceptance-as-implementable)

**OQ-AUDIT-001** (audit event schema); **OQ-LEGAL-005** + `DATA_PROCESSING_INVENTORY.md` /
`DATA_RETENTION_POLICY.md` / `KVKK_LEGAL_BASIS.md` (KVKK, legal advisor); `SECURITY_REVIEW.md` (absent —
manifest reconciliation); **OQ-LOY-001 / OQ-LOY-002 / OQ-LOY-003** (non-F&B earning eligibility, formula,
exclusions — open for non-F&B); **OQ-LOY-004** (redemption) and **OQ-LOY-005** (expiry), referenced not
designed. Pod C remains blocked pending these plus separate Pod B + Kerem approved implementation issues.

*Produced by Pod B — Architecture, Logic & Risk. Accepted 2026-06-14. Implementation blocked. The repository is
the source of truth; re-verify `main` blob SHAs before commit. This ADR does not design
schema/migrations/code, does not resolve KVKK/audit-storage questions, and does not authorize Pod C.*
