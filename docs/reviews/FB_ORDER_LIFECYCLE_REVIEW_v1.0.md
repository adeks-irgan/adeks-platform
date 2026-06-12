# F&B Order Lifecycle — Pod B Review

**Suggested repo path:** `/docs/reviews/FB_ORDER_LIFECYCLE_REVIEW_v1.0.md`
**Review date:** 2026-06-12
**Reviewer:** Pod B — Architecture, Logic & Risk
**Review type:** Narrow lifecycle, audit, payment-boundary, and reversal-risk review. Not a state machine. Does not authorize Pod C.

**Input documents reviewed:**
- `BUSINESS_RULES_FB_ORDER_LIFECYCLE_PATCH.md` (provided via handoff)
- `OPEN_QUESTIONS_FB_ORDER_LIFECYCLE_PATCH.md` (provided via handoff)

**Freshness declaration:** Live versions of `/docs/BUSINESS_RULES.md`, `/docs/OPEN_QUESTIONS.md`, `/docs/MVP_SCOPE.md`, and `/docs/PROJECT_DECISION_INDEX.md` were not loaded in this session. The review is scoped to the F&B product decisions as captured in the two patch files. If the live documents contain prior F&B rules not superseded by these patches, a separate reconciliation pass is required before commit.

---

## 1. Review Verdict

**Safe with corrections.**

Kerem's product-policy decisions are internally sound at a high level. The customer-visible status vocabulary is appropriate for a gaming café F&B context. The core actor boundaries — cashier-only Phase 1 payment, FB_STAFF no-payment authority — are coherent and consistently applied across the patches. Pod A has correctly tagged all state-transition, audit, and reversal implications for Pod B review rather than resolving them.

Three areas require resolution before Pod B can formalize the state machine:

1. The unavailable-item path leaves the order in an undefined lifecycle state — this is a structural gap in the current decision set. (Blocking for state machine design.)
2. Whether F&B orders can be settled against the café wallet is unresolved and is the single most important pre-condition for reversal design. (Requires Kerem decision.)
3. `Ready / On the way` must be confirmed as one internal state or two before formal state transitions can be drawn.

---

## 2. Findings Table

| ID | Classification | Area | Finding | Required action | Owner |
|---|---|---|---|---|---|
| FB-001 | blocking | Lifecycle — unavailable item | "Staff marks item unavailable and asks customer to reorder" is an item-level action with no defined order-level status transition. When this action occurs, the order cannot remain in a lifecycle limbo. Two possible resolutions: (A) the whole order is Rejected (customer submits a new order), or (B) the order enters an intermediate state not currently named. Option B would add a status not in Kerem's approved vocabulary; Option A must be confirmed as intentional since the customer effectively bears the full retry cost. | Kerem to confirm: does item-unavailable result in full-order Rejection (customer submits a new order), or is a different resolution intended? Pod B to resolve in state machine design once confirmed. | Kerem (policy), then Pod B |
| FB-002 | blocking | Lifecycle — "Ready / On the way" | This label may represent one internal state or two (Ready-for-pickup vs. In-transit-to-seat). The distinction affects: when the audit point is logged, which actor triggers the transition, and whether a staff action separates the two (e.g., FB_STAFF presses "Start delivery"). For a gaming café table-delivery model these could be a single action; for a pickup model the distinction is more meaningful. | Kerem to confirm product intent: one state or two states behind one display label? Pod B to resolve in state machine design. | Kerem (product intent), then Pod B |
| FB-003 | non-blocking | Lifecycle — staff cancel scope | "Staff can cancel after acceptance only with a required reason" — "after acceptance" is ambiguous. It most likely means at any post-Accepted state (Accepted, Preparing, Ready / On the way) but could be read as only-from-Accepted-state. The distinction matters when, for example, an order is already Preparing and must be aborted. | Pod B to clarify in state machine design. Advisory to Kerem: if staff cancel is intentionally limited to the Accepted state only (not Preparing or later), flag now — otherwise Pod B will formalize the broader reading. | Pod B (advisory to Kerem) |
| FB-004 | non-blocking | Actor permissions | No staff role granularity is specified for Reject or Cancel. "Staff" could mean FB_STAFF only, or FB_STAFF + MANAGER + ADMIN. For Phase 1 of a single café this may not matter operationally, but it must be explicit in the state machine to prevent over-authorization. | Pod B to assign authorized actors per transition in state machine design. Kerem to confirm if FB_STAFF alone is sufficient or if MANAGER/ADMIN have distinct cancel/reject authority. | Pod B (with advisory to Kerem) |
| FB-005 | non-blocking | Lifecycle — customer cancel source states | "CUSTOMER can cancel until Preparing" correctly implies cancel-from-Submitted and cancel-from-Accepted, but allowed source states are not explicitly enumerated in the decision text. Additionally: what happens if a customer submits a cancel request at the exact moment staff transitions the order to Preparing? This is a concurrency boundary that must be handled atomically in the state machine (the Preparing transition must win; customer cancel arriving in the same instant should be rejected). | Pod B to enumerate allowed source states explicitly and specify concurrency handling in the state machine design. No Kerem decision required. | Pod B |
| FB-006 | requires Kerem decision | Payment / reversal — wallet usage | F&B payment is cashier-only, but the payment *method* for F&B is not specified. Can café wallet balance be used for F&B purchases (cashier-mediated debit at delivery), or is F&B limited to cash or card only? This is the single most important pre-condition for reversal design. If wallet payments are used, cancellations and rejections may require wallet-hold release or balance reversal logic; if not, financial reversal is not required during the lifecycle. Without this, Pod B cannot complete the reversal design. | **[REQUIRES KEREM DECISION]** — Can F&B orders be settled against the café wallet? If yes: does the wallet debit occur at submission (hold model) or at delivery (debit-at-settlement model)? | Kerem |
| FB-007 | requires Kerem decision | Loyalty accrual for F&B | No rule establishes whether loyalty points accrue for F&B purchases in Phase 1. If loyalty applies, the accrual trigger must be specified (Delivered? Payment settled by cashier?). Cancelled and rejected orders must not accrue loyalty. If loyalty is out of scope for F&B in Phase 1, that should be stated explicitly so Pod B can safely exclude it from lifecycle design. | **[REQUIRES KEREM DECISION]** — Do F&B purchases accrue loyalty in Phase 1? If yes: what is the accrual trigger? | Kerem |
| FB-008 | non-blocking | Payment boundary — "combined status" definition | "Customer sees combined customer-facing payment/order status" is imprecisely defined. Three options: (A) fulfillment-only display — the customer sees only order status, payment is invisible in the UI; (B) fulfillment + payment indicator — the customer sees, e.g., "Delivered — Payment Due" vs. "Delivered — Paid"; (C) a single combined label that changes when payment is processed. Options B and C are compatible with cashier-only payment as long as the payment indicator is only updatable by CASHIER/ADMIN and no self-pay UI element exists. Option A is simplest for Phase 1 and eliminates payment-state exposure entirely. | Pod B to define the combined model precisely in formal design. **[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]** — confirm no self-pay UI element is implied by the combined status design. | Pod B + Pod A alignment |
| FB-009 | advisory | Payment boundary — Delivered state | "Delivered" currently means "staff marked order delivered." It does not encode whether payment has been collected. If the combined display includes a payment indicator (Finding FB-008 Option B or C), "Delivered" alone must not imply "Paid" — the two are separate events under cashier-only payment. A customer could see "Delivered" before the cashier has recorded payment. | Pod B to resolve in the combined status model design. | Pod B |
| FB-010 | advisory | Audit — KVKK | Cancellation and rejection audit reasons are linked to specific orders which are linked to specific customers. These constitute personal data under KVKK. The audit reason store must be covered by the project's pseudonymization and retention strategy. A customer exercising a right-to-erasure request must not result in audit records becoming unresolvable or in prohibited data deletion. | Flag for ADR/KVKK review during Pod B audit model design. Not a blocker for state machine formalization. | Pod B (future ADR) |
| FB-011 | advisory | Lifecycle — Rejected status wording | The patch describes the Rejected status as: "Staff cannot accept/fulfill the order before acceptance because item is unavailable or the order is invalid." The phrase "cannot accept/fulfill" is grammatically awkward as a status definition and reads as a constraint rather than a state meaning. | Pod A to apply minor wording correction: "Staff rejected the order before accepting it because an item was unavailable or the order was invalid." | Pod A |
| FB-012 | advisory | Lifecycle — rejection is an explicit staff action | The product decisions do not explicitly state that Reject is an active staff-initiated action rather than an automatic system event. This should be confirmed to prevent implementation ambiguity — particularly given that item-unavailability might in future be detected automatically. | Pod B to note in state machine design that all status transitions are explicit actor-triggered events, not automatic system state changes, unless a future ADR authorizes automated transitions. | Pod B |

---

## 3. State/Lifecycle Clarification Notes

### What must become a state machine before Pod C

The following elements must be formalized by Pod B into a complete state machine — with states, transitions, triggering actors, preconditions, and postconditions — before any Pod C implementation issue can be drafted:

- All order states with precise entry and exit conditions
- All valid transitions with: triggering actor, trigger event, preconditions, postconditions
- The unavailable-item path — lifecycle resolution once Kerem confirms Rejected-vs-other (Finding FB-001)
- Whether `Ready / On the way` is one state or two behind one display label (Finding FB-002)
- Explicit enumeration of customer-cancel source states and concurrency handling (Finding FB-005)
- Scope of staff cancel: only-from-Accepted or any-post-Accepted state (Finding FB-003)
- Actor assignments per transition: which staff role is authorized for each transition (Finding FB-004)
- The combined payment/order display model: what payment states exist, when they update, and who may update them (Findings FB-008, FB-009)

### Lifecycle terms needing sharper product wording before formal design

| Term | Current form | Sharpening needed |
|---|---|---|
| "Until Preparing" | Correctly assumed to mean "before entering Preparing" (BR-FB-004 ASSUMPTION) | Make explicit: "CUSTOMER may cancel when order status is Submitted or Accepted. Once the status has entered Preparing, customer cancellation is blocked." |
| "After acceptance" (staff cancel) | Ambiguous scope | Confirm: "Staff may cancel at any point after acceptance — from Accepted, Preparing, or Ready / On the way — with required reason" OR "Staff may only cancel from the Accepted state; a different governance path applies at Preparing or later." |
| "Ready / On the way" | Single display label, internal state count unclear | Confirm as: one internal state (recommended for Phase 1 simplicity) OR two internal states (Ready, On the way) collapsing to one customer label. |
| "Marks item unavailable and asks to reorder" | Item-level action; order-level outcome undefined | Confirm: full-order Rejected (customer places a new order) OR order enters a named intermediate state. Note: a new state would expand Kerem's approved status vocabulary. |
| "Combined payment/order status" | Direction confirmed; model not defined | Select model: fulfillment-only (payment invisible), or fulfillment + payment indicator. If indicator exists: enumerate its values and confirm CASHIER/ADMIN are the only actors who may update it. |

---

## 4. Audit and Reversal Notes

### Required audit moments

| Event | Audit reason required? | Triggered by | Notes |
|---|---|---|---|
| CUSTOMER cancels order | No (customer action) [ASSUMPTION] | CUSTOMER | If Kerem intends customer cancellations to capture a reason (e.g., for service analytics), this should be noted explicitly. |
| Staff rejects order before acceptance | Yes — item unavailability or order invalidity | FB_STAFF / MANAGER / ADMIN (role TBD) | Reason field must be mandatory, not optional. |
| Staff cancels order after acceptance | Yes — required reason | FB_STAFF / MANAGER / ADMIN (role TBD) | Reason field must be mandatory, not optional. |
| Staff marks item unavailable | Yes — item identity and reason | FB_STAFF | Separate from order-level rejection/cancellation; item-level audit record. |
| All status transitions | Advisory — timestamp + actor should be logged for each transition | System | Not an explicit product decision but a minimum audit-trail expectation for a cashier-gated payment system. |

[ASSUMPTION]: Customer cancellation does not require a stated reason per the product decisions. If this assumption is wrong, Kerem should correct it.

### Reversal risks by payment scenario

**Scenario A — F&B is cash/card-only at delivery (no wallet involvement):**

No wallet balance is at risk during the order lifecycle. Cancellation and rejection have no financial reversal requirement. If loyalty is out of scope for F&B Phase 1 (pending Finding FB-007), there are no ledger entries to reverse. Risk level: **Low.**

**Scenario B — F&B can be settled against café wallet (cashier-mediated):**

Two sub-models are possible:

- **B1 — Debit at delivery only:** CASHIER debits wallet at the point of delivery/settlement. Cancellation or rejection before delivery requires no wallet action because no debit has occurred. Risk level: **Low-medium.**
- **B2 — Hold at submission, settle at delivery:** A wallet hold is created at order submission and converted to a settled debit by CASHIER at delivery. Cancellation or rejection releases the hold. This is a wallet entry (append-only ledger — no direct balance overwrite). The hold-release-settle sequence introduces non-trivial atomicity and ledger design requirements. Risk level: **Medium.**

Model B2 adds significant ledger complexity (hold entries, release entries, settlement entries, partial-failure handling). Pod B would need to design this as a dedicated ledger pattern, not a simple balance check. This is a material design decision that depends entirely on Kerem's answer to Finding FB-006.

### Whether any reversal concern requires Kerem decision before Pod B formal design

**Yes.** Finding FB-006 (café wallet for F&B) must be resolved before Pod B can design the cancellation and rejection reversal paths. Finding FB-007 (loyalty accrual) must also be resolved. All other reversal paths (audit reason capture, state boundary enforcement) can be designed by Pod B independently of these two questions.

---

## 5. Payment-Boundary Notes

### Is combined customer-facing payment/order status acceptable as product policy?

Yes, as a policy direction. A combined display is a reasonable simplification for a gaming café customer who does not need to distinguish between fulfillment and payment events in the PWA. However, the precise model (fulfillment-only vs. fulfillment + payment indicator) must be defined before Pod B designs the display model and before Pod A/UX designs the customer-facing status component.

### Constraints needed to preserve cashier-only payment

1. No state machine transition may be triggered by a payment event unless that event is explicitly initiated by a CASHIER or ADMIN actor.
2. No customer-facing UI element may include a self-pay button, payment link, or prompt of any kind.
3. No FB_STAFF role may hold a "process payment," "mark paid," or "settle balance" authority in the state machine or API contract.
4. If a payment-status field exists in the combined display, it must only be updatable by a CASHIER or ADMIN actor, and only through an explicit cashier-side action.

### Constraints needed to preserve FB_STAFF no-payment authority

1. FB_STAFF transitions are limited to: Accept order, Reject order (before acceptance), Cancel order (after acceptance with reason), Mark item unavailable, Set status to Preparing, Set status to Ready / On the way, Set status to Delivered.
2. None of the FB_STAFF transitions touch any payment state or wallet balance.
3. The customer-visible combined status must not suggest to the customer that FB_STAFF can collect or confirm payment.

### Wording change Pod A should apply to the patches

In the "Combined status meaning" row of the F&B payment visibility section, append the following to the current guardrail text:

> The customer-facing status component must not include any interactive payment element (button, link, prompt, or in-app payment flow). Payment occurs offline via CASHIER only. Pod A and UX design must not derive a self-pay interaction from the "combined status" direction.

This prevents downstream UX design from interpreting "combined status" as authorization for an online payment UI.

---

## 6. Readiness Statement

### Ready for Pod A documentation correction/commit?

**Yes, with minor corrections.** The two patches are well-structured and faithfully record Kerem's decisions with appropriate [REQUIRES POD B REVIEW] guardrails throughout. Pod A should apply the following before commit:

1. Finding FB-011: correct the Rejected status wording (awkward "cannot accept/fulfill" phrasing).
2. Finding FB-008 / §5: add the payment-boundary wording note prohibiting interactive payment elements.
3. Confirm the BR-FB-004 ASSUMPTION ("until Preparing = before entering Preparing") is correct before committing — this assumption should be validated, not assumed.

Pod A must not resolve Findings FB-006 or FB-007 — those await Kerem's product decisions.

### Ready for later Pod B lifecycle/state-machine design?

**Not yet.** The following must be resolved before Pod B begins formal state machine work:

| Blocker | Finding | Resolution path |
|---|---|---|
| Unavailable-item lifecycle outcome | FB-001 | Kerem confirmation on Rejected-vs-other |
| `Ready / On the way` state count | FB-002 | Kerem confirmation on one-state vs. two |
| Wallet for F&B | FB-006 | Kerem decision |
| Loyalty accrual for F&B | FB-007 | Kerem decision |

Findings FB-003, FB-004, FB-005, FB-008, FB-009, FB-012 can be resolved by Pod B during state machine design without further Kerem input. Finding FB-010 (KVKK) is a future ADR item, not a state machine blocker.

### Ready for Pod C issue drafting?

**No.** Pod B formal state machine design must be completed and reviewed before any Pod C implementation issue can be drafted. This is consistent with the existing governance position and the [REQUIRES POD B REVIEW] routing in both patches.

---

*Review produced by Pod B. Not a state machine. Does not authorize Pod C. Kerem decisions required on FB-001 (policy confirm), FB-002 (policy confirm), FB-006, and FB-007 before Pod B can proceed to formal lifecycle design.*
