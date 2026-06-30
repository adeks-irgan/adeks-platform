# PROJECT_BRIEF.md

## Document Status

| Field | Value |
|---|---|
| Document | PROJECT_BRIEF.md |
| Project | Adeks Platform |
| Version | v0.3 |
| Owner | Kerem |
| Prepared by | Pod A — Product & Planning |
| Status | Ready for commit |
| Target location | `/docs/PROJECT_BRIEF.md` |

---

## 1. Purpose

Adeks Platform is a new digital platform for Adeks, an internet café operation in Istanbul, Turkey.

The project starts with a Phase 1 customer-facing PWA and web-based cashier/admin interface. It is also intended to become the foundation for a future vendor-neutral internet café management platform that may eventually reduce or replace dependency on Selcafe and later become a commercial SaaS product for other cafés.

Adeks Platform is not only a customer companion app. It is the first controlled step toward a broader café management platform.

---

## 2. What Adeks Is

Adeks is an internet café business in Istanbul, Turkey.

Current known operational facts:

| Area | Known Detail |
|---|---|
| Gaming PCs | 130 PCs |
| Main cashier | 1 main cashier point |
| F&B cashier/order points | 2 additional F&B cashier/order points |
| Existing café software | Selcafe |
| Current business context | PC usage, customer sessions, cashier workflows, F&B ordering, wallet/loyalty visibility, and reservation handling |

Adeks currently depends on Selcafe for core café management operations. The new platform must respect this operational reality while creating a modern, extensible product foundation.

---

## 3. Current Selcafe Situation

Selcafe is the existing proprietary café management system used by Adeks.

Known Selcafe characteristics:

| Area | Current Situation |
|---|---|
| Ownership | Proprietary system |
| Database | Local SQL Server database |
| Server component | Local server service |
| Cashier component | Windows cashier app |
| PC component | Client app installed on café PCs |
| API availability | No known API |
| POS-device integration | No known POS-device integration |
| Phase 1 role | Legacy system |
| Phase 1 integration posture | Read-only discovery/sync if feasible |
| Phase 1 write policy | No direct writes to Selcafe SQL Server unless Kerem explicitly approves later |

Selcafe must be treated as a legacy adapter, not as the Adeks Platform core domain model.

The platform should avoid becoming tightly coupled to Selcafe-specific tables, naming, workflows, or constraints. Any Selcafe integration should be isolated behind the `CafeManagementAdapter` pattern, with the current integration represented as `SelcafeAdapter`.

---

## 4. Why Adeks Platform Is Being Built

Adeks Platform is being built to solve immediate operational and customer-experience needs while establishing a long-term product foundation.

### 4.1 Near-Term Reasons

Phase 1 should introduce:

- A customer-facing PWA.
- A web-based cashier/admin interface.
- Public browsing of the F&B/catalog experience where appropriate.
- Login-gated access for core customer features.
- F&B ordering from customer seat.
- Wallet visibility and cashier/admin wallet top-up.
- Loyalty visibility, automatic earning on eligible purchases, and cashier-handled redemption.
- Reservation request handling with staff approval.
- Audit logs for administrative and sensitive actions.
- Read-only Selcafe discovery/sync if feasible.

### 4.2 Strategic Reasons

The broader strategic goal is to create a vendor-neutral café management platform that can eventually:

- Reduce dependency on Selcafe.
- Replace selected PC/session/customer experience features over time.
- Support a future Adeks-native café engine.
- Support multiple locations and tenants.
- Become a commercial SaaS product for other internet cafés.

---

## 5. Product Vision by Phase

## 5.1 Phase 1 — Customer PWA and Web Admin Foundation

Phase 1 is the first production-oriented platform layer.

It should provide:

| Capability | Phase 1 Position |
|---|---|
| Customer PWA | Mobile-first customer web app |
| Public catalog browsing | Customers may browse catalog/menu content without login |
| Account-gated features | Discounts, coupons, points, wallet, loyalty, reservations, account/profile features, and account-linked history require account context. QR-linked guest F&B ordering and live-bill visibility are governed by the Operating-Spine Alignment Note below. |
| Web cashier/admin interface | Browser-based operational interface for staff |
| F&B ordering from seat | Customers can place orders from their seat |
| Cashier-only payment | Payments are handled at cashier/F&B cashier points in Phase 1 |
| Wallet visibility | Customers can view wallet information after login |
| Wallet top-up | Cashier/admin users can top up wallets in Phase 1 |
| Customer self-service top-up | Not included in Phase 1; planned for later with online payment |
| Loyalty earning | Loyalty is earned automatically on eligible purchases |
| Loyalty redemption | Redemption is handled at cashier in Phase 1 |
| Customer self-redeem | Not included in Phase 1; planned for later |
| Reservation requests | Customer submits request; staff approves or rejects |
| Audit logs | Sensitive and administrative actions are recorded |
| Selcafe discovery/sync | Read-only integration if technically feasible |
| Selcafe replacement | Not included in Phase 1 |

Phase 1 should coexist with Selcafe. It should not attempt to replace Selcafe's core PC/session control.

### Operating-Spine Alignment Note

Kerem approved the Product Phase 1 operating spine as **Selcafe-linked customer visibility and ordering**.

For this spine:

- Customer-facing visit/session linking is the desk-side, one-time QR handshake. The printed `fiş` / receipt remains a Selcafe/cashier artifact, but the Customer PWA has no typed/scanned `fiş` or `fiş numarası` entry path.
- The QR handshake establishes the PC/session binding. A separate customer table-confirmation step is no longer a control step; a wrong or disputed PC/session blocks ordering and routes the customer to the cashier.
- Guests may order F&B and see the full live bill without an Adeks account. An account is required only for discounts, coupons, and points.
- Cashier manually enters accepted PWA orders into Selcafe.
- Kitchen/service continue from Selcafe printed receipts.
- Selcafe remains read-only to Adeks and remains the final settlement source of truth.
- KD-1 clarifies that Product Phase 1 direction includes Selcafe-sourced active visit/bill/order-line visibility for the active `fiş` / visit, including cashier/staff-entered F&B items not submitted through Adeks PWA.
- Selcafe member identity/profile data must not be read or displayed as part of this operating spine.
- This direction does not authorize implementation and does not override ADR-005 by wording alone. ADR-005 read-surface expansion, KVKK/legal review, auditability, retention, and data-minimization review remain required before any implementation issue can exist.
- KD-2 clarifies that simple reliable customer-visible PC/session estimates are part of this operating spine only; broader real-time station/session status and reservation automation remain deferred unless separately approved.
- Wallet payment/spending, kitchen-facing PWA workflow, delivery tracking, reservation automation, complex campaigns, tiers, and subscriptions are excluded from this operating spine.

This document does not authorize Pod C implementation.

Phase 1 remains read-only toward Selcafe; Selcafe remains the settlement source of truth for this operating spine.

---

## 5.2 Phase 2 — Adeks PC Client and More Reliable Automation

Phase 2 introduces an Adeks-controlled PC client for the 130 café PCs.

The future PC client should support:

| Capability | Description |
|---|---|
| Customer-facing PC interface | Adeks UI displayed on café PCs |
| Remaining time display | Customers can view remaining session time |
| Wallet and loyalty display | Customers can view relevant account status from the PC |
| F&B ordering from PC seat | Customers can order without leaving their PC |
| Session status | PC/session state is visible through Adeks Platform |
| Automatic reservation confirmation | May be introduced once PC status is reliable |
| Online payment | Customer-facing online payment may be introduced in Phase 2 |
| Progressive Selcafe replacement | Selected Selcafe client/session functions may be replaced over time |

The current Phase 2 PC client candidate is Electron + TypeScript.

Phase 2 should be designed as a progressive migration, not a sudden replacement of all Selcafe behavior.

---

## 5.3 Phase 3 — Multi-Location SaaS Platform

Phase 3 extends Adeks Platform beyond the original Adeks location.

The long-term goal is a commercial product that can support:

| Capability | Description |
|---|---|
| Multi-location support | Multiple café branches or venues |
| Multi-tenant SaaS | Separate café operators using the platform |
| Packaging | Installable or deployable product model |
| Licensing | Commercial usage and subscription/licensing model |
| Support operations | Support, updates, monitoring, and tenant management |
| Vendor-neutral café management | Support for Selcafe, future native engine, and possibly other systems through adapters |

---

## 6. Customer PWA

The customer PWA is the primary Phase 1 customer interface.

Expected Phase 1 customer capabilities:

| Capability | Phase 1 Intent |
|---|---|
| Public catalog browsing | Customers can browse available menu/catalog content without login |
| Login | Customers log in for account-only features. QR-linked guest ordering and live-bill visibility are governed by the Operating-Spine Alignment Note above. |
| Account/profile view | Logged-in customers can view basic account information |
| Wallet visibility | Logged-in customers can view wallet status and relevant wallet history |
| Loyalty visibility | Logged-in customers can view loyalty status and relevant loyalty history |
| F&B ordering from seat | QR-linked guests/customers can submit food and beverage orders. Account context is required only for discounts, coupons, points, and account-linked features. |
| Reservation requests | Logged-in customers can submit reservation requests |
| Request/order status | Customers can view status feedback where supported |

The PWA should be designed as the foundation for future expansion, not as a disposable companion app.

---

## 7. Web-Based Cashier/Admin Interface

The web-based cashier/admin interface is the primary Phase 1 staff interface.

Expected Phase 1 staff/admin capabilities:

| Capability | Phase 1 Intent |
|---|---|
| View customer/order activity | Staff can review relevant customer, order, and request information |
| Manage F&B orders | Staff can receive and update F&B order status |
| Handle cashier-only payment | Staff handles payments outside customer self-service online payment |
| Top up wallets | Authorized cashier/admin users can add wallet credit |
| Redeem loyalty | Authorized cashier/admin users can apply loyalty redemption |
| Review reservation requests | Staff can approve or reject reservation requests |
| View wallet/loyalty data | Staff can inspect permitted customer wallet/loyalty information |
| Audit administrative actions | Important admin actions are logged |

The staff interface must respect role-based permissions and audit requirements.

---

## 8. F&B Ordering From Seat

F&B ordering from seat is a core Phase 1 use case.

The intended Phase 1 flow:

1. Customer opens the Adeks PWA.
2. Customer browses the public catalog/menu.
3. Customer logs in before submitting an order.
4. Customer selects items.
5. Customer provides seat/PC context if required.
6. Customer submits the order.
7. Staff sees the order in the web cashier/admin interface.
8. Payment is settled at the main cashier point by CASHIER staff. F&B Staff handles order fulfilment only.
9. Staff processes and updates order status.
10. Customer receives order status feedback where supported.

Online payment is not part of Phase 1. It is planned for Phase 2.

---

## 9. Wallet Principles

Wallet is a sensitive customer-value area.

Locked wallet principles:

| Principle | Requirement |
|---|---|
| Append-only logic | Wallet must use append-only ledger logic |
| No direct overwrite | Wallet balances must not be directly overwritten |
| Derived balance | Wallet balance should be derived from ledger entries |
| Auditability | Wallet top-ups and adjustments must be auditable |
| Human approval | Wallet, payment, refund, security, and customer-data logic require human approval |
| Vendor-neutral domain | Wallet should belong to Adeks Platform domain, not Selcafe-specific structures |

### Phase 1 Wallet Position

| Capability | Phase 1 Decision |
|---|---|
| Customer wallet visibility | Included |
| Cashier/admin wallet top-up | Included |
| Customer self-service top-up | Not included |
| Online payment-based top-up | Phase 2 |
| Direct wallet balance overwrite | Not allowed |
| Wallet ledger | Required |

Cashier/admin wallet top-up is approved as a Phase 1 product capability, but implementation must still follow append-only ledger rules, role-based access, audit logging, and Pod B architecture/security review.

---

## 10. Loyalty Principles

Loyalty is also a sensitive customer-value area.

Locked loyalty principles:

| Principle | Requirement |
|---|---|
| Append-only logic | Loyalty must use append-only ledger logic |
| No direct overwrite | Loyalty balances must not be directly overwritten |
| Derived balance | Loyalty balance should be derived from ledger entries |
| Auditability | Earning, redemption, and adjustments must be auditable |
| Human approval | Loyalty rules and redemption behavior require human approval |
| Vendor-neutral domain | Loyalty should belong to Adeks Platform domain, not Selcafe-specific structures |

### Phase 1 Loyalty Position

| Capability | Phase 1 Decision |
|---|---|
| Customer loyalty visibility | Included |
| Automatic earning | Included for eligible purchases |
| Cashier-handled redemption | Included |
| Customer self-redemption in app | Not included |
| Direct loyalty balance overwrite | Not allowed |
| Loyalty ledger | Required |

The exact earning formula, eligibility rules, expiry rules, and redemption constraints should be defined in `BUSINESS_RULES.md`.

---

## 11. Reservations

Reservation handling is part of Phase 1.

### Phase 1 Reservation Position

| Capability | Phase 1 Decision |
|---|---|
| Customer reservation request | Included |
| Staff approval/rejection | Included |
| Automatic confirmation | Not included |
| PC status-dependent confirmation | Phase 2 candidate once PC status is reliable |

In Phase 1, the platform should treat reservations as requests requiring staff review. Automatic confirmation should wait until the platform has reliable PC/session status, likely through the Phase 2 PC client and stronger session-state integration.

---

## 12. Payment Position

Payment handling is deliberately phased.

| Payment Capability | Phase |
|---|---|
| Cashier-only payment | Phase 1 |
| Customer online payment | Phase 2 |
| Customer self-service wallet top-up | Phase 2 |
| Online payment provider integration | Not part of Phase 1 |

Phase 1 should not introduce online payment complexity. Cashier-only payment reduces payment-provider, reconciliation, refund, and fraud-surface risk during the first launch.

---

## 13. KVKK Requirement

Adeks Platform must comply with KVKK requirements.

The platform must also align with OWASP ASVS and OWASP API Top 10. Full security detail should be defined in `NON_FUNCTIONAL_REQUIREMENTS.md`.

At minimum, the project must treat the following as sensitive:

- Customer identity data.
- Phone numbers.
- Account records.
- Wallet data.
- Loyalty data.
- Order history.
- Reservation history.
- Staff/admin activity logs.
- Any data synchronized or discovered from Selcafe.

KVKK-related requirements should be expanded in `NON_FUNCTIONAL_REQUIREMENTS.md` and reviewed by Pod B for security/privacy implications.

No real Adeks customer names, phone numbers, or transaction records should be used in documentation, tests, fixtures, screenshots, prototypes, or examples. Synthetic data must be used instead.

---

## 14. Vendor-Neutral Architecture Principle

Adeks Platform must remain vendor-neutral.

This means:

| Area | Requirement |
|---|---|
| Core domain | Must not be modeled directly around Selcafe internals |
| Integration | External café systems should connect through adapter interfaces |
| Current adapter | Selcafe integration should be represented as `SelcafeAdapter` |
| Future native engine | Adeks-native café management should be represented separately |
| Commercialization | Platform should be suitable for other cafés and future integrations |

Selcafe is a current operational dependency, not the long-term product architecture.

The platform should support this direction through the `CafeManagementAdapter` integration pattern and a future `AdeksNativeCafeEngine`.

---

## 15. Future Commercialization Goal

Adeks Platform is intended to become more than an internal tool.

The long-term commercialization direction is:

- Start with Adeks' own operational needs.
- Validate customer and staff workflows in a real café environment.
- Build vendor-neutral abstractions.
- Gradually reduce Selcafe dependency.
- Support multiple locations and tenants.
- Package the product for other internet cafés.
- Provide deployment, licensing, support, and operational tooling.

The project should avoid decisions that only work for one café, one database layout, one local software vendor, or one cashier workflow unless explicitly documented as temporary Phase 1 constraints.

---

## 16. Locked Technical Context

The following technical decisions are already locked unless a serious business, security, legal, or implementation conflict is discovered:

| Area | Locked Decision |
|---|---|
| Language | TypeScript throughout |
| Backend framework | NestJS |
| Frontend framework | Next.js |
| Architecture | Modular monolith |
| Customer app | PWA first |
| Database family | PostgreSQL |
| Phase 2 PC client candidate | Electron + TypeScript |
| Local gateway candidate | TypeScript/Node.js inside Adeks local network |
| Integration pattern | `CafeManagementAdapter` |
| Current adapter | `SelcafeAdapter` |
| Future native engine | `AdeksNativeCafeEngine` |

---

## 17. Not Yet Locked

The following topics are intentionally not finalized in this project brief:

| Topic | Status |
|---|---|
| Tenancy strategy | **Locked** — Shared schema with mandatory non-null `tenant_id` on all tenant-scoped tables. Long-term model (Phase 1 through Phase 3). No schema-per-tenant or database-per-tenant planned. ADR-008 Accepted 2026-06-08 (Kerem approval). Binding design requirement: global Prisma Client Extension for tenant scoping enforcement before any tenant-scoped entity is implemented. Pod C schema, migration, and `TenantContext` work remains blocked pending separate Pod B + Kerem approved implementation issues. |
| ORM | **Locked** — Prisma. ADR-004 Accepted 2026-06-08 (Kerem approval). UUID primary keys confirmed on all entity tables. Pod C Prisma installation, schema authoring, and migration work remains blocked pending separate Pod B + Kerem approved implementation issues. |
| Caching layer | Not confirmed |
| Queue system | Not confirmed |
| Real-time transport | Not required for Phase 1. WebSocket is the Phase 2 candidate. Final selection deferred to Pod B architecture review before Phase 2 begins. |
| Payment provider | Not required for Phase 1; Phase 2 topic |
| SMS/email/push provider | Not confirmed |
| Hosting/deployment model | Not confirmed |

These topics should not be finalized by Pod A.

---

## 18. Confirmed Phase 1 Product Decisions

| ID | Decision | Status |
|---|---|---|
| D-001 | Core PWA features require login. | Confirmed by Kerem |
| D-002 | Catalog/menu browsing can be public. | Confirmed by Kerem |
| D-003 | Cashier/admin wallet top-up is included in Phase 1. | Confirmed by Kerem |
| D-004 | Customer self-service wallet top-up is not included in Phase 1. | Confirmed by Kerem |
| D-005 | Loyalty earning happens automatically on eligible purchases. | Confirmed by Kerem |
| D-006 | Loyalty redemption is handled by cashier in Phase 1. | Confirmed by Kerem |
| D-007 | Customer self-redemption through the app comes later. | Confirmed by Kerem |
| D-008 | Reservation requests are staff-approved in Phase 1. | Confirmed by Kerem |
| D-009 | Automatic reservation confirmation is a Phase 2 candidate once PC status is reliable. | Confirmed by Kerem |
| D-010 | Phase 1 payment is cashier-only. | Confirmed by Kerem |
| D-011 | Online payment is planned for Phase 2. | Confirmed by Kerem |

---

## 19. Assumptions in This Draft

| ID | Assumption | Needs Confirmation |
|---|---|---|
| A-001 | "Eligible purchases" for loyalty earning may include F&B purchases, PC/session purchases, or both, depending on later business rules. | Kerem |
| A-002 | Wallet top-up is performed only by authorized cashier/admin users, not general staff. | Kerem |
| A-003 | Cashier-handled loyalty redemption requires staff role permission and audit logging. | Kerem / Pod B |
| A-004 | Public catalog browsing does not expose customer-specific prices, wallet data, loyalty data, or personal recommendations. | Kerem / Pod B |
| A-005 | Resolved: Phone OTP (SMS). Source: `/docs/USER_ROLES_AND_PERMISSIONS.md`. | — |

---

## 20. Open Questions to Carry Forward

These should be added to `OPEN_QUESTIONS.md` if not resolved before commit.

| ID | Question | Owner |
|---|---|---|
| OQ-001 | Resolved: Phase 1 `CUSTOMER` authentication is Phone OTP (SMS). Source: `/docs/USER_ROLES_AND_PERMISSIONS.md`. | Kerem / Pod B |
| OQ-002 | Which purchase types earn loyalty in Phase 1: F&B only, PC/session usage only, wallet top-up, or selected combinations? | Kerem |
| OQ-003 | What is the Phase 1 loyalty earning formula? | Kerem |
| OQ-004 | What are the Phase 1 loyalty redemption rules, limits, and cashier override rules? | Kerem |
| OQ-005 | What wallet top-up methods are allowed at cashier in Phase 1: cash, card through existing POS, manual admin entry, or selected combinations? | Kerem |
| OQ-006 | Should wallet top-up require manager approval above a configured threshold? | Kerem / Pod B |
| OQ-007 | What customer-visible order statuses should the PWA show in Phase 1? | Kerem |
| OQ-008 | What reservation time slots, limits, cancellation rules, and no-show rules should apply in Phase 1? | Kerem |
| OQ-009 | What customer data should be imported or mapped from Selcafe, if read-only sync is feasible? | Kerem / Pod B |
| OQ-010 | What minimum audit fields are required for wallet, loyalty, reservation, and order actions? | Pod B |

---

## 21. Cross-Pod Review Notes

| Area | Status |
|---|---|
| Ready for commit | Yes, as v0.3 |
| Requires Kerem approval | Loyalty formula, redemption limits, wallet top-up methods, reservation rules |
| Requires Pod B — Architecture, Logic & Risk review | Wallet ledger design, loyalty ledger design, Selcafe adapter boundary, KVKK/security implications, OWASP ASVS/API security implications, role permissions, audit requirements, tenancy implementation details |
| Requires Pod C — Build & DevOps implementation | Not yet. This document is planning only |
| Requires Pod D — Prototype, Audit & Monitoring review | Customer PWA flow and staff/admin UI flow should be prototyped later; monitoring requirements should be handled in `NON_FUNCTIONAL_REQUIREMENTS.md` |

---

## 22. Non-Goals for This Document

This document does not define:

- Detailed MVP scope.
- Full business rules.
- Domain model.
- User roles and permissions.
- Full user flows.
- Non-functional requirements.
- Database schema.
- API contracts.
- UI wireframes.
- Implementation tasks.

Those will be covered in later Phase 1 Input Pack documents.
