# KEREM_DECISIONS.md

<!--
  STATUS: COMPLETE — All 10 Kerem items recorded
  SOURCE: Kerem interview session, Pod B facilitation
  AUTHOR: Pod B (Architecture, Logic & Risk)
  VERSION: 1.0
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

---

## Revision Log

| Version | Date | Author | Summary |
|---|---|---|---|
| 1.0 | [DATE] | Pod B | All 10 Kerem items recorded from interview session |

