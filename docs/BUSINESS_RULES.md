# BUSINESS_RULES.md

## Status

| Field | Value |
|---|---|
| Document | BUSINESS_RULES.md |
| Version | v0.5 operating-slice checkpoint cleanup — 2026-07-01 |
| Owner | Pod A — Product & Planning |
| Reviewer | Pod B — Architecture, Logic & Risk |
| Approver | Kerem |
| Current status | Reconciled with merged QR-handshake session-linking design for the Product Phase 1 operating spine; BR-FB account-boundary contradiction corrected against BR-OS-003; not implementation-ready |
| Scope of this version | Documentation-only business-rule reconciliation. Establishes no implementation authority. |
| Target repo path | `/docs/BUSINESS_RULES.md` |

## Freshness Baseline

| Source | Version / SHA / status read | Date read | Use in this draft |
|---|---:|---:|---|
| `/docs/AGENT_CONTEXT_MANIFEST.md` | SHA `47ba17e` | 2026-06-11 | Confirmed required source files and review routing. |
| `/docs/PROJECT_METHODOLOGY.md` | SHA `d3355d0`; v0.8 | 2026-06-11 | Confirmed Pod A/Pod B/Pod C responsibilities and sensitive-review gates. |
| `/docs/PROJECT_DECISION_INDEX.md` | SHA `0bbb3fd` | 2026-06-11 | Confirmed ADR-015 Accepted, SMS provider not locked, ADR-005/006/007 backlog/stub state. |
| `/docs/CORE_USER_FLOWS.md` | SHA `6fe9b2f`; v0.3 | 2026-06-11 | Confirmed OTP send-failure UX fallback and notice/SMS open items. |
| `/docs/architecture/AUTH_THREAT_MODEL.md` | SHA `df9b30b`; v0.4 Accepted, BL-2 closed | 2026-06-11 | Baseline for audit/security questions and auth readiness. |
| `/docs/decision-support/SMS_PROVIDER_REPORT.md` | SHA `27892d4`; v0.1 decision-support | 2026-06-11 | Confirms provider report exists and provider decision remains Kerem-owned. |
| `/docs/KEREM_DECISIONS.md` | SHA `47eaa47`; v1.4 | 2026-06-11 | Confirms K-13/K-14/K-15/K-16 locked state. |
| Attached v0.1 packet + Pod B triage / final confirmation | v0.1 packet; "Safe with corrections"; final confirmation received per PR context | 2026-06-11 | Baseline and required correction list; Pod B confirmed safe for Kerem decision-prep and documentation-class commit after Kerem approval. |

## Purpose

This document separates confirmed Phase 1 business rules from unresolved questions requiring Kerem decision and Pod B review.

This document is **decision-prep only**. This document does not authorize Pod C implementation. It does not select an SMS provider, does not resolve legal/KVKK questions, does not create Pod C implementation issues, and does not approve implementation.

Phase 1 remains read-only toward Selcafe; Selcafe remains the settlement source of truth for this operating spine.

## Known Business Rules Already Confirmed

| ID | Area | Rule | Status / Routing |
|---|---|---|---|
| BR-AUTH-001 | Customer auth | Phase 1 customer authentication is Phone OTP (SMS). | Confirmed by ADR-015/K-13. SMS provider selection remains unresolved. |
| BR-AUTH-002 | Google login | Google login is deferred to Phase 2. | Confirmed. |
| BR-AUTH-003 | Staff credentials | CASHIER, FB_STAFF, and ADMIN use individual accounts; shared staff credentials are prohibited. | Confirmed. |
| BR-AUTH-004 | Admin MFA | ADMIN requires TOTP MFA. | Confirmed. |
| BR-AUTH-005 | Cashier inactivity | CASHIER session inactivity timeout is 40 minutes. | Confirmed. |
| BR-AUTH-006 | Auth threat model | `AUTH_THREAT_MODEL.md` is v0.4 Accepted and BL-2 is closed. | Confirmed; does not authorize Pod C. |
| BR-AUTH-007 | OTP send-failure UX | If OTP cannot be sent, customer sees neutral failure copy; no completed account is created; raw phone is not retained persistently; unsuccessful attempt is audited with derived identifier only. | Resolved by `CORE_USER_FLOWS.md` §3.5.3. Do not reopen. |
| BR-ROLE-001 | Phase 1 roles | Phase 1 roles are CUSTOMER, CASHIER, FB_STAFF, ADMIN. MANAGER is deferred. | Confirmed. |
| BR-ROLE-002 | FB_STAFF scope | FB_STAFF handles orders only and must not handle payment, wallet, or loyalty. | Confirmed. |
| BR-PAY-001 | Payment | Phase 1 payment is cashier-only. | Confirmed. |
| BR-PAY-002 | Online payment | Online payment is excluded from Phase 1 and planned for Phase 2. | Confirmed. |
| BR-WALLET-001 | Wallet visibility | CUSTOMER can view own wallet status after login. | Confirmed. |
| BR-WALLET-002 | Wallet top-up | CASHIER and ADMIN can top up wallets. CUSTOMER and FB_STAFF cannot. | Confirmed. |
| BR-WALLET-003 | Wallet self top-up | Customer self-service wallet top-up is excluded from Phase 1. | Confirmed. |
| BR-WALLET-004 | Wallet ledger | Wallet must use append-only ledger logic; no direct balance overwrite. | Confirmed principle; [REQUIRES POD B REVIEW]. |
| BR-WALLET-005 | Wallet top-up threshold | No approval threshold is enforced in Phase 1; ADMIN receives daily top-up report as compensating control. | Confirmed by K-13/KD-F; report fields unresolved. |
| BR-WALLET-006 | Cashier phone display | Cashier sees masked customer phone number with last 4 digits during top-up. | Confirmed. |
| BR-LOYALTY-001 | Loyalty visibility | CUSTOMER can view own loyalty status after login. | Confirmed. |
| BR-LOYALTY-002 | Loyalty earning | Loyalty earning happens automatically on eligible purchases. | Confirmed intent; F&B accrual formula resolved by K-18 (see BR-LOYALTY-FB-001). Non-F&B eligibility/formula and broader loyalty rules remain unresolved. |
| BR-LOYALTY-003 | Loyalty redemption actor | Loyalty redemption is handled by CASHIER/ADMIN in Phase 1. | Confirmed. |
| BR-LOYALTY-004 | Loyalty self-redemption | Customer self-redemption is excluded from Phase 1. | Confirmed. |
| BR-LOYALTY-005 | Loyalty ledger | Loyalty must use append-only ledger logic; no direct balance overwrite. | Confirmed principle; [REQUIRES POD B REVIEW]. |
| BR-FB-001 | F&B order submission | A QR-linked guest/customer can submit F&B orders from seat in the K-21 operating spine. Account context is not required for F&B order submission; see BR-OS-003 for the operating-spine account boundary and live-bill visibility rule. | Confirmed by K-21/K-OS-009 as product direction. [REQUIRES POD B REVIEW] for auth/KVKK/audit/abuse boundary. Does not authorize Pod C. |
| BR-FB-002 | F&B fulfillment | FB_STAFF can receive/update order fulfillment status and mark delivered; payment remains CASHIER/ADMIN only. | Confirmed. |
| BR-FB-003 | Customer-visible F&B order statuses | Phase 1 customer-visible statuses are: Submitted, Accepted, Preparing, Ready / On the way, Delivered, Rejected, Cancelled. | Confirmed by Kerem F&B order lifecycle decision packet; [REQUIRES POD B REVIEW] for state transitions, actors, and audit points. |
| BR-FB-004 | Customer cancellation | CUSTOMER can cancel an order until the order reaches Preparing. [CONFIRMED by Kerem, 2026-06-12 F&B lifecycle decision packet] "Until Preparing" means cancellation is allowed before the order enters Preparing, not after Preparing has started. | Confirmed by Kerem. [REQUIRES POD B REVIEW] for exact transition boundary and cancellation effects. |
| BR-FB-005 | Staff rejection | Staff can reject before accepting if an item is unavailable or the order is invalid. | Confirmed by Kerem. Every rejection requires an audit reason. [REQUIRES POD B REVIEW]. |
| BR-FB-006 | Staff cancellation | Staff can cancel after acceptance only with a required reason. | Confirmed by Kerem. Every cancellation requires an audit reason. [REQUIRES POD B REVIEW]. |
| BR-FB-007 | Unavailable item handling | If an item becomes unavailable after order submission, staff marks the item unavailable and the order is Rejected. The customer submits a new order. | [RESOLVED by Kerem, 2026-06-12: item unavailability = full order Rejected, new order required. Pod B to formalize audit point and customer-visible copy.] |
| BR-FB-008 | Payment visibility | Customer sees a combined customer-facing order/payment status in Phase 1. | Confirmed by Kerem. Payment remains cashier-only; FB_STAFF does not handle payment; online payment remains excluded from Phase 1. [REQUIRES POD B REVIEW] for combined status model. |
| BR-FB-009 | F&B lifecycle design guardrail | Pod B must later formalize F&B state transitions, actors, audit points, cancellation boundaries, and any reversal logic. | Confirmed routing. Does not authorize Pod C. |
| BR-FB-010 | F&B wallet payment | Café wallet balance may be used to settle F&B orders in Phase 1. Payment is cashier-mediated; the wallet debit is recorded by CASHIER/ADMIN at the time of delivery/settlement. No wallet hold is created at order submission. | Confirmed by Kerem, 2026-06-12. [REQUIRES POD B REVIEW] for ledger entry design and combined payment/order display model. |
| BR-FB-011 | F&B loyalty accrual | F&B purchases accrue loyalty points in Phase 1. Accrual trigger: CASHIER records wallet payment/settlement for the order. Cancelled and rejected orders do not accrue loyalty. | Confirmed by Kerem, 2026-06-12. [REQUIRES POD B REVIEW] for loyalty ledger append event design. |
| BR-LOYALTY-FB-001 | F&B loyalty accrual formula | F&B accrual formula (resolved by K-18, 2026-06-14): `floor(0.10 × settled_amount_TRY)` = `floor(settled_kuruş / 1000)`. 10% of settled F&B amount, rounded down to whole loyalty points. Examples: ₺100→10 pts, ₺157→15 pts, ₺99→9 pts. Accrual trigger: cashier recording payment settlement. | Locked by K-18 (Kerem, 2026-06-14). [REQUIRES POD B REVIEW] for ledger append event and precision implementation. Does not authorize Pod C. |
| BR-RES-001 | Reservation request | Logged-in CUSTOMER can submit reservation requests. | Confirmed. |
| BR-RES-002 | Reservation approval | CASHIER and ADMIN can approve/reject reservations. | Confirmed. |
| BR-RES-003 | Automatic confirmation | Excluded from Phase 1; Phase 2 candidate after reliable PC/session status. | Confirmed. |
| BR-AUDIT-001 | Audit log coverage | Wallet, loyalty, payment, customer data, F&B order status, reservation approval/rejection, staff account actions, and sensitive admin access require audit records. | Confirmed product rule; [REQUIRES POD B REVIEW]. |
| BR-AUDIT-002 | Audit immutability | No Phase 1 role may edit or delete audit logs. | Confirmed. |
| BR-AUDIT-003 | Auth audit baseline | Authentication audit requirements must build on the Accepted auth threat model baseline. | Confirmed baseline; [REQUIRES POD B REVIEW]. |
| BR-KVKK-001 | Synthetic data | Documentation, examples, fixtures, screenshots, tests, and UAT data must be synthetic only. | Confirmed. |
| BR-PRIVACY-001 | Notice before OTP | Aydınlatma Metni acknowledgment is required before OTP send. | Confirmed product flow; legal text unresolved. |
| BR-PRIVACY-002 | Notice text location | Phase 1 canonical Aydınlatma Metni text lives in `/docs/PRIVACY_NOTICE_TR.md`, build-time embedded; no CMS/admin-managed notice surface. | Locked by K-14. |
| BR-PRIVACY-003 | Acknowledgment persistence | Acknowledgment is ephemeral before OTP verification and persisted only on successful OTP verification. | Locked by K-15; legal-advisor sufficiency confirmation pending before Pod C propagation. |
| BR-PRIVACY-004 | Same-session resend reuse | Same-session acknowledgment reuse is valid for OTP resend; re-acknowledgment required on session break or phone-number change. | Locked by K-16; legal-advisor sufficiency confirmation pending before Pod C propagation. |
| BR-SELCAFE-001 | Selcafe posture | Phase 1 Selcafe integration is read-only discovery/sync if feasible; no Selcafe writes. | Confirmed; [REQUIRES POD B REVIEW]. |

## Operating Spine Business Rules — K-21

Kerem approved the Product Phase 1 operating spine as **Selcafe-linked customer visibility and ordering**.

The following business rules reconcile Phase 1 around that spine.

| ID | Area | Rule | Status / Routing |
|---|---|---|---|
| BR-OS-001 | Main visit link | The app's customer-facing visit link is the desk-side one-time QR handshake, not typed/scanned `fiş / fiş numarası`. Two scan directions are supported: desk/customer-facing screen QR scanned by customer, and customer app QR scanned by cashier. “Addition” should not be the primary customer-facing word. | QR handshake design merged in PR #119; K-21/K-OS decision-log amendment remains Kerem-gated. [REQUIRES POD B REVIEW] for session-link/read mapping. |
| BR-OS-002 | Link confirmation / wrong-PC handling | Successful QR handshake binds the app session to one Adeks-native session-link for a cashier-selected PC/session. The PWA may display the linked PC/session for customer awareness, but typed bill entry and separate table-confirmation linking are no longer the security/control path. Wrong or disputed PC/session blocks ordering and routes customer to cashier. | QR handshake design merged in PR #119. [REQUIRES POD B REVIEW] for matching, correction, and audit implications. |
| BR-OS-003 | Guest live bill and order | Guest customer may link through the QR handshake, see the full live bill including itemized lines, and order F&B without an Adeks account. An Adeks account is required only for discounts, coupons, and points; persistent account-linked history requires account context. | Confirmed by SL-6/SL-7; K-21/K-OS amendment remains Kerem-gated. [REQUIRES POD B REVIEW] for auth, KVKK, audit, abuse boundary. |
| BR-OS-004 | Selcafe-linked visibility | Customer-visible PC start/stop/duration/cost estimates are included only if Selcafe read quality is reliable. KD-2 clarifies this supersedes/subsumes K-20 PI-1 only inside the approved operating spine. Hide financial estimates if unreliable. | Confirmed by K-21/K-OS-002 and KD-2. [REQUIRES POD B REVIEW]. |
| BR-OS-005 | Pre-payment estimate wording | Pre-payment financial values must be labeled estimated. Recommended placeholder: “Estimated. Final amount confirmed at cashier.” | Confirmed direction. Final Turkish copy needs Kerem/UX review. |
| BR-OS-006 | Final amount source | Selcafe final settled amount is the source of truth. Adeks does not own final bill calculation in this spine. Final amount reads are desired product direction for the QR-linked active visit/session, but active bill/order-line reads require ADR-005 read-surface expansion, KVKK/legal review, auditability, retention, and data-minimization review before implementation. | Confirmed by K-21/KD-1 and SL-6. [REQUIRES POD B REVIEW] for read/inference feasibility. |
| BR-OS-007 | Manual Selcafe bridge | Cashier manually enters accepted PWA orders into Selcafe. Adeks does not directly write PWA orders into Selcafe. | Confirmed by K-21. [REQUIRES POD B REVIEW] for auditability and comparison. |
| BR-OS-008 | First-slice F&B status | First-slice customer-facing status is simplified. “Accepted + Preparing” means cashier successfully entered the order into Selcafe. No delivered tracking in first-slice UX. | Confirmed by K-21/K-OS-003. [REQUIRES POD B REVIEW] to reconcile with accepted lifecycle model. |
| BR-OS-009 | Kitchen/service workflow | Kitchen/service continue from Selcafe printed receipts only in the first operating slice. No kitchen-facing PWA workflow. | Confirmed by K-21. |
| BR-OS-010 | Simple coupon | One simple combined PC + F&B coupon/discount is included as the first operating-spine habit driver. Broad campaign engine, tiers, and subscriptions are excluded. | Confirmed by K-21/K-OS-004. [REQUIRES POD B REVIEW] for audit/settlement implications. |
| BR-OS-011 | Coupon status | Coupon may be shown as applied, rejected, or corrected. Exact rejection/correction reasons remain unresolved. | [NEEDS KEREM APPROVAL] reason taxonomy. [REQUIRES POD B REVIEW]. |
| BR-OS-012 | Loyalty earning basis | Product target is F&B + PC/session earning after settlement. F&B formula remains locked by K-18. PC/session earning requires later Pod B review and falls back to F&B-only if unreliable. | Confirmed by K-21/K-OS-005. [REQUIRES POD B REVIEW]. |
| BR-OS-013 | Wallet payment/spending | Wallet payment/spending is excluded from this operating spine only. Wallet visibility/top-up may remain separate Phase 1 scope behind existing gates. | Confirmed by K-21/K-OS-006. |
| BR-OS-014 | Settlement comparison | Product target: compare PWA orders, Selcafe F&B items, selected coupon, and Selcafe final settled amount where feasible. Settlement comparison is desired product direction for the QR-linked active visit/session, but active bill/order-line reads require ADR-005 read-surface expansion, KVKK/legal review, auditability, retention, and data-minimization review before implementation. | Confirmed by K-21/KD-1 and QR-handshake design. [REQUIRES POD B REVIEW]. |
| BR-OS-015 | Mismatch threshold | 2% is approved as the pre-settlement estimate warning threshold and, per K-OS-008, as the settlement green-light tolerance: Adeks compares its own discount-inclusive calculation against the Selcafe `adisyon` sum reconciled with the `kasaislem` discount. Final settled amount must still come from Selcafe. | Confirmed by K-21/K-OS-007 and K-OS-008. [REQUIRES POD B REVIEW] for monitoring/mechanics; comparison-basis detail tracked in OQ-OS-004. |
| BR-OS-016 | Pilot pause triggers | Kerem may pause pilot for wrong QR/session-link match, wrong final settled amount, repeated failed linking, missed PWA orders, coupon misapplication, customer complaints, or staff overload. | Confirmed by K-21/K-OS-007 as amended by the QR-handshake design. |
| BR-OS-017 | Pause tolerance | One serious confirmed software-related case may be enough to pause. Human-related issues have tolerance depending on cause/frequency. | Confirmed by K-21/K-OS-007. |
| BR-OS-018 | First-week admin check | During first week, admin/back-office checks all disputed orders plus ten random orders; check coupon application and final settled amount; summarize for Kerem. | Confirmed by K-21/K-OS-007. [REQUIRES POD B REVIEW] for audit/report mechanics. |
| BR-OS-019 | Active visit/bill/order-line visibility | Product direction includes Selcafe-sourced active visit/bill/order-line visibility for the QR-linked active visit/session, including cashier/staff-entered F&B items not submitted through Adeks PWA. Guest customers may see the full live bill including itemized lines after QR linking, subject to the read gate. | Confirmed by K-21/KD-1 and SL-6 as product direction only. [REQUIRES POD B REVIEW], ADR-005 read-surface reconciliation, KVKK/legal review, auditability, retention, and data-minimization review before any implementation issue. |
| BR-OS-020 | Selcafe member identity/profile exclusion | Selcafe member identity/profile data, including `adisyon.uye_no`, must not be read, derived, resolved, or displayed as part of this operating spine. The QR handshake binds app session to PC/session-link, never app session to Selcafe member. | Confirmed by KD-1 and SL member-resolution rule. This exclusion does not fully resolve the ADR-005 read-surface conflict for active bill/order-line data. |
| BR-OS-021 | ADR-005 non-override | K-21/KD-1 does not override ADR-005 by wording alone. | Confirmed by KD-1. Direct implementation remains blocked until required reconciliation and reviews are complete. |
| BR-OS-022 | K-20 / K-21 relationship | K-OS-002 supersedes/subsumes K-20 PI-1 only for customer-visible PC/session estimates inside this operating spine. | Confirmed by KD-2. Broader real-time station/session status and reservation automation remain deferred unless separately approved. |
| BR-OS-023 | Discount ownership | At the Adeks PWA pilot, Selcafe's member-discount mechanism is retired; Adeks owns and calculates all discounts (coupon and loyalty). `adisyon.uye_indirim` is unused/empty. | Confirmed by K-OS-008. Discount-ownership scope is platform-wide. [REQUIRES POD B REVIEW] for coupon/loyalty ledger and audit implications. Pre-implementation; does not authorize Pod C. |
| BR-OS-024 | Selcafe discount reflection (manual bridge) | For Phase 1, Adeks gives the cashier a fixed-format discount reflection record. The cashier reflects the Adeks discount into Selcafe by selecting the dedicated Adeks `islem_tip` from the Kasiyer dropdown, entering the pseudorandom one-time Adeks discount code in `kasaislem.aciklama`, and entering the discount amount as a positive credit in `kasaislem.alacak`. The Selcafe row must not carry `adisyon_no`, an Adeks customer id, coupon id, member id, or any other Adeks identity. Adeks holds the internal `code → linked Selcafe bill/addition → expected discount` mapping and joins reads inside Adeks. Adeks does not write directly to Selcafe; the cashier is the human bridge. | Confirmed by K-OS-008 as amended by the 2026-06-30 kasaislem mechanism QA, with QR-handshake wording replacing customer-facing typed-`fiş` linking. [REQUIRES POD B REVIEW] for SR-003-9 conformance, anti-collision/delimiting, reverse-flow auditability, and KVKK/data-minimization. Fixed-format record spec: `/docs/planning/ADEKS_DISCOUNT_REFLECTION_RECORD_SPEC_v0.1.md`. ADR-005 reconciliation + KVKK/legal review required before implementation. Does not authorize direct Selcafe writes or Pod C. |
| BR-OS-025 | Settlement green-light check | At settlement, Adeks reads the linked Selcafe bill/addition total and reads the matching Adeks discount row from `kasaislem` by dedicated Adeks `islem_tip` + pseudorandom one-time code. Adeks joins those reads inside Adeks and compares the Selcafe settled total net of the matched Adeks discount against Adeks's discount-inclusive total. The cashier receives a green light only when the result is within the approved 2% threshold. No clean match, multiple matches, malformed code, missing `alacak`, or amount mismatch fails closed: no green light and manual check required. Selcafe remains the settlement source of truth. | Confirmed by K-OS-008 as amended by the 2026-06-30 kasaislem mechanism QA, with QR-handshake wording replacing customer-facing typed-`fiş` linking. [REQUIRES POD B REVIEW]. The `adisyon`/`kasaislem` reads require ADR-005 read-surface expansion, KVKK/legal review, auditability, retention, and data-minimization review before implementation. Does not authorize Pod C. |

K-21 first-slice statuses are customer-facing simplified projections for the operating spine. They do not redefine the accepted F&B lifecycle state model. Later Pod B review must reconcile the projection with the accepted model before implementation-readiness work.

The 2% mismatch rule, pilot pause triggers, and first-week admin/back-office checks require later Pod B review for risk/audit mechanics and later Pod D review where UX, monitoring, or operational visibility is affected.

## Business Rules Requiring Kerem Decision

| ID | Area | Decision question | Guardrail | Blocker |
|---|---|---|---|---|
| BRD-LOY-001 | Loyalty earning eligibility | What PC/session loyalty formula applies if Pod B confirms reliable PC/session settlement data? | K-21 approves F&B + PC/session as product target; F&B formula remains locked by K-18. Wallet top-up earning is not part of this operating spine. | Blocks Pod C for PC/session earning |
| BRD-LOY-002 | Loyalty earning formula | F&B formula resolved by K-18: `floor(0.10 × settled_amount_TRY)`. What is the Phase 1 earning formula for non-F&B purchase types? | Must be representable as discrete immutable earn events. Pod B defines precision/rounding. | Blocks Pod C for non-F&B earning |
| BRD-LOY-003 | Loyalty earning exclusions | Are discounts, campaigns, refunded/cancelled purchases, wallet top-ups, or manual adjustments excluded from earning? | Prevent double earning and ensure reversal paths are ledger-based. | Blocks Pod C |
| BRD-LOY-004 | Loyalty redemption unit | Is redemption denominated as points, ₺ discount equivalent, item discount, or another unit? | Ledger semantics and customer-facing value require Pod B review. | Blocks Pod C |
| BRD-LOY-005 | Loyalty redemption limits | What are the minimum/maximum redemption limits per transaction/day/customer? | Refund/cancel interaction and reversing entries require Pod B. | Blocks Pod C |
| BRD-LOY-006 | Loyalty redemption target | Can loyalty be redeemed against F&B only, PC/session usage, wallet top-up, or selected combinations? | Redemption against wallet top-up requires Pod B review. | Blocks Pod C |
| BRD-LOY-007 | Loyalty expiry | Do points expire? If yes, what is the expiry period and reminder policy? | Requires customer-notification policy and legal-advisor input. | Blocks legal / Pod C if included |
| BRD-LOY-008 | Cashier override | Can CASHIER override loyalty redemption rules? If yes, under what conditions and with what audit/ADMIN visibility? | Security-sensitive; reason/admin visibility/audit required if allowed; Pod B + Kerem gate. | Blocks Pod C |
| BRD-WAL-001 | Wallet top-up methods | Which cashier top-up methods are allowed: cash, existing POS card payment, manual admin entry, selected combinations? | POS reconciliation and per-method ledger typing require Pod B. | Blocks Pod C |
| BRD-WAL-002 | Wallet correction/reversal | How are mistaken top-ups corrected? | Mechanism is compensating ledger event only; no overwrite. Actor authority requires Pod B + Kerem. | Blocks Pod C |
| BRD-WAL-003 | Wallet receipt/customer proof | Does customer receive visible top-up confirmation/history immediately after cashier top-up? | Customer proof/history may affect audit, retention, and dispute handling. | Blocks Pod C |
| BRD-WAL-004 | Daily top-up report fields | What should ADMIN see in the daily top-up report? | Customer identifier must remain masked; retention and PII scope require Pod B/legal review. | Blocks Pod C |
| BRD-CASHIER-001 | Cashier own transaction view | Should CASHIER have a "my recent transactions" view limited to their own processed actions? | [REQUIRES POD B REVIEW] if scoped: masked-only, own-actions-only, KVKK minimization. | Not blocking yet |
| BRD-RES-001 | Reservation slots | What slot length or time blocks are allowed? | State-machine review required. | Blocks Pod C |
| BRD-RES-002 | Reservation limits | How many active/future reservations can one customer hold? | Customer-facing restriction policy may require notification/fairness framing. | Blocks Pod C |
| BRD-RES-003 | Reservation cancellation | Can customer cancel? Can staff cancel? What cutoff applies? | State-machine review required. | Blocks Pod C |
| BRD-RES-004 | No-show rule | What happens if customer does not arrive? | Future restrictions may carry customer communication/KVKK implications. | Blocks Pod C |
| BRD-RES-005 | Reservation approval criteria | What criteria should staff use to approve/reject a request when PC/session status is not reliable? | Do not lock status-based approval criteria before Pod B review confirms reliable Selcafe status support. | Blocks Pod C |
| BRD-AUDIT-001 | Audit detail level | Are current minimum audit fields enough, or must reason/comment, IP/device, before/after derived values, and workflow source also be captured? | Build on Accepted auth threat model baseline; schema/storage/tamper/retention are Pod B/legal. | Blocks Pod C / Pod B |
| BRD-SEL-001 | Selcafe customer mapping | What customer data, if any, should be imported or mapped from Selcafe if read-only sync is feasible? | Intent only before Pod B/legal review; PII mapping requires KVKK review. | Blocks Pod C for sync |
| BRD-PRIVACY-001 | Turkish privacy notice legal text | What exact Turkish Aydınlatma Metni text appears in the PWA? | K-14 locks location/delivery; only legal wording remains open. | Blocks legal / launch |
| BRD-SMS-001 | SMS provider | Which SMS provider is selected after price/commercial replies and KVKK assessment? | Provider report exists; selection remains Kerem-owned and does not authorize Pod C. | Blocks Pod C |
| BRD-SMS-002 | SMS operational response | Who owns provider-outage response, and what spend/volume ceiling triggers circuit breaker/escalation? | Provider-outage operations only; customer-facing failure UX is already resolved by CUF §3.5.3. | Blocks Pod C auth issue prep |

F&B order lifecycle product decisions are resolved by Kerem's completed F&B Order Lifecycle Decision Packet and the 2026-06-12 follow-up decisions recorded in this document. Remaining F&B work is Pod B review/formalization of state transitions, actors, audit points, cancellation boundaries, combined payment/fulfillment representation, wallet debit ledger entry design, loyalty accrual append-event design, and any reversal logic. This does not authorize Pod C.

K-21 resolves the operating-spine campaign boundary: one simple combined PC + F&B coupon/discount is included; complex campaign engine, tiers, subscriptions, and broad ARPU campaign modeling remain excluded from this operating spine.

## Decision Prep Notes by Focus Area

### Loyalty earning eligibility

[OPEN QUESTION] Which purchase types earn points in Phase 1?

K-21 approves **F&B + PC/session** as the product target for this operating spine. This does not reopen K-18. F&B formula remains locked. PC/session earning remains blocked until Pod B validates Selcafe settlement data, ledger implications, correction behavior, and KVKK scope. If PC/session data is unreliable, the approved fallback is F&B-only earning.

| Option | Meaning | Guardrail |
|---|---|---|
| F&B only | Points earned only on F&B purchases. | F&B purchases are confirmed as accruing loyalty in Phase 1. Formula/exclusion review remains required. |
| PC/session only | Points earned only on gaming/session usage. | Must wait for Selcafe spike and Pod B review because PC/session data reliability is unknown. |
| F&B + PC/session | Broader program. | Higher customer value but higher integration/audit complexity; PC/session portion gated by spike. |
| Wallet top-up earns | Points earned when topping up wallet. | [REQUIRES POD B REVIEW] before selection. High double-earning risk if wallet spend also earns. |
| No earning until formula approved | Loyalty visibility only until rules are locked. | Safest fallback if formula decisions are not ready. |

### Loyalty earning formula

**F&B formula — RESOLVED by K-18 (Kerem, 2026-06-14):** `floor(0.10 × settled_amount_TRY)` = `floor(settled_kuruş / 1000)`. 10% of settled F&B amount, rounded down to whole points. See BR-LOYALTY-FB-001.

[OPEN QUESTION] Non-F&B earning formula and broader program rules remain unresolved.

| Decision element | Kerem can decide | Guardrail |
|---|---|---|
| Non-F&B formula shape | Points per ₺, percentage, fixed points per item/category, or no earning yet | Must express as discrete immutable earn events. |
| Business value | Earning rate / customer value | Kerem owns financial exposure. |
| Rounding/precision | Product preference can be stated | Pod B defines ledger precision and rounding implementation. |
| Refund/cancel interaction | Business intent | Pod B designs reversing ledger events. |

Do not implement non-F&B earning or redemption until Kerem chooses a formula and Pod B reviews ledger implications.

### Loyalty redemption limits

[OPEN QUESTION] Define redemption rules.

| Rule | Decision needed | Guardrail |
|---|---|---|
| Minimum redemption | Is there a minimum points/value threshold? | Must be enforceable without balance overwrite. |
| Maximum redemption per transaction | Can a customer pay 100% with points/value? | Financial exposure decision for Kerem. |
| Maximum redemption per day/customer | Any anti-abuse cap? | May require monitoring/audit design. |
| Eligible redemption targets | F&B, PC/session, both, or selected categories? | Redemption against wallet top-up requires Pod B review. |
| Expiry/forfeiture | Do points expire or remain until used? | Requires customer-notification policy and legal-advisor input. |
| Refund/cancel interaction | What happens to redeemed points if an order is cancelled? | Pod B designs compensating ledger events; no overwrite. |

### Cashier override rules

[OPEN QUESTION] Define whether override exists.

| Question | Needs Kerem decision | Guardrail |
|---|---|---|
| Can CASHIER override loyalty redemption limits? | Yes / no | Security-sensitive. If yes, requires Pod B + Kerem approval path. |
| Can ADMIN override? | Yes / no | Requires step-up/audit design if high sensitivity. |
| Is reason required? | Yes / no | Recommended as mandatory for any discretionary financial action. |
| Is daily override report required? | Yes / no | Recommended if overrides exist. |
| Are overrides reversible only through ledger events? | Intent can be confirmed | Mechanism must be Pod B-designed; no balance overwrite. |

### Wallet top-up methods

[OPEN QUESTION] Define allowed cashier top-up methods.

| Method | Phase 1 decision needed | Guardrail |
|---|---|---|
| Cash | Allowed / not allowed | Needs per-method reporting and reconciliation. |
| Existing POS card payment | Allowed / not allowed | POS reconciliation implications require Pod B review. |
| Manual admin entry | Allowed / not allowed | Higher-abuse; pair with audit and daily report. |
| Mixed payment | Allowed / not allowed | Increases reconciliation complexity. |
| Complimentary/admin credit | Allowed / not allowed; if allowed, who approves? | High-abuse; recommend ADMIN-only, reason required, audit-visible. |

### Wallet correction / reversal

[OPEN QUESTION] How are mistaken wallet top-ups corrected?

| Decision element | Kerem can decide | Guardrail |
|---|---|---|
| Correction allowed? | Yes / no | If yes, correction is ledger event only. |
| Who may request? | Customer / cashier / admin request path | Initiation authority is security-sensitive. |
| Who may execute? | CASHIER / ADMIN | Recommend ADMIN-initiated reversal with required reason in Phase 1; cashier raises request. |
| Reason required? | Yes / no | Recommended mandatory. |
| Customer visibility | Whether customer sees reversal history | Customer proof/dispute handling; retention review required. |

### Daily top-up report fields

K-13/KD-F confirms **no top-up threshold in Phase 1** and a daily top-up report visible to ADMIN as compensating control.

[OPEN QUESTION] What fields must the ADMIN daily top-up report include?

| Candidate field | Guardrail |
|---|---|
| Cashier actor | Required for accountability. |
| Count of top-ups | Useful for operational monitoring. |
| Total top-up amount | Required for daily control. |
| Payment method | Requires agreed method vocabulary. |
| Masked customer identifier | Must remain masked last-4 or equivalent minimized identifier; no full phone in report. |
| Exceptions/reversals | Recommended for abuse/dispute monitoring. |
| Override/correction reasons | Recommended for discretionary financial actions. |

[REQUIRES POD B REVIEW] PII masking and audit scope.  
[NEEDS KEREM APPROVAL] Operational report fields.  
[NEEDS LEGAL/KVKK INPUT] Retention period.

### Customer-visible F&B order statuses

[RESOLVED] Kerem approved the following Phase 1 customer-visible F&B order statuses.

| Customer-visible status | Product meaning | Review routing |
|---|---|---|
| Submitted | Customer placed the order; staff has not accepted/rejected it yet. | Pod B to formalize transition model. |
| Accepted | Staff accepted the order. | Pod B to formalize actor and audit point. |
| Preparing | Order is being prepared. Customer cancellation is no longer allowed once this status is reached. | Pod B to formalize exact transition boundary. |
| Ready / On the way | Order is ready for pickup/delivery or is being brought to the customer. | [RESOLVED by Kerem, 2026-06-12: one internal state, one customer-visible label. Pod B to formalize transition entry/exit conditions and actor.] |
| Delivered | Staff marked the order delivered. | Pod B to formalize audit point and actor authority. |
| Rejected | Staff rejected the order before accepting it because an item was unavailable or the order was invalid. When item unavailability is the cause, the order is fully rejected and the customer submits a new order. | Audit reason required. Item-unavailability resolution [RESOLVED by Kerem, 2026-06-12: full order Rejected, customer submits new order]. Pod B to formalize actor, audit fields, and transition boundary. |
| Cancelled | Order was cancelled by customer before Preparing or by staff after acceptance with required reason. | Audit reason required for staff cancellation. Pod B to formalize actor, audit fields, and transition boundary. |

[REQUIRES POD B REVIEW] Pod B must formalize the lifecycle/state model. This section records product vocabulary only and is not a state machine.

### Order cancellation, staff rejection/cancellation, and unavailable items

[RESOLVED] Kerem approved the following product rules.

| Area | Product decision | Guardrail / routing |
|---|---|---|
| Customer cancellation | CUSTOMER can cancel until the order reaches Preparing. | [CONFIRMED by Kerem, 2026-06-12] Cancellation is allowed while Submitted or Accepted, and not allowed once Preparing starts. [REQUIRES POD B REVIEW]. |
| Staff rejection | Staff can reject before accepting if an item is unavailable or the order is invalid. | Audit reason required. [REQUIRES POD B REVIEW]. |
| Staff cancellation | Staff can cancel after acceptance only with a required reason. | Audit reason required. [REQUIRES POD B REVIEW]. |
| Unavailable item | Staff marks the item unavailable and the order is Rejected. The customer submits a new order. | [RESOLVED by Kerem, 2026-06-12: full order Rejected, customer submits new order. Pod B to formalize customer-visible copy and audit point.] |
| Audit | Every rejection/cancellation requires an audit reason. | [REQUIRES POD B REVIEW] for required fields, storage, tamper resistance, and retention. |
| Financial/reversal impact | Any wallet, loyalty, payment, refund, cancellation, or reversal effect must be designed by Pod B. | No direct balance overwrite. No Pod C implementation authorization. |

### F&B payment visibility

[RESOLVED] Customer sees combined customer-facing payment/order status in Phase 1.

| Rule | Product decision | Guardrail / routing |
|---|---|---|
| Customer display | Customer sees combined status rather than fulfillment-only or separate payment-only status. | [REQUIRES POD B REVIEW] for formal model. |
| Payment actor | Phase 1 payment remains cashier-only. | CASHIER/ADMIN only. Phase 1 F&B payment method is café wallet, cashier-mediated at delivery. See BR-FB-010. |
| FB_STAFF payment authority | FB_STAFF does not handle payment. | Locked Phase 1 role boundary. |
| Online payment | Online payment remains excluded from Phase 1. | Phase 2 candidate only. |
| Combined status meaning | Combined display must not imply FB_STAFF can settle payment or that online payment exists. | [REQUIRES POD B REVIEW]. The customer-facing status component must not include any interactive payment element (button, link, prompt, or in-app payment flow). Payment occurs offline via CASHIER only. Pod A and UX must not derive a self-pay interaction from the "combined status" direction. |

### Reservation rules

[OPEN QUESTION] Define reservation rules.

| Rule | Decision needed | Guardrail |
|---|---|---|
| Slot length | Fixed duration or customer-requested range? | State-machine review required. |
| Advance booking window | Same day only, next day, week ahead? | State-machine/UX review required. |
| Active reservation limit | Max active/future reservations per customer. | Prevents hoarding; customer policy decision. |
| Cancellation cutoff | When customer/staff can cancel. | State-machine review required. |
| No-show grace period | How long after slot start before no-show. | Operational policy decision. |
| No-show consequence | Warning, temporary reservation restriction, or no consequence. | Customer communication/fairness and possible KVKK implications. |
| Staff approval criteria | How staff decides without reliable automated PC/session status. | Do not lock status-based approval criteria before Pod B review confirms reliable Selcafe status support. Phase 1 stays manual staff judgment unless Pod B review supports more. |

### Audit detail level

[OPEN QUESTION] Are minimum audit fields enough, or should additional fields be mandatory?

This question is **not greenfield**. It must build on the Accepted auth threat-model baseline.

| Detail | Decision / review need | Guardrail |
|---|---|---|
| Reason/comment | Kerem can require for overrides, reversals, cancellations, unavailable items | Recommended for every discretionary financial action. |
| IP/device | Pod B review | May be security useful but has retention/KVKK implications. |
| Before/after derived values | Pod B review | Must not imply balance overwrite; derived values only. |
| Workflow source | Pod B review | Useful for auditability across PWA/staff/admin actions. |
| Storage/tamper/retention | Pod B + legal advisor | Not a Pod A decision. |

### Selcafe customer mapping

[OPEN QUESTION] What customer data should be imported or mapped from Selcafe if read-only sync is feasible?

| Kerem can decide now | Must not lock yet |
|---|---|
| Product intent: prefer minimal mapping, avoid historical spend unless needed, treat Selcafe as legacy adapter. | Exact fields, identifiers, sync frequency, data quality assumptions, customer PII mapping, and any legal basis before Pod B/legal review. |

[GUARDRAIL] Selcafe is a legacy adapter, not the core domain model. No direct writes to Selcafe SQL Server in Phase 1 unless Kerem explicitly approves later.

### SMS provider

[OPEN QUESTION] Which SMS provider is selected?

| State | Meaning |
|---|---|
| Done | Pod B SMS provider report exists as `SMS_PROVIDER_REPORT.md` decision support. |
| Still open | Kerem provider decision after commercial replies and legal/KVKK confirmation. |
| Do not do | Do not treat the report as selection. Do not authorize Pod C from provider report alone. |
| Operational decision still possible | Kerem can define IR-25 spend/volume ceiling and outage-response owner while provider selection is pending. |

### Legal / KVKK items

[OPEN QUESTION] Legal text and legal sufficiency remain open; flow mechanics are locked.

| Item | State |
|---|---|
| K-14 notice text location | Locked: `/docs/PRIVACY_NOTICE_TR.md`, build-time embedded, no CMS in Phase 1. |
| K-15 acknowledgment persistence | Locked: ephemeral pre-verification; persisted only on successful OTP verification. |
| K-16 same-session resend reuse | Locked: valid in uninterrupted session; re-ack on session break or phone-number change. |
| Aydınlatma Metni legal text | Open; legal advisor/Kerem. |
| K-15/K-16 KVKK sufficiency | Open legal-advisor confirmation before Pod C propagation. |
| VERBİS, retention, legal basis, cross-border transfer | Open legal-advisor/Kerem items. |

## Review Routing

- Ready for commit: Yes — documentation-only replacement after Kerem approval. Decision-prep only; not implementation-ready.
- Requires Kerem approval: Yes — all unresolved business rules affecting loyalty, wallet, reservations, privacy, SMS provider, operational response, and launch gates.
- Requires Pod B review: Yes — wallet/loyalty ledgers, reservation state, order state, audit, auth/KVKK/data handling, Selcafe mapping, provider-specific security.
- Requires Pod C implementation: No.
- Requires Pod D prototype/audit/monitoring review: Later for customer PWA onboarding/order/reservation UX and pre-go-live audit/monitoring review.
