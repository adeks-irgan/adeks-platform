# MVP_SCOPE.md

## Status

| Field | Value |
|---|---|
| Document | MVP_SCOPE.md |
| Version | v0.5 operating-spine reconciliation — 2026-06-28 |
| Owner | Pod A — Product & Planning |
| Reviewer | Pod B — Architecture, Logic & Risk |
| Approver | Kerem |
| Current status | Reconciled with Kerem-approved Product Phase 1 operating spine and K-21/K-OS decisions; not implementation-ready |
| Scope of this version | Documentation-only product-scope reconciliation. Aligns Product Phase 1 around Selcafe-linked customer visibility and ordering; does not authorize Pod C. |
| Target repo path | `/docs/MVP_SCOPE.md` |

## Freshness Baseline

| Source | Version / SHA / status read | Date read | Use in this draft |
|---|---:|---:|---|
| `/docs/AGENT_CONTEXT_MANIFEST.md` | SHA `6ff11efd`; active context-routing index | 2026-06-16 | Confirmed context loading and review routing. |
| `/docs/PROJECT_METHODOLOGY.md` | SHA `d3355d0`; header stale at v0.8, revision log contains v0.9 | 2026-06-16 | Confirmed Pod boundaries, Definition of Ready, and methodology-governance review requirements. |
| `/docs/PROJECT_DECISION_INDEX.md` | SHA `e9eaf85d`; last updated 2026-06-16 | 2026-06-16 | Confirmed ADR-006, ADR-007, ADR-015 accepted; K-17/K-18/K-19 locked. |
| `/docs/KEREM_DECISIONS.md` | SHA `5999d9a`; v1.6 | 2026-06-16 | Confirmed K-01 through K-19 recorded, including K-17/K-18/K-19. |
| `/docs/BUSINESS_RULES.md` | SHA `c8c00ad`; v0.2 decision-prep with F&B formula corrected | 2026-06-16 | Source for current business-rule wording. |
| `/docs/OPEN_QUESTIONS.md` | SHA `d96c31e`; v0.2 replacement draft | 2026-06-16 | Confirmed F&B lifecycle, ADR-006, ADR-007, K-17, K-18, K-19 are no longer open. |
| `/docs/architecture/FB_ORDER_LIFECYCLE_STATE_MODEL_v1.0.md` | SHA `91f21fe`; Accepted 2026-06-13 | 2026-06-16 | Confirms F&B lifecycle/state model accepted; no Pod C authorization. |
| `/docs/architecture/AUDIT_EVENT_SCHEMA.md` | Accepted 2026-06-15; PR #66 | 2026-06-16 | Confirms OQ-AUDIT-001 resolved at design level; implementation still blocked by legal/KVKK and issue-readiness gates. |
| `/docs/adr/ADR-006-wallet-append-only-ledger.md` | SHA `4a9a339`; Accepted 2026-06-14 | 2026-06-16 | Confirms wallet append-only ledger design accepted; implementation blocked. |
| `/docs/adr/ADR-007-loyalty-append-only-ledger.md` | SHA `42ffd1a`; Accepted 2026-06-14 | 2026-06-16 | Confirms loyalty append-only ledger design and K-18 formula accepted; implementation blocked. |
| `/docs/SECURITY_REVIEW.md` | SHA `f96af72`; draft/review-level security artifact | 2026-06-16 | Confirms review-level security artifact exists; still no Pod C authorization. |
| `/docs/DATA_PROCESSING_INVENTORY.md` | SHA `5d6da97`; v0.1 Kerem-approved 2026-06-15 | 2026-06-16 | Confirms data-processing inventory prerequisite satisfied at inventory level only. |
| `/docs/planning/OPERATING_SLICE_DISCOVERY_v0.1.md` | Kerem-approved provisional operating-model spine | 2026-06-28 | Source for Product Phase 1 spine: Selcafe-linked customer visibility and ordering. |
| `/docs/planning/SCOPE_RECONCILIATION_OPERATING_SPINE_ALIGNMENT_v0.1.md` | v0.1 Kerem-approved reconciliation packet | 2026-06-28 | Source for K-OS-001…K-OS-007 scope/business-rule reconciliation. |
| `/docs/KEREM_DECISIONS.md` §21 | K-21 recorded | 2026-06-28 | Records Kerem approval of K-OS-001…K-OS-007. |

## Purpose

This document defines the Phase 1 MVP scope for Adeks Platform and separates confirmed scope from blocked, deferred, and unresolved items.

Phase 1 is a customer PWA plus web cashier/admin foundation. It includes public catalog browsing, login-gated customer features, F&B ordering from seat, wallet visibility and cashier/admin top-up, loyalty visibility and cashier-handled redemption, staff-approved reservation requests, audit logging, and read-only Selcafe discovery/sync if feasible. It does not replace Selcafe or Selcafe PC/session control.

This v0.5 draft is **documentation-only product-scope reconciliation**. This document does not authorize Pod C implementation, does not select an SMS provider, does not resolve legal/KVKK questions, and does not create implementation authority.

Phase 1 remains read-only toward Selcafe; Selcafe remains the settlement source of truth for this operating spine.

## Reconciled Current State — 2026-06-16

| Area | Corrected state |
|---|---|
| Authentication strategy | ADR-015 is Accepted. Phase 1 customer authentication is Phone OTP (SMS); staff use individual username/password; ADMIN requires TOTP MFA. Authentication threat model (`AUTH_THREAT_MODEL.md` v0.4) is accepted. |
| SMS provider state | `SMS_PROVIDER_REPORT.md` exists as decision support. Provider selection remains open pending commercial replies and legal/KVKK processor/cross-border assessment. |
| Privacy-notice flow mechanics | K-14/K-15/K-16 are locked. Legal text and legal sufficiency confirmations remain open before Pod C propagation. |
| Security/data artifacts | `SECURITY_REVIEW.md` exists at review level. `DATA_PROCESSING_INVENTORY.md` exists and is Kerem-approved at inventory level. `DATA_RETENTION_POLICY.md`, `KVKK_LEGAL_BASIS.md`, and `CROSS_BORDER_TRANSFER_ASSESSMENT.md` remain required blockers before launch/implementation claims. |
| Wallet ledger | ADR-006 is Accepted as design. Implementation remains blocked by unresolved top-up methods/correction/report fields, legal/KVKK artifacts, security/DoR issue packets, and separate Pod B + Kerem-approved implementation issues. |
| Loyalty ledger | ADR-007 is Accepted as design. F&B accrual formula is locked by K-18. Redemption, expiry, broader exclusions, non-F&B earning if included, legal/KVKK artifacts, and approved implementation packets remain open. |
| Audit event schema | `AUDIT_EVENT_SCHEMA.md` is accepted at design level. Implementation remains blocked by legal/KVKK retention/legal-basis closure and approved issue packets. |
| Selcafe | Read-only Phase 1 posture remains locked. Spike/report work and ADR-005 are complete; operating-spine Selcafe reads still require product alignment, Pod B adapter/integration review, legal/KVKK/cross-border clearance where applicable, and a separately approved Definition-of-Ready issue. |
| F&B order lifecycle | Accepted by `/docs/architecture/FB_ORDER_LIFECYCLE_STATE_MODEL_v1.0.md`; do not reopen the accepted state model. |
| F&B settlement price source | K-17 locked 2026-06-14: settlement uses immutable price snapshot captured at order submission. |
| F&B loyalty accrual | K-18 locked 2026-06-14: `floor(0.10 × settled_amount_TRY)` = `floor(settled_kuruş / 1000)`, triggered when cashier records settlement. |
| F&B post-settlement correction | K-19 locked 2026-06-14: cashier same-shift self-correction for own settlements only; cashier-executed; minimized customer-visible history; append-only correction discipline. |

## Product Phase 1 Operating Spine — K-21

Kerem approved the provisional Product Phase 1 operating spine as:

> Selcafe-linked customer visibility and ordering.

For scope purposes, this means:

1. Customer registers or uses a permitted addition-only guest flow.
2. Customer links the active Selcafe visit through `fiş / fiş numarası`.
3. Customer confirms the displayed table before ordering.
4. Customer sees Selcafe-linked visit information where read reliability supports it.
5. Customer may order F&B from the PWA.
6. Cashier manually enters accepted PWA orders into Selcafe.
7. Kitchen/service continue from Selcafe printed receipts.
8. Customer sees estimated PC + F&B totals and coupon/points information where reliable. Discount values are Adeks-calculated; pre-payment values remain estimates.
9. Final payment happens at cashier.
10. At payment/settlement, Adeks provides the cashier with a fixed-format discount reflection record for the applicable Adeks discount. The cashier selects the dedicated Adeks `islem_tip` from the Selcafe Kasiyer dropdown, enters the pseudorandom one-time Adeks discount code in `kasaislem.aciklama`, and enters the discount amount as a positive credit in `kasaislem.alacak`. The Selcafe row carries no `adisyon_no` and no Adeks customer/coupon/member identifier; Adeks holds the `code → adisyon_no → expected discount` mapping internally.
11. Adeks reads `adisyon.toplam_tutar` by `fiş` and reads the matching `kasaislem.alacak` row by dedicated Adeks `islem_tip` + pseudorandom one-time code where feasible. Adeks joins the reads inside Adeks, compares `adisyon.toplam_tutar − kasaislem.alacak` against its own discount-inclusive calculation, and gives the cashier a green light only when the result is within the 2% threshold; no clean match fails closed to manual check.
12. Adeks updates settled amount, coupon/discount status, and loyalty history after payment where supported. Selcafe remains the settlement source of truth.

The K-OS-008 discount reflection and settlement green-light steps are desired product direction only. They remain blocked on ADR-005 read-surface reconciliation, KVKK/legal review, auditability, retention, and data-minimization review before implementation. This operating spine does not authorize direct Selcafe writes, wallet/payment implementation, schema/API work, ADR drafting, Pod C implementation, or real data use.

### Post-Review Gate — KD-1 / KD-2

K-21 locks the Product Phase 1 operating-spine direction, not implementation authority.

KD-1 records constrained Option B: the product direction includes a Selcafe-sourced active visit/bill/order-line view for the active `fiş` / visit, including cashier/staff-entered F&B items not submitted through Adeks PWA. Selcafe member identity/profile data must not be read or displayed as part of this Phase 1 operating spine.

This does not authorize implementation and does not override ADR-005 by wording alone. ADR-005 read-surface expansion, KVKK/legal review, auditability, retention, and data-minimization review remain required before any implementation issue can exist.

KD-2 records that K-OS-002 supersedes/subsumes K-20 PI-1 only for customer-visible PC/session estimates inside this approved operating spine. Broader real-time station/session status, PC availability exposure, automatic reservation confirmation, and PC-status-dependent reservation automation remain deferred unless separately approved.

## Phase 1 Included Scope

| Area | Included in Phase 1 | Status |
|---|---|---|
| Customer PWA | Mobile-first customer web app. Customers can browse public catalog/menu without login. Addition-only guest ordering is permitted after `fiş / fiş numarası` link and table confirmation under K-21/K-OS-001; wallet, loyalty visibility, reservations, account/profile, coupon, loyalty, and settled visit history require account binding where applicable. | Confirmed |
| Authentication dependency | Customer login uses Phone OTP (SMS). Staff use individual username/password. ADMIN uses username/password + TOTP MFA. | Confirmed by ADR-015/K-13; SMS provider not selected |
| Public catalog/menu | Public browsing is allowed without authentication. | Confirmed |
| Cashier/admin web interface | Browser-based staff interface for order handling, wallet top-up, loyalty redemption, reservation review, permitted customer data, and audit visibility. | Confirmed |
| F&B ordering | Customer submits F&B order from seat after `fiş / fiş numarası` link and table confirmation. Addition-only guest ordering is permitted under K-21/K-OS-001. Cashier manually enters accepted PWA orders into Selcafe; kitchen/service continue from Selcafe printed receipts. | Confirmed. F&B lifecycle/state model remains accepted as broader/internal-or-later reference. Still blocked for implementation by API/schema/security/KVKK/DoR issue packets and separate Pod B + Kerem-approved implementation issues. No Pod C authorization. |
| Wallet | Customer wallet visibility and cashier/admin wallet top-up. Append-only ledger, derived balance, no direct overwrite, audit logging. | Included. ADR-006 accepted as design; top-up methods, top-up correction, daily report fields, legal/KVKK artifacts, and implementation issue packets remain blocking. |
| Loyalty | Customer loyalty visibility, confirmed F&B accrual, automatic earning on any later-approved eligible purchases, cashier-handled redemption. Append-only ledger, derived balance, no direct overwrite, audit logging. | Included. ADR-007 accepted for loyalty ledger design and F&B accrual formula; redemption, expiry, broader exclusions, non-F&B earning if included, legal/KVKK artifacts, and implementation issue packets remain blocking. |
| Reservations | Customer submits request. Staff approves/rejects. Automatic confirmation is excluded until reliable PC/session status exists. | Included; detailed rules unresolved; [REQUIRES POD B REVIEW] |
| Audit | Sensitive/admin actions must be auditable. MVP includes product-level audit requirements, with storage/tamper/retention details owned by Pod B/legal. | Included; build on Accepted auth threat-model baseline |
| Selcafe | Read-only discovery/sync if feasible. Selcafe remains legacy adapter and is not the core domain model. | Included only as read-only posture; spike-dependent |
| KVKK/privacy notice | Aydınlatma Metni must be acknowledged before OTP send. Flow mechanics are locked by K-14/K-15/K-16. | Legal text and legal sufficiency remain open |

## Scope by Product Area

### Customer PWA

| Capability | Phase 1 Scope |
|---|---|
| Public catalog browsing | Included. No login required. |
| Phone OTP login/registration | Included in product scope. ADR-015 Accepted and AUTH_THREAT_MODEL v0.4 Accepted. Still blocked for implementation by provider selection, legal/KVKK dependencies, and separate approved Pod C issues. |
| Wallet visibility | Included for own account only. |
| Loyalty visibility | Included for own account only. |
| F&B order submission | Included after `fiş / fiş numarası` link and table confirmation. Addition-only guest ordering is permitted under K-21/K-OS-001. Coupon, loyalty, and settled visit history require Adeks account binding before final settlement. |
| Reservation request submission | Included after login. |
| Own order/reservation status | Included where supported by approved statuses. |
| Customer self top-up | Excluded. |
| Customer self-payment | Excluded. |
| Customer self-redemption | Excluded. |

### Cashier/Admin Web Interface

| Capability | Phase 1 Scope |
|---|---|
| Receive/manage F&B orders | Included for CASHIER, FB_STAFF, ADMIN according to permissions. |
| Payment settlement | CASHIER and ADMIN only. FB_STAFF does not handle payment. |
| Wallet top-up | CASHIER and ADMIN only. |
| Loyalty redemption | CASHIER and ADMIN only. |
| Reservation approval/rejection | CASHIER and ADMIN only. |
| Daily wallet top-up report | Included as compensating control because K-13/KD-F confirms no Phase 1 top-up threshold. Exact fields unresolved. |
| Audit log read | ADMIN only. |
| Staff account management | ADMIN only. |
| Edit/delete audit logs | Excluded for all roles. |

### F&B Ordering

| Capability | Phase 1 Scope |
|---|---|
| Customer order from seat | Included after `fiş / fiş numarası` link and table confirmation. Addition-only guest ordering is permitted under K-21/K-OS-001. |
| Receipt/session link | `fiş / fiş numarası` is the main customer-facing visit link. Table number is displayed for confirmation; customer should not manually enter table number as the primary link. |
| Manual Selcafe entry | Included as mandatory Phase 1 operating bridge. Cashier manually enters accepted PWA orders into Selcafe. Adeks does not directly write PWA orders into Selcafe. |
| Seat/PC context | Included if required for fulfillment. |
| Staff order queue | Included. |
| Status updates | Included using accepted state model as broader/internal-or-later design reference: Submitted, Accepted, Preparing, Ready / On the way, Delivered, Rejected, Cancelled. Transitions, actors, audit points, and concurrency boundaries are accepted in `FB_ORDER_LIFECYCLE_STATE_MODEL_v1.0.md`; implementation still requires API/schema/security/KVKK/DoR packets. |
| First-slice customer status | Simplified for launch. “Accepted + Preparing” means cashier successfully entered the order into Selcafe. No customer-facing delivered tracking in the first operating slice. Broader accepted F&B lifecycle may remain internal/later expansion. |
| Kitchen/service PWA workflow | Excluded from this operating spine. Kitchen/service continue from Selcafe printed receipts. |
| Delivery tracking | Excluded from the first operating slice. |
| Customer cancellation | Included until before Preparing; allowed while Submitted or Accepted, blocked once Preparing starts. |
| Unavailable item handling | Included as full order Rejected; customer submits a new order. |
| Combined order/payment display | Included with guardrail: no customer self-pay UI, payment link, payment button, payment prompt, or in-app payment flow. CASHIER/ADMIN remain the only payment actors. |
| Café wallet payment for F&B | Included as cashier-mediated wallet debit at delivery/settlement. No wallet hold is created at order submission. |
| F&B loyalty accrual | Included on cashier-recorded F&B settlement. Formula locked by K-18 and ADR-007: `floor(settled_kuruş / 1000)`. Cancelled and rejected orders do not accrue. Broader loyalty exclusions/redemption/expiry remain separate open questions. |
| F&B settlement price | Included. K-17 locks immutable price snapshot at order submission; catalog edits after submission do not affect settlement amount. |
| F&B post-settlement correction | Included as accepted business policy under K-19 and accepted ledger design under ADR-006/ADR-007. Implementation still blocked by legal/KVKK artifacts and issue packets. |
| F&B payment by FB_STAFF | Excluded. |
| Online payment | Excluded; Phase 2. |
| Inventory/stock management | Excluded unless separately approved. |
| Promotions/campaigns | Excluded from Phase 1 MVP unless separately scoped through feature discovery. |

The accepted F&B lifecycle model remains a broader/internal-or-later design reference. K-21 narrows the first operating-slice customer UX so it does not promise delivery tracking at launch.

First-slice statuses are customer-facing simplified projections for the operating spine. They do not redefine the accepted F&B lifecycle state model. Later Pod B review must decide whether the first-slice projection is implemented as a distinct customer-facing projection or a true subset of the accepted model.

### Coupon / Discount Scope for Operating Spine

| Capability | Phase 1 Position |
|---|---|
| One simple PC + F&B coupon/discount | Included as the first operating-spine habit driver under K-21/K-OS-004. |
| Discount calculation authority | Adeks owns and calculates all discounts, including coupon and loyalty, under K-OS-008 / BR-OS-023. Selcafe's member-discount mechanism is retired for the PWA pilot, and `adisyon.uye_indirim` is unused. |
| Selcafe reflection / manual bridge | For Phase 1, Adeks provides the cashier with a fixed-format discount reflection record. The cashier selects the dedicated Adeks `islem_tip` from the Selcafe Kasiyer dropdown, enters the pseudorandom one-time Adeks discount code in `kasaislem.aciklama`, and enters the discount amount as a positive credit in `kasaislem.alacak`. The Selcafe row carries no `adisyon_no` and no Adeks customer/coupon/member identifier; Adeks holds the `code → adisyon_no → expected discount` mapping internally. Adeks does not write directly to Selcafe. See BR-OS-024. |
| Settlement green light | At settlement, Adeks reads `adisyon.toplam_tutar` by `fiş` and reads the matching `kasaislem.alacak` row by dedicated Adeks `islem_tip` + pseudorandom one-time code where feasible. Adeks joins the reads inside Adeks, compares `adisyon.toplam_tutar − kasaislem.alacak` against its own discount-inclusive calculation, and gives the cashier a green light only when within the 2% threshold under K-OS-007/K-OS-008 and BR-OS-015/BR-OS-025; no clean match fails closed to manual check. Selcafe remains the settlement source of truth. |
| Broad campaign engine | Excluded. |
| Complex campaigns, tiers, subscriptions, ARPU campaign modeling | Excluded from this operating spine. |
| Coupon status | Applied, rejected, or corrected status may be shown where supported. Exact reason taxonomy and audit implications require later Pod B review. |
| Settlement authority | Final customer payment remains cashier-handled, and Selcafe remains the settlement source of truth. Adeks's green light supports cashier reconciliation; it does not replace Selcafe settlement authority. |

The K-OS-008 `kasaislem` reflection path and `adisyon`/`kasaislem` reads remain pre-implementation product direction only. ADR-005 read-surface reconciliation, KVKK/legal review, retention, auditability, and data-minimization review remain required before any implementation issue.

### Wallet

| Capability | Phase 1 Scope |
|---|---|
| Customer wallet visibility | Included. |
| Cashier/admin top-up | Included. |
| Customer self top-up | Excluded. |
| Online payment top-up | Excluded; Phase 2. |
| Manual balance overwrite | Prohibited. |
| Append-only wallet ledger | Required; ADR-006 accepted 2026-06-14. Implementation remains blocked by legal/KVKK artifacts and separate approved issue packets. |
| Top-up threshold approval | No threshold in Phase 1 per K-13/KD-F; daily top-up report visible to ADMIN. |
| Top-up method | Unresolved; Kerem decision required. |
| F&B wallet settlement | Included for F&B payment as CASHIER/ADMIN-mediated debit at settlement; no order-submission hold. ADR-006 accepts the append-only wallet settlement/correction design. |
| F&B settlement correction/reversal | K-19 and ADR-006/ADR-007 accepted for F&B settlement correction/reversal. Wallet top-up correction remains open under wallet business rules. |

K-21/K-OS-006 excludes wallet payment/spending from the Selcafe-linked customer visibility and ordering spine only. Wallet visibility and cashier/admin top-up may remain separate Phase 1 scope behind existing wallet, legal/KVKK, audit, and Pod B gates. This reconciliation does not authorize wallet payment/spending implementation.

### Loyalty

| Capability | Phase 1 Scope |
|---|---|
| Customer loyalty visibility | Included. |
| Automatic earning | Included for F&B settlement accrual. Formula locked by K-18 and ADR-007. PC/session earning is a product target under K-21/K-OS-005 only if Selcafe read and settlement data are reliable and after later Pod B review. |
| Cashier-handled redemption | Included. Redemption rules unresolved. |
| Customer self-redemption | Excluded. |
| Manual balance overwrite | Prohibited. |
| Append-only loyalty ledger | Required; ADR-007 accepted 2026-06-14. Implementation remains blocked by legal/KVKK artifacts and approved issue packets. |
| Expiry rules | Unresolved; requires customer-notification policy and legal-advisor input. |
| F&B earning formula | Locked by K-18: `floor(settled_kuruş / 1000)`. Non-F&B formula remains open only if non-F&B earning is later included. |
| F&B earning | Included using locked K-18 formula. |
| PC/session earning | Product target under K-21/K-OS-005 if Selcafe read and settlement data are reliable. Requires later Pod B review before design or implementation. If unreliable, fallback is F&B-only earning. |
| Earning timing | After cashier payment/settlement. |
| Pre-payment points | Estimated only. |
| Redemption limits | Unresolved. |
| Cashier override rules | Unresolved; security-sensitive if allowed. |

### Reservations

| Capability | Phase 1 Scope |
|---|---|
| Customer reservation request | Included. |
| Staff approval/rejection | Included. |
| Automatic confirmation | Excluded. |
| PC status-dependent confirmation | Deferred to Phase 2 candidate and dependent on reliable PC/session status. |
| Slots/limits/cancellation/no-show | Unresolved; Kerem decision required. |
| Reservation state machine | [REQUIRES POD B REVIEW]. |
| Status-based approval criteria | Must not be locked before Pod B review confirms reliable Selcafe status support. Phase 1 stays manual staff judgment unless Pod B review supports more specific status criteria. |

### Audit

| Capability | Phase 1 Scope |
|---|---|
| Audit for wallet/loyalty/payment/customer data/order/reservation/staff-account actions | Included. |
| Minimum product fields | Actor UUID, action type, timestamp, affected entity UUID. |
| Auth audit baseline | Must build on Accepted `AUTH_THREAT_MODEL.md` v0.4, especially authentication audit requirements and derived-identifier audit for failed OTP send. |
| Admin audit visibility | Included, read-only. |
| Edit/delete audit logs | Excluded for every role. |
| Audit schema/storage/tamper resistance/retention | [REQUIRES POD B REVIEW] and legal-advisor retention input. |

### Selcafe Read-Only Posture

| Capability | Phase 1 Scope |
|---|---|
| Selcafe read-only discovery/sync | Included only if feasible. |
| `fiş / fiş numarası` linking | Included as operating-spine target; exact Selcafe field/read feasibility requires Pod B review. |
| Table confirmation | Included before ordering. Wrong or unknown table blocks ordering and routes customer to cashier. |
| Active visit/bill/order-line view | Product direction under K-21/KD-1: desired for the active `fiş` / visit so the customer can see F&B items entered directly into Selcafe by cashier/staff, even if not submitted through Adeks PWA. Not implementation-authorized; requires ADR-005 read-surface expansion, KVKK/legal review, auditability, retention, and data-minimization review. |
| Selcafe member identity/profile data | Excluded from this operating spine. Must not be read or displayed. This exclusion does not fully resolve the ADR-005 read-surface conflict for active bill/order-line data. |
| PC start/stop/duration/cost estimates | Included in the Product Phase 1 modeling spine if reliable. KD-2 clarifies this supersedes/subsumes K-20 PI-1 only for customer-visible PC/session estimates inside the approved operating spine. |
| Final settled amount | Selcafe is source of truth. Adeks reads final settled amount where feasible; normal-flow manual final-total entry into Adeks is not acceptable. |
| Settlement comparison | Product target: compare PWA orders, Selcafe items, selected coupon, and final settled amount where feasible. |
| Selcafe write access | Excluded unless Kerem explicitly approves later. |
| Selcafe replacement | Excluded. |
| Core domain modeled on Selcafe internals | Prohibited. |
| Adapter boundary | [REQUIRES POD B REVIEW]. |
| Feasibility spike | Authorized separately, read-only, with no real data copied into docs or AI sessions. |
| Customer mapping | Intent can be discussed, but no final mapping should be locked before Pod B review and KVKK review. |

The 2% mismatch rule, pilot pause triggers, and first-week admin/back-office checks require later Pod B review for risk/audit mechanics and later Pod D review where UX, monitoring, or operational visibility is affected.

### Authentication and Legal Dependencies

| Dependency | Phase 1 Position |
|---|---|
| CUSTOMER auth | Phone OTP (SMS), locked by ADR-015/K-13. |
| Staff auth | Individual username/password, locked. |
| ADMIN MFA | TOTP required, locked. |
| Shared accounts | Prohibited. |
| SMS provider report | Done: `SMS_PROVIDER_REPORT.md` exists. |
| SMS provider selection | [NEEDS KEREM APPROVAL]; awaiting provider commercial replies and legal/KVKK assessment. |
| Customer-facing OTP send-failure UX | Resolved by `CORE_USER_FLOWS.md` §3.5.3. |
| Provider-outage operational response | Still open: secondary provider/switchover/IR-25 ceiling and owner. |
| Legal notice text | [BLOCKED] Awaiting legal/KVKK advisor. |
| K-15/K-16 legal sufficiency | [BLOCKED FOR POD C PROPAGATION] Awaiting legal/KVKK advisor confirmation. |
| Pod C auth implementation | Not ready. |

## Explicitly Excluded From Phase 1

| Excluded item | Reason | Revisit trigger |
|---|---|---|
| Selcafe replacement | Phase 1 coexists with Selcafe. | Phase 2/3 architecture planning. |
| Direct writes to Selcafe SQL Server | Locked posture prohibits this unless Kerem explicitly approves later. | New Kerem approval + Pod B review. |
| Wallet payment/spending in operating spine | Excluded from the Selcafe-linked customer visibility and ordering spine under K-21/K-OS-006. Wallet visibility/top-up remain separate Phase 1 scope. | Separate wallet scope with existing wallet, legal/KVKK, audit, and Pod B gates. |
| Kitchen-facing PWA workflow | Excluded from first operating slice; kitchen/service continue from Selcafe printed receipts. | Later workflow reconciliation if Kerem requests. |
| Delivery tracking | Excluded from first operating slice. | Later customer-status UX reconciliation. |
| Reservation automation | Excluded from this operating spine. | Separate reservation scope and review. |
| Complex campaign engine, tiers, subscriptions | Excluded. One simple PC + F&B coupon/discount is included separately under K-21/K-OS-004. | Feature discovery and Kerem prioritization. |
| Adeks PC client | Phase 2 candidate. | Phase 2 planning. |
| Automatic reservation confirmation | Depends on reliable PC/session status. | Phase 2 PC/session status capability. |
| Online payment | Phase 2; not needed for cashier-only Phase 1. | Payment provider ADR/review. |
| Customer self wallet top-up | Phase 2 with online payment. | Payment provider + wallet review. |
| Customer self loyalty redemption | Deferred. | Later UX/business-rule review. |
| Google login | Deferred to Phase 2. | Phase 2 auth review. |
| MANAGER role | Deferred; Phase 1 has ADMIN only. | Phase 2 role review. |
| CASHIER MFA | Deferred; Phase 1 uses password + server-side session controls. | Phase 2 security review. |
| Runtime/CMS-managed privacy notice | Excluded; K-14 locks notice text as build-time embedded from `/docs/PRIVACY_NOTICE_TR.md`. | Legal/privacy content process change. |
| Real-time/WebSocket transport | Not required for Phase 1. | Phase 2 transport review. |
| Campaigns/subscriptions | Complex campaign engine, tiers, and subscriptions are not in this operating spine. One simple PC + F&B coupon/discount is included separately under K-21/K-OS-004. | Feature discovery and Kerem prioritization. |
| Pod C implementation issues | Explicitly excluded by current task. | Only after Kerem decisions + Pod B review + legal/SMS gates + approved issues. |

## Blocked Items

| Item | Blocked by | Blocker type |
|---|---|---|
| Customer OTP provider implementation | SMS provider selection, provider-specific threat assessment, cross-border assessment, and separate Pod B + Kerem approved Pod C issue | Blocks Pod C |
| Customer OTP launch readiness | SMS provider + KVKK processor/cross-border assessment + legal basis + retention + notice text | Blocks launch |
| Privacy notice legal text | Legal/KVKK advisor | Blocks legal / launch |
| K-15/K-16 propagation to Pod C | Legal advisor confirmation of KVKK sufficiency | Blocks Pod C propagation |
| VERBİS position | Legal advisor confirmation | Blocks launch |
| Data inventory/legal basis/retention/cross-border documents | Legal advisor + Pod B review | Blocks launch |
| Wallet implementation | ADR-006 accepted, but top-up methods, top-up correction/report fields, legal/KVKK artifacts, security/DoR issue packets, and separate Pod B + Kerem-approved implementation issues remain missing | Blocks Pod C |
| Loyalty implementation | ADR-007 accepted for F&B accrual ledger design, but redemption, expiry, broader exclusions, non-F&B earning if included, legal/KVKK artifacts, security/DoR issue packets, and separate Pod B + Kerem-approved implementation issues remain missing | Blocks Pod C |
| Loyalty expiry, if included | Customer notification policy + legal-advisor input | Blocks legal / Pod C if included |
| Reservation implementation | Kerem reservation rules + Pod B state-machine review | Blocks Pod C |
| F&B implementation | F&B lifecycle state model, K-17, K-18, K-19, ADR-006, and ADR-007 are accepted; implementation still requires API/schema/security/KVKK/DoR issue packets and separate Pod B + Kerem-approved implementation issues | Blocks Pod C |
| Selcafe read-only sync | Operating-spine product alignment, planned integration-view readiness, dedicated read-only login/secrets prerequisites, Selcafe read feasibility, Pod B adapter design, KVKK/cross-border scoping where applicable, and separate Pod B + Kerem-approved implementation issue | Blocks Pod C for integration |

## Kerem Decisions Still Useful While SMS / Legal Replies Are Pending

| Area | Decision Kerem can answer now | Limit |
|---|---|---|
| Loyalty earning | PC/session earning formula if Pod B confirms reliable Selcafe settlement data | F&B formula remains locked by K-18; PC/session earning falls back to F&B-only if unreliable. |
| Loyalty redemption | Business intent for min/max limits, eligible targets, 100% redemption, cashier/admin override policy | Mechanism, reversal, precision, and ledger entries remain Pod B-owned. |
| Wallet | Preferred cashier top-up methods, correction policy intent, daily report field needs | Method-specific ledger typing, correction mechanics, masking, and retention remain Pod B/legal-owned. |
| Reservations | Slot length/window, limits, cancellation/no-show rules, manual staff approval policy | Do not lock automated PC/status-based approval criteria before Pod B review confirms reliable Selcafe status/read support. |
| Audit | Business need for reasons/comments on discretionary financial actions and override visibility | Schema/storage/tamper/retention remain Pod B/legal-owned. |
| Selcafe mapping | Remaining operating-spine product-alignment items before implementation issue prep | No broader access, direct writes, or implementation authorization from this decision alone. |
| SMS operations | IR-25 global spend/volume ceiling value and operational response-path owner | Does not select provider or authorize Pod C. |
| MVP boundary | Coupon eligibility and coupon rejection/correction reason taxonomy for the one simple PC + F&B coupon | Complex campaign engine, tiers, subscriptions, and broad ARPU campaign modeling remain excluded from this operating spine. |
| UX review | Decide whether Pod D should prototype/review onboarding, order, and reservation UX before Pod C issue drafting | No implementation authorization. |

F&B order lifecycle product decisions are not listed here because they are resolved and formalized in the accepted F&B lifecycle state model. K-17, K-18, and K-19 are also locked. Remaining F&B work is implementation-readiness packaging after legal/KVKK, API/schema/security, and Definition-of-Ready gates are satisfied. This does not authorize Pod C.

## Review Routing

- Ready for commit: Yes — documentation-only operating-spine reconciliation.
- Requires Kerem approval: Yes — records Product Phase 1 operating-spine scope and K-21/K-OS decisions.
- Requires Pod B review: Yes — Selcafe read feasibility, loyalty, coupon/audit, KVKK/customer-data, cashier manual bridge, mismatch threshold, and wallet-boundary implications are affected.
- Requires Pod C implementation: No. This document does not authorize Pod C implementation.
- Requires Pod D prototype/audit/monitoring review: No for this reconciliation. Later only for separately scoped PWA UX review, monitoring spec, or pre-go-live audit.
