# USER_ROLES_AND_PERMISSIONS.md

## Status

| Field | Value |
|---|---|
| Document | USER_ROLES_AND_PERMISSIONS.md |
| Project | Adeks Platform |
| Version | v0.2 |
| Owner | Pod A — Product & Planning |
| Reviewer | Pod B — Architecture, Logic & Risk |
| Approver | Kerem |
| Current status | Pod B review complete — ready for Kerem approval |
| Target location | `/docs/USER_ROLES_AND_PERMISSIONS.md` |
| Implementation status | Does not authorize Pod C implementation |

---

## 1. Overview

This document defines the Phase 1 user roles, authentication expectations, session behavior, permission boundaries, audit requirements, and KVKK data-access flags for Adeks Platform. It is based on Pod B’s OQ-001 authentication architecture recommendation and Kerem-confirmed authentication and role decisions supplied for this drafting task. It is not the authentication ADR; Pod B has reviewed v0.1 and the non-blocking review findings have been applied in v0.2. This document is ready for Kerem approval as the product-layer authority for Phase 1 roles and permissions.

OTP-specific security requirements, including rate limiting and phone enumeration protection, are out of scope for this document. They are recorded in the OQ-001 authentication recommendation and must be included in the authentication ADR.

---

## 2. Role Definitions

Phase 1 has exactly four user-facing roles:

| Role | Phase 1 Status |
|---|---|
| `CUSTOMER` | Included |
| `CASHIER` | Included |
| `FB_STAFF` | Included |
| `ADMIN` | Included |
| `MANAGER` | Not included in Phase 1; Phase 2 candidate split from `ADMIN` |

### 2.1 `CUSTOMER`

| Field | Definition |
|---|---|
| Who holds this role | Gaming customer using Adeks services |
| Interface | Customer PWA, mobile web first |
| Primary job in platform | View own wallet and loyalty status, submit F&B orders, submit reservation requests, and track own customer-facing activity where supported |
| Authentication method | Phone OTP (SMS) |
| Session behavior | Stateless JWT access token, short-lived, plus refresh token |
| Phase 1 financial boundary | Cannot top up wallet, self-pay, self-redeem loyalty, or mutate own wallet/loyalty balance |

### 2.2 `CASHIER`

| Field | Definition |
|---|---|
| Who holds this role | Main cashier point staff |
| Interface | Web admin/cashier interface |
| Primary job in platform | Handle wallet top-up, loyalty redemption, payment settlement, reservation approval/rejection, and operational order handling where assigned |
| Authentication method | Individual username/password |
| Session behavior | Server-side session with 40-minute inactivity timeout |
| Credential rule | No shared cashier accounts |
| Customer phone display rule | During wallet top-up, cashier sees masked customer phone number only, with last 4 digits visible, for example `+90 555 *** ** 01` |

### 2.3 `FB_STAFF`

| Field | Definition |
|---|---|
| Who holds this role | F&B order point staff at the two F&B stations |
| Interface | Web admin/order interface |
| Primary job in platform | Receive F&B orders, update order status, and mark orders delivered |
| Authentication method | Individual username/password |
| Session behavior | Server-side session with 40-minute inactivity timeout |
| Credential rule | No shared F&B staff accounts |
| Phase 1 financial boundary | Does not handle payment, wallet, or loyalty, including F&B payment |

### 2.4 `ADMIN`

| Field | Definition |
|---|---|
| Who holds this role | Full operational administrator, expected to be Kerem or explicitly authorized admin users in Phase 1 |
| Interface | Web admin interface |
| Primary job in platform | Full operational oversight, staff account management, audit-log visibility, customer-data administration, wallet/loyalty operational access, and permission-sensitive actions |
| Authentication method | Individual username/password + required TOTP MFA |
| Session behavior | Server-side session with shorter inactivity timeout than staff; exact timeout to be specified by Pod B in the authentication ADR |
| Credential rule | No shared admin accounts |
| Audit boundary | Admin can view audit logs but cannot edit or delete audit log entries |

[REQUIRES POD B REVIEW] Admin inactivity timeout value is intentionally left to the future authentication ADR. This document records only the confirmed direction: shorter than the 40-minute staff timeout.

---

## 3. Permission Matrix

Public catalog/menu browsing is available to unauthenticated visitors (no role required, no JWT required). This is a pre-authentication endpoint. The authentication ADR must reflect this when defining route-level auth enforcement.

Legend:

| Symbol | Meaning |
|---|---|
| ✅ | Permitted |
| ❌ | Explicitly prohibited |
| — | Not applicable / not a role responsibility |
| ✅ own | Permitted only for the actor’s own customer account |
| ✅ all | Permitted across relevant operational/customer records |

| Feature / Action | `CUSTOMER` | `CASHIER` | `FB_STAFF` | `ADMIN` |
|---|---:|---:|---:|---:|
| Browse public catalog/menu | ✅ | — | — | ✅ |
| Log in to customer PWA | ✅ | ❌ | ❌ | ❌ |
| Log in to staff/admin web interface | ❌ | ✅ | ✅ | ✅ |
| View own wallet balance | ✅ own | — | — | ✅ all |
| View own loyalty balance | ✅ own | — | — | ✅ all |
| View own customer profile/account information | ✅ own | — | — | ✅ all |
| Submit F&B order | ✅ | — | — | — |
| View own F&B order status | ✅ own | — | — | ✅ all |
| Submit reservation request | ✅ | — | — | — |
| View own reservation request status | ✅ own | — | — | ✅ all |
| Wallet top-up | ❌ | ✅ | ❌ | ✅ |
| Loyalty redemption | ❌ | ✅ | ❌ | ✅ |
| Receive / update order status | — | ✅ | ✅ | ✅ |
| Mark F&B order delivered | — | ✅ | ✅ | ✅ |
| Handle payment, any type | ❌ | ✅ | ❌ | ✅ |
| Handle F&B payment (explicit restatement that `FB_STAFF` ❌ applies even at F&B stations) | ❌ | ✅ | ❌ | ✅ |
| Approve / reject reservation | — | ✅ | ❌ | ✅ |
| View masked customer phone number during cashier top-up flow | ❌ | ✅ | ❌ | ✅ |
| View full customer phone number | ✅ own | ❌ | ❌ | ✅ |
| View customer wallet/loyalty records for operational handling | ❌ | ✅ (transaction-scoped: visible only during an active top-up or redemption workflow for the customer being served — not all-customer browse) | ❌ | ✅ |
| View audit logs, read-only | ❌ | ❌ | ❌ | ✅ |
| Create staff accounts | ❌ | ❌ | ❌ | ✅ |
| Suspend staff accounts | ❌ | ❌ | ❌ | ✅ |
| Reset staff credentials | ❌ | ❌ | ❌ | ✅ |
| Edit or delete audit log entries | ❌ | ❌ | ❌ | ❌ |

[Pod B confirmed — 2026-06-09] This matrix applies the confirmed decision that `FB_STAFF` manages orders only and does not handle payment, wallet, or loyalty. This supersedes any older repo wording that implies payment can be handled at F&B cashier/order points by F&B staff.

K-21 narrows the first operating-slice customer UX: kitchen/service continue from Selcafe printed receipts and first-slice UX does not include customer-facing delivered tracking. Any broader `FB_STAFF` order-status capability remains internal/later expansion until reconciled by Pod B and Kerem.

Open question for `BUSINESS_RULES.md`: should `CASHIER` have a “view my own recent transactions” interface limited to their own processed actions? Not addressed in this document — flag for `BUSINESS_RULES.md`.

---

## Operating Spine Role Notes — K-21

K-21 approves the Product Phase 1 operating spine: **Selcafe-linked customer visibility and ordering**.

This section reconciles role expectations for that spine only. This document does not authorize Pod C implementation.

Phase 1 remains read-only toward Selcafe; Selcafe remains the settlement source of truth for this operating spine.

| Role / Actor | Operating-spine responsibility | Boundary |
|---|---|---|
| `CUSTOMER` with Adeks account | May link `fiş`, confirm table, order F&B, use eligible coupon, earn loyalty after settlement, and view settled history where supported. | Coupon, loyalty, and settled visit history require account binding before final settlement. |
| Addition-only guest | May link `fiş`, confirm table, and submit F&B order under K-21/K-OS-001. | No coupon, loyalty, or settled visit history unless account is bound before final settlement. |
| `CASHIER` | Primary first-slice operational receiver for PWA F&B orders; manually enters accepted orders into Selcafe; handles final payment; resolves wrong `fiş`/table/coupon/order exceptions. | No direct Selcafe write by Adeks is implied; cashier uses Selcafe manually. Cashier actions affecting order/coupon/settlement require later audit review. |
| `FB_STAFF` | Kitchen/service continue from Selcafe printed receipts in the first operating slice. | No kitchen-facing PWA workflow or customer-facing delivery tracking is included in the first operating slice. Existing broader order-status work may remain internal/later expansion but should not define first-slice UX. |
| `ADMIN` | Reviews first-week disputed orders and ten random orders; receives summary/check outputs where later defined. | Exact report fields, access scope, masking, retention, and audit mechanics require Pod B/legal review. |

[REQUIRES POD B REVIEW] Addition-only guest ordering, cashier exception handling, admin check reports, and Selcafe-derived visibility affect authentication, authorization, audit, KVKK, and data minimization boundaries.

---

## 4. Shared Credentials Prohibition

No Phase 1 role permits shared credentials.

Each staff member must have an individual account. This applies to:

- `CASHIER`
- `FB_STAFF`
- `ADMIN`

This is a locked audit-principle requirement, not a recommendation. Shared staff accounts are prohibited because sensitive actions must be attributable to a specific human actor.

---

## 5. Audit Trail Requirement

All `CASHIER`, `FB_STAFF`, and `ADMIN` actions affecting any of the following areas must produce audit records:

- Wallet
- Loyalty
- Payment
- Customer data
- F&B order status changes
- Reservation approval/rejection
- Staff account creation, suspension, reactivation, or credential reset
- Admin access to audit logs or sensitive operational records

Minimum audit record fields:

| Field | Requirement |
|---|---|
| Actor UUID | Required |
| Action type | Required |
| Timestamp | Required |
| Affected entity UUID | Required |

Audit records must be append-only from the perspective of application roles. No Phase 1 role, including `ADMIN`, may edit or delete audit log entries.

[REQUIRES POD B REVIEW] This is a product-level audit requirement only. Audit event schema, storage model, retention, tamper resistance, and implementation mechanics belong to Pod B architecture/security work.

---

## 6. KVKK Data Access Flags

Every role that accesses personal data or staff activity data must be represented in `/docs/DATA_PROCESSING_INVENTORY.md`.

| Role | Personal / sensitive data accessed | Access scope | DATA_PROCESSING_INVENTORY.md flag |
|---|---|---|---|
| `CUSTOMER` | Own phone number, own wallet records, own loyalty records, own F&B order records, own reservation records | Own account only | Required |
| `CASHIER` | Masked customer phone number during top-up flow, customer wallet records during top-up, customer loyalty records during redemption, payment-related operational records, reservation/order records needed for cashier workflows | Operational access only; full customer phone number not displayed in top-up flow | Required |
| `FB_STAFF` | F&B order records, order status, seat/PC context where needed for delivery, staff activity records generated by their own actions | Order-management access only; no customer phone, wallet, loyalty, or payment access | Required |
| `ADMIN` | Customer phone numbers, customer wallet records, customer loyalty records, order and reservation records, staff account records, staff activity logs, audit logs | Full operational access | Required |

Note: The Aydınlatma Metni (privacy notice) must be displayed and acknowledged before the OTP is sent. This is a KVKK-mandatory registration flow requirement. It must be captured in `CORE_USER_FLOWS.md` — not this document.

### 6.1 Phone Number Display Rule

During the cashier wallet top-up flow, the cashier sees only a masked customer phone number with the last 4 digits visible.

Example synthetic display:

```txt
+90 555 *** ** 01
```

Full customer phone number display is limited to `CUSTOMER` for their own account and `ADMIN` for authorized operational administration.

`ADMIN` access to full customer phone numbers must produce an audit record (actor UUID, accessed customer UUID, timestamp), per the general audit requirements in §5.

### 6.2 Data Minimization Requirements

- `FB_STAFF` must not see customer wallet data.
- `FB_STAFF` must not see customer loyalty data.
- `FB_STAFF` must not handle or see payment settlement data unless a later Pod B-reviewed and Kerem-approved decision changes the role boundary.
- `CASHIER` should see only the customer data required to complete the cashier workflow.
- Staff-facing workflows must avoid exposing full phone numbers unless the role and workflow explicitly require it.

[REQUIRES POD B REVIEW] KVKK handling, data inventory structure, legal basis mapping, retention, and access logging must be reviewed through Pod B and Kerem/legal-advisor processes before production use with real customer data.

---

## 7. Phase 2 Candidates

The following items are explicitly deferred, not forgotten:

| Candidate | Phase 1 Position | Future Review |
|---|---|---|
| Google login for `CUSTOMER` | Deferred | Phase 2 candidate |
| `MANAGER` role split from `ADMIN` | Deferred | Phase 2 candidate |
| MFA for `CASHIER` | Deferred; Phase 1 uses password-only with server-side session controls | Phase 2 candidate |
| Admin access to customer PWA (e.g. for customer support impersonation or operational testing) | Deferred | Phase 2 candidate if operational need emerges |

---

## 8. Repo Reconciliation Notes

The following repo-visible items should be reconciled after Kerem approval.

| ID | Source Area | Current repo wording | Confirmed decision applied in this document | Routing |
|---|---|---|---|---|
| RR-001 | `PROJECT_BRIEF.md` assumptions/open questions | Customer login method appears as not finalized / OQ-001 open | Phase 1 `CUSTOMER` authentication is Phone OTP (SMS) | Update relevant product/open-question docs after Kerem approval |
| RR-002 | `PROJECT_BRIEF.md` payment wording | `PROJECT_BRIEF.md` §8 (F&B Ordering From Seat), step 8: “Payment is handled by cashier/F&B cashier workflow.” — must be updated. F&B Staff does not handle payment. F&B payment is settled by `CASHIER` at the main cashier point. Update `PROJECT_BRIEF.md` §8 step 8 and any corresponding `CORE_USER_FLOWS.md` content when that document is produced. | `FB_STAFF` does not handle any payment; F&B payment is settled at the main cashier point by `CASHIER` | Update `PROJECT_BRIEF.md` §8 and future `CORE_USER_FLOWS.md` content after Kerem approval |
| RR-003 | Older `MANAGER/ADMIN` wording | Some earlier auth recommendation language used `Manager/Admin` | Phase 1 has `ADMIN` only; `MANAGER` split is Phase 2 candidate | Update future auth ADR terminology |

---

## 9. Non-Goals

This document does not define:

- Database schema
- Prisma models
- Token storage, rotation, hashing, or expiry implementation details
- Session table design
- Password hashing algorithm
- MFA implementation library
- SMS provider
- API contracts
- GitHub issue text
- Pod C implementation tasks
- Selcafe SQL Server write behavior

---

## 10. Review Routing

- Ready for commit: Yes, as v0.2 after Kerem approval.
- Requires Kerem approval: Yes — final approval of Phase 1 roles and permissions.
- Requires Pod B review: Complete for v0.1. Pod B re-review is not required for v0.2 unless changes exceed the NB/ADV fixes applied here.
- Requires Pod C implementation: No. This document must not be used to issue implementation work.
- Requires Pod D prototype/audit/monitoring review: Optional later for staff/admin UI flow and customer PWA flow validation.
