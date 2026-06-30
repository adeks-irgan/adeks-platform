# Scope Reconciliation Packet — Operating Spine Alignment

## Status

| Field | Value |
|---|---|
| Document | `SCOPE_RECONCILIATION_OPERATING_SPINE_ALIGNMENT_v0.1.md` |
| Target path | `/docs/planning/SCOPE_RECONCILIATION_OPERATING_SPINE_ALIGNMENT_v0.1.md` |
| Owner | Pod A — Product & Planning |
| Reviewer | Pod B — Architecture, Logic & Risk for Selcafe, wallet, loyalty, audit, security, KVKK, schema/API, and ADR-impacting implications |
| Approver | Kerem |
| Current status | Kerem-approved scope/business-rule reconciliation direction; post-Pod-B-review KD-1/KD-2 constraints recorded; not implementation-ready |
| Approval date | 2026-06-28 |
| Post-review gate | K-21 locks product direction only. ADR-005 read-surface expansion, KVKK/legal review, auditability, retention, and data-minimization review remain required before any implementation issue can exist. |
| Implementation status | Does not authorize Pod C implementation |
| Data rule | Synthetic examples only; no real customer, phone, wallet, loyalty, transaction, reservation, staff, screenshot, Selcafe row data, credentials, or secrets |
| Methodology status | Does not change methodology or pod behavior |

---

> **SUPERSEDED POINTER - K-OS-009 QR handshake:** This planning artifact is retained as historical input for K-21. Any typed-`fiş` link, customer table-confirmation, or standalone "addition-only guest" framing in the body is superseded by K-OS-009 and `docs/planning/SESSION_LINKING_QR_HANDSHAKE_DESIGN_v0.1.md`. The current Phase 1 customer-facing app session-linking path is the desk-side, one-time QR handshake: no typed/scanned `fiş` entry exists in the Customer PWA; the QR handshake establishes the PC/session binding; guests may order F&B and see the full live bill without an account; an account is required only for discounts, coupons, and points. Do not rewrite the body when preserving this artifact as K-21 decision-index context.

## 1. Situation

Kerem approved `OPERATING_SLICE_DISCOVERY_v0.1.md` as the provisional Product Phase 1 operating-model spine.

This packet records the approved scope and business-rule reconciliation decisions that align current Phase 1 product planning around that spine.

Pod B review of PR #105 identified that the approved operating spine implies active Selcafe visit/bill/order-line reads that ADR-005 currently hard-excludes. Kerem resolved the product direction through constrained KD-1 Option B: Product Phase 1 should target a Selcafe-sourced active visit/bill/order-line view for the active `fiş` / visit, but Selcafe member identity/profile reads remain excluded.

This product direction does not authorize implementation and does not override ADR-005 by wording alone. ADR-005 read-surface expansion, KVKK/legal review, auditability, retention, and data-minimization review remain required before any implementation issue can exist.

This document does not authorize Pod C implementation.

This packet does not authorize:

- Pod C implementation;
- schema design;
- API contracts;
- ADR drafting;
- direct Selcafe write access;
- wallet/payment implementation;
- use of real customer/staff/transaction/Selcafe data;
- methodology or pod-instruction changes.

---

## 2. Approved Operating Spine

**Approved spine:** Selcafe-linked customer visibility and ordering.

Customer registers or uses a permitted guest/addition flow, links the current Selcafe visit through `fiş / fiş numarası`, confirms the table, views Selcafe-linked visit information, orders F&B from the PWA, and the cashier manually enters accepted orders into Selcafe.

Kitchen/service continue from Selcafe printed receipts.

Customer sees estimated PC + F&B totals plus coupon/points information before payment.

Final payment happens at cashier.

Adeks reads the final settled amount from Selcafe and updates settled amount, coupon status, and loyalty history after payment.

Phase 1 remains read-only toward Selcafe; Selcafe remains the settlement source of truth for this operating spine.

Post-review clarification: the approved spine is a **product direction**. It remains provisional for feasibility, risk, and compliance review. Active visit/bill/order-line visibility is desired for the first operating spine, including cashier/staff-entered F&B items for the active `fiş` / visit, but this remains gated by ADR-005 read-surface reconciliation and KVKK/legal review. Selcafe member identity/profile data must not be read or displayed as part of this Phase 1 operating spine.

---

## 3. Approved Reconciliation Decisions

| ID | Decision | Scope effect | Later review |
|---|---|---|---|
| K-OS-001 | Addition-only guest may order. Coupon, loyalty, and settled visit history require Adeks account binding before final settlement. | Reconciles guest/addition flow with registration habit. | Pod B for auth, KVKK, audit, abuse boundary. |
| K-OS-002 | Include customer-visible PC start/stop/duration/cost estimates if Selcafe read quality is reliable. Hide financial estimates if unreliable. KD-2 clarifies this supersedes/subsumes K-20 PI-1 only for customer-visible PC/session estimates inside this approved operating spine. | Makes Selcafe-linked visit visibility part of the Product Phase 1 spine. | Pod B for Selcafe read feasibility, freshness, matching, calculation trust, and K-20/K-21 consistency. |
| K-OS-003 | Keep broader F&B lifecycle as internal/later expansion, but simplify first-slice customer-facing status. | First-slice UX should not promise delivery tracking. | Pod B to reconcile accepted lifecycle model with first-slice behavior. |
| K-OS-004 | Include one simple combined PC + F&B coupon/discount. Exclude campaign engine, complex campaigns, tiers, and subscriptions from this operating spine. | Adds a simple habit-driver coupon while preserving campaign exclusion. | Pod B for settlement, audit, coupon status, rejection/correction, KVKK. |
| K-OS-005 | Loyalty product target is F&B + PC/session earning after settlement. F&B formula remains locked by K-18; PC/session earning requires later Pod B review and falls back to F&B only if data is unreliable. | Adds PC/session loyalty target to the spine without implementation authority. | Pod B for ledger, correction, Selcafe settlement data, KVKK. |
| K-OS-006 | Exclude wallet payment/spending from this operating spine only. Wallet visibility/top-up may remain separate Phase 1 scope behind existing gates. | Keeps spine cashier-payment-first and Selcafe-settlement-first. | Pod B only when separate wallet scope proceeds. |
| K-OS-007 | Approve 2% pre-settlement mismatch threshold, pilot pause triggers, and first-week admin/back-office checks. | Adds pilot trust controls. | Pod B for monitoring, audit, alerting, threshold mechanics. |
| KD-1 | Constrained Option B: target Selcafe-sourced active visit/bill/order-line visibility for the active `fiş` / visit, including cashier/staff-entered F&B items not submitted through Adeks PWA. Selcafe member identity/profile reads remain excluded. | Keeps the product spine aligned with the customer-visible live bill need while preserving the ADR-005/KVKK gate. | Pod B + Kerem + legal/KVKK before any implementation issue; likely ADR-005 reconciliation required. |

---

## 4. Product-Scope Reconciliation

| Area | Reconciled Product Phase 1 position |
|---|---|
| Account vs guest | Account is the target path. Addition-only guest ordering is permitted, but coupon, loyalty, and settled visit history require account binding before final settlement. |
| Main session link | `fiş / fiş numarası` is the main customer-facing visit link. “Addition” should not be the primary customer-facing word. |
| Table confirmation | Customer must confirm the displayed table before ordering. Wrong or unknown table blocks ordering and routes customer to cashier. |
| Selcafe-linked visibility | Customer may see Selcafe-linked active visit/bill/order-line data where read-surface approval and read reliability support it. This is product direction only and does not override ADR-005. |
| PC estimate visibility | PC start/stop/duration/cost estimates are included only if reliable. KD-2 clarifies this supersedes/subsumes K-20 PI-1 only for customer-visible PC/session estimates inside this operating spine. |
| F&B ordering | Customer may order from seat after `fiş` link and table confirmation. |
| Manual Selcafe bridge | Cashier manually enters accepted PWA orders into Selcafe. No direct Adeks write to Selcafe is authorized. |
| Kitchen/service | Kitchen/service continue from Selcafe printed receipts. No kitchen-facing PWA workflow in the first operating slice. |
| Customer F&B status | First-slice customer status is simplified. “Accepted + Preparing” means cashier successfully entered the order into Selcafe. No delivered tracking in first-slice UX. |
| Coupon | One simple combined PC + F&B coupon/discount is included. Complex campaign engine, tiers, and subscriptions are excluded. |
| Loyalty | Target is earning after settlement on F&B + PC/session usage. F&B formula remains locked by K-18. PC/session formula and reliability require Pod B review. |
| Wallet payment/spending | Excluded from this operating spine. Wallet visibility/top-up may remain separate Phase 1 scope behind existing gates. |
| Final settled amount | Selcafe final settled amount is the source of truth. Customer-visible final-settlement comparison is desired for the active `fiş` / visit, but remains blocked on ADR-005 read-surface expansion, KVKK/legal review, auditability, retention, and data-minimization review. |
| Settlement comparison | Staff/admin and customer-facing comparison should support PWA orders, Selcafe-entered F&B order lines, selected coupon, and final Selcafe settled amount where later approved. This requires Pod B review and likely ADR-005 reconciliation before implementation. |
| Selcafe member identity/profile | Excluded. The operating spine must not read or display Selcafe member identity/profile data. This exclusion does not by itself resolve the ADR-005 read-surface conflict for active bill/order-line data. |
| Reservation automation | Excluded from this operating spine. Staff-approved reservation requests remain separate Phase 1 scope. |
| Delivery tracking | Excluded from first operating slice. |
| Campaigns/subscriptions | Complex campaigns, tiers, subscriptions, and broad ARPU campaign modeling are excluded from this operating spine. |

---

## 5. Business-Rule Reconciliation

| Rule area | Reconciled Phase 1 rule |
|---|---|
| Account vs guest order boundary | Addition-only guest may order after `fiş` link and table confirmation. Account binding before final settlement is required for coupon, loyalty, and settled visit history. |
| Coupon eligibility | One simple combined PC + F&B coupon/discount is included. Exact eligibility remains to be finalized before implementation. |
| Coupon rejection/correction | Cashier may mark coupon applied, rejected, or corrected. Exact reason list and inference/manual-marking rule require later definition. |
| Loyalty earning timing | Loyalty earns after cashier payment/settlement. |
| Loyalty calculation basis | F&B uses locked K-18 formula. PC/session earning is product target only until Pod B validates data and ledger implications. |
| Loyalty correction | Removed/corrected Selcafe item should result in loyalty correction through append-only logic, not balance overwrite. |
| Estimate wording | Pre-payment totals must be labeled estimated. Recommended placeholder: “Estimated. Final amount confirmed at cashier.” |
| Final amount source | Final settled amount comes from Selcafe. |
| 2% mismatch threshold | 2% is approved as pre-settlement estimate warning threshold. Final settled amount must still match Selcafe. |
| Cashier order acceptance | “Accepted + Preparing” means cashier successfully entered the PWA order into Selcafe. |
| Cancellation reason | Cashier/staff cancellation requires reason. Exact reason taxonomy and customer visibility remain open. |
| Wrong `fiş` / wrong table | Unknown `fiş`, wrong table, or failed confirmation blocks ordering and tells customer to ask cashier. Casual customer relinking is not allowed. |
| Pilot pause triggers | Kerem may pause pilot for wrong `fiş`/table match, wrong final settled amount, repeated failed linking, missed PWA orders, coupon misapplication, customer complaints, or staff overload. |
| Software vs human tolerance | One serious confirmed software-related case may be enough to pause. Human-related issues have tolerance depending on cause/frequency. |
| First-week admin check | During first week, admin/back-office checks all disputed orders plus ten random orders; check coupon application and final settled amount; summarize for Kerem. |

---

## 6. Later Pod B Review Package

After product documents are reconciled, Pod B should review:

| Review topic | Later Pod B question |
|---|---|
| Selcafe read feasibility and fields | Can read-only Selcafe safely support active `fiş` / visit, bill/order-line, PC timing/cost estimate, F&B items, quantities, prices, coupons where visible, and final settled amount without reading/displaying Selcafe member identity/profile data? What ADR-005 read-surface expansion, KVKK/legal, auditability, retention, and data-minimization work is required first? |
| ADR-005 reconciliation gate | What exact ADR-005 read-surface change, if any, is required for active visit/bill/order-line visibility, and what must remain hard-excluded? |
| Addition/table matching risk | How should wrong `fiş`, stale table, table movement, and relinking be handled safely and auditably? |
| Estimate/final settlement trust boundary | How should estimates be calculated, hidden, warned, refreshed, and distinguished from final Selcafe settlement? |
| Coupon/audit implications | What evidence and audit trail are required for applied/rejected/corrected coupon status? |
| Loyalty ledger/correction implications | How should F&B + PC/session loyalty earning and corrections work under append-only ledger constraints? |
| KVKK/customer-data implications | What data inventory, legal basis, retention, access-control, and audit updates are required for visit linking and Selcafe-derived display? |
| Cashier manual bridge | What audit events and risk controls are required when cashier receives PWA order and manually enters it into Selcafe? |
| Mismatch threshold and pilot pause rules | How should the 2% warning threshold, pause triggers, and first-week checks be represented in audit, monitoring, staff workflow, and review outputs? Pod B owns risk/audit architecture; Pod D should later review monitoring/UX/operational visibility where relevant. |

Do not ask Pod B to design schema, API contracts, or ADRs from this packet alone.

---

## 7. What Must Not Proceed

Do not proceed from this packet with:

- Pod C implementation;
- schema design;
- API contracts;
- ADR drafting;
- direct Selcafe write design;
- wallet/payment implementation;
- online payment implementation;
- kitchen-facing PWA workflow;
- delivery tracking;
- reservation automation;
- complex campaign/tier/subscription model;
- real customer/staff/transaction/Selcafe examples;
- methodology rewrite;
- pod-instruction rewrite.

---

## 8. Review Routing

| Route | Status |
|---|---|
| Ready for commit | Yes, as a Kerem-approved planning/reconciliation packet. |
| Requires Kerem approval | Approval recorded in session on 2026-06-28; repo merge remains Kerem-only. |
| Requires Pod B review now | No. |
| Requires Pod B review later | Yes, after product docs are reconciled and before architecture/design or implementation-readiness work. |
| Requires Pod C implementation | No. |
| Requires Pod D prototype/audit/monitoring review | Not now; later for PWA flow prototype/audit if Kerem requests. |
| Creates implementation authority | No. |
| Changes methodology or pod behavior | No. |
| Uses real data | No. |
