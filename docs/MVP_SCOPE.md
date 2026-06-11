# MVP_SCOPE.md

## Status

| Field | Value |
|---|---|
| Document | MVP_SCOPE.md |
| Version | v0.2 decision-prep draft |
| Owner | Pod A — Product & Planning |
| Reviewer | Pod B — Architecture, Logic & Risk |
| Approver | Kerem |
| Current status | Confirmed v0.2 decision-prep documentation for Kerem approval; not implementation-ready |
| Scope of this version | Applies Pod B “Safe with corrections” triage to the v0.1 packet. Establishes no new locked decision. |
| Target repo path | `/docs/MVP_SCOPE.md` |

## Freshness Baseline

| Source | Version / SHA / status read | Date read | Use in this draft |
|---|---:|---:|---|
| `/docs/AGENT_CONTEXT_MANIFEST.md` | SHA `47ba17e`; active context-routing index | 2026-06-11 | Confirmed required context loading and review routing. |
| `/docs/PROJECT_METHODOLOGY.md` | SHA `d3355d0`; v0.8 | 2026-06-11 | Confirmed Pod A boundaries, Pod B review triggers, and no Pod C work without Definition of Ready. |
| `/docs/PROJECT_DECISION_INDEX.md` | SHA `0bbb3fd`; last updated 2026-06-10 | 2026-06-11 | Confirmed ADR-015 Accepted, SMS provider not locked, ADR-005/006/007 backlog/stub state. |
| `/docs/CORE_USER_FLOWS.md` | SHA `6fe9b2f`; v0.3 | 2026-06-11 | Confirmed OTP send-failure UX fallback in §3.5.3 and open notice/SMS items. |
| `/docs/architecture/AUTH_THREAT_MODEL.md` | SHA `df9b30b`; v0.4 Accepted, BL-2 closed | 2026-06-11 | Reconciled authentication/security blocker state. |
| `/docs/decision-support/SMS_PROVIDER_REPORT.md` | SHA `27892d4`; v0.1 decision-support | 2026-06-11 | Moved provider report from outstanding to done; provider selection remains open. |
| `/docs/KEREM_DECISIONS.md` | SHA `47eaa47`; v1.4, K-01 through K-16 recorded | 2026-06-11 | Confirmed K-13/K-14/K-15/K-16 locked decisions and remaining legal dependencies. |
| Attached v0.1 packet | `MVP_SCOPE_v0_1.md`, `BUSINESS_RULES_v0_1.md`, `OPEN_QUESTIONS_v0_1.md` | 2026-06-11 | Baseline corrected into v0.2. |
| Pod B risk triage + final confirmation | “Safe with corrections”; final confirmation received per PR context | 2026-06-11 | Applied B-1/B-2/B-3 and N-1…N-5; Pod B confirmed safe for Kerem decision-prep and documentation-class commit after Kerem approval. |

## Purpose

This document defines the Phase 1 MVP scope for Adeks Platform and separates confirmed scope from blocked, deferred, and unresolved items.

Phase 1 is a customer PWA plus web cashier/admin foundation. It includes public catalog browsing, login-gated customer features, F&B ordering from seat, wallet visibility and cashier/admin top-up, loyalty visibility and cashier-handled redemption, staff-approved reservation requests, audit logging, and read-only Selcafe discovery/sync if feasible. It does not replace Selcafe or Selcafe PC/session control.

This v0.2 draft is **decision-prep only**. It does not authorize Pod C implementation, does not select an SMS provider, does not resolve legal/KVKK questions, and does not add or change locked decisions.

## Reconciled Current State — 2026-06-11

| Area | Corrected state |
|---|---|
| Authentication strategy | ADR-015 is Accepted. Phase 1 customer authentication is Phone OTP (SMS); staff use individual username/password; ADMIN requires TOTP MFA. |
| Auth threat model | `AUTH_THREAT_MODEL.md` is v0.4 Accepted and BL-2 is closed. Implementation remains blocked by BL-1/BL-3/BL-4/BL-5/BL-6 and separate Pod B + Kerem approved Pod C issues. |
| SMS provider report | `SMS_PROVIDER_REPORT.md` exists as Pod B decision support. The report is done; provider selection remains open pending Kerem decision, commercial replies, and legal/KVKK processor/cross-border confirmation. |
| OTP send-failure UX fallback | Customer-facing fallback is resolved in `CORE_USER_FLOWS.md` §3.5.3: neutral failure copy, no completed account, no persistent raw phone retention, derived-identifier audit only. Do not reopen this in this MVP scope. |
| Privacy-notice flow mechanics | K-14/K-15/K-16 are locked: notice text canonical in `/docs/PRIVACY_NOTICE_TR.md` and build-time embedded; acknowledgment ephemeral before OTP verification and persisted only after successful OTP verification; same-session acknowledgment reuse allowed for OTP resend. |
| Remaining legal/KVKK state | Open items are the actual Turkish Aydınlatma Metni text, legal-advisor sufficiency confirmation for K-15/K-16, VERBİS, retention, legal basis, data inventory, and cross-border transfer assessment. |
| Wallet/loyalty ledgers | Append-only principles are locked. ADR-006 and ADR-007 remain backlog/stub-level; full ledger design is still Pod B-owned. |
| Selcafe | Read-only Phase 1 posture is locked. ADR-005 remains backlog/stub-level and Selcafe sync depends on the feasibility spike. |

## Phase 1 Included Scope

| Area | Included in Phase 1 | Status |
|---|---|---|
| Customer PWA | Mobile-first customer web app. Customers can browse public catalog/menu without login and must log in for wallet, loyalty, orders, reservations, account/profile, and own status/history. | Confirmed |
| Authentication dependency | Customer login uses Phone OTP (SMS). Staff use individual username/password. ADMIN uses username/password + TOTP MFA. | Confirmed by ADR-015/K-13; SMS provider not selected |
| Public catalog/menu | Public browsing is allowed without authentication. | Confirmed |
| Cashier/admin web interface | Browser-based staff interface for order handling, wallet top-up, loyalty redemption, reservation review, permitted customer data, and audit visibility. | Confirmed |
| F&B ordering | Customer submits F&B order from seat/PC context. Staff receives order. FB_STAFF handles fulfillment only. Payment remains CASHIER/ADMIN at cashier point. | Confirmed; status/cancellation rules unresolved |
| Wallet | Customer wallet visibility and cashier/admin wallet top-up. Append-only ledger, derived balance, no direct overwrite, audit logging. | Included; [REQUIRES POD B REVIEW] |
| Loyalty | Customer loyalty visibility, automatic earning on eligible purchases, cashier-handled redemption. Append-only ledger, derived balance, no direct overwrite, audit logging. | Included; business rules unresolved; [REQUIRES POD B REVIEW] |
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
| F&B order submission | Included after login. |
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
| Customer order from seat | Included after login. |
| Seat/PC context | Included if required for fulfillment. |
| Staff order queue | Included. |
| Status updates | Included, exact customer-visible statuses unresolved. |
| F&B payment by FB_STAFF | Excluded. |
| Online payment | Excluded; Phase 2. |
| Inventory/stock management | Excluded unless separately approved. |
| Promotions/campaigns | Excluded from Phase 1 MVP unless separately scoped through feature discovery. |

### Wallet

| Capability | Phase 1 Scope |
|---|---|
| Customer wallet visibility | Included. |
| Cashier/admin top-up | Included. |
| Customer self top-up | Excluded. |
| Online payment top-up | Excluded; Phase 2. |
| Manual balance overwrite | Prohibited. |
| Append-only wallet ledger | Required; full ADR/design still [REQUIRES POD B REVIEW]. |
| Top-up threshold approval | No threshold in Phase 1 per K-13/KD-F; daily top-up report visible to ADMIN. |
| Top-up method | Unresolved; Kerem decision required. |
| Correction/reversal | Unresolved business intent; mechanism must be compensating ledger event and [REQUIRES POD B REVIEW]. |

### Loyalty

| Capability | Phase 1 Scope |
|---|---|
| Customer loyalty visibility | Included. |
| Automatic earning | Included for eligible purchases. Eligibility unresolved. |
| Cashier-handled redemption | Included. Redemption rules unresolved. |
| Customer self-redemption | Excluded. |
| Manual balance overwrite | Prohibited. |
| Append-only loyalty ledger | Required; full ADR/design still [REQUIRES POD B REVIEW]. |
| Expiry rules | Unresolved; requires customer-notification policy and legal-advisor input. |
| Earning formula | Unresolved. |
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
| Status-based approval criteria | Must not be locked before Selcafe spike results. Phase 1 stays manual staff judgment unless the spike and Pod B review support more specific status criteria. |

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
| Selcafe write access | Excluded unless Kerem explicitly approves later. |
| Selcafe replacement | Excluded. |
| Core domain modeled on Selcafe internals | Prohibited. |
| Adapter boundary | [REQUIRES POD B REVIEW]. |
| Feasibility spike | Authorized separately, read-only, with no real data copied into docs or AI sessions. |
| Customer mapping | Intent can be discussed, but no final mapping should be locked before spike results and KVKK review. |

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
| Campaigns/subscriptions | Not in current Phase 1 MVP packet. | Feature discovery and Kerem prioritization. |
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
| Wallet implementation | Pod B wallet ledger ADR/design and Kerem-sensitive approvals | Blocks Pod C |
| Loyalty implementation | Kerem business rules + Pod B loyalty ledger ADR/design | Blocks Pod C |
| Loyalty expiry, if included | Customer notification policy + legal-advisor input | Blocks legal / Pod C if included |
| Reservation implementation | Kerem reservation rules + Pod B state-machine review | Blocks Pod C |
| F&B order lifecycle implementation | Kerem-visible status decisions + Pod B review if order state/audit/API affected | Blocks Pod C |
| Selcafe read-only sync | Selcafe feasibility spike + Pod B adapter design + KVKK scoping | Blocks Pod C for integration |

## Kerem Decisions Still Useful While SMS / Legal Replies Are Pending

| Area | Decision Kerem can answer now | Limit |
|---|---|---|
| Loyalty earning | Preferred eligible purchase types and business formula direction | Do not lock wallet-top-up earning or PC/session earning without Pod B/Selcafe review. |
| Loyalty redemption | Business intent for min/max limits, eligible targets, 100% redemption, cashier/admin override policy | Mechanism, reversal, precision, and ledger entries remain Pod B-owned. |
| Wallet | Preferred cashier top-up methods, correction policy intent, daily report field needs | Method-specific ledger typing, correction mechanics, masking, and retention remain Pod B/legal-owned. |
| F&B orders | Customer-visible status vocabulary, cancellation policy intent, unavailable-item handling, payment-status visibility | State transitions and ledger interactions require Pod B. |
| Reservations | Slot length/window, limits, cancellation/no-show rules, manual staff approval policy | Do not lock automated PC/status-based approval criteria before Selcafe spike. |
| Audit | Business need for reasons/comments on discretionary financial actions and override visibility | Schema/storage/tamper/retention remain Pod B/legal-owned. |
| Selcafe mapping | Product intent for what data should be considered or avoided | No final mapping before spike + KVKK/legal review. |
| SMS operations | IR-25 global spend/volume ceiling value and operational response-path owner | Does not select provider or authorize Pod C. |
| MVP boundary | Confirm campaign/subscription/ARPU models remain outside Phase 1 MVP and go to feature discovery | Does not prevent future discovery. |
| UX review | Decide whether Pod D should prototype/review onboarding, order, and reservation UX before Pod C issue drafting | No implementation authorization. |

## Review Routing

- Ready for commit: Yes — documentation-only replacement after Kerem approval. Decision-prep only; not implementation-ready.
- Requires Kerem approval: Yes — all unresolved business rules affecting loyalty, wallet, orders, reservations, privacy, SMS provider, and launch gates.
- Requires Pod B review: Yes — wallet, loyalty, reservation state, audit, auth/KVKK/data handling, Selcafe integration, and any balance-affecting rules.
- Requires Pod C implementation: No.
- Requires Pod D prototype/audit/monitoring review: Later — PWA onboarding/order/reservation UX and required pre-go-live audit/monitoring review.
