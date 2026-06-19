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
| OQ-SMS-002 | What is the provider-outage / availability response path if the SMS provider is unavailable? | Kerem + Pod B | blocks Pod C auth issue prep | Kerem + Pod B | Narrowed to provider outage/availability response only: secondary-provider policy, switchover posture, and availability-failure response path. Spend-volume ceiling values and `ADMIN` response-path owner are resolved at design level — see `AUTH_THREAT_MODEL.md` v0.5 §15. Customer-facing send-failure UX is resolved by CUF §3.5.3. |
| OQ-LEGAL-001 | What exact Turkish Aydınlatma Metni text must be displayed in the PWA? | Kerem + legal advisor | blocks legal / launch | legal advisor | K-14 is locked: text lives in `/docs/PRIVACY_NOTICE_TR.md`, build-time embedded, no CMS in Phase 1. Only the wording remains open. |
| OQ-LEGAL-002 | Does legal advisor confirm K-15's acknowledgment persistence model is KVKK-sufficient? | Kerem + legal advisor + Pod B | blocks Pod C propagation | legal advisor | K-15 is locked: ephemeral pre-verification, persisted only on successful OTP verification. Only legal sufficiency remains open. |
| OQ-LEGAL-003 | Does legal advisor confirm K-16's same-session acknowledgment reuse for OTP resend is KVKK-sufficient? | Kerem + legal advisor + Pod B | blocks Pod C propagation | legal advisor | K-16 is locked: reuse valid only in uninterrupted session; re-ack on session break or phone-number change. Only legal sufficiency remains open. |
| OQ-LEGAL-004 | Is VERBİS registration required before go-live with real customer data, or is Adeks exempt? | Kerem + legal advisor | blocks launch | legal advisor | K-07 says Kerem consults legal advisor and acts accordingly. |
| OQ-LEGAL-005 | What retention periods apply to customer account, phone, wallet, loyalty, order, reservation, audit, auth, and Selcafe-discovered data? | Kerem + legal advisor + Pod B | blocks legal / launch | legal advisor + Pod B | Needed for auth, audit, wallet/loyalty, and customer-data views. |
| OQ-LEGAL-006 | Is any cross-border transfer created by hosting, SMS provider, monitoring, logging, or support tooling? | Kerem + legal advisor + Pod B | blocks launch | legal advisor + Pod B | SMS provider choice and hosting model affect answer. |
| OQ-LOY-001 | Are any non-F&B earning events included in Phase 1 loyalty, or is Phase 1 earning limited to the accepted F&B settlement accrual design? | Kerem + Pod A | blocks only non-F&B loyalty issue prep | Kerem, then Pod B if non-F&B earning is included | Do not reopen K-18 or ADR-007. Accepted F&B accrual is locked: `floor(settled_kuruş / 1000)` on cashier-recorded F&B settlement. |
| OQ-LOY-002 | If non-F&B earning is later included, what formula applies to those non-F&B earning events? | Kerem | blocks only non-F&B loyalty earning | Kerem, then Pod B | F&B formula is not open. This row is only for non-F&B earning if Kerem includes it later. |
| OQ-LOY-003 | What broader loyalty exclusion rules apply beyond the accepted F&B cancelled/rejected/corrected-order mechanics? | Kerem | blocks loyalty issue prep | Kerem, then Pod B | Include discounts, campaigns, wallet top-ups, manual adjustments, refunds/corrections outside the accepted F&B settlement path, and any non-F&B earning if included. |
| OQ-LOY-004 | What are the loyalty redemption rules, limits, eligible targets, and cashier/admin override rules? | Kerem | blocks Pod C | Kerem, then Pod B | Redemption entry types and authority are not designed in ADR-007. Refund/cancel interaction and override authority require Pod B review. |
| OQ-LOY-005 | Do loyalty points expire? If yes, what expiry period and customer notification policy apply? | Kerem + legal advisor | blocks legal / Pod C if included | Kerem + legal advisor, then Pod B | Expiry requires legal-advisor input. Expiry reminders may be marketing/legal-sensitive and must not be implemented from assumptions. |
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

| OQ-AUTH-002 | What is the initial ADMIN bootstrap procedure for Phase 1? | Kerem + Pod B | blocks Pod C auth issue prep | Kerem + Pod B | From Accepted auth threat model IR-24; security-sensitive, not a Pod A decision. |

## Resolved / No Longer Open in This List

### Architectural / design resolutions

| Former issue / dependency | Resolution | Remaining open dependencies / guardrails |
|---|---|---|
| OQ-AUTH-001 — IR-25 SMS app-side spend/volume ceiling and response-path owner | Resolved at design level by `AUTH_THREAT_MODEL.md` v0.5 §15 (Kerem decision 2026-06-19). Spend-count ceiling values decided: soft 150/hr, hard 300/hr, +100 override band (effective ceiling 400 while a cashier-unilateral override is active). Operational response-path owner decided: `ADMIN`. Does not select a provider; does not define a currency-denominated spend ceiling. Calibration caveat: 150/300/+100 values are provisional pending observed live OTP traffic. | Remaining open dependencies: BL-1 (provider-side cost controls cannot be assessed until a provider is named); OQ-SMS-002 narrowed (provider outage/availability — see open table). Does not authorize Pod C. |
| OQ-AUDIT-001 — audit event schema | Resolved at design level by `/docs/architecture/AUDIT_EVENT_SCHEMA.md`; Kerem-accepted 2026-06-15 in PR #66. KD-A unified store, KD-B scoped IP/device capture, KD-C Option B hash chain, KD-F mapping, and KD-G accept are accepted. | Pod-B-then-Kerem architectural resolution; not a Kerem product-decision lock. KD-D retention remains open under OQ-LEGAL-005. KD-E inventory entries are recorded in the now-present `/docs/DATA_PROCESSING_INVENTORY.md` (Kerem-approved 2026-06-15); KD-E inventory-artifact prerequisite is satisfied. Audit implementation still requires legal/KVKK retention/legal-basis closure and approved issue packets. Does not authorize Pod C. |
| F&B lifecycle/state-model formalization | Resolved by accepted `/docs/architecture/FB_ORDER_LIFECYCLE_STATE_MODEL_v1.0.md`. | Do not reopen the accepted state model. F&B implementation still requires API/schema/security/KVKK/ledger/DoR issue packets. Does not authorize Pod C. |
| ADR-006 wallet append-only ledger design | Resolved at design level by accepted `/docs/adr/ADR-006-wallet-append-only-ledger.md`. | Implementation remains blocked by legal/KVKK artifacts, wallet top-up methods, top-up correction/report fields, security/DoR issue packets, and separate Pod B + Kerem-approved implementation issues. |
| ADR-007 loyalty append-only ledger design | Resolved at design level by accepted `/docs/adr/ADR-007-loyalty-append-only-ledger.md`. | F&B accrual formula is locked. Redemption, expiry, broader exclusions, override rules, non-F&B earning if included, legal/KVKK artifacts, security/DoR issue packets, and separate Pod B + Kerem-approved implementation issues remain open. |

### Kerem product-decision resolutions

| Former issue | Resolution | Do not reopen |
|---|---|---|
| Customer-facing OTP send-failure fallback | Resolved by `CORE_USER_FLOWS.md` §3.5.3. | Neutral failure copy, no completed account on failed send, no persistent raw phone retention after failed send, derived-identifier audit. |
| Pod B SMS provider report | Report exists as `/docs/decision-support/SMS_PROVIDER_REPORT.md`. | Remaining question is provider selection after commercial replies and legal/KVKK processor/cross-border review, not report production. |
| Privacy-notice text location | K-14 locked: `/docs/PRIVACY_NOTICE_TR.md`, build-time embedded, no CMS. | Do not reopen CMS/runtime notice editor for Phase 1. |
| Privacy acknowledgment persistence mechanics | K-15 locked. | Only legal-advisor sufficiency remains open. |
| Same-session acknowledgment reuse mechanics | K-16 locked. | Only legal-advisor sufficiency remains open. |
| OQ-ORDER-001 — customer-visible F&B order statuses | Resolved by Kerem's 2026-06-12 F&B lifecycle decisions recorded in `BUSINESS_RULES.md` and formalized in the accepted F&B lifecycle state model: Submitted, Accepted, Preparing, Ready / On the way, Delivered, Rejected, Cancelled. | Do not reopen as a Kerem product-decision item. Do not reopen the accepted F&B lifecycle state model. |
| OQ-ORDER-002 — customer F&B cancellation boundary | Resolved by Kerem's 2026-06-12 F&B lifecycle decisions recorded in `BUSINESS_RULES.md` and formalized in the accepted F&B lifecycle state model: customer cancellation is allowed before Preparing and blocked after Preparing starts. | Do not reopen unless Kerem explicitly changes the boundary. Do not reopen the accepted F&B lifecycle state model. |
| OQ-ORDER-003 — unavailable F&B item handling | Resolved by Kerem's 2026-06-12 F&B lifecycle decisions recorded in `BUSINESS_RULES.md` and formalized in the accepted F&B lifecycle state model: unavailable item means the full order is Rejected and the customer submits a new order. | Do not reopen partial-order handling for Phase 1 unless Kerem explicitly changes product policy. Do not reopen the accepted F&B lifecycle state model. |
| OQ-ORDER-004 — F&B payment/fulfillment visibility | Resolved by Kerem's 2026-06-12 F&B lifecycle decisions recorded in `BUSINESS_RULES.md` and formalized in the accepted F&B lifecycle state model: customer sees one combined customer-facing status; settlement remains internal/cashier-only. | Do not reopen customer self-pay or customer-visible settlement state for Phase 1. Do not reopen the accepted F&B lifecycle state model. |
| K-17 — F&B price source for settlement | Locked: settlement uses the immutable price snapshot captured at order submission. | Do not reopen catalog-price-at-settlement or mutable post-submission price lookup for Phase 1. |
| K-18 — F&B loyalty accrual formula | Locked: `floor(0.10 × settled_amount_TRY)` = `floor(settled_kuruş / 1000)`, triggered when cashier records F&B settlement. | Do not reopen F&B accrual formula, precision, rounding, or trigger. |
| K-19 — F&B post-settlement correction policy | Locked: cashier same-shift self-correction for own settlements only; cashier-executed; minimized customer-visible history; reason-code home in ADR-006. | Do not reopen accepted correction executor, correction visibility, or append-only correction discipline. |

## End Status

### Ready for Kerem decision-prep?

Yes — for the remaining business/product decisions that can be decided without inventing legal/KVKK answers or SMS provider commercial terms.

Use this list to prepare decisions on:

1. SMS provider outage / availability response path (secondary-provider policy, switchover posture). Spend-ceiling values and `ADMIN` response-path owner are decided at design level — `AUTH_THREAT_MODEL.md` v0.5 §15.
2. Wallet top-up methods, top-up correction policy, and ADMIN daily report fields.
3. Loyalty redemption, expiry, broader exclusion, and cashier/admin override rules.
4. Reservation slots, limits, cancellation, no-show, and manual approval rules.
5. Selcafe customer-mapping intent after the read-only spike and legal/KVKK review.
6. MVP boundary for any non-Phase-1 feature discovery, if Kerem wants that clarified separately.

Do not use this list to:

- select an SMS provider before commercial replies and legal/KVKK processor/cross-border review;
- invent legal basis, retention, VERBİS, cross-border, privacy-notice, or K-15/K-16 sufficiency answers;
- reopen accepted ADR-006, ADR-007, K-17, K-18, K-19, or the accepted F&B lifecycle state model;
- authorize Pod C.

### Ready for Pod B confirmation?

Yes — Pod B has reviewed and cleared this reconciliation with no blocking findings. NB-1 and NB-2 corrections are applied in this patch.

This update remains a documentation reconciliation only. It:

- correctly reflects accepted ADR-006 and ADR-007 state;
- preserves the accepted F&B lifecycle state model;
- does not reopen K-17, K-18, K-19, ADR-006, ADR-007, or the accepted F&B lifecycle state model;
- keeps Pod C blocked;
- does not create architecture, schema, API, security, KVKK, or implementation decisions.

### Ready for Pod C?

No.

Reasons:

- Legal/KVKK advisor answers are still pending.
- `/docs/DATA_RETENTION_POLICY.md` is still required for retention closure.
- `/docs/KVKK_LEGAL_BASIS.md` is still required for legal-basis closure.
- `/docs/CROSS_BORDER_TRANSFER_ASSESSMENT.md` is still required for hosting/SMS/monitoring/logging/support transfer assessment.
- Final Turkish `/docs/PRIVACY_NOTICE_TR.md` legal text is still pending.
- K-15/K-16 legal sufficiency still awaits legal-advisor confirmation before Pod C propagation.
- SMS provider selection is still pending commercial replies and legal/KVKK processor/cross-border review.
- SMS provider outage / availability response path is still pending. (Spend-volume ceiling values and `ADMIN` response-path owner are decided at design level — `AUTH_THREAT_MODEL.md` v0.5 §15.)
- Wallet top-up methods, top-up correction policy, and ADMIN daily report fields remain unresolved.
- Loyalty redemption, expiry, broader exclusions, and cashier/admin override rules remain unresolved.
- Reservation product rules and reservation state machine remain unresolved.
- Selcafe read-only sync/integration depends on the Selcafe spike result, `/docs/SELCAFE_SPIKE_REPORT.md`, and Pod B adapter/integration review.
- F&B implementation still requires API/schema/security/KVKK/ledger/DoR issue packets even though the lifecycle state model, ADR-006, ADR-007, K-17, K-18, and K-19 are accepted.
- No Pod B + Kerem-approved implementation issue packet exists for the affected areas.
- This document is documentation-only and not implementation-ready.

### Kerem decisions needed next

1. Obtain and record legal/KVKK advisor answers for privacy notice text, K-15/K-16 sufficiency, VERBİS/exemption, retention, legal basis, and cross-border transfer.
2. Approve or direct production of `/docs/DATA_RETENTION_POLICY.md`, `/docs/KVKK_LEGAL_BASIS.md`, and `/docs/CROSS_BORDER_TRANSFER_ASSESSMENT.md` after legal/KVKK input.
3. Select SMS provider after commercial replies and legal/KVKK processor/cross-border assessment.
4. Decide SMS provider outage / availability response path (secondary-provider policy, switchover posture). Spend-volume ceiling values and `ADMIN` response-path owner are decided at design level — `AUTH_THREAT_MODEL.md` v0.5 §15.
5. Decide wallet top-up methods for Phase 1.
6. Decide wallet top-up correction policy and ADMIN daily top-up report fields.
7. Decide loyalty redemption unit, targets, limits, and cashier/admin override policy.
8. Decide loyalty expiry and notification policy after legal-advisor input.
9. Decide broader loyalty exclusion rules not already fixed by accepted F&B settlement/correction design.
10. Decide reservation slots, advance window, active limits, cancellation cutoff, no-show grace, and no-show consequence.
11. Decide manual reservation approval policy, while avoiding automated Selcafe-status criteria until the spike result supports them.
12. Decide Selcafe customer-mapping intent only after the read-only spike result and legal/KVKK review.
13. Approve sequencing for API/schema/security/DoR issue packets only after the relevant legal, business, architecture, and security gates are closed.

### Documentation-only status

This reconciliation is documentation-only.

It does not:

- create a new product decision;
- reopen accepted decisions;
- approve architecture, schema, API, security, KVKK, wallet, loyalty, reservation, Selcafe, or audit implementation design;
- create GitHub issues;
- authorize Pod C.

## Review Routing

- Ready for commit: Yes — documentation-only patch is ready for Kerem approval to merge.
- Requires Kerem approval: Yes — next stop is Kerem approval to commit/merge this documentation-only reconciliation.
- Requires Pod B review: No further Pod B review required for this patch; Pod B cleared it with no blocking findings and NB-1/NB-2 are applied.
- Requires Pod C implementation: No. [REQUIRES POD C IMPLEMENTATION] only after future approved issue packets exist.
- Requires Pod D prototype/audit/monitoring review: No for this reconciliation; yes later for PWA UX prototype/review, monitoring spec, and pre-go-live audit where separately scoped.
