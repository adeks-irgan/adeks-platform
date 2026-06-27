# OPERATING_SLICE_DISCOVERY_v0.1.md

## Status

| Field                 | Value                                                                                                                                                     |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Document              | `OPERATING_SLICE_DISCOVERY_v0.1.md`                                                                                                                       |
| Target path           | `/docs/planning/OPERATING_SLICE_DISCOVERY_v0.1.md`                                                                                                        |
| Owner                 | Pod A — Product & Planning                                                                                                                                |
| Approver              | Kerem                                                                                                                                                     |
| Current status        | Revised discovery draft after full operating-model transcript review                                                                                      |
| Implementation status | Does not authorize Pod C implementation                                                                                                                   |
| Methodology status    | Does not change methodology or pod behavior                                                                                                               |
| Data rule             | Synthetic examples only; no real customer, phone, wallet, loyalty, transaction, reservation, staff, screenshot, Selcafe row data, credentials, or secrets |

---

## 1. Situation

Adeks has strong governance: pods, gates, ADRs, review routing, handoffs, source-of-truth rules, and implementation-readiness controls.

The working diagnosis is:

> Adeks is over-governed because it is under-modeled.

The immediate problem is not that methodology must be rewritten. The problem is that component-level planning advanced before the café’s real end-to-end operating flow was modeled clearly enough.

The previous under-scoped draft treated the slice mainly as guest F&B ordering with optional discount. The full discovery transcript shows that the confirmed slice is broader and more operationally specific.

The slice must model:

* customer registration and repeat PWA habit;
* receipt/addition linking;
* table confirmation;
* Selcafe-linked visit visibility;
* estimated PC + F&B totals;
* PWA F&B ordering;
* manual cashier entry into Selcafe;
* read-only Selcafe comparison;
* coupon/discount flow;
* loyalty earning after settlement;
* final settled amount visibility;
* pilot trust thresholds.

This document remains discovery/planning only. It does not create implementation issues, ADRs, API contracts, schema, or Pod C authorization.

---

## 2. Confirmed Working Slice Name

> **Selcafe-Linked Customer Visibility and Ordering Slice**

Confirmed product spine wording:

> Selcafe-linked customer visibility and ordering: the minimum feature set that gives customers enough value and eagerness to use Adeks.

---

## 3. Essential Promises

### 3.1 Customer Promise

> Register, link your receipt, order from your seat, get PC + F&B discount, and earn points after payment.

### 3.2 Staff Promise

> Fewer missed orders, fewer verbal-order interruptions, and better comparison between Adeks PWA orders and Selcafe settlement.

### 3.3 Business Promise

> Build registration and repeat PWA usage habit through Selcafe-linked visibility, F&B ordering, discounts, and loyalty.

---

## 4. Candidate Operating Slices Considered

| Candidate | Slice                                                                                    | Strength                                                                               | Weakness                                                                                 |
| --------- | ---------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| A         | Receipt/addition linking only                                                            | Smallest possible model; validates link between customer and active visit              | Too little customer value; unlikely to build PWA habit                                   |
| B         | Receipt/addition linking + F&B order submission                                          | Reduces verbal ordering and staff walking                                              | Still misses visibility, coupon, loyalty, and settlement-trust loop                      |
| C         | Receipt/addition linking + F&B + Selcafe-linked visibility                               | Creates trust and utility by showing PC/F&B session information                        | Still weak as a registration/habit engine without coupon/loyalty                         |
| D         | Receipt/addition linking + visibility + F&B ordering + coupon + loyalty after settlement | Best fit after discovery; creates customer value, staff value, and business habit loop | Depends on reliable read-only Selcafe data and careful cashier workflow                  |
| E         | Full wallet/payment/reservation/campaign platform                                        | Too broad                                                                              | Pulls in settlement ownership, wallet payment, direct Selcafe coupling, and excess scope |

Recommended candidate: **D**.

---

## 5. Recommended Slice to Model Next

The confirmed first operating slice is:

> Customer registers or uses a permitted guest/addition flow, links the current Selcafe visit through `fiş / fiş numarası`, confirms the table, sees Selcafe-linked visit information, orders F&B from the PWA, cashier manually enters accepted orders into Selcafe, kitchen/service continue from Selcafe printed receipts, customer sees estimated PC + F&B totals and coupon/points information, final payment happens at cashier, Adeks reads final settled amount from Selcafe, and Adeks updates settled amount, coupon status, and loyalty history after payment.

This slice must not be interpreted as direct Adeks settlement ownership.

Selcafe remains the operational and settlement source of truth in Phase 1.

---

## 6. Why This Slice Is the Smallest Useful Correction

This slice is the smallest useful correction because it models the real café spine rather than isolated platform features.

Today’s café operation is centered on:

* cashier-started Selcafe table/seat session;
* printed receipt;
* table number;
* addition number;
* manual F&B entry into Selcafe;
* Selcafe printed kitchen/service receipts;
* cashier settlement at the end.

The slice improves the real workflow without pretending Phase 1 can replace Selcafe.

It is small enough because it excludes:

* direct Adeks writes to Selcafe;
* PWA payment;
* wallet spending/payment;
* customer self-settlement;
* kitchen-facing PWA workflow;
* delivery tracking;
* custom staff-to-customer messaging;
* reservation automation;
* customer self-seat-change;
* complex campaign/tier/subscription logic;
* full Selcafe member-number dependency;
* PWA-owned final bill calculation.

It is useful enough because it includes:

* registration/app usage habit;
* F&B ordering from seat;
* Selcafe-linked visibility;
* estimated PC + F&B totals;
* coupon/discount motivation;
* loyalty earning after payment;
* missed-order prevention;
* settlement comparison;
* customer trust through receipt/table confirmation.

---

## 7. Current Real-World Operating Baseline

| Area                         | Today’s operation                                                                                                                                   |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| Customer arrival             | Customer comes to cashier first.                                                                                                                    |
| Seat selection               | Customer and cashier look at available seats on Selcafe cashier screen and choose seat together.                                                    |
| Session start                | Cashier starts the seat through Selcafe cashier module.                                                                                             |
| Member handling              | If customer is a member, customer gives member number and cashier enters it while starting the seat.                                                |
| Group seating                | Cashier tries to seat friends together.                                                                                                             |
| Reservations                 | Cashier checks handwritten reservation list.                                                                                                        |
| Operational identity         | Table/seat number, printed receipt, addition number. Customer name is not the main operational identity.                                            |
| Receipt                      | Receipt prints with table and addition number.                                                                                                      |
| Customer movement            | Cashier moves addition in Selcafe and writes new table on receipt.                                                                                  |
| Current F&B order            | Customer verbally tells staff; staff enters order into Selcafe.                                                                                     |
| Selcafe client ordering      | Exists but customers do not use it because UI is clumsy.                                                                                            |
| Kitchen/service flow         | Selcafe prints receipt; cashier hands it to staff/kitchen; cashier rings bell; service staff delivers.                                              |
| Delivery status              | No reliable preparation/delivery/completion tracking today.                                                                                         |
| Payment                      | Mostly after usage; F&B and PC usually settled together at the end.                                                                                 |
| Café-table transfer          | If customer leaves PC area but stays in café, staff stops PC time, calculates PC + F&B sum, and transfers amount to a newly opened cafeteria table. |
| Biggest pain                 | Registration, missing order statuses, beverages delivered but not entered into Selcafe, customer waiting for staff.                                 |
| First transaction to improve | Customer orders F&B from seat.                                                                                                                      |

---

## 8. Core Operating Spine

### 8.1 Main Flow

| Step | Actor                    | Action                                                                      | Product meaning                                                                         |
| ---: | ------------------------ | --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
|    1 | Customer                 | Arrives at Adeks.                                                           | Flow starts at real café entry, not in the app.                                         |
|    2 | Cashier + Customer       | Choose available seat from Selcafe cashier screen.                          | Selcafe remains seat/session source.                                                    |
|    3 | Cashier                  | Starts seat in Selcafe.                                                     | Adeks does not start PC/session in Phase 1.                                             |
|    4 | Selcafe / Cashier        | Printed receipt is given to customer.                                       | Receipt is main onboarding/linking object.                                              |
|    5 | Staff / receipt / banner | Customer is informed about PWA, discount, and loyalty.                      | PWA habit starts from concrete benefit.                                                 |
|    6 | Customer                 | Opens PWA.                                                                  | PWA access may be via receipt QR if possible, typed URL, saved app, or campaign prompt. |
|    7 | Customer                 | Registers/logs in where required.                                           | Adeks account supports coupons, loyalty, and history.                                   |
|    8 | Customer                 | Enters/scans `fiş / fiş numarası`.                                          | Addition number is main visit/session link.                                             |
|    9 | Adeks                    | Reads Selcafe in read-only mode to find addition data.                      | No Selcafe write is implied.                                                            |
|   10 | PWA                      | Shows table confirmation.                                                   | Customer confirms: “Yes, this is my table.”                                             |
|   11 | Customer                 | Confirms table.                                                             | Ordering is blocked until confirmation.                                                 |
|   12 | PWA                      | Shows addition-linked visit view.                                           | Includes launch-blocking Selcafe-derived details where reliable.                        |
|   13 | Customer                 | Places F&B order from seat.                                                 | Customer avoids waiting for staff to take order verbally.                               |
|   14 | Cashier                  | Sees PWA order queue with alert.                                            | Main cashier is first operational receiver.                                             |
|   15 | Cashier                  | Checks order and manually enters it into Selcafe.                           | This is mandatory Phase 1 manual bridge.                                                |
|   16 | Adeks                    | Infers accepted/preparing by reading matching Selcafe order if possible.    | Status is tied to Selcafe entry, not just a button click.                               |
|   17 | Selcafe                  | Prints normal order receipt.                                                | Kitchen/service workflow remains Selcafe-based.                                         |
|   18 | Kitchen/service          | Prepares and delivers using Selcafe printed receipt.                        | No kitchen PWA workflow in first slice.                                                 |
|   19 | Customer                 | Sees estimated totals, coupon/discount, and points estimate where reliable. | All pre-settlement financial values are estimated.                                      |
|   20 | Cashier                  | Settles final amount in Selcafe.                                            | Selcafe is source of truth.                                                             |
|   21 | Adeks                    | Reads settled final amount from Selcafe.                                    | Cashier does not manually enter final total into Adeks.                                 |
|   22 | PWA                      | Shows settled amount, points/coupon result, and history.                    | Habit loop completes after payment.                                                     |
|   23 | Customer                 | Returns later for coupons/discounts/points.                                 | Business goal is repeat PWA usage.                                                      |

---

## 9. Addition-Number-First Model

### 9.1 Confirmed Direction

| Area                            | Confirmed direction                                     |
| ------------------------------- | ------------------------------------------------------- |
| Main session link               | Selcafe addition number / `fiş numarası`                |
| Customer identity               | Adeks account for PWA, loyalty, coupon, and history     |
| Selcafe member number           | Optional/later; not required as main PWA flow           |
| Table number                    | Confirmation only                                       |
| Printed receipt                 | Main onboarding/linking object                          |
| Ordering block                  | Customer cannot order until addition/table is confirmed |
| Unknown addition                | Customer should ask cashier                             |
| Wrong table                     | Customer should ask cashier; no casual override         |
| Existing Selcafe member history | Can be linked later; not critical for first slice       |

### 9.2 Customer-Facing Language

Use customer language, not internal Selcafe language.

Recommended Turkish customer-facing terms:

* `fiş`
* `fiş numarası`

Avoid using “addition” as the primary customer-facing word unless later UX research says customers understand it.

Suggested instruction:

> Please scan the receipt with Adeks and confirm your table number.

Suggested confirmation:

> Yes, this is my table.

---

## 10. Registration, Guest Use, and PWA Habit

The discovery contains a tension that must be handled explicitly:

* Kerem wants guest/non-member use to be available.
* Kerem also confirmed that every PWA user should have an Adeks account for the intended registration/habit loop.
* Guest orders can be useful, but loyalty/coupon benefits require registration or account binding before settlement.

### 10.1 Working Interpretation

| User type                    |                       Allowed? | Boundary                                                                                                |
| ---------------------------- | -----------------------------: | ------------------------------------------------------------------------------------------------------- |
| Existing Selcafe member      |                            Yes | Can use addition-first flow; Selcafe member number should not be primary.                               |
| New Adeks account customer   |                            Yes | Target path for habit, coupons, loyalty, and history.                                                   |
| Non-Selcafe-member customer  |                            Yes | Can become Adeks customer without being created in Selcafe immediately.                                 |
| Guest/addition-only customer | Permitted as a controlled flow | Can order where allowed, but loyalty/coupon/history require Adeks account binding before final payment. |

### 10.2 Registration Goal

The slice is not only about reducing staff order-taking. It is also about:

> registration and app usage habit.

Drivers for first PWA use:

* staff instruction;
* loyalty campaign announcement banners;
* receipt/table prompts;
* PC + F&B discount;
* F&B ordering from seat.

Drivers for repeat use:

* loyalty points;
* discounts;
* available coupons;
* F&B ordering;
* settled visit history.

First campaign message:

> Register and get PC usage and F&B discount.

---

## 11. Selcafe Read Dependency

This is launch-blocking.

The first slice is not launchable if Adeks cannot reliably read enough Selcafe data to support linked visibility and estimates.

### 11.1 Required Selcafe Read Data

| Required data         | Purpose                                                              |
| --------------------- | -------------------------------------------------------------------- |
| Table number          | Confirm correct receipt/addition/table link.                         |
| PC usage start time   | Derive active status and duration.                                   |
| PC usage stop time    | Derive stopped/closed status.                                        |
| F&B item names        | Show all addition F&B items, including verbal/Selcafe-entered items. |
| F&B item prices       | Calculate/verify F&B subtotal.                                       |
| F&B item quantities   | Calculate/verify F&B subtotal.                                       |
| Settled final amount  | Show final amount and calculate post-payment loyalty.                |
| Seat category         | Calculate PC usage estimate.                                         |
| Category hourly price | Calculate PC usage estimate.                                         |

### 11.2 Adeks-Derived Values

Adeks may calculate:

* open/closed status;
* PC usage duration;
* PC usage amount;
* F&B subtotal;
* estimated total;
* estimated coupon-adjusted total;
* estimated loyalty points;
* updated post-settlement loyalty.

### 11.3 Refresh Requirement

| Area                  | Rule                                                                           |
| --------------------- | ------------------------------------------------------------------------------ |
| Refresh cadence       | Every 1 minute and/or customer manual refresh.                                 |
| PC usage delay        | Small delay acceptable.                                                        |
| F&B list delay        | Small delay acceptable.                                                        |
| Display               | Show visible “last updated at…” timestamp.                                     |
| Financial reliability | Hide financial estimates unless reliable.                                      |
| Failure state         | If Selcafe read fails, tell customer to contact staff/cashier.                 |
| Unknown addition      | Block ordering.                                                                |
| Missing F&B data      | Do not allow ordering if required data is missing, though expected to be rare. |

### 11.4 Customer Trust Rule

The worst trust problem is not only wrong data. It is also:

> PWA says “ask cashier” too often.

Therefore the slice must balance safety with usefulness. Over-blocking can damage adoption.

---

## 12. Addition-Linked Customer View

After linking `fiş / fiş numarası`, the PWA should show enough information for trust and habit.

### 12.1 Launch View

| Item                         | Include? | Notes                                                   |
| ---------------------------- | -------: | ------------------------------------------------------- |
| Table number                 |      Yes | Immediate confirmation item.                            |
| Active/open status           |      Yes | Derived from Selcafe data.                              |
| PC usage start time          |      Yes | Launch-blocking.                                        |
| PC usage duration            |      Yes | Derived.                                                |
| Estimated PC cost            |      Yes | Based on seat category and hourly price.                |
| F&B items already in Selcafe |      Yes | Includes verbal orders already entered into Selcafe.    |
| PWA-originated F&B orders    |      Yes | Needed for customer confidence and comparison.          |
| Estimated total              |      Yes | Must be labeled estimated.                              |
| Coupon status                |      Yes | Selected/applied/rejected/corrected where known.        |
| Loyalty estimate             |      Yes | Estimated before payment.                               |
| History of changes           |      Yes | Customer should see history, not only current estimate. |
| Last updated timestamp       |      Yes | Required for trust.                                     |

### 12.2 Amount Copy

Near all pre-payment totals, show:

> Estimated. Final amount confirmed at cashier.

After settlement, customer may see:

* settled final amount;
* settled amount used for points;
* earned points from PC usage;
* earned points from F&B;
* total earned for visit;
* updated loyalty balance;
* available coupons/discounts.

---

## 13. F&B Order Flow

### 13.1 Order Requirements

| Area              | Rule                                                                   |
| ----------------- | ---------------------------------------------------------------------- |
| Table entry       | Customer should not manually enter table number.                       |
| Main link         | Customer enters/scans `fiş numarası`; table is shown for confirmation. |
| Menu              | Full F&B menu for pilot.                                               |
| Modifiers         | Modifier-heavy items included.                                         |
| Unavailable items | Rare, but cashier handles manually; admin can hide/unhide in Adeks.    |
| Customer edit     | Customer can edit/cancel before cashier accepts.                       |
| Kitchen workflow  | Kitchen/preparation staff continue from Selcafe printed receipts only. |

### 13.2 Status Model

| Status               | Meaning                                                                                                                                            |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| Received             | Order recorded without error in Adeks PWA and shown to cashier.                                                                                    |
| Accepted + Preparing | Cashier checked the order, resolved missing details, and entered it into Selcafe successfully. Ideally inferred by reading matching Selcafe order. |
| Cancelled            | Something is wrong; order is removed/cancelled in relevant systems, and customer is informed.                                                      |

No delivered status is required for Phase 1.

### 13.3 Accepted + Preparing Rule

> “Accepted + Preparing” means the order has been entered into Selcafe successfully.

If cashier cannot enter it into Selcafe immediately, the order remains:

> Received.

This is essential because the biggest current mistake is an order being delivered but not entered into Selcafe.

---

## 14. Manual Selcafe Mirroring Loop

Phase 1 must model a manual bridge between Adeks PWA and Selcafe.

Adeks does not directly write PWA orders into Selcafe.

Instead:

1. Customer submits F&B order in Adeks PWA.
2. Main cashier sees the order.
3. Cashier checks the order.
4. Cashier manually enters the corresponding order into Selcafe.
5. Selcafe prints the normal order receipt.
6. Kitchen/service staff work from Selcafe printed receipt.
7. Adeks reads Selcafe in read-only mode.
8. Adeks tries to match PWA order to Selcafe items.
9. Adeks infers accepted/preparing if the Selcafe match is reliable.
10. Cashier settlement in Selcafe remains final source of truth.

This loop is part of the slice because it explains how Adeks can improve ordering without violating the Phase 1 no-Selcafe-write boundary.

---

## 15. Cashier-Side Workflow

### 15.1 Cashier Queue

The cashier screen should show:

* table number;
* order details;
* ordered items;
* modifiers/notes;
* selected coupon if relevant;
* stale Selcafe-read warning if relevant.

Queue should include:

* new orders;
* accepted orders;
* cancelled orders;
* recent orders.

New PWA orders should create sound/visual alert.

### 15.2 Timing

| Rule                                                 | Value                                                              |
| ---------------------------------------------------- | ------------------------------------------------------------------ |
| Main watcher                                         | Main cashier                                                       |
| Staff help                                           | Service/delivery staff can help if they access cashier/order point |
| Maximum acceptable delay before cashier sees/accepts | 2 minutes                                                          |
| Alert condition                                      | PWA order stays Received for more than 2 minutes                   |
| Alert audience                                       | All cashier/staff where operationally relevant                     |

### 15.3 Item Naming

| Area                             | Rule                                                   |
| -------------------------------- | ------------------------------------------------------ |
| Menu grouping                    | PWA should group items like Selcafe menu categories.   |
| Staff-facing item name           | Use Selcafe item names to reduce translation mistakes. |
| Copy-friendly normal order entry | Not required for ordinary F&B order entry.             |

---

## 16. Coupon and Discount Handling

Coupons/discounts are included in the first slice.

This corrects the earlier under-scoped draft.

### 16.1 Coupon Scope

| Coupon / discount type               |                        Include? |
| ------------------------------------ | ------------------------------: |
| PC usage discount                    |                             Yes |
| F&B discount                         |                             Yes |
| Combined PC + F&B discount           | Yes — best first pilot campaign |
| First registration coupon            |   Desired in broader coupon set |
| First PWA order coupon               |   Desired in broader coupon set |
| Loyalty-point coupon                 |   Desired in broader coupon set |
| Manual cashier-issued coupon         |   Desired in broader coupon set |
| Complex campaign tiers/subscriptions |                              No |
| Broad campaign engine                |                              No |

### 16.2 First Pilot Campaign

Recommended first campaign:

> Combined PC + F&B discount.

Suggested customer-facing message:

> Register and get PC usage and F&B discount.

### 16.3 Coupon Use Flow

| Step                 | Rule                                                                        |
| -------------------- | --------------------------------------------------------------------------- |
| Customer visibility  | Coupons should be visible in PWA before ordering.                           |
| Customer choice      | Customer chooses coupon in PWA.                                             |
| Price display        | PWA shows estimated total after coupon.                                     |
| Settlement authority | Cashier applies/records coupon manually in Selcafe/cashier session history. |
| Selcafe reference    | Cashier uses addition number or member number where needed.                 |
| Adeks status         | Applied, rejected, corrected.                                               |
| Rejection            | Customer sees simple “coupon not applied” message.                          |
| Multiple coupons     | Depends on campaign terms and conditions.                                   |
| Finality             | Coupon effect remains estimated until cashier settlement.                   |

### 16.4 Cashier Coupon Support

At settlement, cashier should see one copy-friendly message including:

* addition number;
* discount/coupon code;
* discount amount.

Manual marking in Adeks may still be needed for daily balance/admin checks, even if some coupon application can be inferred from Selcafe read data.

Open issue: exact written explanation required when cashier rejects a coupon.

---

## 17. Loyalty Handling

Loyalty is part of the confirmed operating slice.

This corrects the earlier under-scoped draft that deferred loyalty entirely.

### 17.1 Loyalty Scope

| Area                                | Rule                                                                                                                       |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Earning source                      | Settled PC usage and settled F&B usage.                                                                                    |
| Earn timing                         | After customer pays at cashier.                                                                                            |
| Pre-payment display                 | Estimated points.                                                                                                          |
| Post-payment display                | Earned PC points, earned F&B points, total earned for visit, updated loyalty balance, settled amount used for calculation. |
| Retroactivity                       | Guest order can earn loyalty if customer registers before final payment.                                                   |
| After-payment registration          | Earlier order should not earn retroactively if customer registers after payment.                                           |
| Cancelled order                     | Does not earn loyalty.                                                                                                     |
| Delivered then removed from Selcafe | Loyalty should also be removed/corrected.                                                                                  |
| Manual correction                   | Acceptable in Phase 1, but accuracy is important.                                                                          |
| Loyalty calculation basis           | Before coupon discount.                                                                                                    |
| Delay                               | Short delay after payment is acceptable.                                                                                   |
| Habit message                       | “Use points/coupon next visit.”                                                                                            |

### 17.2 Loyalty Habit Loop

Confirmed habit loop:

> Link addition → order F&B → see estimated total/points → pay cashier → see earned points/coupons → return next visit.

Most habit-forming display:

> Available coupons/discounts.

“Progress toward next discount” is later, not first launch.

---

## 18. Settlement and Final Amount Rules

### 18.1 Source of Truth

| Area                                | Rule                                                      |
| ----------------------------------- | --------------------------------------------------------- |
| Final amount owed                   | Selcafe only.                                             |
| PWA estimates                       | Estimated until cashier settlement.                       |
| Customer notice                     | Final amount confirmed at cashier.                        |
| Staff correction priority           | If PWA and Selcafe disagree, correct/check Selcafe first. |
| Final settled amount visibility     | Customer eventually sees settled amount in Adeks PWA.     |
| Settlement read method              | Adeks reads settled amount from Selcafe if possible.      |
| Manual final total entry into Adeks | Not acceptable as normal flow.                            |
| Settlement completion               | Adeks should infer settlement from Selcafe read data.     |

### 18.2 Missing-Order Handling

If Adeks PWA shows an order but Selcafe does not:

1. Cashier asks customer whether it was delivered.
2. If delivered, cashier enters it into Selcafe before settlement.
3. If not delivered, cashier removes/erases it from Adeks with a cause.

If Selcafe contains an item but customer says they did not order it in PWA:

1. Cashier checks with staff.
2. If it was ordered verbally, cashier explains to customer.
3. If customer insists, cashier removes it from Selcafe with written explanation.

### 18.3 Settlement Comparison

Minimum P1 support to prevent missed orders:

> Adeks / Selcafe settlement comparison.

Settlement check screen should compare:

* Adeks PWA orders;
* Selcafe F&B items;
* selected coupons;
* settled Selcafe final amount.

Do not include loyalty-to-be-earned in the cashier settlement comparison screen.

---

## 19. Estimate, Mismatch, and Calculation Trust

### 19.1 Estimate Rules

Before payment, PWA should show detailed calculation lines, not only one total.

Pre-payment estimates may include:

* PC usage;
* PWA F&B;
* all Selcafe F&B if readable;
* selected coupons;
* discount estimate;
* loyalty estimate.

All must be marked estimated.

### 19.2 Mismatch Threshold

| Area                             | Rule                                              |
| -------------------------------- | ------------------------------------------------- |
| Difference threshold             | Percentage-based, 2%.                             |
| Small differences                | Explain as estimated pricing.                     |
| Warning                          | Show warning above accepted difference threshold. |
| Must-match for launch            | Final settled amount.                             |
| Most dangerous calculation error | Final settled amount wrong.                       |

### 19.3 Calculation Failure

Wrong final settled amount, wrong Selcafe data, wrong addition/table matching, or wrong calculations can make the pilot not worth continuing.

---

## 20. Wrong Receipt / Wrong Table / Relinking

### 20.1 Likely Failure

Most likely linking failure:

> Customer mistypes `fiş numarası`.

### 20.2 Confirmation Rule

After entering/scanning `fiş numarası`, PWA should show table number and require confirmation.

Ordering is blocked until confirmation.

### 20.3 Relinking Rule

| Situation                                            | Rule                                                                                              |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| Customer wants to unlink/relink before placing order | Not allowed as free customer action.                                                              |
| Customer wants to relink after placing order         | Cashier required.                                                                                 |
| Wrong `fiş` but wrong table confirmed                | Cashier handles correction.                                                                       |
| Wrong table shown                                    | Tell customer to ask cashier.                                                                     |
| Addition not found                                   | Tell customer to ask cashier.                                                                     |
| Customer physically changes table                    | PWA should follow the addition and show new table immediately, based on Selcafe read if possible. |

### 20.4 Rollback Principle

If wrong addition/table assignment occurs:

> Complete rollback and assignment to the correct addition number is mandatory.

This is an operating principle, not a technical transaction design.

---

## 21. Staff Exception Handling

| Exception                           | Handling                                                                |
| ----------------------------------- | ----------------------------------------------------------------------- |
| Item unavailable                    | Cashier calls/asks customer or service staff.                           |
| Unclear modifier/instruction        | Cashier asks service staff to clarify.                                  |
| Duplicate PWA order                 | Cashier asks customer/staff; system should warn about likely duplicate. |
| Customer verbally changes PWA order | Cashier and customer analyze together.                                  |
| Customer cancellation               | Customer can cancel before accepted.                                    |
| Cashier cancellation                | Cashier can cancel.                                                     |
| Cancellation reason                 | Required.                                                               |
| Cancellation reason visibility      | May be visible to customer.                                             |
| Staff-to-customer custom notes      | Not in Phase 1.                                                         |
| Customer communication              | Verbal for Phase 1, plus simple PWA statuses.                           |

Simple PWA messages should include:

* Order received;
* Order accepted;
* Order cancelled;
* Please contact cashier;
* Final amount confirmed at cashier.

---

## 22. Pilot Boundary

### 22.1 Pilot Scope

| Area                                | Decision                                                        |
| ----------------------------------- | --------------------------------------------------------------- |
| Physical scope                      | All tables/PCs.                                                 |
| Table types                         | Both PC tables and non-PC café tables.                          |
| First users                         | Known regular customers.                                        |
| Rollout style                       | Soft start with selected customers.                             |
| Guest use                           | Allowed.                                                        |
| Queue watcher                       | Main cashier only.                                              |
| Manager/trusted cashier restriction | Not required.                                                   |
| Kitchen/preparation                 | Continue normally from Selcafe printed receipts only.           |
| Menu                                | Full F&B menu.                                                  |
| Modifiers                           | Included from start.                                            |
| Unavailable item control            | Cashier handles manually; admin can hide/unhide items in Adeks. |
| Coupons                             | Included immediately.                                           |
| First coupon campaign               | One simple combined PC + F&B discount.                          |

### 22.2 First-Week Success Signal

Primary success signal:

> Repeat PWA usage.

Additional useful signals:

* linked additions;
* PWA F&B orders;
* coupon usage;
* fewer missed Selcafe entries;
* fewer verbal orders;
* staff feedback.

### 22.3 Main Pilot Risks

| Risk                            | Why it matters                          |
| ------------------------------- | --------------------------------------- |
| Customer fails to link addition | Biggest pilot risk.                     |
| Wrong Selcafe data              | Can destroy trust.                      |
| Wrong addition/table matching   | Can create wrong order/settlement.      |
| Wrong calculations              | Can undermine launch.                   |
| Cashier forgets Selcafe entry   | Current core problem remains unsolved.  |
| Coupon confusion                | Can create customer dispute.            |
| Staff overload                  | May make the slice not worth operating. |

---

## 23. Pilot Pause and Admin Check Rules

### 23.1 Pause Triggers

Any of the following can pause the pilot:

* wrong `fiş`/table match;
* wrong final settled amount;
* repeated failed linking;
* missed PWA orders;
* coupon misapplication;
* customer complaints;
* staff overload.

### 23.2 Pause Authority

Kerem decides whether to pause.

### 23.3 Tolerance

| Cause                          | Tolerance                                                      |
| ------------------------------ | -------------------------------------------------------------- |
| Software-related serious issue | One serious confirmed case is enough to pause.                 |
| Human-related issue            | Some tolerance is acceptable depending on cause and frequency. |

### 23.4 Admin Daily Check

During first week, admin/back-office should check:

* all disputed orders;
* ten random orders.

Check scope:

* coupon application;
* final settled amount.

Results should be summarized for Kerem.

---

## 24. What Must Remain Strict

| Area                                     | Strict boundary                                               |
| ---------------------------------------- | ------------------------------------------------------------- |
| Selcafe write posture                    | No direct Adeks writes to Selcafe SQL Server in Phase 1.      |
| Settlement ownership                     | Selcafe/cashier remains source of truth.                      |
| Final payment                            | Cashier only.                                                 |
| PWA payment                              | Excluded.                                                     |
| Wallet spending/payment                  | Excluded from this operating slice.                           |
| Final bill calculation                   | PWA does not own final bill.                                  |
| Manual settlement total entry into Adeks | Not acceptable as normal flow.                                |
| Kitchen workflow                         | Kitchen works from Selcafe printed receipts, not PWA screens. |
| Delivery tracking                        | Excluded from first slice.                                    |
| Custom staff messaging                   | Excluded; verbal communication remains.                       |
| Customer self-seat-change                | Excluded.                                                     |
| Reservation automation                   | Excluded from this first slice.                               |
| Complex campaigns/tiers/subscriptions    | Excluded.                                                     |
| Real data                                | Prohibited in docs, examples, AI sessions, tests, prototypes. |
| Implementation                           | This document does not authorize Pod C.                       |
| Methodology                              | This document does not rewrite pod behavior or methodology.   |

---

## 25. What Can Be Explored Loosely With Synthetic Data

The following can be explored with synthetic examples:

* `fiş numarası` entry;
* receipt barcode/OCR linking;
* table confirmation screen;
* “Yes, this is my table” flow;
* wrong `fiş` / ask-cashier flow;
* addition-linked session view;
* PC start/stop/duration/cost estimates;
* F&B item list from Selcafe;
* PWA order submission;
* cashier received queue;
* accepted + preparing inference;
* coupon selection;
* estimated total after coupon;
* settled amount display;
* loyalty pending/earned display;
* settlement comparison;
* wrong-table rollback;
* disputed order review;
* ten-random-order admin check.

Synthetic example:

> Customer A receives receipt `FIŞ-000123` at table `T-12`. Customer A opens Adeks PWA, registers by phone, enters `FIŞ-000123`, sees table `T-12`, confirms “Yes, this is my table,” sees estimated PC usage and existing F&B items, chooses a combined PC + F&B discount, orders tea and toast, waits while cashier enters the order into Selcafe, pays at cashier, then sees settled amount and earned points after payment.

---

## 26. What Must Not Proceed Yet

Do not proceed yet with:

* Pod C implementation issues;
* schema design;
* API contracts;
* ADR drafting;
* direct Selcafe write design;
* wallet payment/spending design;
* online payment design;
* settlement ownership by Adeks;
* kitchen-facing PWA screens;
* delivery tracking;
* reservation automation;
* complex campaign/tier/subscription model;
* full Selcafe member synchronization;
* methodology rewrite;
* pod-instruction rewrite;
* real customer/staff/transaction/Selcafe examples.

---

## 27. Repo Tensions to Reconcile Later

| Tension                                                                                                                                      | Why it matters                                                                                |
| -------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| Current docs may treat F&B ordering as login-gated, while discovery includes guest/addition flow and registration-driven habit               | Requires product-scope reconciliation.                                                        |
| Campaigns/promotions may currently be outside Phase 1 MVP, but this slice requires PC + F&B discount/coupon as habit driver                  | Requires MVP/business-rule reconciliation.                                                    |
| Current docs may emphasize F&B order submission, while this slice requires Selcafe-linked visibility and settlement comparison               | Requires flow and scope update.                                                               |
| Phase 2 previously held richer PC/session visibility, but this slice requires PC start/stop/cost estimate in Phase 1 if Selcafe read permits | Requires explicit scope reconciliation and Pod B feasibility review later.                    |
| Loyalty earning from PC + F&B settlement is central to habit loop                                                                            | Requires later Pod B review for ledger/accuracy/correction; no implementation authority here. |
| Coupon/manual discount affects settlement but must be manually entered in Selcafe                                                            | Requires careful business-rule and audit definition later.                                    |
| Guest use vs Adeks account requirement remains semantically unclear                                                                          | Needs Kerem wording: guest as non-Selcafe member, anonymous user, or pre-registration flow.   |

---

## 28. Open Questions for Kerem

| ID      | Question                                                                                                                | Current working assumption                                                                                                   |
| ------- | ----------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| OSD-001 | Does “guest use” mean anonymous ordering, non-Selcafe-member ordering, or pre-registration browsing/linking?            | Non-Selcafe-member and/or addition-linked use is allowed; loyalty/coupon/history require Adeks account before final payment. |
| OSD-002 | Should every PWA order require Adeks account, or can a pure addition-only guest submit an order?                        | Account is target habit flow; addition-only may be pilot fallback.                                                           |
| OSD-003 | What exact Turkish wording should replace “addition”?                                                                   | `fiş` or `fiş numarası`.                                                                                                     |
| OSD-004 | What should be the exact customer copy when addition lookup fails?                                                      | “Please ask cashier/staff.”                                                                                                  |
| OSD-005 | What exact coupon rejection reasons should cashier choose from?                                                         | Open.                                                                                                                        |
| OSD-006 | Should cashier manually mark coupon applied/rejected/corrected in Adeks for every coupon, or only when inference fails? | Manual marking may be needed for daily balance/admin check.                                                                  |
| OSD-007 | What exact loyalty formula applies to settled PC + F&B usage?                                                           | Not defined in this discovery artifact.                                                                                      |
| OSD-008 | Does 2% mismatch threshold apply to estimated total vs Selcafe current total, or only before final settlement?          | Working assumption: pre-settlement estimate warning threshold; final settled amount must match.                              |
| OSD-009 | How should immediate table-change visibility work if Selcafe read has a one-minute refresh cadence?                     | Open; customer manual refresh and/or faster update may be needed.                                                            |
| OSD-010 | What exact admin report cadence should summarize disputed + ten random orders for Kerem?                                | First week daily is implied but not fully locked.                                                                            |

---

## 29. Whether a Later Methodology or Pod-Behavior Change Appears Necessary

Current finding:

> A methodology or pod-behavior rewrite does not appear necessary yet.

The immediate correction is to model the operating slice more completely and then reconcile product scope around that slice.

The project may feel over-governed because components were governed before the operating model was coherent. The remedy is not to remove gates. The remedy is to anchor gates to a confirmed café operating spine.

A methodology or pod-behavior change should only be considered later if the existing process continues to push pods into component-level work before operating-slice clarity exists.

---

## 30. Later Pod B Review Question If Methodology/Pod Behavior Change Appears Necessary

No Pod B routing is triggered by this document yet.

If Kerem later decides a methodology or pod-behavior change may be needed, the narrow Pod B review question should be:

> Does the current Adeks methodology need a lightweight “Operating Slice Discovery” checkpoint before component-level ADRs, API/schema design, and implementation issue drafting, so that architecture and governance decisions are anchored to a confirmed end-to-end café operating model?

This question should be reviewed later only if Kerem decides the operating-slice modeling result exposes a repeatable process gap.

---

## 31. Review Routing

| Route                                                | Status                                                                                                                                                 |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Ready for commit                                     | No — revised draft for Kerem review first                                                                                                              |
| Requires Kerem approval                              | Yes                                                                                                                                                    |
| Requires Pod B review now                            | No                                                                                                                                                     |
| Requires Pod B review later                          | Yes, after Kerem approves this as the discovery spine, especially for Selcafe read feasibility, loyalty/coupon correctness, audit, and data boundaries |
| Requires Pod C implementation                        | No                                                                                                                                                     |
| Requires Pod D prototype/audit/monitoring review now | No                                                                                                                                                     |
| Creates implementation authority                     | No                                                                                                                                                     |
| Changes methodology or pod behavior                  | No                                                                                                                                                     |
| Uses real data                                       | No                                                                                                                                                     |
