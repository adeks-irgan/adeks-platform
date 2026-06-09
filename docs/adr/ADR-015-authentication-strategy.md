# ADR-015: Authentication Strategy (Phase 1)

<!--
  STATUS: Accepted
  AUTHOR: Pod B — Architecture, Logic & Risk
  REVIEWER: Pod B (self) + Kerem (required — Authentication/authorization + Customer
            personal data handling + Security-sensitive, ADR-009 §3)
  APPROVER: Kerem
  DATE PROPOSED: 2026-06-09
  DATE APPROVED: 2026-06-09
  CANONICAL REPO PATH: /docs/adr/ADR-015-authentication-strategy.md
  RELATED DOCUMENTS:
    - /docs/architecture/AUTHENTICATION_RECOMMENDATION_OQ-001.md (pre-ADR recommendation; resolves OQ-001)
    - /docs/USER_ROLES_AND_PERMISSIONS.md (v0.2 — Pod A role/permission authority)
    - /docs/adr/ADR-004-orm-selection.md (Prisma; UUID PKs)
    - /docs/adr/ADR-008-schema-per-tenant-tenancy.md (shared schema + tenant_id, long-term)
    - /docs/adr/ADR-009-pr-approval-policy.md (PR merge gates; §3 / §4)
    - /docs/PROJECT_METHODOLOGY.md §20 (Security and KVKK Process)
    - /docs/PROJECT_DECISION_INDEX.md (decision state)
    - /docs/KEREM_DECISIONS.md (K-08 KVKK advisor; K-10 Selcafe spike)
  PR GATE: Behavior-changing under ADR-009 §4. Requires Pod Impact Matrix +
           INSTRUCTION_UPDATE_PACKET. Risk categories (ADR-009 §3): Authentication/
           authorization, Customer personal data handling, Security-sensitive →
           strictest governs = Pod B + Kerem before merge. Primary impacted pod: Pod C.
-->

## Status

Accepted — 2026-06-09 (Kerem approval).

The authentication direction recorded here was resolved through the OQ-001 pre-ADR
recommendation (`AUTHENTICATION_RECOMMENDATION_OQ-001.md`) and the Kerem-confirmed
decisions KD-A through KD-H supplied for this ADR. This ADR converts those confirmed
decisions into a durable record. It does not re-open them.

**Decision summary:** Phone OTP (SMS) for `CUSTOMER` with short-lived JWT access tokens
plus refresh tokens in `httpOnly` cookies; individual username/password with server-side
sessions for `CASHIER` and `FB_STAFF` (40-minute inactivity timeout); individual
username/password **plus required TOTP MFA** with a shorter server-side session
(15-minute inactivity timeout) for `ADMIN`. No shared accounts for any role.

---

## Context

### Phase 1 actor model

Phase 1 has exactly four user-facing roles (`USER_ROLES_AND_PERMISSIONS.md` v0.2 §2):

| Role | Interface | Phase 1 financial/privilege surface |
|---|---|---|
| `CUSTOMER` | Customer PWA (mobile web first) | Read own wallet/loyalty; submit F&B orders and reservation requests. No self-mutation of balances. |
| `CASHIER` | Web admin/cashier | Wallet top-up, loyalty redemption, payment settlement, reservation approval/rejection, order handling. Very high sensitivity. |
| `FB_STAFF` | Web admin/order | Receive and update F&B orders only. No payment, wallet, or loyalty access. |
| `ADMIN` | Web admin | Full operational oversight, staff account management, audit-log visibility, customer-data administration. Highest privilege surface. |

`MANAGER` is **not** a Phase 1 role; it is a Phase 2 candidate split from `ADMIN`
(`USER_ROLES_AND_PERMISSIONS.md` §2, §7).

### Locked decisions informing this ADR

These are not re-opened here. They constrain the authentication design.

| Decision | Source | Constraint on authentication |
|---|---|---|
| D-001 — login-gated core PWA features | PROJECT_BRIEF.md / Decision Index §4 | `CUSTOMER` must authenticate before wallet, loyalty, F&B ordering, reservations. |
| D-003 — cashier/admin wallet top-up (Phase 1) | PROJECT_BRIEF.md | Wallet writes are staff-only; require an identified cashier/admin actor. |
| D-006 — cashier-handled loyalty redemption | PROJECT_BRIEF.md | Redemption requires an identified cashier actor with audit trail. |
| D-008 — staff-approved reservations | PROJECT_BRIEF.md | Reservation approval requires an identified staff actor. |
| D-010 — cashier-only payment (Phase 1) | PROJECT_BRIEF.md | No customer self-payment; payment requires an identified cashier. |
| All admin/staff actions auditable (Locked Principle) | PROJECT_METHODOLOGY.md §20 | **Individual identity is a hard requirement for all staff roles.** Shared accounts are architecturally prohibited. |
| Human approval for wallet/payment/refund/security/customer-data | PROJECT_METHODOLOGY.md (Locked Principle) | High-sensitivity actions require an identifiable human actor on record. |
| Phone number as primary PII identifier | PROJECT_METHODOLOGY.md §20.2 | Customer identity anchors to phone number; KVKK obligations follow. |
| KVKK — Aydınlatma Metni before first data collection | K-09 / PROJECT_METHODOLOGY.md §20.2 | Privacy notice must be acknowledged before OTP is sent. |
| Prisma ORM; UUID primary keys; shared schema + `tenant_id` | ADR-004, ADR-008 | Auth entities use UUID PKs and are tenant-scoped via `tenant_id`; the auth module lives inside the modular monolith. |

### OQ-001 resolution

OQ-001 (*what customer login method should Phase 1 use?*) was resolved by the Pod B
pre-ADR recommendation, confirmed by Kerem (KD-A): **Phone OTP (SMS)**. Google login was
deferred to Phase 2 (KD-A). This ADR records the resolved decision and its security and
KVKK consequences.

### Why this needs an ADR

Authentication and session management is a mandatory Pod B security-review area
(PROJECT_METHODOLOGY.md §20.3) and a high-risk PR category (ADR-009 §3). The decision
sets binding behavior that Pod C must implement and that downstream session, RBAC,
audit-log, and PC-seat-linking designs depend on. It therefore requires a durable,
Kerem-approved record before any auth-related implementation is unblocked.

---

## Decision

### 1. `CUSTOMER` — Phone OTP (SMS) with JWT + refresh token (KD-A)

- **Identity source:** phone number (the platform's primary PII anchor). Login is
  phone number + one-time password delivered by SMS.
- **Token model:** short-lived **JWT access token** (target lifetime **~15 minutes**)
  plus a longer-lived **refresh token** (target lifetime **~7–30 days**;
  exact value aligned to `DATA_RETENTION_POLICY.md` before go-live).
- **Token storage:** tokens are stored in **`httpOnly` cookies** — never in
  `localStorage` or `sessionStorage`.
- **Token claims:** tokens carry the **customer UUID**, never the phone number or any
  other PII.
- **Read path:** stateless — reads are authorized from the access token without a
  server-side session lookup.
- **Logout:** explicit logout invalidates the refresh token server-side (see
  Consequences → Security).

### 2. `CASHIER` and `FB_STAFF` — individual credentials, server-side session (KD-D, KD-E)

- **Identity source:** platform-managed staff account, provisioned by `ADMIN`.
- **Login method:** **individual username/password.** One account per human.
  Shared accounts are prohibited (locked audit principle).
- **Session model:** **server-side session** (enables instant invalidation on
  suspension or credential compromise).
- **Inactivity timeout:** **40 minutes**, enforced server-side (KD-D).
- **`FB_STAFF` boundary:** order management only — no payment, wallet, or loyalty access
  (KD-E; `USER_ROLES_AND_PERMISSIONS.md` §2.3, §3).

### 3. `ADMIN` — individual credentials + required TOTP MFA, shorter session (KD-C)

- **Identity source:** platform-managed account; in the Phase 1 single-café context the
  holder is Kerem or an explicitly authorized admin user.
- **Login method:** **individual username/password + required TOTP MFA.** MFA is
  mandatory for this role in Phase 1 (KD-C). No shared accounts.
- **Session model:** **server-side session.**
- **Inactivity timeout:** **15 minutes** — shorter than the 40-minute staff timeout,
  reflecting the elevated privilege surface. Confirmed by Kerem 2026-06-09 (the roles
  doc deferred this value to this ADR).
- **Step-up re-authentication:** re-authentication (password + TOTP) is required
  immediately before each of the following high-sensitivity actions, regardless of an
  active session:
  - creating a staff account;
  - suspending or reactivating a staff account;
  - resetting another user's credentials;
  - changing any user's role or permissions;
  - disabling or re-enrolling MFA on any account;
  - exporting or bulk-accessing customer personal data.

### 4. System/service access

Inter-module communication within the Phase 1 modular monolith is in-process and requires
no token-based authentication. The `SelcafeAdapter` connection uses a database-level
credential held in secrets configuration outside the user authentication layer
(K-10); it is not a platform user actor. No Phase 1 inbound webhook or external
API-to-API surface requiring bearer authentication is assumed; introducing one requires a
separate Pod B auth review.

### 5. Token / session direction summary

| Role | Mechanism | Storage | Timeout | MFA |
|---|---|---|---|---|
| `CUSTOMER` | JWT access (~15 min) + refresh (~7–30 d), stateless reads | `httpOnly` cookie | access ~15 min; refresh ~7–30 d | No (Phase 1) |
| `CASHIER` | Server-side session | Server-side | 40 min inactivity | No (Phase 2 candidate) |
| `FB_STAFF` | Server-side session | Server-side | 40 min inactivity | No (Phase 2 candidate) |
| `ADMIN` | Server-side session | Server-side | 15 min inactivity | **Required (TOTP)** |

The divergence (stateless JWT for customers, server-side session for staff) is
intentional: customer PWA sessions benefit from stateless scalability, while staff/admin
sessions require server-controlled invalidation for operational and security control.

---

## Consequences

### Security requirements (binding on Pod C implementation)

These are non-negotiable implementation requirements derived from this decision.

1. **OTP rate limiting (required).** OTP requests must be rate-limited by IP and by phone
   number to prevent SMS flooding and brute-force enumeration. Absence of rate limiting is
   a security defect, not a configuration choice.
2. **Phone enumeration protection (required).** The OTP request endpoint must return a
   consistent user-facing response whether or not the phone number is registered. The
   response must not reveal registration status.
3. **`httpOnly` cookie storage (required).** JWT access and refresh tokens are stored in
   `httpOnly` cookies. `localStorage`/`sessionStorage` must not be used for auth tokens
   (XSS exfiltration surface). `Secure` and an appropriate `SameSite` attribute apply.
4. **No phone number in token claims or logs (required).** The phone number must not
   appear in JWT claims, nor in application request/response logs, nor in audit event
   records in plaintext. Tokens and logs reference the customer UUID; audit records may
   reference a derived identifier (UUID or phone hash), never the raw phone number.
5. **Refresh-token invalidation on logout (required).** Explicit logout must invalidate
   the refresh token server-side — via a server-side revocation list, or via short-lived
   refresh tokens with forced re-authentication. A logged-out refresh token must not be
   reusable.
6. **Admin step-up re-authentication (required).** The high-sensitivity admin actions
   listed in Decision §3 require password + TOTP re-authentication immediately before
   execution, independent of the active session.
7. **Staff failed-login handling.** Failed staff login attempts must be logged; repeated
   consecutive failures should trigger account lockout/alerting (threshold configurable;
   Pod B recommends 5). `[ASSUMPTION]` exact threshold is an implementation detail for the
   security view, not locked here.
8. **Credential hashing.** Staff/admin passwords must be stored using a modern memory-hard
   hash (e.g. Argon2id or bcrypt). Algorithm selection is an implementation-level decision
   for Pod C, reviewed by Pod B; it is not fixed in this ADR.

Threat modelling for authentication is mandatory (PROJECT_METHODOLOGY.md §20.1) and will
be produced by Pod B as part of the security view before implementation is unblocked.

### KVKK requirements (binding)

1. **Aydınlatma Metni before OTP (required).** The privacy notice must be displayed and
   acknowledged **before the OTP is sent** — i.e. before any customer personal data is
   committed. This is a registration-flow requirement; the flow detail is owned by
   `CORE_USER_FLOWS.md` (cross-reference), and the notice text by `PRIVACY_NOTICE_TR.md`
   (PROJECT_METHODOLOGY.md §20.2).
2. **OTP codes are ephemeral (required).** OTP codes are verified and discarded; they are
   never persisted after verification.
3. **Phone number in the data processing inventory (required).** The phone number is PII
   and must appear in `DATA_PROCESSING_INVENTORY.md`. Legal basis is **TBD by the legal/
   privacy advisor** (K-08); this ADR does not assert a legal basis.
4. **Admin access to full phone numbers is audited (required).** Any `ADMIN` access to a
   full customer phone number must produce an audit record (admin UUID, accessed customer
   UUID, timestamp). `CASHIER` sees only a masked number (last 4 digits) during the
   top-up flow (`USER_ROLES_AND_PERMISSIONS.md` §6.1).
5. **Retention.** Retention periods for customer accounts and authentication events must
   be defined in `DATA_RETENTION_POLICY.md` before go-live.

### Audit consequences

All authentication events (successful login, failed attempt, logout, session expiry for
staff, password change, account suspension/reactivation, MFA events for admin) must be
captured in audit-capable form with actor UUID and timestamp, per
`USER_ROLES_AND_PERMISSIONS.md` §5 and the OQ-001 recommendation §6.3. The audit log is
append-only and admin-readable but not admin-writable — no role, including `ADMIN`, may
edit or delete audit entries. Audit-event schema is out of scope here and belongs to the
audit-log ADR/security work.

### What becomes easier

- A single, Kerem-approved authentication record that session design, RBAC enforcement,
  audit-log design, and PC-seat linking can build on without re-deciding identity.
- Passwordless customer onboarding (no password reset flows, no password reuse risk).
- Attributable staff actions — every wallet/loyalty/payment/order/reservation event ties
  to a named actor, satisfying the locked audit principle.

### What becomes harder or more constrained

- **SMS provider is a hard dependency for customer login.** SMS provider selection is
  **Not locked** (Decision Index §2). Customer OTP implementation cannot complete until a
  provider is selected (KD-B). If provider selection slips past the Phase 1 readiness
  checkpoint, a phone + PIN fallback was discussed in the OQ-001 recommendation but is
  **not adopted by this ADR**; activating it would require a Kerem decision and a new Pod B
  note. `[NEEDS KEREM APPROVAL]` if a fallback is ever required.
- **MFA enrolment for admin** adds a one-time setup step and a 6-digit prompt per login.
  Accepted as proportionate to the admin privilege surface.
- **Server-side sessions for staff** require session state and an invalidation mechanism
  (out of scope here; session table design is not part of this ADR).
- **40-minute staff timeout** will produce re-login events during busy periods; a fast
  re-auth path is a possible later UX refinement, not a Phase 1 requirement.

### Risks accepted

- **Admin without hardware-key MFA.** TOTP is phishing-susceptible relative to WebAuthn/
  hardware keys. TOTP is accepted for Phase 1 as a proportionate control for a single-café
  admin; WebAuthn is a Phase 2 candidate.
- **Single-factor staff login.** `CASHIER`/`FB_STAFF` are password-only in Phase 1.
  Compensating controls: individual accounts, server-side session with 40-minute timeout,
  failed-login handling, and shift-end logout in staff procedure. Staff MFA is a Phase 2
  candidate (`USER_ROLES_AND_PERMISSIONS.md` §7).
- **SMS interception / SIM-swap.** SMS OTP is vulnerable to SIM-swap and interception.
  Accepted for Phase 1 given the customer surface (no self-service balance mutations);
  re-evaluate if customer self-payment is introduced.

### Constrained

- No shared credentials for any role.
- No auth tokens in browser `localStorage`/`sessionStorage`.
- No phone number in token claims, application logs, or audit records in plaintext.
- Tenant scoping for any auth/session-related tenant-scoped table follows the locked
  shared-schema + `tenant_id` model (ADR-008) and the mandatory Prisma Client Extension
  (ADR-004) — no separate per-tenant schema or database for session isolation.

---

## Alternatives Considered

### Google (social) login for `CUSTOMER`

**Deferred — Phase 2 candidate (KD-A).** Introduces a third-party identity dependency and
a cross-border data-transfer consideration for KVKK assessment. Not required for the
Phase 1 customer surface. Revisited in Phase 2.

### Shared staff credentials

**Rejected.** Directly violates the locked audit principle ("all admin/staff actions
auditable", PROJECT_METHODOLOGY.md §20). Shared accounts make it impossible to attribute a
wallet top-up or loyalty redemption to a specific human. Architecturally prohibited.

### Selcafe account mapping for customer identity

**Rejected.** Creates a hard dependency on the legacy system, violating the vendor-neutral
principle, and would break customer identity on future Selcafe retirement. The Selcafe
spike (K-10) is also not complete, so the shape of any existing Selcafe accounts is
unknown. If the spike later reveals importable accounts, that is a new Pod B review — it
does not reopen this decision.

### Email + password for `CUSTOMER`

**Rejected.** Turkish gaming-café customers are mobile-primary; email flows are
high-friction on mobile, require collecting email as additional PII, and offer no
operational benefit over phone OTP given the phone number is already the primary PII
anchor.

### Per-tenant schema or database for session isolation

**Not adopted.** ADR-008 locks **shared schema + mandatory non-null `tenant_id`** as the
long-term tenancy model, with no schema-per-tenant or database-per-tenant planned. Auth and
session data are tenant-scoped via `tenant_id` like all other tenant-scoped data, enforced
by the mandatory Prisma Client Extension (ADR-004). A separate schema/database per tenant
for session isolation is therefore out of scope and not a Phase 1 requirement.

---

## Implementation

| Step | Where | Notes |
|---|---|---|
| This ADR lands in `/docs/adr/` | `/docs/adr/ADR-015-authentication-strategy.md` | Behavior-changing PR (ADR-009 §4). |
| Decision Index row | `/docs/PROJECT_DECISION_INDEX.md` §1 + §3 | §1 Authentication row added (Locked → ADR-015); §3 ADR-015 → Accepted on Kerem approval. |
| Pod Impact Matrix + Instruction Update Packet | PR body + `/docs/instruction-update-packets/IUP-ADR-015.md` | Required by ADR-009 §4. Pod C is the primary impacted pod. |
| Pod B threat model (authentication) | Security view (separate Pod B artifact) | Required before Pod C implementation is unblocked (PROJECT_METHODOLOGY.md §20.1). |
| SMS provider selection | Decision Index §2 (Not locked) | Kerem action (KD-B); blocks customer OTP implementation, not this ADR's acceptance. |

**Implementation remains blocked.** No auth-module implementation, session-table design,
OTP integration, or credential-hashing work begins until this ADR is `Accepted`, the Pod B
authentication threat model is reviewed, and separate Pod B + Kerem approved implementation
issues exist. This ADR does not authorize Pod C work.

---

## PR Gate Classification (ADR-009)

This ADR's PR is **behavior-changing under ADR-009 §4** — it defines authentication
behavior that Pod C must implement. The PR **must** include a **Pod Impact Matrix** (all
four pods assessed) and a filled **`INSTRUCTION_UPDATE_PACKET.md`**.

Under ADR-009 §3 the PR matches three risk rows — Authentication/authorization, Customer
personal data handling, and Security-sensitive — and the strictest applicable requirement
governs: **Pod B + Kerem required before merge.** **Pod C is the primary impacted pod**
(authentication implementation will be issued from this ADR via separate approved issues).

---

## Approval

- **Author:** Pod B — Architecture, Logic & Risk
- **Reviewer:** Pod B (self) + Kerem (required per ADR-009 §3)
- **Approver:** Kerem
- **Date proposed:** 2026-06-09
- **Date approved:** 2026-06-09 (Kerem approval)
