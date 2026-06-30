# CORE_USER_FLOWS.md

## Status

| Field                 | Value                                                                                 |
| --------------------- | ------------------------------------------------------------------------------------- |
| Document              | CORE_USER_FLOWS.md                                                                    |
| Project               | Adeks Platform                                                                        |
| Version               | v0.4 product-flow QR handshake reconciliation                                          |
| Owner                 | Pod A — Product & Planning                                                            |
| Reviewer              | Pod B — Architecture, Logic & Risk                                                    |
| Approver              | Kerem                                                                                 |
| Current status        | Kerem decisions OQ-CUF-AUTH-002/003/004 recorded 2026-06-10 (K-14/15/16; Pod B annotation pass v0.3). §4 reconciled to merged QR-handshake session-linking design. Open: OQ-CUF-AUTH-001 (notice legal text), OQ-CUF-AUTH-005 (SMS provider), Kerem-gated K-21/K-OS QR amendment. |
| Target location       | `/docs/CORE_USER_FLOWS.md`                                                            |
| Implementation status | Does not authorize Pod C implementation                                               |

---

## 1. Purpose

This document defines the core Phase 1 user flows for Adeks Platform at the product and workflow level.

This version adds the Phase 1 customer registration/login flow for the Customer PWA, including the required Aydınlatma Metni / privacy notice acknowledgment before OTP is sent.

---

## 2. Source References

This flow is constrained by:

* `/docs/adr/ADR-015-authentication-strategy.md`
* `/docs/architecture/AUTH_THREAT_MODEL.md`
* `/docs/USER_ROLES_AND_PERMISSIONS.md`
* `/docs/PROJECT_METHODOLOGY.md` §20.2 KVKK Compliance Process
* `/docs/PROJECT_DECISION_INDEX.md`
* `/docs/planning/SESSION_LINKING_QR_HANDSHAKE_DESIGN_v0.1.md`

---

## 3. Flow: Customer Registration/Login With Aydınlatma Metni Before OTP

### 3.1 Scope

This flow covers the unified Customer PWA registration/login entry path for Phase 1.

Phase 1 uses a single phone-number OTP flow for both:

* existing customers returning to the PWA;
* first-time customers creating a customer account.

The PWA must not expose whether the entered phone number is already registered before OTP verification.

### 3.2 Actors

| Actor                | Role                                                                                            |
| -------------------- | ----------------------------------------------------------------------------------------------- |
| Customer             | Enters phone number, acknowledges privacy notice, verifies OTP                                  |
| Customer PWA         | Displays phone entry, Aydınlatma Metni acknowledgment, OTP entry, and neutral status/error copy |
| Backend auth service | Sends OTP only after acknowledgment, verifies OTP, creates or resumes customer session          |
| SMS provider         | Sends OTP after the backend accepts a compliant OTP request                                     |

[REQUIRES POD B REVIEW] Backend auth service, OTP storage, rate limits, resend limits, verification attempt limits, and SMS provider interaction are security/architecture details owned by Pod B and Pod C implementation later.

---

## 3.3 Required Product Behavior

| ID           | Requirement                                                                                                             |
| ------------ | ----------------------------------------------------------------------------------------------------------------------- |
| CUF-AUTH-001 | Customer enters phone number in the Customer PWA.                                                                       |
| CUF-AUTH-002 | Before OTP is sent, the PWA displays the Aydınlatma Metni / privacy notice acknowledgment step.                         |
| CUF-AUTH-003 | Customer must actively acknowledge the notice before OTP is sent. Passive display is not enough.                        |
| CUF-AUTH-004 | If the customer does not acknowledge the notice, no OTP is sent.                                                        |
| CUF-AUTH-005 | If the customer does not acknowledge the notice, no customer personal data is committed.                                |
| CUF-AUTH-006 | OTP request response must not reveal whether the phone number is already registered.                                    |
| CUF-AUTH-007 | The same customer-facing OTP request confirmation copy must be used for both existing and new customers.                |
| CUF-AUTH-008 | All examples, test data, screenshots, and documentation must use synthetic data only.                                   |
| CUF-AUTH-009 | Legal/privacy notice text is not defined in this file. The approved legal text belongs in `/docs/PRIVACY_NOTICE_TR.md`. |
| CUF-AUTH-010 | The flow must remain registration/login-neutral until OTP verification succeeds.                                       |

---

## 3.4 Step-by-Step Main Flow

### Flow Name

Customer PWA — Phone OTP registration/login with privacy notice acknowledgment

### Preconditions

| Item                | Requirement                                                                                                                           |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| PWA access          | Customer can open the Customer PWA.                                                                                                   |
| Public browsing     | Public catalog/menu browsing may be available before login where allowed by role/permission rules.                                    |
| Phone number        | Customer has a phone number capable of receiving SMS.                                                                                 |
| Privacy notice text | Approved Aydınlatma Metni text is available for display. `[NEEDS KEREM APPROVAL]`                                                     |
| SMS provider        | SMS provider selection is outside this flow and requires separate approval/review. `[NEEDS KEREM APPROVAL]` `[REQUIRES POD B REVIEW]` |

### Main Flow

| Step | Actor                | Action                                                                                      | System/Product Requirement                                                                                                        |
| ---: | -------------------- | ------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
|    1 | Customer             | Opens Customer PWA and chooses to continue/login.                                           | PWA shows phone-number entry screen.                                                                                              |
|    2 | Customer             | Enters phone number. Example: `+90 555 000 00 01`.                                          | Phone entry uses synthetic examples in docs/tests. Do not display real customer data in documentation or non-production contexts. |
|    3 | Customer PWA         | Validates basic phone-number format locally where possible.                                 | Format feedback must not query registration status.                                                                               |
|    4 | Customer PWA         | Displays Aydınlatma Metni / privacy notice acknowledgment step before any OTP send request. | Notice step must appear before backend OTP send is triggered.                                                                     |
|    5 | Customer             | Reviews notice and actively acknowledges it.                                                | Acknowledgment must be explicit, e.g. checkbox or required confirmation action.                                                   |
|    6 | Customer PWA         | Enables “Send OTP” only after acknowledgment.                                               | If acknowledgment is missing, send action remains unavailable or returns a blocking validation message.                           |
|    7 | Customer             | Taps “Send OTP”.                                                                            | PWA submits OTP request only after acknowledgment is present.                                                                     |
|    8 | Backend auth service | Processes OTP request.                                                                      | Response must be neutral and must not reveal whether the phone number is registered.                                              |
|    9 | Customer PWA         | Shows OTP entry screen.                                                                     | Copy must be neutral: “If this phone number can receive SMS, a verification code will be sent.”                                   |
|   10 | Customer             | Enters OTP.                                                                                 | PWA submits OTP verification.                                                                                                     |
|   11 | Backend auth service | Verifies OTP.                                                                               | On valid OTP, system authenticates customer and creates/resumes customer session according to ADR-015.                            |
|   12 | Customer PWA         | Routes authenticated customer to the appropriate post-login surface.                        | Existing vs new customer handling must not be exposed before OTP verification succeeds.                                           |

### Postconditions — Success

| Area                     | Result                                                                                                                                            |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| Customer session         | Customer is authenticated in the PWA.                                                                                                             |
| Registration/login state | Existing customer is logged in, or new customer account is created/activated after successful OTP verification according to approved auth design. |
| Token/session behavior   | Customer auth uses ADR-015 customer session direction.                                                                                           |
| Privacy notice           | Acknowledgment has occurred before OTP send.                                                                                                      |
| Audit/security           | Authentication events are handled according to ADR-015 and Pod B threat model requirements.                                                       |

[REQUIRES POD B REVIEW] Exact persistence timing and evidence model for privacy-notice acknowledgment must be reviewed by Pod B and Kerem/legal advisor, especially for failed OTP, abandoned OTP, and unverified phone-number attempts. *(Resolved by K-15, 2026-06-10: acknowledgment is ephemeral pre-verification and persisted only on successful OTP verification; pending K-08 legal-advisor confirmation before Pod C propagation.)*

---

## 3.5 Error and Edge Cases

### 3.5.1 No Acknowledgment

| Field                        | Requirement                                                                 |
| ---------------------------- | --------------------------------------------------------------------------- |
| Trigger                      | Customer enters phone number but does not acknowledge the Aydınlatma Metni. |
| System behavior              | No OTP is sent.                                                             |
| Data behavior                | No customer personal data is committed.                                     |
| User-facing copy placeholder | “To continue, please review and acknowledge the privacy notice.”            |
| Recovery                     | Customer may acknowledge and continue, or exit the flow.                    |
| Review                       | `[NEEDS KEREM APPROVAL]` final Turkish UX copy and legal framing.           |

### 3.5.2 Customer Cancels During Notice Step

| Field                        | Requirement                                                                           |
| ---------------------------- | ------------------------------------------------------------------------------------- |
| Trigger                      | Customer closes/back-navigates from the Aydınlatma Metni acknowledgment step.         |
| System behavior              | OTP send is not triggered.                                                            |
| Data behavior                | No customer personal data is committed.                                               |
| User-facing copy placeholder | No persistent error required. Customer returns to previous screen or public PWA area. |
| Recovery                     | Customer may restart login/registration later.                                        |

### 3.5.3 OTP Send Failure

| Field                        | Requirement                                                                                                                                                                                                                                                                                                             |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Trigger                      | Customer has acknowledged notice, but OTP cannot be sent due to provider/network/system failure.                                                                                                                                                                                                                        |
| System behavior              | Show neutral failure state. Do not reveal registration status.                                                                                                                                                                                                                                                          |
| User-facing copy placeholder | “We could not send a verification code right now. Please try again later.”                                                                                                                                                                                                                                              |
| Data behavior                | Do not create a completed customer account solely because OTP send failed. If OTP send fails, the phone number must not be retained in persistent backend storage. The unsuccessful send attempt is recorded in the authentication audit log using a derived identifier (UUID or phone hash), not the raw phone number. |
| Recovery                     | Customer may retry if rate limits and provider state allow.                                                                                                                                                                                                                                                             |
| Review                       | `[REQUIRES POD B REVIEW]` exact retry and failure handling.                                                                                                                                                                                                                                                             |

### 3.5.4 OTP Verify Failure — Incorrect Code

| Field                        | Requirement                                                                   |
| ---------------------------- | ----------------------------------------------------------------------------- |
| Trigger                      | Customer enters an incorrect OTP.                                             |
| System behavior              | Reject verification and allow retry within approved attempt limits.           |
| User-facing copy placeholder | “The verification code did not work. Please check the code and try again.”    |
| Disclosure rule              | Copy must not reveal whether the phone number belongs to an existing account. |
| Recovery                     | Customer may retry until attempt limit is reached.                            |
| Review                       | `[REQUIRES POD B REVIEW]` attempt count, lockout, TTL, and audit behavior.    |

### 3.5.5 Expired OTP

| Field                        | Requirement                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Trigger                      | Customer submits OTP after the approved expiry window.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| System behavior              | Reject expired OTP.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| User-facing copy placeholder | “This verification code has expired. Please request a new code.”                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| Recovery                     | Customer may request a new OTP if acknowledgment state and rate limits allow.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Product rule                 | If the PWA session was refreshed or acknowledgment state cannot be confirmed, show the Aydınlatma Metni acknowledgment step again before requesting a new OTP. Acknowledgment state is session-scoped. It is valid for OTP resend if captured within the current uninterrupted browser session (in-memory or session-scoped state, not persisted storage). If the browser session has been refreshed, navigated away from, or closed, acknowledgment state is considered unconfirmed and the notice must be shown again. Re-acknowledgment is also required if the phone number is changed mid-flow. `[KEREM APPROVED 2026-06-10 — OQ-CUF-AUTH-004 / K-16]` |
| Review                       | `[REQUIRES POD B REVIEW]` exact expiry and resend behavior.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |

### 3.5.6 Too Many OTP Requests

| Field                        | Requirement                                                                                                                                                           |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Trigger                      | Customer or attacker requests too many OTPs for the same phone number, IP, device, or other approved risk dimension.                                                  |
| System behavior              | Block or delay additional OTP requests according to Pod B security design.                                                                                            |
| User-facing copy placeholder | “Too many code requests. Please try again later.”                                                                                                                     |
| Disclosure rule              | Copy must not reveal registration status.                                                                                                                             |
| Review                       | Pod B confirmed enumeration-safety of this copy on 2026-06-10. Thresholds, cooldowns, monitoring, and operational alerting remain Pod B-owned implementation details. |

### 3.5.7 Too Many OTP Verification Attempts

| Field                        | Requirement                                                                                                                                                           |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Trigger                      | Customer submits too many incorrect OTPs.                                                                                                                             |
| System behavior              | Stop accepting attempts for the current OTP and require a new OTP or cooldown according to Pod B security design.                                                     |
| User-facing copy placeholder | “Too many incorrect attempts. Please request a new code later.”                                                                                                       |
| Disclosure rule              | Copy must not reveal whether the phone number is registered.                                                                                                          |
| Review                       | Pod B confirmed enumeration-safety of this copy on 2026-06-10. Attempt limits, lock/expire behavior, audit, and monitoring remain Pod B-owned implementation details. |

### 3.5.8 Phone Number Format Error

| Field                        | Requirement                                                        |
| ---------------------------- | ------------------------------------------------------------------ |
| Trigger                      | Customer enters an invalid phone-number format.                    |
| System behavior              | Show local validation error before notice/OTP send where possible. |
| User-facing copy placeholder | “Please enter a valid phone number.”                               |
| Disclosure rule              | Format validation must not query or reveal account existence.      |
| Example                      | `+90 555 000 00 01` is a synthetic documentation example only.     |

---

## 3.6 Product Notes for UX Copy Placeholders

Final UI copy must be reviewed separately from this flow. This document defines product intent, not approved legal language.

| UI Moment                         | Placeholder Copy                                                           | Approval / Review Status                              |
| --------------------------------- | -------------------------------------------------------------------------- | ----------------------------------------------------- |
| Phone entry heading               | “Enter your phone number”                                                  | Pod A / Kerem                                         |
| Phone entry helper                | “We’ll use this number to verify your Adeks account.”                      | `[NEEDS KEREM APPROVAL]` legal/privacy advisor review |
| Aydınlatma Metni heading          | “Privacy Notice” / “Aydınlatma Metni”                                      | `[NEEDS KEREM APPROVAL]` legal/privacy advisor review |
| Acknowledgment label              | “I have read and acknowledge the Privacy Notice.”                          | `[NEEDS KEREM APPROVAL]` legal/privacy advisor review |
| Send OTP button                   | “Send verification code”                                                   | Pod A / Kerem                                         |
| OTP request neutral success       | “If this phone number can receive SMS, a verification code will be sent.”  | `[REQUIRES POD B REVIEW]` for enumeration safety      |
| OTP error                         | “The verification code did not work. Please check the code and try again.” | `[REQUIRES POD B REVIEW]`                             |
| Expired OTP                       | “This verification code has expired. Please request a new code.”           | `[REQUIRES POD B REVIEW]`                             |
| OTP send rate limit (§3.5.6)      | “Too many code requests. Please try again later.”                          | Pod B confirmed enumeration-safety on 2026-06-10      |
| OTP verify attempt limit (§3.5.7) | “Too many incorrect attempts. Please request a new code later.”            | Pod B confirmed enumeration-safety on 2026-06-10      |

[NEEDS KEREM APPROVAL] This document does not draft the legal text of the Aydınlatma Metni. The legal/privacy notice text is owned by Kerem + external legal/privacy advisor and should be maintained in `/docs/PRIVACY_NOTICE_TR.md`.

---

## 3.7 Product Non-Goals

This flow does not define:

* SMS provider selection.
* OTP code length, expiry duration, entropy, storage, hashing, or resend thresholds.
* API contracts.
* Database schema.
* Audit event schema.
* Token rotation or cookie implementation.
* Legal basis text.
* Aydınlatma Metni legal wording.
* Pod C implementation issue text.
* Selcafe customer-account mapping.

---

## 3.8 Downstream Pod C Implementation Requirements

These are downstream implementation requirements to be converted into approved implementation issues later. This section does not create Pod C issues.

| ID            | Requirement                                                                                                                                                                   | Review Before Implementation  |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| PCUF-AUTH-001 | Customer PWA must place Aydınlatma Metni acknowledgment before OTP send.                                                                                                      | Pod B + Kerem                 |
| PCUF-AUTH-002 | OTP send action must be disabled or blocked until acknowledgment is present.                                                                                                  | Pod B + Kerem                 |
| PCUF-AUTH-003 | If acknowledgment is missing, canceled, or session state is unconfirmed, backend OTP send must not occur.                                                                     | Pod B + Kerem                 |
| PCUF-AUTH-004 | If acknowledgment is missing, canceled, or session state is unconfirmed, no customer personal data may be committed.                                                          | Pod B + Kerem                 |
| PCUF-AUTH-005 | OTP request response must be neutral and must not reveal account existence.                                                                                                   | Pod B                         |
| PCUF-AUTH-006 | OTP send failure, verify failure, expired OTP, and rate-limit messages must not reveal whether a phone number is registered.                                                  | Pod B                         |
| PCUF-AUTH-007 | PWA must use approved placeholder/copy source and must not embed unapproved legal text.                                                                                       | Kerem + legal/privacy advisor |
| PCUF-AUTH-008 | Examples, fixtures, screenshots, test data, and UAT data must be synthetic only.                                                                                              | Pod B + Kerem                 |
| PCUF-AUTH-009 | OTP verify, resend, expiry, and too-many-attempt behavior must follow Pod B threat model requirements.                                                                        | Pod B                         |
| PCUF-AUTH-010 | Any persistence of acknowledgment evidence before verified account creation must be reviewed by Pod B and Kerem/legal advisor. *(K-15: no persistence before verified OTP; pending K-08 confirmation.)* | Pod B + Kerem/legal advisor   |
| PCUF-AUTH-011 | If OTP send fails, the phone number must not be retained in persistent storage. The failed send event must be audit-logged without the raw phone number, per IR-03 and IR-09. | Pod B + Kerem                 |

[REQUIRES POD C IMPLEMENTATION] Later, after Pod B security/KVKK review and Kerem approval, Pod C will need implementation issues derived from this section.

---

## 3.9 Open Questions

| ID              | Kerem Marker | Question                                                                                                                                                  | Owner                                 | Status                                             |
| --------------- | ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------- | -------------------------------------------------- |
| OQ-CUF-AUTH-001 | —            | What exact Turkish Aydınlatma Metni text must be displayed in the PWA?                                                                                    | Kerem + legal/privacy advisor         | `[NEEDS KEREM APPROVAL]`                           |
| OQ-CUF-AUTH-002 | K-14         | Where should the approved Aydınlatma Metni text live: `/docs/PRIVACY_NOTICE_TR.md`, CMS/admin-managed copy, or both?                                      | Kerem + Pod B                         | `[KEREM APPROVED 2026-06-10 — K-14]` Canonical text in `/docs/PRIVACY_NOTICE_TR.md`, build-time embedded; no CMS in Phase 1. |
| OQ-CUF-AUTH-003 | K-15         | Should acknowledgment evidence be persisted before OTP verification, after OTP verification, or only after successful OTP/account creation?               | Kerem + legal/privacy advisor + Pod B | `[KEREM APPROVED 2026-06-10 — K-15]` Ephemeral pre-verification; persisted only on successful OTP verification; no record on failed/expired/abandoned flows. Pending K-08 confirmation before Pod C propagation. |
| OQ-CUF-AUTH-004 | K-16         | If OTP expires after acknowledgment, can the same session-scoped acknowledgment state be reused for resend, or must the notice be shown again every time? | Kerem + legal/privacy advisor + Pod B | `[KEREM APPROVED 2026-06-10 — K-16]` Same-session reuse valid for resend; re-acknowledge on session break or phone-number change. Pending K-08 confirmation before Pod C propagation. |
| OQ-CUF-AUTH-005 | —            | What is the approved SMS provider and related KVKK data-processor/cross-border-transfer assessment?                                                       | Kerem + Pod B                         | `[NEEDS KEREM APPROVAL]` `[REQUIRES POD B REVIEW]` |

---

## 3.10 Revision History

| Version | Date       | Author | Change                                                                                                                                                                                                                                                                                                                           |
| ------- | ---------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| v0.1    | 2026-06-10 | Pod A  | Initial customer registration/login flow requiring Aydınlatma Metni acknowledgment before OTP send.                                                                                                                                                                                                                              |
| v0.2    | 2026-06-10 | Pod A  | Applied Pod B non-blocking review updates: OTP send failure phone-number disposal and derived-identifier audit clause; session-scoped acknowledgment clarification for expired OTP/resend; split rate-limit UX copy into OTP-send and OTP-verify rows. Pod B review complete 2026-06-10; pending Kerem decisions KEREM-01/02/03. |
| v0.3    | 2026-06-10 | Pod B  | Approval-annotation pass. Recorded Kerem decisions K-14/15/16 resolving OQ-CUF-AUTH-002/003/004; added the phone-number-change re-acknowledgment condition to the §3.5.5 product rule (K-16); realigned the §3.9 "Kerem Marker" column to cite K-numbers (resolving the prior KEREM-01/02/03 label collision); annotated §3.4 postconditions and PCUF-AUTH-010 with K-15. OQ-CUF-AUTH-001 (notice legal text) and OQ-CUF-AUTH-005 (SMS provider) remain open. |

---

## 4. Flow: Selcafe-Linked Customer Visibility and Ordering

### 4.1 Scope

This flow defines the approved Product Phase 1 operating spine:

> Selcafe-linked customer visibility and ordering.

It starts from the real café visit and binds the customer's phone/PWA session to the cashier-started Selcafe PC session through a **desk-side, one-time QR handshake**.

The QR handshake replaces typed/scanned `fiş / fiş numarası` entry as the customer-facing app linking path. The printed receipt and Selcafe addition/bill identifiers may still exist in cashier/Selcafe operations, but they are not exposed as the app's customer-entered visit-link key.

This flow does not authorize direct Selcafe writes, schema/API work, ADR drafting, Pod C implementation, wallet/payment implementation, or real data use.

Post-review constraint: K-21 locks the product direction only. It does not authorize implementation and does not override ADR-005 by wording alone. The K-21/K-OS wording requires a Kerem-gated amendment to reflect the QR handshake.

This document does not authorize Pod C implementation.

Phase 1 remains read-only toward Selcafe; Selcafe remains the settlement source of truth for this operating spine.

### 4.2 Actors

| Actor | Role in flow |
|---|---|
| Customer | Starts visit through cashier/Selcafe, links their phone/PWA to the active PC session through the desk-side QR handshake, views the live bill, places F&B order, and later sees settled result where supported. |
| Guest customer | May link through the QR handshake, view the full live bill including itemized lines, and order F&B without an Adeks account. Signup/login is offered alongside ordering and is required only for discounts, coupons, and points. Persistent account-linked history requires account context. |
| Cashier | Starts the PC session in Selcafe, starts the matching Adeks session-link for the same PC, presents or scans the one-time QR depending on scan direction, receives PWA orders, manually enters accepted orders into Selcafe, obtains the Adeks-issued fixed-format discount reflection record where applicable, handles final payment, and resolves wrong-PC/session/coupon/order issues. |
| Kitchen/service staff | Continue from Selcafe printed receipts only in the first operating slice. |
| Selcafe | Creates and owns the PC session/addition and remains read-only to Adeks and the settlement source of truth. |
| Adeks PWA | Scans or shows the one-time QR, displays the linked live bill where allowed, offers guest ordering, offers signup/login alongside ordering, and shows estimates/order/settlement status where reliable. |
| Adeks cashier/admin UI | Lets the cashier manually select the PC/session, start the Adeks session-link, display the desk-side QR, scan the customer app QR, manage the order queue, support coupon status, and support admin checks where later approved. |
| Customer-facing desk screen / scanner | Supports the QR handshake at the desk. Direction A displays the Adeks QR for the customer to scan; Direction B lets the cashier scan the customer's app QR. |
| Adeks backend | Mints and validates the one-time QR token, binds the app session to the Adeks-native session-link, burns the token on first successful scan, and performs only gated read-only Selcafe reads where later approved. |

### 4.3 Preconditions

| Item | Requirement |
|---|---|
| Selcafe visit | Cashier has started the customer visit/session in Selcafe for a specific PC/station. |
| Adeks session-link | Cashier starts the matching Adeks session-link for the same PC in the Adeks cashier UI. Manual PC selection is the Phase 1 path. Auto-detecting the PC is a fast-follow behind ADR-005 read-surface expansion and legal/KVKK clearance. |
| QR handshake | Linking is exclusively through a desk-side, one-time QR handshake. No typed/scanned `fiş` entry field exists in the Customer PWA. |
| Two scan directions | Direction A: desk/customer-facing screen shows QR and customer scans it. Direction B: customer app shows QR and cashier scans it. |
| Token properties | The QR token is cryptographically random, single-use, bound to exactly one `(PC, Adeks session-link)`, seconds-scale, and burned on first successful scan. Re-display mints a fresh token and invalidates the prior token. |
| Selcafe read | Adeks may show live-bill data only after the read surface is approved. The read remains blocked on ADR-005 read-surface expansion, KVKK/legal review, auditability, retention, and data-minimization review before implementation. |
| Active bill/order-line read gate | Selcafe-sourced active visit/bill/order-line visibility is desired under KD-1 and SL-6, including itemized lines, but remains gated. QR opt-in improves the legal posture; it does not clear the gate. |
| Discount reflection / settlement green-light gate | K-OS-008 product direction includes an Adeks-issued fixed-format discount reflection record: dedicated Adeks `islem_tip` selected by the cashier from the Selcafe Kasiyer dropdown, pseudorandom one-time code in `kasaislem.aciklama`, and positive discount amount in `kasaislem.alacak`. The Selcafe row carries no `adisyon_no` and no Adeks customer/coupon/member id. Adeks holds the `code → linked Selcafe bill/addition → expected discount` mapping internally and joins Selcafe reads inside Adeks. Adeks support for this reflection/read path remains blocked on ADR-005 read-surface reconciliation, KVKK/legal review, auditability, retention, and data-minimization review before implementation. |
| Member identity/profile exclusion | The handshake binds app session to PC/session-link, never app session to Selcafe member. Selcafe member identity/profile data, including `adisyon.uye_no`, must not be read, derived, resolved, or displayed as part of this operating spine. |
| Customer account | Not required for QR linking, live-bill visibility, or F&B ordering. Required only for discounts, coupons, and points. Signup/login is offered alongside ordering, not as an ordering gate. |
| Real data | No real customer/staff/transaction/Selcafe data may be used in non-production docs, examples, tests, or AI sessions. |

### 4.4 Main Flow

#### 4.4.1 Direction A — Desk/customer-facing screen shows QR

| Step | Actor | Action | Product requirement |
|---:|---|---|---|
| 1 | Customer | Arrives at Adeks and starts visit through cashier/Selcafe. | Flow starts from real café operation, not from app-only session ownership. |
| 2 | Cashier | Starts seat/session in Selcafe for the selected PC/station. | Selcafe remains operational source for Phase 1. |
| 3 | Cashier | Starts the matching Adeks session-link for the same PC in the Adeks cashier UI. | PC/session association is manual first. The UI should support selecting only eligible/unlinked sessions where later approved. |
| 4 | Adeks backend / desk screen | Mints a one-time QR token bound to that `(PC, Adeks session-link)` and shows it on the customer-facing desk screen. | Token is random, single-use, seconds-scale, and burned on first successful scan. No bill number is typed or exposed as a customer-entered link. |
| 5 | Customer | Scans the desk QR with their phone or PWA. | First-timer lands as guest; signup/login is offered alongside ordering. |
| 6 | Adeks backend | Validates the token and binds the PWA/app session to the Adeks-native session-link. | Fail closed on expired, reused, mismatched, or invalid token. Burn token after first successful scan. |
| 7 | PWA | Displays the linked PC/session and live bill where allowed. | Guests can see the full live bill including itemized lines after successful QR link, subject to ADR-005/legal/KVKK read gate. Hide financial values if unreliable or not cleared. |
| 8 | Customer | Places F&B order from seat. | Guest ordering is permitted after successful QR link. Account is required only for discounts, coupons, and points. |
| 9 | Cashier | Receives PWA order in queue. | Cashier is primary first-slice operational receiver. |
| 10 | Cashier | Checks order and manually enters accepted order into Selcafe. | This is the mandatory Phase 1 manual bridge for PWA orders. |
| 11 | PWA | Shows simplified customer status. | “Accepted + Preparing” is a customer-facing simplified projection meaning cashier has entered the accepted order into Selcafe. It is not a redefinition of the accepted F&B lifecycle state model. No delivered tracking in first-slice UX. |
| 12 | Selcafe | Prints normal receipt for kitchen/service. | Kitchen/service continue from Selcafe printed receipts. |
| 13 | Customer | Proceeds to cashier for final payment. | No online payment or wallet payment/spending is authorized by this operating spine. |
| 14 | Adeks cashier/admin UI | Provides the cashier with the Adeks-issued fixed-format discount reflection record where an Adeks discount applies. | The record instructs the cashier to select the dedicated Adeks `islem_tip`, enter the pseudorandom one-time Adeks discount code in `kasaislem.aciklama`, and enter the discount amount as a positive credit in `kasaislem.alacak`. The code must be non-identifying and must not expose an Adeks customer, coupon, member, or Selcafe bill/addition value in Selcafe. |
| 15 | Cashier | Reflects the Adeks discount into Selcafe `kasaislem`. | The cashier is the human bridge. Adeks does not write directly to Selcafe. `adisyon.uye_indirim` is unused. The `kasaislem` row is selected later by dedicated Adeks `islem_tip` + pseudorandom one-time code, not by `adisyon.kasaislem_no`. |
| 16 | Adeks | Reads the linked Selcafe bill/addition total and reads the matching Adeks discount row from `kasaislem` by dedicated Adeks `islem_tip` + pseudorandom one-time code where feasible. | The reads are joined inside Adeks using the internally held `code → linked Selcafe bill/addition → expected discount` mapping. This read path is desired product direction only and remains blocked on ADR-005 read-surface reconciliation, KVKK/legal review, auditability, retention, and data-minimization review before implementation. |
| 17 | Adeks cashier/admin UI | Compares the Selcafe settled total net of the matched Adeks discount against Adeks's own discount-inclusive calculation. | The cashier receives a green light only when the result is within the 2% threshold under K-OS-007/K-OS-008. No clean `islem_tip` + code match, multiple matches, malformed code, missing `alacak`, or amount mismatch fails closed: no green light and manual check required. |
| 18 | Customer | Pays the final Selcafe-settled amount at cashier. | Selcafe remains the settlement source of truth. |
| 19 | PWA | Shows settled amount, coupon/discount status, and loyalty/points status where supported. | Discounts, coupons, and points require account context. Guest live bill and F&B ordering do not. |

#### 4.4.2 Direction B — Customer app shows QR, cashier scans

| Step | Actor | Action | Product requirement |
|---:|---|---|---|
| 1 | Customer | Opens the Customer PWA at the desk. | The app may be opened from saved PWA, URL, staff prompt, or first-timer landing. |
| 2 | PWA | Shows a customer app one-time QR. | This QR is used only for desk-side linking. It does not reveal account existence or Selcafe member identity. |
| 3 | Cashier | Starts the PC session in Selcafe and selects the same PC/session in the Adeks cashier UI. | Manual PC/session association remains the Phase 1 path. |
| 4 | Cashier | Scans the customer's app QR at the desk for that specific PC/session. | Physical co-presence at the desk remains the linking control. |
| 5 | Adeks backend | Validates the token and binds the PWA/app session to the Adeks-native session-link for that PC/session. | Fail closed on expired, reused, mismatched, or invalid token. Burn token after first successful scan. |
| 6 | PWA / Cashier / Customer | Continue from Direction A step 7 onward. | Live bill, ordering, settlement, discount reflection, and review gates are the same as Direction A. |

### 4.5 Error and Edge Cases

| Case | Customer-facing behavior | Staff behavior | Routing |
|---|---|---|---|
| QR expires before scan | Customer is told to ask cashier to show/scan a fresh QR. | Cashier re-displays/re-mints a fresh QR; prior token is invalidated. | [REQUIRES POD B REVIEW] exact token TTL, rate limits, and retry behavior. |
| QR already used / replayed | Linking fails closed; do not reveal whether the token was previously valid. | Cashier starts a fresh QR handshake if customer is physically present. | [REQUIRES POD B REVIEW] abuse handling and audit. |
| Wrong PC/session linked | Customer sees the linked PC/session and asks cashier for correction if it is wrong; ordering should not continue on a disputed link. | Cashier resolves the operational assignment and correction. Complete rollback and assignment to the correct session is mandatory as operating principle. | [REQUIRES POD B REVIEW] correction handling. |
| Customer wants to link later | No in-seat late-joiner fallback. Customer revisits cashier for a fresh QR handshake. | Cashier performs a new desk-side QR handshake. The earlier “link within ~10 minutes” concept is dropped. | [REQUIRES POD B REVIEW] late-link audit and abuse boundary. |
| Customer declines to link | Customer continues the Selcafe visit normally without Adeks session features. | No Adeks order/live-bill surface is created. | No Pod C authorization. |
| Selcafe read not legally/technically cleared | Hide live-bill financial values and itemized lines; show only non-sensitive placeholder/status where approved, or block the live-bill surface. | Staff/cashier remains fallback. | ADR-005 read-surface expansion + KVKK/legal review remain required. |
| Selcafe read stale/unreliable | Hide financial estimates if unreliable; show last-updated timestamp where possible. | Staff/cashier remains fallback. | [REQUIRES POD B REVIEW]. |
| PWA order not in Selcafe | Customer status should not imply accepted/preparing. | Cashier checks whether order was delivered and enters/removes as appropriate. | [REQUIRES POD B REVIEW]. |
| Coupon rejected/corrected | Customer sees simple applied/rejected/corrected status only if account/discount flow is used. | Cashier records reason/status where later defined. | [NEEDS KEREM APPROVAL] reason taxonomy; [REQUIRES POD B REVIEW]. |
| Estimate mismatch above 2% | Show warning that estimate may differ and final amount is confirmed at cashier. | Staff checks Selcafe and PWA comparison. At settlement, the same 2% threshold is also the K-OS-008 green-light tolerance. No clean match fails closed to manual check. | [REQUIRES POD B REVIEW]. Pre-settlement warning-basis detail remains tracked by OQ-OS-004. |

### 4.6 Review Routing

- Requires Kerem approval: K-21 approved 2026-06-28; QR-handshake amendment to K-21/K-OS remains Kerem-gated via PR body draft; final UX copy and unresolved reason taxonomies still require Kerem approval.
- Requires Pod B review: Yes — QR/session-link consistency, token/linking safety, Selcafe read feasibility, never-resolve-member rule, matching, audit, KVKK, estimate/final settlement boundary, coupon/loyalty correctness.
- Requires Pod C implementation: No.
- Requires Pod D review: Later if Kerem requests desk-screen/scanner/PWA prototype or UX review.

### 4.7 KD-1 / KD-2 / QR-Handshaking Constraints

| Decision | Flow implication |
|---|---|
| KD-1 constrained Option B | Product direction includes Selcafe-sourced active visit/bill/order-line visibility for the QR-linked active visit/session, including cashier/staff-entered F&B items not submitted through Adeks PWA. Selcafe member identity/profile data must not be read, derived, resolved, or displayed. This does not authorize implementation and does not override ADR-005 by wording alone. |
| KD-2 | K-OS-002 supersedes/subsumes K-20 PI-1 only for customer-visible PC/session estimates inside this approved operating spine. Broader real-time station/session status and reservation automation remain deferred unless separately approved. |
| SL-1…SL-7 | The app link is the desk-side QR handshake, not typed/scanned `fiş`. Guests can link, see the full live bill including itemized lines, and order F&B. Account/signup is offered alongside and is required only for discounts, coupons, and points. Late joiners revisit the cashier; there is no in-seat fallback. |

[REQUIRES POD B REVIEW] Active bill/order-line visibility requires ADR-005 read-surface reconciliation, KVKK/legal review, auditability, retention, and data-minimization review before any implementation issue can exist.

[REQUIRES POD D REVIEW LATER] Desk-side QR display/scanner UX, the 2% mismatch warning, pilot pause visibility, and first-week admin check outputs may require Pod D UX/monitoring/operational review after Pod B defines the risk/audit boundaries.

## Review Routing

* Ready for commit: Yes — Kerem decisions recorded 2026-06-10 (K-14/15/16).
* Requires Kerem approval: OQ-CUF-AUTH-002/003/004 resolved 2026-06-10 (K-14/15/16). Still required — OQ-CUF-AUTH-001 final Aydınlatma Metni legal text, OQ-CUF-AUTH-005 SMS provider, and final Turkish UX/legal copy.
* Requires Pod B review: Pod B review complete 2026-06-10 for v0.2 auth requested changes. Re-review required for §4 QR-handshake reconciliation to confirm flow/decision consistency, read-gating, and the never-resolve-member rule.
* Requires Pod C implementation: Later only. This document lists downstream requirements but does not create implementation issues. K-15/K-16 require K-08 legal-advisor confirmation before any Pod C issue is derived from them.
* Requires Pod D prototype/audit/monitoring review: Optional later for PWA onboarding UX review and before Phase 1 go-live consistency audit.
