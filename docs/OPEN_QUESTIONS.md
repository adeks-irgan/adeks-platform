# OPEN_QUESTIONS.md

## Status

| Field | Value |
|---|---|
| Document | OPEN_QUESTIONS.md |
| Version | v0.2 replacement draft |
| Owner | Pod A — Product & Planning |
| Reviewer | Pod B — Architecture, Logic & Risk |
| Approver | Kerem |
| Current status | Confirmed v0.2 decision-prep documentation for Kerem approval; not implementation-ready |
| Scope of this version | Applies Pod B B-1/B-2/B-3 and N-1…N-5 corrections. Establishes no new locked decision. |
| Target repo path | `/docs/OPEN_QUESTIONS.md` |

## Freshness Baseline

| Source | Version / SHA / status read | Date read | Use in this draft |
|---|---:|---:|---|
| `/docs/AGENT_CONTEXT_MANIFEST.md` | SHA `47ba17e` | 2026-06-11 | Confirmed context loading and review routing. |
| `/docs/PROJECT_METHODOLOGY.md` | SHA `d3355d0`; v0.8 | 2026-06-11 | Confirmed Pod A boundaries and Pod C readiness gates. |
| `/docs/PROJECT_DECISION_INDEX.md` | SHA `0bbb3fd` | 2026-06-11 | Confirmed locked/not-locked decision state. |
| `/docs/CORE_USER_FLOWS.md` | SHA `6fe9b2f`; v0.3 | 2026-06-11 | Confirmed §3.5.3 OTP send-failure UX fallback and open notice/SMS items. |
| `/docs/architecture/AUTH_THREAT_MODEL.md` | SHA `df9b30b`; v0.4 Accepted, BL-2 closed | 2026-06-11 | Confirmed accepted auth baseline and remaining implementation blockers. |
| `/docs/decision-support/SMS_PROVIDER_REPORT.md` | SHA `27892d4`; v0.1 decision-support | 2026-06-11 | Confirms provider report exists; provider choice remains open. |
| `/docs/KEREM_DECISIONS.md` | SHA `47eaa47`; v1.4 | 2026-06-11 | Confirms K-13/K-14/K-15/K-16 locked state. |
| Attached v0.1 packet + Pod B triage | v0.1 packet; "Safe with corrections" | 2026-06-11 | Baseline and correction requirements. |

## Notes on Corrected State

- `AUTH_THREAT_MODEL.md` is v0.4 Accepted and BL-2 is closed.
- `SMS_PROVIDER_REPORT.md` exists. The report is no longer outstanding; the remaining SMS decision is Kerem's provider selection after commercial replies and KVKK/legal assessment.
- `CORE_USER_FLOWS.md` §3.5.3 resolves the customer-facing OTP send-failure UX fallback. Do not reopen:
  - neutral "could not send" failure copy;
  - no completed account on failed send;
  - no persistent raw phone retention after failed send;
  - derived-identifier audit only.
- K-14/K-15/K-16 are locked. The open legal questions are the exact legal text and legal-advisor sufficiency confirmations, not the flow mechanics.

## Open Questions

| ID | Question | Owner | Blocker level | Recommended next resolver | Notes / guardrails |
|---|---|---|---|---|---|
| OQ-SMS-001 | What SMS provider is approved after provider price/commercial replies and KVKK data-processor/cross-border assessment? | Kerem + Pod A + Pod B + legal advisor | blocks Pod C / BL-1 | Kerem after commercial replies + legal/KVKK input | Pod B report exists. Report informs decision; it does not select provider. |
| OQ-SMS-002 | What is the provider-outage operational response path if SMS provider is unavailable or spend/volume ceiling is hit? | Kerem + Pod B | blocks Pod C auth issue prep | Kerem + Pod B | Narrowed to operational response only: secondary-provider/switchover policy, IR-25 ceiling value, and response-path owner. Customer-facing send-failure UX is resolved by CUF §3.5.3. |
| OQ-LEGAL-001 | What exact Turkish Aydınlatma Metni text must be displayed in the PWA? | Kerem + legal advisor | blocks legal / launch | legal advisor | K-14 is locked: text lives in `/docs/PRIVACY_NOTICE_TR.md`, build-time embedded, no CMS in Phase 1. Only the wording remains open. |
| OQ-LEGAL-002 | Does legal advisor confirm K-15's acknowledgment persistence model is KVKK-sufficient? | Kerem + legal advisor + Pod B | blocks Pod C propagation | legal advisor | K-15 is locked: ephemeral pre-verification, persisted only on successful OTP verification. Only legal sufficiency remains open. |
| OQ-LEGAL-003 | Does legal advisor confirm K-16's same-session acknowledgment reuse for OTP resend is KVKK-sufficient? | Kerem + legal advisor + Pod B | blocks Pod C propagation | legal advisor | K-16 is locked: reuse valid only in uninterrupted session; re-ack on session break or phone-number change. Only legal sufficiency remains open. |
| OQ-LEGAL-004 | Is VERBİS registration required before go-live with real customer data, or is Adeks exempt? | Kerem + legal advisor | blocks launch | legal advisor | K-07 says Kerem consults legal advisor and acts accordingly. |
| OQ-LEGAL-005 | What retention periods apply to customer account, phone, wallet, loyalty, order, reservation, audit, auth, and Selcafe-discovered data? | Kerem + legal advisor + Pod B | blocks legal / launch | legal advisor + Pod B | Needed for auth, audit, wallet/loyalty, and customer-data views. |
| OQ-LEGAL-006 | Is any cross-border transfer created by hosting, SMS provider, monitoring, logging, or support tooling? | Kerem + legal advisor + Pod B | blocks launch | legal advisor + Pod B | SMS provider choice and hosting model affect answer. |
| OQ-LOY-001 | Which purchase types earn loyalty in Phase 1: F&B, PC/session usage, wallet top-up, or selected combinations? | Kerem | blocks Pod C | Kerem, then Pod B | Wallet top-up earning requires Pod B ledger review first; PC/session earning gated by Selcafe spike. |
| OQ-LOY-002 | What is the Phase 1 loyalty earning formula? | Kerem | blocks Pod C | Kerem, then Pod B | Must be representable as discrete immutable earn events; Pod B defines precision/rounding. |
| OQ-LOY-003 | What purchases/events are excluded from loyalty earning? | Kerem | blocks Pod C | Kerem, then Pod B | Include discounts, campaigns, refunded/cancelled purchases, wallet top-ups, manual adjustments. |
| OQ-LOY-004 | What are the loyalty redemption rules, limits, eligible targets, and cashier override rules? | Kerem | blocks Pod C | Kerem, then Pod B | Refund/cancel interaction and override authority require Pod B review. |
| OQ-LOY-005 | Do loyalty points expire? If yes, what expiry period and customer notification policy apply? | Kerem + legal advisor | blocks legal / Pod C if included | Kerem + legal advisor | Expiry requires customer-notification/legal-advisor input; reminder classification may be marketing/legal-sensitive. |
| OQ-WAL-001 | What wallet top-up methods are allowed at cashier in Phase 1: cash, card through existing POS, manual admin entry, or selected combinations? | Kerem | blocks Pod C | Kerem, then Pod B | Per-method ledger typing and reconciliation require Pod B. |
| OQ-WAL-002 | How are mistaken wallet top-ups corrected without direct balance overwrite? | Kerem + Pod B | blocks Pod C | Kerem, then Pod B | Mechanism must be compensating ledger event, never overwrite. Actor authority is security-sensitive. |
| OQ-WAL-003 | What fields should the ADMIN daily top-up report include? | Kerem + Pod B | blocks Pod C | Kerem, then Pod B | Customer identifier must remain masked/minimized; retention requires legal input. |
| OQ-WAL-004 | Should CASHIER have a "my recent transactions" view limited to their own processed actions? | Kerem | not blocking yet | Kerem, then Pod B if scoped | [REQUIRES POD B REVIEW] if included: masked-only, own-actions-only, KVKK data-scoping. |
| OQ-RES-001 | What reservation time slots are allowed in Phase 1? | Kerem | blocks Pod C | Kerem, then Pod B | State-machine review required. |
| OQ-RES-002 | What reservation limits apply per customer? | Kerem | blocks Pod C | Kerem, then Pod B | Prevents hoarding; customer-facing restriction policy. |
| OQ-RES-003 | What cancellation rules apply for customer and staff? | Kerem | blocks Pod C | Kerem, then Pod B | State-machine review required. |
| OQ-RES-004 | What no-show grace period and consequence apply? | Kerem | blocks Pod C | Kerem, then Pod B | Future reservation restriction has customer-communication and possible KVKK implications. |
| OQ-RES-005 | What criteria should staff use when approving/rejecting reservation requests without reliable automated PC/session status? | Kerem + Pod B | blocks Pod C | Kerem after Selcafe spike, then Pod B | Do not lock status-based approval criteria before Selcafe spike results. Phase 1 stays manual staff judgment by design unless spike supports more. |
| OQ-SEL-001 | What customer data should be imported or mapped from Selcafe if read-only sync is feasible? | Kerem + Pod B | blocks Pod C for sync | Kerem, then Pod B | Intent only before spike. No final field mapping until Selcafe spike + KVKK/legal review. |
| OQ-SEL-002 | What is the result of the Selcafe feasibility spike, and is Phase 1 read-only sync feasible, partial, or not feasible? | Pod C + Pod B + Kerem | blocks Pod C for sync | Pod C, then Pod B | Spike must use read-only access and no real customer data in docs/AI sessions. |
| OQ-MVP-001 | Are campaign/subscription/ARPU features explicitly excluded from Phase 1 MVP and tracked only in feature discovery? | Kerem + Pod A | not blocking yet | Kerem | Can be answered while SMS/legal replies are pending. |
| OQ-UX-001 | Does the Phase 1 PWA order/reservation/onboarding UX need Pod D prototype review before Pod C issues are drafted? | Pod A + Kerem | not blocking yet | Pod A, then Pod D | Can be answered while SMS/legal replies are pending. |
| OQ-LAUNCH-001 | What launch gate checklist must be satisfied after SMS and legal advisor feedback arrive? | Kerem + Pod A + Pod B | blocks launch | Kerem + Pod A + Pod B | Should be finalized after provider/legal inputs land. |
| OQ-AUTH-001 | Who owns the Phase 1 SMS global spend/volume ceiling response path, and what ceiling value triggers circuit breaker/escalation? | Kerem + Pod B | blocks Pod C auth issue prep | Kerem + Pod B | Can be answered while provider/legal replies are pending. Does not select provider. |
| OQ-AUTH-002 | What is the initial ADMIN bootstrap procedure for Phase 1? | Kerem + Pod B | blocks Pod C auth issue prep | Kerem + Pod B | From Accepted auth threat model IR-24; security-sensitive, not a Pod A decision. |

## Resolved / No Longer Open in This List

### Architectural / design resolutions

| Former issue | Resolution | Remaining open dependencies / guardrails |
|---|---|---|
| OQ-AUDIT-001 — audit event schema | Resolved (design) by `/docs/architecture/AUDIT_EVENT_SCHEMA.md`; Kerem-accepted 2026-06-15 (KD-A unified store, KD-B scoped IP/device capture, KD-C Option B hash chain, KD-F mapping, KD-G accept). | Pod-B-then-Kerem architectural resolution; not a Kerem product-decision lock. KD-D retention remains open under OQ-LEGAL-005; KD-E `DATA_PROCESSING_INVENTORY.md` remains open. Does not authorize Pod C. |

### Kerem product-decision resolutions

| Former issue | Resolution | Do not reopen |
|---|---|---|
| Customer-facing OTP send-failure fallback | Resolved by `CORE_USER_FLOWS.md` §3.5.3. | Neutral failure copy, no completed account, no persistent raw phone retention after failed send, derived-identifier audit. |
| Pod B SMS provider report | Report exists as `/docs/decision-support/SMS_PROVIDER_REPORT.md`. | Remaining question is provider selection, not report production. |
| Privacy-notice text location | K-14 locked: `/docs/PRIVACY_NOTICE_TR.md`, build-time embedded, no CMS. | Do not reopen CMS/runtime notice editor for Phase 1. |
| Privacy acknowledgment persistence mechanics | K-15 locked. | Only legal-advisor sufficiency remains open. |
| Same-session acknowledgment reuse mechanics | K-16 locked. | Only legal-advisor sufficiency remains open. |
| OQ-ORDER-001 — customer-visible F&B order statuses | Resolved by Kerem's 2026-06-12 F&B lifecycle decisions recorded in `BUSINESS_RULES.md`: Submitted, Accepted, Preparing, Ready / On the way, Delivered, Rejected, Cancelled. | Do not reopen as a Kerem product-decision item. Pod B must still formalize lifecycle/state transitions, actors, and audit points before Pod C. |
| OQ-ORDER-002 — customer F&B cancellation boundary | Resolved by Kerem's 2026-06-12 F&B lifecycle decisions recorded in `BUSINESS_RULES.md`: customer cancellation is allowed before the order enters Preparing and blocked after Preparing has started. | Do not reopen as a Kerem product-decision item unless Kerem corrects the boundary. Pod B must still formalize the exact transition boundary and concurrency handling. |
| OQ-ORDER-003 — unavailable F&B item handling | Resolved by Kerem's 2026-06-12 F&B lifecycle decisions recorded in `BUSINESS_RULES.md`: unavailable item means the full order is Rejected and the customer submits a new order. | Do not reopen partial-order handling for Phase 1 unless Kerem explicitly changes product policy. Pod B must still formalize audit point and customer-visible copy. |
| OQ-ORDER-004 — F&B payment/fulfillment visibility | Resolved by Kerem's 2026-06-12 F&B lifecycle decisions recorded in `BUSINESS_RULES.md`: customer sees a combined customer-facing order/payment status in Phase 1, with no customer self-pay UI and cashier-only payment preserved. | Do not reopen as a Kerem product-decision item. Pod B must still formalize the combined display/status model. |

## End Status

### Ready for Kerem decision-prep?

Yes — for the business decisions that do not require the pending SMS provider commercial replies or legal/KVKK advisor answers.

Use this list to answer loyalty, wallet, F&B order, reservation, audit-intent, Selcafe-mapping-intent, MVP-boundary, and Pod D UX-review questions. Do not use it to select the SMS provider before commercial/legal inputs, resolve legal/KVKK positions, or authorize implementation.

### Ready for Pod B confirmation?

Yes — Pod B confirmation has been received per PR context. The packet remains decision-prep only and does not alter locked decisions.

### Ready for Pod C?

No.

Reasons:

- SMS provider is still not selected.
- Legal/KVKK advisor feedback is still pending.
- Aydınlatma Metni legal text is still not finalized.
- K-15/K-16 legal sufficiency is still awaiting advisor confirmation before Pod C propagation.
- Wallet/loyalty ledger ADRs are still backlog/stub-level and full Pod B designs are required.
- Loyalty eligibility, formula, redemption limits, expiry, and override rules are unresolved.
- Wallet top-up methods, correction rules, and daily report fields are unresolved.
- F&B order lifecycle implementation remains blocked by Pod B formalization/review of lifecycle transitions, actors, audit points, cancellation boundaries, combined payment/order display, wallet debit ledger design, loyalty accrual append-event design, and any reversal logic.
- Reservation slots, limits, cancellation, no-show, and state machine are unresolved.
- Selcafe read-only sync depends on spike results and adapter review.
- Pod C issues must meet Definition of Ready and must not rely on guessed business rules.

### Kerem decisions needed next

1. Loyalty earning eligibility.
2. Loyalty earning formula.
3. Loyalty earning exclusions.
4. Loyalty redemption unit, targets, limits, and cashier/admin override policy.
5. Loyalty expiry preference, with customer-notification/legal-advisor input before finalization.
6. Wallet top-up methods.
7. Wallet correction/reversal policy intent.
8. ADMIN daily top-up report fields.
9. Whether CASHIER should have a scoped "my recent transactions" view.
10. Reservation slots, advance window, active limits, cancellation cutoff, no-show grace, and no-show consequence.
11. Manual reservation approval policy, while avoiding status-based Selcafe criteria until the spike returns.
12. Audit business intent: where reason/comment is mandatory.
13. Selcafe customer-mapping intent, without final field mapping.
14. IR-25 SMS spend/volume ceiling value and operational response owner.
15. Initial ADMIN bootstrap policy, routed to Pod B for security review.
16. Campaign/subscription/ARPU feature boundary for Phase 1 vs feature discovery.
17. Whether Pod D should prototype/review onboarding, order, and reservation UX before Pod C issue drafting.
