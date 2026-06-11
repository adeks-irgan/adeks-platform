# KEREM_DECISIONS.md

<!--
  STATUS: COMPLETE — K-01 through K-16 recorded
  SOURCE: Kerem interview session, Pod B facilitation; K-11 from Kerem chat approval 2026-06-07;
          K-13 from Kerem session decisions 2026-06-09 (OQ-001 auth resolution);
          K-14/15/16 from Kerem session decisions 2026-06-10 (CORE_USER_FLOWS OQ-CUF-AUTH-002/003/004)
  AUTHOR: Pod B (Architecture, Logic & Risk)
  VERSION: 1.4
  PATH: /docs/KEREM_DECISIONS.md

  PURPOSE:
  This document records Kerem's decisions on all [NEEDS KEREM APPROVAL] items
  from PROJECT_METHODOLOGY.md. It serves as the canonical reference for
  updating companion documents (VISION.md, PHASE_GATES.md, PRODUCT_METRICS.md,
  ROLLBACK_POLICY.md, MVP_HYPOTHESIS.md, etc.).

  NEXT STEP:
  Pod A to use this document to fill companion documents.
  Pod B to carry architectural implications into ADRs and architecture views.
  Pod C to action K-10 spike when network credentials are provided by Kerem.
-->

---

## Decision Summary Table

| ID | Topic | Decision | Status |
|---|---|---|---|
| K-01 | Vision + North Star Metric | See 1.1 and 1.2 | ✅ Recorded |
| K-02 | Work cadence | Milestone-based | ✅ Recorded |
| K-03 | Rollback threshold | Kerem's discretion + Pod B mandatory triggers | ✅ Recorded |
| K-04 | Feature flag tool | Deferred to Pod B ADR-012 | ✅ Recorded |
| K-05 | All product metric targets | See Section 5 | ✅ Recorded |
| K-06 | Feedback capture mechanism | WhatsApp group → Kerem converts to GitHub issues | ✅ Recorded |
| K-07 | VERBİS registration | Kerem consults current legal advisor and acts accordingly | ✅ Recorded |
| K-08 | KVKK legal advisor | Current legal advisor handles all KVKK obligations | ✅ Recorded |
| K-09 | Pilot participant selection | See Section 9 | ✅ Recorded |
| K-10 | Selcafe feasibility spike | Authorised — Pod C executes remotely | ✅ Recorded |
| K-11 | BC-2: approval gate alignment (ADR-009 §3 vs §11.1/§15) | Option A approved — alignment path | ✅ Recorded |
| K-12 | Tenancy model + ORM | Shared schema + mandatory non-null `tenant_id` (long-term); Prisma ORM; UUID primary keys; binding global tenant scoping enforcement | ✅ Recorded |
| K-13 | Phase 1 authentication decisions (KD-A through KD-H) | See Section 13 | ✅ Recorded |
| K-14 | Aydınlatma Metni notice text location (Phase 1) | Canonical in `/docs/PRIVACY_NOTICE_TR.md`, build-time embedded; no CMS Phase 1 | ✅ Recorded |
| K-15 | Acknowledgment persistence model (Phase 1) | Ephemeral pre-verification; persisted only on successful OTP verification | ✅ Recorded |
| K-16 | Same-session acknowledgment reuse (Phase 1) | Valid within uninterrupted session; re-ack on session break or phone-number change | ✅ Recorded |

---

## 1. K-01 — Vision and North Star Metric

### 1.1 Vision Direction

**Decision:**
> Adeks Platform is a digital companion for gaming café customers, café operating
> and POS software, and the foundation for a future SaaS platform for café operators.

**Architectural implication recorded by Pod B:**
This confirms that Adeks Platform is not only a customer-facing companion app.
It is intended to eventually operate as the full café management and POS system,
replacing Selcafe entirely. This must be reflected in Phase 2–3 architecture.
The modular monolith structure and vendor-neutral domain model are validated by
this direction. The SelcafeAdapter remains a temporary legacy bridge, not a
permanent integration.

**Action:** Pod A to produce `/docs/VISION.md` using this direction as the
foundation. Pod B to carry the POS/operating system ambition into Phase 2
architecture planning.

### 1.2 North Star Metric

**Decision:** Weekly active PWA users among eligible customers.

**Definition:**
A weekly active PWA user is a customer who logs into the Adeks Platform PWA
and performs at least one action (views wallet, places F&B order, checks loyalty
balance, submits reservation request) within a given calendar week.

**Eligible customers:** All customers who visit Adeks and have been onboarded
to the platform (registered with phone number and completed first login).

**Target (from K-05b):** 40–60% of weekly visitors within 3 months of launch.
Estimated absolute range: 40–180 weekly active users based on 100–300 weekly visitors.

---

## 2. K-02 — Work Cadence

**Decision:** Milestone-based. Reviews and phase gates happen when a defined
feature set is complete, not on a fixed time schedule.

**Implication:** Milestones must be explicitly defined in `/docs/ROADMAP.md`
and `/docs/PHASE_GATES.md` before build begins. Without pre-defined milestones,
"complete" becomes subjective and reviews are deferred indefinitely.

**Pod B requirement:** Every milestone must have:
- A named feature set that defines completion
- A list of Definition of Done criteria that must be satisfied
- A list of required Kerem approvals before the milestone is closed
- A Pod B architecture/security clearance check

**Action:** Pod A to define Phase 1 milestones in `/docs/ROADMAP.md`.
Pod B to validate milestone boundaries for architectural completeness.

---

## 3. K-03 — Rollback Threshold

**Decision:** At Kerem's discretion. No fixed time threshold.
Kerem decides case by case based on the nature and severity of the incident.

**Pod B mandatory override (non-discretionary):**
Regardless of Kerem's discretion, the following conditions trigger
an immediate mandatory rollback with no deliberation:

| Condition | Why mandatory |
|---|---|
| Wallet or loyalty balance/events appear incorrect | Financial integrity — customer value is at risk |
| Customer personal data exposed to unauthorised parties | KVKK legal obligation — 72-hour breach notification clock starts |

All other incident types remain at Kerem's discretion.

**Action:** Pod B to write these two mandatory conditions into
`/docs/ROLLBACK_POLICY.md` as non-negotiable triggers.

---

## 4. K-04 — Feature Flag Tool

**Decision:** Deferred to Pod B. Pod B to produce ADR-012 with a tool
recommendation before Phase 1 go-live.

**Pod B intent:** Recommend a simple database-driven flag system for Phase 1
(zero external dependency, zero cost), with a migration path to a managed
service (Unleash or equivalent) before Phase 3 multi-tenant rollout.
Full reasoning to be documented in ADR-012.

**Action:** Pod B to produce ADR-012 before Phase 1 release milestone.

---

## 5. K-05 — Product Metric Targets

All six Phase 1 product metrics with approved targets:

| Metric | Definition | Target | Review Point |
|---|---|---|---|
| **PWA adoption** (North Star) | % of weekly visitors who are weekly active PWA users | 40–60% of weekly visitors | 3 months post-launch |
| **F&B orders** | Successful seat-originated F&B orders placed via PWA | 5–10 orders per day | 1 month post-launch |
| **Loyalty visibility** | % of weekly active PWA users who check loyalty balance weekly | ≥30% of PWA users | 1 month post-launch |
| **Reservations** | Digital reservation requests submitted per week | ≥5 requests per week | 1 month post-launch |
| **Wallet** | Cashier-initiated top-ups per week + success rate | ≥20 top-ups/week AND ≥99% success rate | 1 month post-launch |
| **System reliability** | Platform uptime SLO | 99.9% overall (≤44 min downtime/month) | Daily monitoring |

**Pod B note on 99.9% SLO:**
This is a serious infrastructure commitment. It requires:
- Hosting with redundancy and health checks
- Automated alerting with fast incident escalation path
- Pod D monitoring specification covering uptime, error rate, and latency
- Documented incident response path that can achieve resolution in under 44 minutes
  cumulative per month

Pod B will carry this into the deployment view and observability architecture.

**Action:** Pod A to populate `/docs/PRODUCT_METRICS.md` using this table.
Pod B to flag SLO implications in deployment view. Pod D to design monitoring
spec to support 99.9% SLO measurement.

---

## 6. K-06 — Feedback Capture Mechanism

**Decision:** WhatsApp group for staff reporting.
Kerem converts significant reports into GitHub issues.

**Triage rule (Pod B recommendation, Kerem to confirm):**
- Wallet, loyalty, or data correctness issues → GitHub issue within 24 hours
- F&B or reservation operational issues → GitHub issue within 48 hours
- UX friction or minor display issues → batch at next milestone review

**KVKK note:**
No real customer personal data (names, phone numbers, transaction details)
should be shared in the WhatsApp group. Staff should describe issues using
PC number, time, and synthetic/anonymous reference only (e.g. "PC-12, top-up
issue around 18:30, no personal details").

**Action:** Pod A to document the WhatsApp → GitHub triage process in
`/docs/BUG_TRIAGE_PROCESS.md`.

---

## 7. K-07 — VERBİS Registration

**Decision:** Kerem will consult their current legal advisor on VERBİS
registration requirements and act on their guidance.

**Key question to bring to the legal advisor:**
> "Do we need to register in VERBİS before we collect customer phone numbers
> and personal data through a mobile web app? If so, what data processing
> activities, categories of data subjects, and retention periods do we need
> to declare?"

**Go-live blocker:** VERBİS registration must be confirmed before the platform
goes live with real customer data. This is a hard dependency for Phase 1 launch.

**Action:** Kerem to consult legal advisor and report outcome.
Pod B to track as open dependency in delivery risk register until confirmed.

---

## 8. K-08 — KVKK Legal Advisor

**Decision:** Kerem's current legal advisor will handle all KVKK obligations.

**Scope they must cover:**
| Obligation | Required Output |
|---|---|
| VERBİS registration | Confirmed registration or confirmed exemption |
| Data processing inventory | `/docs/DATA_PROCESSING_INVENTORY.md` reviewed and signed off |
| Legal basis per data type | `/docs/KVKK_LEGAL_BASIS.md` reviewed and signed off |
| Aydınlatma Metni (Privacy Notice) | Turkish-language text reviewed and approved for PWA |
| Data subject rights process | Process reviewed for legal sufficiency |
| Data retention policy | Retention periods reviewed and approved |
| Cross-border transfer assessment | Required if hosting is outside Turkey |

**Action:** Pod A to produce draft documents for legal advisor review.
Kerem to coordinate review timing aligned with Phase 1 build progress.

---

## 9. K-09 — Pilot Participant Selection

### 9.1 Selection Method

**Decision:** Cashier staff identify regular customers during normal café
operation and verbally invite them to participate.

**Recommended guidance for cashiers:**
- Target customers who visit at least weekly
- Target customers who are digitally comfortable (already use smartphones actively)
- Aim for 20–30 pilot customers in Week 2
- Do not invite customers who are in the middle of a session or visibly busy

### 9.2 Pilot Framing

**Decision:** Frame as early access / VIP access to a new feature.
Not explicitly framed as a test.

**Example cashier script:**
> "We're launching a new app for our regulars — you can order food from your
> seat, check your balance, and book your spot in advance. Would you like
> early access?"

**KVKK requirement (non-negotiable regardless of framing):**
Every pilot customer must receive and acknowledge the Aydınlatma Metni
(Privacy Notice) during app registration before any personal data is collected.
The VIP framing applies to the invitation. The privacy notice applies to
the registration flow. Both must coexist.

**Action:** Pod A to include pilot onboarding flow in `/docs/CORE_USER_FLOWS.md`.
Pod C to ensure the Aydınlatma Metni is displayed and acknowledged before
first data collection in the PWA registration flow.

---

## 10. K-10 — Selcafe Feasibility Spike

**Decision:** Authorised. Read-only schema inspection of the live Selcafe
SQL Server. Pod C executes remotely using network credentials provided
by Kerem through a secure channel.

**Constraints (non-negotiable):**
- Read-only queries only — no INSERT, UPDATE, DELETE, DROP, or ALTER
- No changes to Selcafe configuration
- No interruption to live café operation
- Time-boxed to one working day
- All findings documented in `/docs/SELCAFE_SPIKE_REPORT.md`
- No real customer data copied into any document or AI session
  (schema structure and column names only — no row data)

**What Pod C needs from Kerem (via secure channel — not chat):**
- SQL Server hostname or IP address
- Port number (default 1433)
- Read-only SQL account username and password
- Network access method (VPN, port forwarding, or on-site access)

**What the spike must answer:**
| Question | Required Output |
|---|---|
| Is the SQL Server network-accessible? | Yes / No / Requires VPN |
| What authentication method is needed? | Windows auth / SQL auth / other |
| What tables and columns exist? | Schema inventory (names only, no row data) |
| What data quality is present? | Nulls, completeness, encoding |
| What customer data exists? | Field names and types only |
| What session/PC data exists? | Field names and types only |
| What value/balance data exists? | Field names and types only |
| Is Phase 1 read-only sync feasible? | Feasible / Partial / Not feasible |

**Action:** Pod B to produce the spike query script.
Kerem to provide credentials to Pod C via secure channel.
Pod C to execute and produce `/docs/SELCAFE_SPIKE_REPORT.md`.
Pod B to review findings and update SelcafeAdapter design accordingly.

---

## 11. K-11 — BC-2: Approval Gate Alignment (ADR-009 §3 vs §11.1 / §15)

**Date:** 2026-06-07
**Source:** Kerem chat approval to Pod B
**Scope:** Correcting §11.1 and §15 conflicts with ADR-009 §3 approval gates
**PR:** bc-2/approval-gate-alignment → main (Issue #26)

### Decision

Kerem approved **Option A** (approval-gate alignment path):

- §11.1 Selcafe adapter row corrected to `Pod B + Kerem` (was `Pod B` only).
- §11.1 Database/schema migration row corrected to `Pod B + Kerem` (was `Pod B` only).
- §11.1 Security-sensitive PR row added with `Pod B + Kerem`.
- §11.1 annotated with pointer to ADR-009 §3 as authoritative source on conflict.
- Stale embedded PR template in §15 removed; replaced with pointer to live
  `.github/PULL_REQUEST_TEMPLATE.md` and ADR-009.
- Treated as behavior-changing under ADR-009 §4; Pod Impact Matrix and
  Instruction Update Packet included in PR.
- Tenancy cleanup and ADR stub renumbering explicitly excluded from this work.

### Constraints Recorded

- Do not merge without Kerem approval.
- Do not include tenancy cleanup or ADR stub renumbering.

### Option Considered but Rejected

**Option B (document-note only):** Add a conflict note to §11.1 and §15 without
correcting the gate text. Rejected by Kerem in favour of correcting the text to
eliminate the ambiguity entirely.


---

## 12. K-12 — Tenancy Model and ORM Decision

**Date:** 2026-06-08
**Source:** Kerem explicit decision (task input to Pod B session)
**Scope:** Tenancy strategy (ADR-008), ORM selection (ADR-004), UUID primary keys, global tenant scoping enforcement requirement
**PR:** `docs/accept-tenancy-orm-decisions` → `main`

### Decision

| Decision area | Value locked |
|---|---|
| Tenancy model | Shared schema with mandatory non-null `tenant_id` on all tenant-scoped tables |
| Tenancy lock scope | Locked for Phase 1 AND as the long-term model. No schema-per-tenant or database-per-tenant planned. |
| ORM | Prisma |
| Primary keys | UUID on all entity tables (resolves UUID-vs-bigint open question) |
| Global tenant enforcement | Prisma Client Extension injecting `tenant_id` on all tenant-scoped queries — binding design requirement |

### Binding design requirement recorded

Phase 1 database design MUST enforce tenant scoping globally via a Prisma Client Extension. This requirement:
- Must be satisfied before any tenant-scoped schema or migration is created
- Requires Pod B + Kerem approval under ADR-009 §3 (database/schema migration + security-sensitive)
- Cannot be bypassed without a new Pod B architecture review and Kerem approval

### What this does NOT unlock

This decision records the architecture choices. It does NOT authorize Pod C to begin implementation. The following remain blocked until separate Pod B + Kerem approved implementation issues exist:

- Prisma installation and configuration
- Schema authoring (any table)
- Database migrations
- `TenantContext` module implementation
- Prisma Client Extension implementation
- Wallet/loyalty/entity table creation
- `SelcafeAdapter` work (also blocked separately pending ADR-005)

### ADRs locked by this decision

| ADR | Status before | Status after |
|---|---|---|
| ADR-004 (ORM selection) | Proposed — not locked | Accepted — 2026-06-08 |
| ADR-008 (tenancy strategy) | Proposed — deferred (Kerem 2026-06-04) | Accepted — 2026-06-08 |

---

## 13. K-13 — Phase 1 Authentication Decisions

**Date:** 2026-06-09
**Source:** Kerem session decisions (KD-A through KD-H), confirmed in Pod B OQ-001 recommendation session
**Scope:** Phase 1 authentication decisions for all actors
**PR:** PR #37 (`docs/auth-recommendation-and-roles` → `main`)

### Decision

| ID | Decision area | Value locked |
|---|---|---|
| KD-A | Customer login method | Phone OTP (SMS). Google login deferred to Phase 2. |
| KD-B | SMS provider | Pod B to produce provider report; Kerem decides with Pod A (business/price aspects). Backlog item. |
| KD-C | Admin MFA | Required. TOTP (authenticator app). |
| KD-D | Cashier inactivity timeout | 40 minutes. |
| KD-E | F&B Staff scope | Order management only. No payment, wallet, or loyalty — including F&B payment. F&B payment handled by CASHIER at main cashier point. |
| KD-F | Top-up threshold | No threshold in Phase 1. Daily top-up report visible to ADMIN as compensating control. |
| KD-G | Phone display in cashier top-up flow | Masked — last 4 digits only (e.g. +90 555 *** ** 01). |
| KD-H | Role structure | One elevated role: ADMIN. MANAGER/ADMIN split deferred to Phase 2. |

### Architectural implications recorded by Pod B

- **KD-A:** Customer auth module must implement SMS OTP flow. No OAuth/social login surface in Phase 1. Google login deferred to Phase 2 — no placeholder code required, but module boundary must not preclude it.
- **KD-B:** SMS provider ADR (or provider selection sub-decision) is a Phase 1 blocker for customer login. Pod B to produce provider comparison report before ADR-015 is finalised.
- **KD-C:** Admin auth module must enforce TOTP second factor. Authenticator-app-based (TOTP RFC 6238); not SMS-based for admin. Separate from customer OTP channel.
- **KD-D:** Cashier session token must expire after 40 minutes of inactivity. Server-side enforcement required — client-side idle timer alone is insufficient.
- **KD-E:** F&B Staff role scope is orders-only. Role-based access control must exclude payment, wallet top-up, wallet adjustment, loyalty redemption, and loyalty adjustment endpoints. F&B payment (e.g. food charges) is routed through CASHIER role at the main cashier point, not through F&B Staff.
- **KD-F:** No top-up threshold enforced in Phase 1. Compensating control is a daily top-up report surfaced to ADMIN. Pod B to include this report as a required admin dashboard feature in the auth/roles architecture.
- **KD-G:** Phone number in cashier top-up UI must be masked to last 4 digits. Data minimisation by display — full number stored in backend, never sent to cashier client in top-up context.
- **KD-H:** Role enum for Phase 1: CUSTOMER, CASHIER, FB_STAFF, ADMIN. MANAGER role is not created in Phase 1. No code scaffolding for MANAGER — deferral is clean.

### What this does NOT unlock

These decisions record authentication policy. They do not authorise Pod C to implement auth. The following remain blocked until ADR-015 is drafted, reviewed (Pod B), and Kerem-approved:

- Auth module scaffolding
- OTP flow implementation
- Session/token management implementation
- Role guard implementation
- Any endpoint decorated with role guards

---

## 14. K-14 — Aydınlatma Metni Notice Text Location (Phase 1)

**Date:** 2026-06-10
**Source:** Kerem session approval — resolves OQ-CUF-AUTH-002 (handoff label KEREM-03)
**Scope:** Canonical storage of the Phase 1 Aydınlatma Metni / privacy notice text and how it reaches the Customer PWA
**Related:** CORE_USER_FLOWS.md §3.9 OQ-CUF-AUTH-002, CUF-AUTH-009; AUTH_THREAT_MODEL.md BL-5

### Decision

Phase 1 canonical Aydınlatma Metni text lives in `/docs/PRIVACY_NOTICE_TR.md` and is
build-time embedded into the PWA. No CMS-managed or admin-managed notice surface in Phase 1.

### Implication

- No runtime notice-content store, no admin notice editor, and no notice-versioning service
  in Phase 1 scope.
- Updating the notice is a code/doc change + redeploy, governed by the normal PR gates.
- Does NOT resolve OQ-CUF-AUTH-001 (the actual Turkish legal wording), which remains owned by
  Kerem + legal advisor (K-08) and is still `[NEEDS KEREM APPROVAL]`.

---

## 15. K-15 — Acknowledgment Persistence Model (Phase 1)

**Date:** 2026-06-10
**Source:** Kerem session approval — resolves OQ-CUF-AUTH-003 (handoff label KEREM-01)
**Scope:** When/whether privacy-notice acknowledgment is persisted relative to OTP verification
**Related:** CORE_USER_FLOWS.md §3.9 OQ-CUF-AUTH-003, §3.4 postconditions, PCUF-AUTH-010; AUTH_THREAT_MODEL.md T-P3, IR-03

### Decision

Acknowledgment is **ephemeral (session-scoped, in-memory)** during the pre-verification flow.
It is **persistently recorded only on successful OTP verification**, as part of the
account-creation / login event. Failed, expired, or abandoned flows leave **no persistent
acknowledgment record**.

### Implication

- Consistent with the §3.5.3 phone-disposal rule and IR-03: no PII/consent artifact is
  persisted before a verified identity exists.
- Pre-verification acknowledgment is not evidence; only the post-verification record is.
- **K-08 legal-advisor confirmation required before Pod C propagation:** the evidentiary
  sufficiency of capturing consent only at verification (vs. earlier) must be confirmed by the
  legal/privacy advisor before this decision becomes a Pod C implementation issue. This is a
  flag, not a blocker on the document work.

---

## 16. K-16 — Same-Session Acknowledgment Reuse (Phase 1)

**Date:** 2026-06-10
**Source:** Kerem session approval — resolves OQ-CUF-AUTH-004 (handoff label KEREM-02)
**Scope:** Whether an existing acknowledgment can be reused for OTP resend
**Related:** CORE_USER_FLOWS.md §3.5.5 product rule, §3.9 OQ-CUF-AUTH-004

### Decision

Within the same uninterrupted browser session, existing acknowledgment state is **valid for
OTP resend**. Re-acknowledgment is **required** on: (1) session break — refresh, navigation
away, or browser close; and (2) **phone-number change mid-flow**.

### Implication

- Matches the v0.2 §3.5.5 session-scoped clarification; adds the phone-number-change condition,
  which is reflected in the §3.5.5 product rule and §3.9.
- **K-08 legal-advisor confirmation required before Pod C propagation** (as with K-15): the
  advisor confirms the reuse semantics are KVKK-sufficient before a Pod C issue is created.
  This is a flag, not a blocker.

---

## Open Actions Summary

| Action | Owner | Dependency | Priority |
|---|---|---|---|
| Produce `/docs/VISION.md` | Pod A | This document | High |
| Produce `/docs/PRODUCT_METRICS.md` | Pod A | This document | High |
| Produce `/docs/ROADMAP.md` with milestone definitions | Pod A | This document | High |
| Consult legal advisor on VERBİS | Kerem | — | **Go-live blocker** |
| Coordinate KVKK document review with legal advisor | Kerem + Pod A | Pod A drafts | High |
| Produce ADR-012: Feature flag tool | Pod B | — | Before go-live |
| Produce spike query script | Pod B | — | High |
| Provide Selcafe credentials to Pod C (secure channel) | Kerem | Pod B spike script | High |
| Execute Selcafe spike + produce report | Pod C | Credentials + script | High |
| Write mandatory rollback triggers into ROLLBACK_POLICY.md | Pod B | This document | High |
| Define milestone structure in PHASE_GATES.md | Pod B + Pod A | ROADMAP.md | High |
| Design monitoring spec for 99.9% SLO | Pod D | Deployment view | High |
| Document WhatsApp triage process | Pod A | This document | Medium |
| Include pilot onboarding flow in CORE_USER_FLOWS.md | Pod A | This document | Medium |
| Update `PROJECT_DECISION_INDEX.md` with BC-2/K-11 row | Pod B | PR-A merge | High |
| Update Pod B snapshot `LAST SYNCED TO PLATFORM` date | Kerem | PR-A merge | High |
| Update Pod C instruction snapshot for §11.1 gate change | Kerem/Pod C | PR-A merge | High |
| Produce SMS provider comparison report | Pod B | — | High — blocks KD-B / ADR-015 |
| Draft ADR-015: Authentication strategy | Pod B | K-13 locked; provider report complete | High — blocks Pod C auth implementation |
| Legal advisor (K-08) to confirm K-15 + K-16 KVKK sufficiency | Kerem + legal advisor | K-15/K-16 recorded | High — gates Pod C propagation of these decisions |

---

## Revision Log

| Version | Date | Author | Summary |
|---|---|---|---|
| 1.0 | [DATE] | Pod B | All 10 Kerem items recorded from interview session |
| 1.1 | 2026-06-07 | Pod B | K-11 BC-2 Option A approval added; Open Actions Summary updated with post-merge tasks |
| 1.2 | 2026-06-08 | Pod B | K-12 tenancy model + ORM decisions added; summary table and open actions updated |
| 1.3 | 2026-06-09 | Pod B | K-13 Phase 1 authentication decisions (KD-A through KD-H) added; summary table, open actions, and revision log updated |
| 1.4 | 2026-06-10 | Pod B | K-14/15/16 recorded (CORE_USER_FLOWS OQ-CUF-AUTH-002/003/004 resolved): notice text location, acknowledgment persistence, same-session reuse. Summary table, Open Actions (K-08 confirmation of K-15/K-16), and revision log updated. |