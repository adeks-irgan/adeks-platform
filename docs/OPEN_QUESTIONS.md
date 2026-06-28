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
- This document does not authorize Pod C implementation.
- Phase 1 remains read-only toward Selcafe; Selcafe remains the settlement source of truth for this operating spine.

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
| OQ-RES-005 | What criteria should staff use when approving/rejecting reservation requests without reliable automated PC/session status? | Kerem + Pod B | blocks Pod C | Kerem, then Pod B | Do not lock status-based approval criteria before Pod B review confirms reliable Selcafe status support. Phase 1 stays manual staff judgment by design unless Pod B review supports more. |
| OQ-SEL-001 | Which remaining Selcafe product-alignment items must be resolved before a separately approved implementation issue can be prepared? | Kerem + Pod A + Pod B | blocks Selcafe implementation issue prep | Kerem + Pod A, then Pod B for gate/integration implications | PR #101 reconciled ROADMAP.md after the completed Selcafe spike/report and accepted ADR-005. Phase 1 remains read-only. Do not authorize Pod C. Any future implementation requires a separate approved Definition-of-Ready issue, planned integration-view readiness, Pod B + Kerem approval, and legal/KVKK/cross-border clearance where PII or cross-border is in scope. |
| OQ-MVP-001 | Are campaign/subscription/ARPU features explicitly excluded from Phase 1 MVP and tracked only in feature discovery? | Kerem + Pod A | resolved for operating spine | Resolved by K-21/K-OS-004 | One simple combined PC + F&B coupon/discount is included in the operating spine. Complex campaigns, tiers, subscriptions, and broad ARPU campaign modeling remain excluded from this operating spine. |
| OQ-OS-001 | What exact eligibility rule applies to the first simple combined PC + F&B coupon? | Kerem + Pod A | blocks coupon issue prep | Kerem, then Pod B | K-21 includes one simple coupon but does not define eligibility. Options include new account, first PWA order, selected pilot users, or all pilot users. |
| OQ-OS-002 | What exact coupon rejection/correction reason list should cashier use? | Kerem + Pod A | blocks coupon/audit issue prep | Kerem, then Pod B | K-21 allows applied/rejected/corrected status. Reason taxonomy and customer-visible explanation remain open. |
| OQ-OS-003 | What PC/session loyalty formula applies if Pod B confirms reliable PC/session settlement data? | Kerem + Pod A + Pod B | blocks PC/session loyalty design | Kerem, then Pod B | K-21 sets F&B + PC/session as product target. K-18 remains locked for F&B only. |
| OQ-OS-004 | Does the 2% mismatch warning apply to estimated total vs current Selcafe total, coupon-adjusted estimate, or both? | Kerem + Pod A + Pod B | blocks settlement comparison design | Kerem, then Pod B | K-21 approves 2% threshold as pre-settlement warning threshold. Final settled amount must still come from Selcafe. |
| OQ-OS-005 | What exact first-week admin/back-office check report fields and cadence should be used? | Kerem + Pod A + Pod B | blocks pilot admin-check design | Kerem, then Pod B | K-21 approves disputed orders + ten random orders, checking coupon application and final settled amount, summarized for Kerem. Daily first-week cadence is recommended unless Kerem changes it. |
| OQ-OS-006 | What ADR-005 read-surface reconciliation is required before active Selcafe visit/bill/order-line visibility can be implemented? | Pod B + Kerem + legal advisor | blocks active bill/order-line implementation issue prep | Pod B, then Kerem/legal | KD-1 sets product direction only. Selcafe member identity/profile data remains excluded, but active bill/order-line data may still be sensitive or PII-by-linkage. |
| OQ-OS-007 | What KVKK/legal basis, retention, data-minimization, and auditability requirements apply to active visit/bill/order-line visibility? | Pod B + Kerem + legal advisor | blocks implementation issue prep | legal advisor + Pod B | Must be resolved before any implementation issue. Do not use real data in analysis or examples. |
| OQ-OS-008 | What customer-facing and staff-facing UX/monitoring should support 2% mismatch warnings, pilot pause triggers, and first-week admin checks? | Pod A + Pod B + Pod D + Kerem | not implementation-ready | Pod B risk review, then Pod D UX/monitoring review | K-21 approves values/policy, but mechanics and visibility remain later review work. |
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
| OQ-SEL-002 — Selcafe feasibility spike result | Resolved by completed `SELCAFE_SPIKE_REPORT.md` and accepted `docs/adr/ADR-005-selcafe-read-only-adapter.md`; ROADMAP.md was reconciled in PR #101. | Discovery/report/ADR status is no longer open. Remaining open work is product alignment and implementation-readiness gating under OQ-SEL-001. Does not authorize Pod C, change ADR-005, or change the Phase 1 read-only posture. |

### Operating-spine reconciliation resolutions

| Former issue / dependency | Resolution | Remaining open dependencies / guardrails |
|---|---|---|
| Guest/addition flow vs account requirement | Resolved by K-21/K-OS-001: addition-only guest may order; coupon, loyalty, and settled visit history require Adeks account binding before final settlement. | Pod B review required for auth, KVKK, audit, and abuse boundary. |
| PC/session visibility in operating spine | Resolved by K-21/K-OS-002: customer-visible PC start/stop/duration/cost estimates are included if Selcafe read is reliable; hide financial estimates if unreliable. | Pod B review required for Selcafe read feasibility, freshness, and calculation trust. |
| First-slice F&B status vs broader lifecycle | Resolved by K-21/K-OS-003: broader lifecycle may remain internal/later, but first-slice customer status is simplified and does not include delivered tracking. | Pod B review required to reconcile accepted lifecycle model. |
| Simple coupon vs campaign exclusion | Resolved by K-21/K-OS-004: one simple combined PC + F&B coupon/discount is included; campaign engine, complex campaigns, tiers, and subscriptions remain excluded from this operating spine. | Coupon eligibility, rejection/correction reasons, audit, and settlement implications remain open. |
| Operating-spine loyalty basis | Resolved by K-21/K-OS-005 as product target: F&B + PC/session earning after settlement; F&B formula remains K-18; PC/session earning falls back to F&B-only if unreliable. | Pod B review required for PC/session data, ledger, correction, and KVKK implications. |
| Wallet payment/spending in operating spine | Resolved by K-21/K-OS-006: excluded from this operating spine only; wallet visibility/top-up may remain separate Phase 1 scope behind existing gates. | Existing wallet implementation blockers remain. |
| Settlement trust controls | Resolved by K-21/K-OS-007: 2% pre-settlement mismatch threshold, pause triggers, and first-week admin checks approved. | Pod B review required for audit/report/monitoring mechanics. |
| Active visit/bill/order-line product direction | Clarified by KD-1: constrained Option B selected. Product Phase 1 direction includes Selcafe-sourced active visit/bill/order-line visibility for the active `fiş` / visit, including cashier/staff-entered F&B items not submitted through Adeks PWA. | Not implementation-authorized. ADR-005 read-surface expansion, KVKK/legal review, auditability, retention, and data-minimization review remain required. Selcafe member identity/profile reads remain excluded. |
| K-20 PI-1 relationship | Clarified by KD-2: K-OS-002 supersedes/subsumes K-20 PI-1 only for customer-visible PC/session estimates inside the approved operating spine. | Broader real-time station/session status, PC availability exposure, automatic reservation confirmation, and PC-status-dependent reservation automation remain deferred unless separately approved. |

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
5. Selcafe product-alignment items required before any separately approved implementation issue can be prepared, while preserving ADR-005, read-only posture, and legal/KVKK/cross-border gates where applicable.
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
- Selcafe read-only sync/integration remains blocked by unresolved product alignment, planned integration-view readiness, dedicated read-only login/secrets prerequisites, a separately approved Definition-of-Ready issue, Pod B + Kerem approval, and legal/KVKK/cross-border gates where PII or cross-border is in scope.
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
11. Decide manual reservation approval policy, while avoiding automated Selcafe-status criteria until Pod B review confirms reliable Selcafe status support.
12. Decide remaining Selcafe product-alignment items required before any separately approved implementation issue can be prepared; do not authorize broader access, direct writes, or implementation from this decision alone.
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
