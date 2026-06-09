# Authentication Architecture Recommendation — OQ-001

**Document type:** Pod B Architecture Recommendation (Pre-ADR)
**Status:** Draft — awaiting Kerem decision on marked items before ADR can be written
**Intended repo path:** `/docs/architecture/AUTHENTICATION_RECOMMENDATION_OQ-001.md`
**Author:** Pod B — Architecture, Logic & Risk
**Date:** 2026-06-09
**Feeds:** `/docs/USER_ROLES_AND_PERMISSIONS.md` (Pod A); future authentication ADR (Pod B)
**Required before:** Pod A finalises USER_ROLES_AND_PERMISSIONS.md; authentication ADR drafted; Pod C implementation of any auth-related module
**Review gate:** Pod B + Kerem (per ADR-009 §3: Authentication and authorisation; Customer personal data handling)

---

## 1. Not Authorized by This Recommendation

The following are explicitly out of scope and must not be actioned based on this document:

- Implementation issue creation
- Database schema design
- Database migrations
- Prisma installation or configuration
- `TenantContext` module implementation
- Session table design
- Pod C handoff of any kind
- SMS provider selection (raised as a Kerem decision point; not resolved here)

---

## 2. Purpose and Scope

This recommendation resolves **OQ-001** (*What customer login method should Phase 1 use?*) and extends it to cover all Phase 1 actors. It is a structured recommendation, not a unilateral decision. Items marked `[NEEDS KEREM APPROVAL]` must be confirmed by Kerem before the authentication ADR can be written and before implementation is unblocked.

**Scope:**
- Recommended identity source and login method per actor
- Required authentication strength per actor
- Session direction per actor (token lifecycle and inactivity behavior — not session table design)
- Audit implications per actor
- KVKK/customer-data implications per actor
- Wallet, loyalty, payment, and admin sensitivity per actor

**Not in scope:** RBAC permission matrix detail (Pod A's `USER_ROLES_AND_PERMISSIONS.md`), session table schema, credential hashing implementation, token storage implementation.

---

## 3. Context: Locked Decisions Informing This Recommendation

The following locked decisions constrain the authentication direction. They are not re-opened here.

| Decision | Source | Constraint on Auth |
|---|---|---|
| D-001: Login-gated core PWA features | PROJECT_BRIEF.md | Customer must authenticate before accessing wallet, loyalty, F&B ordering, reservations |
| D-003: Cashier/admin wallet top-up Phase 1 | PROJECT_BRIEF.md | Wallet write access is staff-only; requires identified cashier actor |
| D-006: Cashier-handled loyalty redemption | PROJECT_BRIEF.md | Redemption requires identified cashier actor with audit trail |
| D-008: Staff-approved reservations | PROJECT_BRIEF.md | Reservation approval requires identified staff actor |
| D-010: Cashier-only payment Phase 1 | PROJECT_BRIEF.md | No customer self-payment; all payment flows require identified cashier |
| All admin actions auditable | PROJECT_METHODOLOGY.md §20 (Locked Principle) | **Individual identity is a hard requirement for all staff roles.** Shared accounts are architecturally prohibited. |
| Human approval for wallet/payment/refund/security/customer-data | PROJECT_METHODOLOGY.md (Locked Principle) | High-sensitivity actions require identifiable human actor on record |
| Authentication and authorisation → Pod B + Kerem review | ADR-009 §3 / PROJECT_METHODOLOGY.md §11.1 | This recommendation and any resulting ADR require Kerem approval before locking |
| Phone number as primary PII identifier | PROJECT_METHODOLOGY.md §20.2 / PROJECT_BRIEF.md §13 | Customer identity is anchored to phone number; KVKK data processing obligations follow |
| KVKK: Aydınlatma Metni before first data collection | KEREM_DECISIONS.md K-09, PROJECT_METHODOLOGY.md §20.2 | Privacy notice must be acknowledged before OTP is sent or any personal data collected |
| Modular monolith / NestJS / Next.js / PostgreSQL / Prisma / UUID PKs | ADR-001 through ADR-004, ADR-008 | Auth module lives inside the monolith; entity identifiers are UUIDs |

**Open question being addressed:** OQ-001 (customer login method) and A-005 (login method not finalized). Both are addressed with recommendations below; both require Kerem confirmation.

---

## 4. Actor Summary

| Actor | Interface | Phase 1 Sensitivity | Individual Identity Required? |
|---|---|---|---|
| Gaming Customer | PWA (mobile web browser) | Medium — read own wallet/loyalty; submit F&B orders and reservation requests; no balance mutations | Yes — for audit trail and KVKK subject rights |
| Cashier | Web cashier/admin (main cashier point) | Very High — wallet top-up, loyalty redemption, payment, order management | Yes — hard requirement (locked audit principle) |
| F&B Staff | Web cashier/admin (F&B points ×2) | Medium-High — order management, F&B payment; wallet/loyalty write TBD | Yes — hard requirement (locked audit principle) |
| Manager/Admin | Web cashier/admin (full access) | Very High — full operational access, audit log visibility, staff account management, customer data access | Yes — hard requirement; elevated assurance needed |
| System/Service | Internal (in-process) / SelcafeAdapter | Low — no external API surface in Phase 1 modular monolith | N/A — see §8.5 |

---

## 5. Per-Actor Authentication Recommendations

### 5.1 Gaming Customer (PWA)

**Identity source:** Phone number as primary identifier. This is already the KVKK-mandated PII anchor for the platform (PROJECT_BRIEF.md §13, PROJECT_METHODOLOGY.md §20.2). No alternative identity anchor is recommended.

**Login method recommendation:** Phone number + OTP (SMS one-time password).

**Rationale:**

- Phone is already collected as the primary customer PII — the identity source and the PII are the same field, which simplifies the data model and the KVKK data processing inventory
- SMS OTP is the dominant consumer authentication pattern in the Turkish market; customers will recognise it immediately
- Passwordless: eliminates password reset flows, weak passwords, and password reuse risk
- Self-service: customer can register and authenticate without cashier assistance, supporting the PWA adoption target (K-01, K-05)
- Persistent identity: the same phone number is recognized across visits, enabling loyalty earning history and wallet continuity
- Compatible with Aydınlatma Metni requirement: privacy notice is displayed and acknowledged before OTP is sent — i.e., before any personal data is committed to the platform

**Fallback option (if SMS provider selection is delayed):** Phone number + PIN (4–6 digit numeric code, set by the customer on first registration). This is a weaker credential but has no external dependency. [NEEDS KEREM APPROVAL — see KD-A and KD-B in §9]

**Rejected alternatives:**

| Option | Rejection reason |
|---|---|
| Cashier-created account | Requires cashier action per customer; poor self-service UX; slows cashier; does not scale; friction for adoption target |
| QR/session code tied to PC | Ties identity to a session, not a person; requires a second binding for persistence; non-standard consumer UX; implementation complexity without proportionate benefit |
| Selcafe account mapping | Creates hard dependency on legacy system in violation of vendor-neutral principle; Selcafe spike (K-10) not yet complete; future Selcafe retirement would break identity |
| Email + password | Turkish gaming café customers are mobile-primary; email flows are high-friction on mobile; requires email collection as additional PII; no operational benefit over phone OTP |
| Social login (Google, Apple) | Introduces third-party identity dependency; adds cross-border data transfer risk for KVKK assessment; over-engineered for Phase 1 scope |

**Authentication strength:** Medium. Phone possession acts as a second factor in practice (something you have: the SIM). Single-factor in technical terms. Appropriate for Phase 1 customer scope where no self-service financial mutations are permitted.

**Session direction:**
- Short-lived access token (JWT) carrying customer UUID (not phone number) — target lifetime 15–30 minutes
- Refresh token for session persistence — target lifetime 7–30 days [ASSUMPTION: align with a documented retention period in DATA_RETENTION_POLICY.md]
- Explicit logout invalidates the refresh token server-side
- Re-authentication required if refresh token expires or is invalidated
- Tokens must not contain phone number or any PII in claims
- [ASSUMPTION: httpOnly cookie preferred over localStorage for token storage — reduces XSS surface area. Implementation scope; stated here as a security direction requirement for the implementation ADR.]

**Audit implications:**
- All wallet/loyalty/order/reservation events record customer UUID + timestamp
- Authentication events (successful login, failed attempt, logout) should be retained in an audit-capable form
- Phone number must not appear in application request/response logs unmasked
- Data subject access requests under KVKK Art. 11 must be serviceable from the audit trail

**KVKK implications:**
- Phone number = PII (Art. 3/d KVKK) → must appear in DATA_PROCESSING_INVENTORY.md with legal basis (likely contract performance or legitimate interest — legal advisor to confirm per K-08)
- Aydınlatma Metni displayed and acknowledged **before OTP is sent** — this is a registration-flow UX requirement for Pod A and Pod C; it is non-negotiable regardless of the chosen login method
- OTP codes are ephemeral: verified and discarded; never persisted after verification
- Phone enumeration risk: OTP API endpoint must return the same user-facing response whether or not the phone number is registered (to prevent discovery of which numbers are in the system). This is a security requirement, not a UX choice.
- Rate limiting on OTP requests: required to prevent abuse (enumeration, SMS flooding)
- Retention period for customer account records: must be defined in DATA_RETENTION_POLICY.md before go-live

**Wallet/loyalty sensitivity:** Customer can view own wallet balance and loyalty balance after login. Cannot top up wallet self (D-003/D-004 — cashier-only). Cannot initiate loyalty redemption self (D-006 — cashier-handled). Can place F&B orders (which may trigger automatic loyalty earn per D-005, but earn is a backend event, not a customer-initiated mutation). Can submit reservation requests (no financial consequence at submission).

---

### 5.2 Cashier

**Identity source:** Platform-managed staff account provisioned by Manager/Admin.

**Login method recommendation:** Individual email/username + password.

**Rationale:**

- Individual accounts are a hard requirement for the locked audit principle ("all admin actions auditable"). If two cashiers share one account, audit records cannot identify which cashier performed a wallet top-up. This is not a preference — it is a non-negotiable architectural constraint.
- Browser-based interface on a fixed cashier terminal: standard username/password login is fast and familiar for staff
- Password managed by the platform (hashed, policy-enforced): no external dependency

**Authentication strength:** Medium. Password-based, single factor. Compensating controls recommended: short inactivity timeout (see KD-D), terminal-context awareness, explicit logout on shift end.

**Session direction:**
- Server-side session preferred for staff accounts: enables instant invalidation if a staff account is suspended or credentials are compromised, without waiting for a short-lived token to expire
- Inactivity timeout enforced server-side: idle session terminated after [NEEDS KEREM APPROVAL — see KD-D; Pod B recommends 20 minutes]
- Explicit logout on shift end must be documented in staff operating procedure (Pod A to note in `CORE_USER_FLOWS.md`)
- If cashier terminal is a shared device, re-authentication on each shift is required; session must not persist across browser close without explicit choice
- [ASSUMPTION: "remember me" should not be offered on shared cashier terminals]

**Audit implications:**
- Every wallet top-up event must record: cashier UUID, timestamp, customer UUID, amount, entry type. This is a ledger-level requirement.
- Every loyalty redemption event must record: cashier UUID, timestamp, customer UUID, points redeemed, reason.
- Every order status change must record cashier/staff UUID + timestamp.
- Failed login attempts for cashier accounts must be logged; N consecutive failures should trigger alerting [ASSUMPTION: N = 5; configurable].
- Cashier login and logout events must be retained in audit-capable form.

**KVKK implications:**
- Staff credentials are personal data of staff members. Staff activity logs (wallet actions, order actions, login events) must be included in DATA_PROCESSING_INVENTORY.md with appropriate legal basis (employment relationship).
- Retention period for staff activity logs must be defined in DATA_RETENTION_POLICY.md.
- Cashier role accesses customer personal data (phone number visible during top-up flow? — [NEEDS KEREM APPROVAL: confirm whether cashier sees full phone or masked version during top-up workflow]). If full phone is displayed, this access must be proportionate and audited.

**Wallet/loyalty sensitivity:** Very High. Cashier initiates wallet top-ups and loyalty redemptions — both are append-to-ledger events with financial value. Every action must produce a durable, non-repudiable audit record. If OQ-006 (manager approval above threshold) is confirmed, cashier's top-up capability will be bounded; see KD-F.

---

### 5.3 F&B Staff

**Identity source:** Platform-managed staff account provisioned by Manager/Admin. Same mechanism as cashier.

**Login method recommendation:** Individual email/username + password (identical mechanism to cashier).

**Rationale:** Same individual-identity audit requirement applies. F&B staff process orders and handle F&B payment — these are auditable actions that must be attributable to a named actor.

**Authentication strength:** Same as cashier.

**Session direction:** Same patterns as cashier. On shared F&B terminals with high order volume, a fast "switch user" flow (re-enter password without full logout) is architecturally desirable for operational speed — but this is a UX refinement, not a Phase 1 blocker. [ASSUMPTION: Phase 1 F&B terminals have one active user per shift; switch-user is deferred if operationally acceptable to Kerem.]

**Audit implications:** Order received, order status updated, and F&B payment recorded must capture F&B staff UUID + timestamp.

**KVKK implications:** Same as cashier (staff activity logs, employment basis). F&B staff interaction with customer personal data is expected to be minimal (order is linked to seat/PC number, not necessarily to customer name at the F&B counter level) — [ASSUMPTION: to be confirmed in CORE_USER_FLOWS.md].

**Wallet/loyalty sensitivity:** [NEEDS KEREM APPROVAL — KD-E] Does F&B Staff have any wallet or loyalty write access? Pod B's default recommendation is **no** — F&B Staff manages orders and F&B payment only; wallet top-up and loyalty redemption are cashier-role actions at the main cashier point. If F&B staff can also redeem loyalty at the F&B counter (e.g., a customer paying for food with loyalty points), this changes the audit and role-boundary design. Kerem must confirm.

---

### 5.4 Manager/Admin

**Identity source:** Platform-managed account provisioned by Kerem (self-provisioned in Phase 1 single-café context).

**Login method recommendation:** Individual email/username + password **+ MFA (TOTP)**.

**MFA recommendation rationale:**

The Manager/Admin role has the highest privilege surface in Phase 1:
- Full read access to audit logs (which contain cashier activity, wallet events, customer data access records)
- Ability to manage staff accounts (create, suspend, reset passwords)
- Potential access to customer personal data at aggregate level
- Ability to view and report on wallet/loyalty balances

A compromised admin account creates risk across all of these dimensions simultaneously. MFA adds material protection with minimal operational overhead: Kerem is one person in Phase 1; setting up a TOTP app (e.g., Google Authenticator, standard iOS Passwords) takes under two minutes and adds no per-login friction beyond 6 digits.

[NEEDS KEREM APPROVAL — KD-C] Whether MFA is required or optional in Phase 1. Pod B recommendation: **required for the admin role**.

If Kerem declines MFA, the compensating control requirement is: strong password policy enforced at account creation, shortest session timeout of any role, and IP allowlisting if Kerem is willing to restrict admin access to known network addresses.

**Authentication strength:** High (password + TOTP) or Medium (password only if MFA declined). Admin is the only role for which Pod B recommends MFA in Phase 1.

**Session direction:** Shorter inactivity timeout than cashier — Pod B recommendation: 15 minutes for admin. Re-authentication recommended for high-sensitivity actions (e.g., staff account reset, bulk operations) — specific action list to be defined when USER_ROLES_AND_PERMISSIONS.md is drafted.

**Audit implications:**
- All admin actions must produce audit records (locked principle — non-negotiable)
- Admin must not be able to edit or delete audit log entries — audit log is append-only and admin-readable, not admin-writable
- Admin login, logout, and MFA events must be logged
- Staff account creation, suspension, and credential reset by admin must be logged with admin UUID + timestamp

**KVKK implications:**
- Admin has the broadest access to personal data of any role: customer phone numbers (potentially), wallet/loyalty records, staff activity logs
- Admin access to personal data must be logged proportionately and retained
- Under KVKK Art. 11 (data subject rights), the admin role is likely the actor who handles access and erasure requests — the workflow must be defined in `DATA_SUBJECT_RIGHTS_PROCESS.md` (K-08)
- Admin credentials must be protected with higher assurance than staff (MFA, strong password policy, session hardening)

**Wallet/loyalty sensitivity:** Very High. Admin can view all wallet/loyalty data; whether admin can initiate corrections (e.g., reversals for error cases) is a product decision for Kerem and must be modelled in `USER_ROLES_AND_PERMISSIONS.md` and reflected in the wallet/loyalty ADRs (ADR-006/007).

---

### 5.5 System/Service Access

**Phase 1 modular monolith:** Inter-module communication is in-process. No token-based authentication is required between NestJS modules within the same process. This is a non-issue for the auth architecture.

**SelcafeAdapter (Selcafe read-only connection):** This is a database-level credential (SQL Server username/password) provided by Kerem to Pod C via a secure channel (K-10), stored as an environment variable or secrets configuration outside the application's user authentication layer. It is not a platform-level auth concern and does not use the same identity mechanisms as user actors.

[ASSUMPTION: No Phase 1 webhooks, inbound API-to-API calls, or background jobs requiring external bearer token authentication exist. If this changes (e.g., an SMS provider webhook, a payment callback for Phase 2), a separate auth recommendation is needed for that integration surface.]

If a scheduled background job is introduced in Phase 1 (e.g., a batch loyalty calculation), it runs as an internal service under the modular monolith process — no external token required. Authorization inside the application should use a service context that bypasses the user-facing RBAC layer, with clear code-level separation to avoid privilege confusion.

---

## 6. Cross-Cutting Concerns

### 6.1 Individual Identity as a Hard Requirement

The locked principle "all admin actions auditable" makes shared credentials architecturally prohibited for all staff roles. Every cashier, F&B staff member, and manager must have their own account. Pod A must state this explicitly in `USER_ROLES_AND_PERMISSIONS.md`. Account provisioning workflow (who creates accounts, what the onboarding process is) is an operational concern for Kerem and should be documented in the staff onboarding flow.

### 6.2 KVKK — Phone Number and Customer Identity

Phone number is the primary PII identifier. Every feature that stores, transmits, or displays phone numbers must reference the DATA_PROCESSING_INVENTORY.md entry. The following requirements are non-negotiable:

- Aydınlatma Metni acknowledged before OTP is sent (before any customer data is committed)
- OTP codes discarded after verification — not persisted
- Phone number not included in JWT claims or application event logs in plaintext
- OTP endpoint must return a consistent response regardless of whether the phone number is registered (prevents enumeration of registered customers)
- Rate limiting on OTP requests (prevents SMS flooding and brute-force enumeration)
- Retention period for customer accounts and authentication events must be defined before go-live (K-07 VERBİS dependency)

### 6.3 Audit Trail Requirements (Direction, Not Schema)

The following authentication events must be auditable for all actors. This is a requirements statement; session table design and schema are explicitly out of scope here.

| Event | Applies to | Required captured data |
|---|---|---|
| Successful login | All actors | Actor UUID, timestamp, actor type (customer/cashier/staff/admin) |
| Failed login attempt | Staff roles; Customer (rate-limiting purpose) | Actor identifier (UUID or phone hash for customer), timestamp, attempt count |
| Logout (explicit) | All actors | Actor UUID, timestamp |
| Session expiry (timeout) | Staff roles | Actor UUID, timestamp |
| Password change | Staff roles | Actor UUID, changed-by (self or admin), timestamp |
| Account suspension / reactivation | Staff roles | Target actor UUID, admin UUID, timestamp |
| MFA event (if enabled) | Manager/Admin | Actor UUID, event type (success/failure), timestamp |

Customer authentication events contain a derived reference (UUID or phone hash) — the full phone number must not be stored in audit event records.

### 6.4 Token and Session Direction Summary

This is a directional statement only. Session table design is out of scope.

| Actor | Direction | Notes |
|---|---|---|
| Gaming Customer | JWT access token (short-lived) + refresh token (longer-lived), stateless read | Refresh token invalidated on explicit logout; httpOnly cookie preferred over localStorage |
| Cashier | Server-side session | Enables instant invalidation; inactivity timeout enforced |
| F&B Staff | Server-side session | Same as cashier |
| Manager/Admin | Server-side session | Shorter timeout; re-auth prompt for high-sensitivity actions |

The divergence (JWT for customers, server-side session for staff) is intentional. Customer sessions on the PWA benefit from stateless JWT architecture for scalability; staff sessions on the web admin require server-controlled invalidation for security and operational control.

---

## 7. Risks

| Risk | Category | Severity | Mitigation |
|---|---|---|---|
| SMS provider not selected | Schedule | High — blocks customer auth implementation | Begin provider evaluation immediately (parallel track with this recommendation); define phone + PIN as fallback if provider selection slips beyond Phase 1 readiness checkpoint. KD-B requires Kerem action. |
| Phone enumeration via OTP endpoint | Security / KVKK | Medium | Consistent API response regardless of registration status; rate limiting on OTP requests by IP and by phone number. Non-negotiable implementation requirement. |
| Staff shared accounts (current practice unknown) | Security / Audit | High if present | Audit principle prohibits shared accounts. Kerem must confirm current staff practice. If shared accounts exist today, migration to individual accounts is a pre-launch operational requirement, not a Phase 2 item. |
| Admin account compromise without MFA | Security | High | MFA recommended (KD-C). If Kerem declines, compensating controls: strong password policy, short session timeout, IP restriction. Risk accepted with Kerem's explicit sign-off. |
| JWT token leakage via XSS (customer PWA) | Security | Medium | httpOnly cookie for token storage preferred over localStorage. This is an implementation-layer requirement stated here as a direction; Pod C must not use localStorage for auth tokens. |
| Selcafe account mapping pressure post-spike | Scope risk | Low-Medium | If the Selcafe spike (K-10) reveals existing customer accounts in Selcafe, pressure may arise to import or map those accounts. This would require a new Pod B review. The recommendation here explicitly rejects Selcafe account mapping for Phase 1. |
| Re-authentication UX friction at cashier | Operational | Low | Inactivity timeout creates re-login events during busy periods. Mitigation: calibrate timeout threshold with Kerem (KD-D); consider fast-path re-auth (PIN re-entry) rather than full login. Not a Phase 1 blocker. |
| Customer data subject rights (Art. 11 KVKK) | Legal / Compliance | High if unplanned | Customer must be able to exercise rights (access, correction, erasure). Erasure conflicts with append-only ledger principle — this is a known open design tension. Pod B will flag this as a separate open question for the ledger ADRs (ADR-006/007). Not blocking this auth recommendation, but must be resolved before go-live. |

---

## 8. What Pod A Must Reflect in USER_ROLES_AND_PERMISSIONS.md

The following items are Pod B handoff notes to Pod A. They are requirements for `USER_ROLES_AND_PERMISSIONS.md`, not optional suggestions.

**8.1 Role structure** — Four user-facing roles confirmed for Phase 1:
- `CUSTOMER` — Gaming customer accessing the PWA
- `CASHIER` — Main cashier point staff
- `FB_STAFF` (or `FOOD_BEVERAGE_STAFF`) — F&B cashier/order point staff
- `MANAGER` / `ADMIN` — Full operational access (may be a single role in Phase 1 if Kerem's team has no role split between manager and admin)

Pod A must confirm with Kerem whether `MANAGER` and `ADMIN` are one role or two in Phase 1. Pod B's default recommendation is a single elevated role for Phase 1 (Kerem is both in the single-café context) with the option to split in Phase 2 if needed.

**8.2 Individual identity requirement** — Pod A must state explicitly in the document that no role permits shared credentials. Each staff member has their own account. This is not an advisory note; it is an audit-principle requirement.

**8.3 Permission matrix guidance** (indicative — Pod A to confirm and expand):

| Permission | CUSTOMER | CASHIER | FB_STAFF | MANAGER/ADMIN |
|---|---|---|---|---|
| View own wallet balance | ✅ | — | — | ✅ (all customers) |
| View own loyalty balance | ✅ | — | — | ✅ (all customers) |
| Submit F&B order | ✅ | — | — | — |
| Submit reservation request | ✅ | — | — | — |
| Wallet top-up | ❌ | ✅ | ❌ [KD-E] | ✅ |
| Loyalty redemption | ❌ | ✅ | ❌ [KD-E] | ✅ |
| Manage order status | — | ✅ | ✅ | ✅ |
| Handle F&B payment | — | ✅ | ✅ | ✅ |
| Approve/reject reservation | — | ✅ | ❌ | ✅ |
| View audit logs | — | ❌ | ❌ | ✅ (read-only) |
| Create / suspend staff accounts | — | ❌ | ❌ | ✅ |
| Edit or delete audit log entries | ❌ | ❌ | ❌ | ❌ (nobody) |

Items marked `[KD-E]` depend on Kerem's decision (§9, KD-E).

**8.4 KVKK data access flag** — Pod A must note which roles access personal data (phone number, wallet records with linked customer identity) and flag each for linkage to DATA_PROCESSING_INVENTORY.md. At minimum: CASHIER accesses phone number during top-up flow (confirm masked vs. full — KD-G); MANAGER/ADMIN accesses customer personal data in operational and audit contexts.

**8.5 Authentication method note per role** — Pod A may annotate `USER_ROLES_AND_PERMISSIONS.md` with the method from this recommendation (Phone OTP for CUSTOMER; username + password for staff; + MFA for MANAGER/ADMIN pending KD-C). Mark customer auth method as `[PENDING KEREM APPROVAL — OQ-001]` until KD-A is resolved.

**8.6 Audit requirement statement** — Pod A must include a section or annotation stating that all CASHIER, FB_STAFF, and MANAGER/ADMIN actions on wallet, loyalty, payment, customer data, and account management must produce audit records with actor UUID and timestamp. This is a locked-principle requirement, not a feature request.

---

## 9. Kerem Decision Points

These items must be resolved by Kerem before the authentication ADR can be written and before Pod A can finalise `USER_ROLES_AND_PERMISSIONS.md` as complete.

| ID | Topic | Question for Kerem | Pod B Recommendation | Impact if deferred |
|---|---|---|---|---|
| KD-A | Customer login method (OQ-001) | Should Phase 1 use Phone OTP (SMS) or Phone + PIN as the primary customer authentication method? | Phone OTP (SMS). Reason: self-service, standard Turkish consumer UX, no password complexity overhead. | Blocks customer auth ADR; blocks Pod C customer login implementation |
| KD-B | SMS provider timing | If Phone OTP: Kerem must initiate SMS provider selection. Has a provider been identified? Is this on the Phase 1 critical path? | Begin immediately. Consider Netgsm, İleti yönetim sistemi, or equivalent Turkish SMS gateway. | Blocks customer OTP implementation. If no provider before Phase 1 readiness: Phone + PIN fallback should be activated. |
| KD-C | Admin MFA requirement | Should MFA (TOTP) be required for the Manager/Admin role in Phase 1? | Yes — required. Admin privilege surface justifies MFA; setup cost is trivial for a single admin user. | If declined: risk accepted with Kerem sign-off; compensating controls (short timeout, IP restriction) must be documented. |
| KD-D | Cashier inactivity timeout | How many minutes of cashier-session inactivity before re-login is required? | 20 minutes. Balance between security and operational flow during busy periods. | Operational policy; not a blocker but must be defined before staff UAT. |
| KD-E | F&B Staff wallet/loyalty access | Does F&B Staff (at F&B cashier points) have any wallet top-up or loyalty redemption permissions? | No. Wallet and loyalty mutations are cashier-point-only in Phase 1. | Directly shapes the CASHIER vs FB_STAFF permission boundary in USER_ROLES_AND_PERMISSIONS.md. |
| KD-F | Manager approval above top-up threshold (OQ-006) | Should wallet top-ups above a configurable amount require manager approval or re-authentication? | Not required in Phase 1 (single-café, small team, Kerem is the manager). Recommend a daily top-up report visible to admin as a compensating control. Phase 2 candidate for threshold alerts. | If yes: two-step approval flow required in cashier UX and wallet ledger design. Architectural impact — must be decided before cashier UI flow is designed. |
| KD-G | Cashier view of customer phone number | During the cashier top-up flow, should the cashier see the customer's full phone number or a masked version (e.g., +90 555 *** ** 01)? | Masked — show last 4 digits only for confirmation, not full number. Reduces staff exposure to PII. | KVKK data minimisation; affects cashier UI design. |
| KD-H | MANAGER vs ADMIN role split | Are "manager" and "admin" one role or two in Phase 1? (E.g., is there a distinction between day-to-day operational access and system configuration access?) | One role in Phase 1 — `ADMIN`. Split into `MANAGER` and `ADMIN` in Phase 2 if operational need emerges. | Affects role count in USER_ROLES_AND_PERMISSIONS.md and permission matrix. |

---

## 10. Readiness Assessment

**Ready to hand to Pod A: Yes, conditionally.**

Pod A can begin drafting `USER_ROLES_AND_PERMISSIONS.md` using the role structure, permission matrix guidance, and audit requirements in §8 immediately. Pod A must mark the customer authentication method (KD-A) and the F&B Staff wallet/loyalty boundary (KD-E) as pending Kerem decision.

**Ready to produce authentication ADR: No.**

The authentication ADR cannot be written until:
1. Kerem has confirmed KD-A (customer login method — Phone OTP vs. PIN)
2. Kerem has confirmed KD-C (admin MFA — required or optional)
3. Kerem has confirmed KD-E (F&B Staff permission boundary)
4. `USER_ROLES_AND_PERMISSIONS.md` is drafted by Pod A and reviewed by Pod B (context needed for the ADR's "Consequences" section)

Once those four items are resolved, Pod B will produce the authentication ADR, which will cover the formal decision record, token architecture, session management direction, and security requirements.

**Not ready to unblock Pod C for any auth module implementation.** Authentication is in the mandatory security review category (ADR-009 §3, PROJECT_METHODOLOGY.md §20.3). Implementation cannot begin until the ADR is accepted and Kerem has approved.

---

## 11. Items Explicitly Not Addressed Here

The following topics are in scope for later Pod B work (auth ADR, security view, ledger ADR review) but are out of scope for this narrowly-scoped recommendation:

- KVKK erasure vs. append-only ledger conflict (to be addressed in ADR-006/007 review)
- RBAC enforcement implementation pattern (Kerem guards, NestJS decorators, Prisma row-level)
- Token storage implementation (httpOnly cookie setup, refresh token rotation)
- Password hashing algorithm selection (Argon2 / bcrypt — implementation-level)
- Specific audit log table structure and Prisma schema
- Session invalidation implementation
- Rate limiting implementation approach
- MFA TOTP implementation library

---

*This document is a Pod B architecture recommendation. No item in it is locked until Kerem has explicitly confirmed the items marked `[NEEDS KEREM APPROVAL]` and the authentication ADR has been written, reviewed, and accepted through the standard ADR process.*
