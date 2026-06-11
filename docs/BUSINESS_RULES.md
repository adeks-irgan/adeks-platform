# BUSINESS_RULES.md

## Status

| Field | Value |
|---|---|
| Document | BUSINESS_RULES.md |
| Version | v0.2 decision-prep draft |
| Owner | Pod A — Product & Planning |
| Reviewer | Pod B — Architecture, Logic & Risk |
| Approver | Kerem |
| Current status | Confirmed v0.2 decision-prep documentation for Kerem approval; not implementation-ready |
| Scope of this version | Applies Pod B B-1/B-2/B-3 and N-1…N-5 corrections to v0.1. Establishes no new locked decision. |
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
| Attached v0.1 packet + Pod B triage / final confirmation | v0.1 packet; “Safe with corrections”; final confirmation received per PR context | 2026-06-11 | Baseline and required correction list; Pod B confirmed safe for Kerem decision-prep and documentation-class commit after Kerem approval. |

## Purpose

This document separates confirmed Phase 1 business rules from unresolved questions requiring Kerem decision and Pod B review.

This document is **decision-prep only**. It does not select an SMS provider, does not resolve legal/KVKK questions, does not create Pod C implementation issues, and does not approve implementation.

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
| BR-LOYALTY-002 | Loyalty earning | Loyalty earning happens automatically on eligible purchases. | Confirmed intent; eligibility/formula unresolved. |
| BR-LOYALTY-003 | Loyalty redemption actor | Loyalty redemption is handled by CASHIER/ADMIN in Phase 1. | Confirmed. |
| BR-LOYALTY-004 | Loyalty self-redemption | Customer self-redemption is excluded from Phase 1. | Confirmed. |
| BR-LOYALTY-005 | Loyalty ledger | Loyalty must use append-only ledger logic; no direct balance overwrite. | Confirmed principle; [REQUIRES POD B REVIEW]. |
| BR-FB-001 | F&B order submission | Logged-in CUSTOMER can submit F&B orders from seat. | Confirmed. |
| BR-FB-002 | F&B fulfillment | FB_STAFF can receive/update order status and mark delivered; payment remains CASHIER/ADMIN only. | Confirmed. |
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

## Business Rules Requiring Kerem Decision

| ID | Area | Decision question | Guardrail | Blocker |
|---|---|---|---|---|
| BRD-LOY-001 | Loyalty earning eligibility | Which Phase 1 purchase types earn loyalty: F&B only, PC/session usage, wallet top-up, or selected combinations? | “Wallet top-up earns” requires Pod B ledger review first; PC/session earning is gated on Selcafe spike. | Blocks Pod C |
| BRD-LOY-002 | Loyalty earning formula | What is the Phase 1 earning formula? | Must be representable as discrete immutable earn events. Pod B defines precision/rounding. | Blocks Pod C |
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
| BRD-CASHIER-001 | Cashier own transaction view | Should CASHIER have a “my recent transactions” view limited to their own processed actions? | [REQUIRES POD B REVIEW] if scoped: masked-only, own-actions-only, KVKK minimization. | Not blocking yet |
| BRD-ORDER-001 | Customer-visible order statuses | What statuses should the PWA show? | Kerem selects vocabulary; Pod B formalizes transitions/actors/audit. | Blocks Pod C |
| BRD-ORDER-002 | Order cancellation | Can customers cancel after submission? Can staff cancel? Under which status and who sees what? | State-machine and any wallet/loyalty interaction require Pod B. | Blocks Pod C |
| BRD-ORDER-003 | Unavailable items | How should staff handle unavailable F&B items after order submission? | State-machine and reversal implications require Pod B. | Blocks Pod C |
| BRD-ORDER-004 | Payment state visibility | Should customer see payment status, or only order fulfillment status? | Keep payment status separate from fulfillment status unless Pod B designs combined state. | Blocks Pod C |
| BRD-RES-001 | Reservation slots | What slot length or time blocks are allowed? | State-machine review required. | Blocks Pod C |
| BRD-RES-002 | Reservation limits | How many active/future reservations can one customer hold? | Customer-facing restriction policy may require notification/fairness framing. | Blocks Pod C |
| BRD-RES-003 | Reservation cancellation | Can customer cancel? Can staff cancel? What cutoff applies? | State-machine review required. | Blocks Pod C |
| BRD-RES-004 | No-show rule | What happens if customer does not arrive? | Future restrictions may carry customer communication/KVKK implications. | Blocks Pod C |
| BRD-RES-005 | Reservation approval criteria | What criteria should staff use to approve/reject a request when PC/session status is not reliable? | Do not lock status-based criteria before Selcafe spike results. | Blocks Pod C |
| BRD-AUDIT-001 | Audit detail level | Are current minimum fields enough, or must reason/comment, IP/device, before/after derived values, and workflow source also be captured? | Build on Accepted auth threat model baseline; schema/storage/tamper/retention are Pod B/legal. | Blocks Pod C / Pod B |
| BRD-SEL-001 | Selcafe customer mapping | What customer data, if any, should be imported or mapped from Selcafe if read-only sync is feasible? | Intent only before spike; PII mapping requires KVKK review. | Blocks Pod C for sync |
| BRD-PRIVACY-001 | Turkish privacy notice legal text | What exact Turkish Aydınlatma Metni text appears in the PWA? | K-14 locks location/delivery; only legal wording remains open. | Blocks legal / launch |
| BRD-SMS-001 | SMS provider | Which SMS provider is selected after price/commercial replies and KVKK assessment? | Provider report exists; selection remains Kerem-owned and does not authorize Pod C. | Blocks Pod C |
| BRD-SMS-002 | SMS operational response | Who owns provider-outage response, and what spend/volume ceiling triggers circuit breaker/escalation? | Provider-outage operations only; customer-facing failure UX is already resolved by CUF §3.5.3. | Blocks Pod C auth issue prep |

## Decision Prep Notes by Focus Area

### Loyalty earning eligibility

[OPEN QUESTION] Which purchase types earn points in Phase 1?

| Option | Meaning | Guardrail |
|---|---|---|
| F&B only | Points earned only on F&B purchases. | Lowest integration dependency; still needs formula/exclusion review. |
| PC/session only | Points earned only on gaming/session usage. | Must wait for Selcafe spike and Pod B review because PC/session data reliability is unknown. |
| F&B + PC/session | Broader program. | Higher customer value but higher integration/audit complexity; PC/session portion gated by spike. |
| Wallet top-up earns | Points earned when topping up wallet. | [REQUIRES POD B REVIEW] before selection. High double-earning risk if wallet spend also earns. |
| No earning until formula approved | Loyalty visibility only until rules are locked. | Safest fallback if decisions are not ready. |

### Loyalty earning formula

[OPEN QUESTION] What is the Phase 1 formula?

| Decision element | Kerem can decide | Guardrail |
|---|---|---|
| Formula shape | Points per ₺, percentage, fixed points per item/category, or no earning yet | Must express as discrete immutable earn events. |
| Business value | Earning rate / customer value | Kerem owns financial exposure. |
| Rounding/precision | Product preference can be stated | Pod B defines ledger precision and rounding implementation. |
| Refund/cancel interaction | Business intent | Pod B designs reversing ledger events. |

Do not implement until Kerem chooses a formula and Pod B reviews ledger implications.

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

[OPEN QUESTION] Define the Phase 1 status vocabulary.

| Candidate status | Meaning | Guardrail |
|---|---|---|
| Submitted | Customer placed order; staff has not accepted/rejected yet. | Kerem selects vocabulary; Pod B formalizes transitions. |
| Accepted | Staff accepted the order. | Actor-per-transition review required. |
| Preparing | Staff/F&B is preparing. | Actor-per-transition review required. |
| Ready / On the way | Optional if operationally useful. | Avoid unnecessary status if not operationally used. |
| Delivered | Staff marked delivered. | Audit point likely required. |
| Cancelled | Cancelled by staff or customer if allowed. | Requires cancellation rules and ledger interaction review. |
| Rejected | Staff cannot fulfill. | Requires unavailable-item policy. |

[GUARDRAIL] Keep payment status separate from fulfillment status unless Pod B designs a combined state model. Payment is cashier-only in Phase 1.

### Order cancellation and unavailable items

[OPEN QUESTION] Define cancellation and unavailable-item handling.

| Decision area | Kerem can decide | Guardrail |
|---|---|---|
| Customer cancellation | Whether customer can cancel and until which status | State-machine review required. |
| Staff cancellation | Who can cancel and what reason is required | Reason/audit recommended. |
| Unavailable item | Reject whole order, suggest substitute, remove item, or staff contacts customer | Workflow and customer copy require UX review if complex. |
| Financial interaction | Whether points/wallet/payment are affected | Reversal must be ledger-based if any charge/earn/redeem occurred. |

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
| Staff approval criteria | How staff decides without reliable automated PC/session status. | Do not lock status-based approval criteria before Selcafe spike results. Phase 1 stays manual staff judgment unless spike supports more. |

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
| Product intent: prefer minimal mapping, avoid historical spend unless needed, treat Selcafe as legacy adapter. | Exact fields, identifiers, sync frequency, data quality assumptions, customer PII mapping, and any legal basis before spike + Pod B/legal review. |

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
- Requires Kerem approval: Yes — all unresolved business rules affecting loyalty, wallet, orders, reservations, privacy, SMS provider, operational response, and launch gates.
- Requires Pod B review: Yes — wallet/loyalty ledgers, reservation state, order state, audit, auth/KVKK/data handling, Selcafe mapping, provider-specific security.
- Requires Pod C implementation: No.
- Requires Pod D prototype/audit/monitoring review: Later for customer PWA onboarding/order/reservation UX and pre-go-live audit/monitoring review.
