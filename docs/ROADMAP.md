# ROADMAP.md

## Status

| Field | Value |
|---|---|
| Document | `ROADMAP.md` |
| Project | Adeks Platform |
| Version | v0.1 — landed on `main`; post-landing status/routing metadata reconciled |
| Owner | Pod A — Product & Planning |
| Reviewer | Pod B — Architecture, Logic & Risk for future gate, owner, sequence, architecture/security/KVKK, or implementation-readiness changes |
| Approver | Kerem |
| Current status | Landed Phase 1 planning roadmap; legal/KVKK advisor answers and implementation-readiness gates remain open |
| Target repo path | `/docs/ROADMAP.md` |
| Change class | Documentation-only status/routing metadata reconciliation |
| Implementation status | Does **not** authorize Pod C implementation |
| Data rule | Synthetic examples only; no real customer, phone, transaction, wallet, loyalty, reservation, staff, screenshot, test, or prototype data |

---

## Purpose

This roadmap defines the exact Phase 1 sequence for Adeks Platform while legal/KVKK advisor answers are pending.

It separates:

- work that can proceed now;
- work blocked by legal/KVKK closure;
- work blocked by SMS provider and provider outage decisions;
- work blocked by Pod B architecture/security review;
- work that must not go to Pod C yet.

This roadmap is a planning document only. It does not create GitHub issues, does not approve implementation, does not approve schema/API contracts, does not select vendors, and does not authorize any direct write to Selcafe SQL Server.

---

## Source Context

This roadmap is based on the current repository context listed below.

| Source | Use in roadmap |
|---|---|
| `/docs/PROJECT_METHODOLOGY.md` | Pod boundaries, lifecycle, Definition of Ready, Definition of Done, security/KVKK process, review gates, handoff protocol |
| `/docs/AGENT_CONTEXT_MANIFEST.md` | Required context routing and planned product deliverables |
| `/docs/PROJECT_DECISION_INDEX.md` | Locked/not locked decision state |
| `/docs/KEREM_DECISIONS.md` | K-01 through K-19 decisions |
| `/docs/PROJECT_BRIEF.md` | Product vision, Phase 1/2/3 scope direction, Selcafe posture |
| `/docs/MVP_SCOPE.md` | Confirmed Phase 1 scope, exclusions, blockers |
| `/docs/OPEN_QUESTIONS.md` | Remaining unresolved business/legal/technical questions |
| `/docs/DATA_PROCESSING_INVENTORY.md` | Phase 1 personal-data-bearing surfaces and inventory gates |
| `/docs/SECURITY_REVIEW.md` | Security posture, residual risks, open blockers |
| `/docs/BUSINESS_RULES.md` | Product/business rules and unresolved business decisions |
| `/docs/USER_ROLES_AND_PERMISSIONS.md` | Roles, access, data minimization, audit expectations |
| `/docs/CORE_USER_FLOWS.md` | Customer OTP/privacy-notice flow and open legal/SMS questions |
| `/docs/architecture/FB_ORDER_LIFECYCLE_STATE_MODEL_v1.0.md` | Accepted F&B lifecycle design, still not Pod C-ready |
| `/docs/adr/ADR-005-selcafe-read-only-adapter.md` | Accepted 2026-06-23; Phase 1 Selcafe remains read-only and implementation remains blocked pending separate readiness gates |
| `/docs/adr/ADR-006-wallet-append-only-ledger.md` | Accepted wallet ledger design; implementation still blocked |
| `/docs/adr/ADR-007-loyalty-append-only-ledger.md` | Accepted loyalty ledger design and F&B accrual formula; implementation still blocked |
| `/docs/adr/ADR-015-authentication-strategy.md` | Accepted Phase 1 authentication strategy; implementation still blocked |

### Post-Landing Freshness Note

[ASSUMPTION] This roadmap has been re-evaluated after PR #73, PR #74, and PR #75 landed on `main`.

PR #73 resolves the B-2 stale-status contradiction identified in
`/docs/reviews/POD_B_REVIEW_ROADMAP_v0.1.md`:

- `/docs/DATA_PROCESSING_INVENTORY.md` is present and Kerem-approved
  at inventory-artifact level.
- `/docs/SECURITY_REVIEW.md` is present at review level.
- `/docs/DATA_RETENTION_POLICY.md`, `/docs/KVKK_LEGAL_BASIS.md`, and
  `/docs/CROSS_BORDER_TRANSFER_ASSESSMENT.md` remain blocking legal/KVKK
  artifacts.
- Pod C remains unauthorized.

PR #74 landed this roadmap on `main` as a planning-only Phase 1 roadmap.

PR #75 reconciled `/docs/OPEN_QUESTIONS.md` with the landed roadmap state and
confirmed that the reconciliation is documentation-only, does not reopen accepted
ADR-006, ADR-007, K-17, K-18, K-19, or the accepted F&B lifecycle state model,
does not create Pod C issues, and does not authorize implementation.

This PR reconciles Pod D audit finding F-01 / issue #100 by updating stale
Selcafe spike, report, and ADR-005 status references. It is documentation-only
and does not authorize Pod C implementation.

No structural roadmap sequence change is made by this note. The roadmap remains
milestone-based, planning-only, and non-implementation-authorizing.

[ASSUMPTION] This roadmap is milestone-based, not calendar-based, because Kerem approved milestone-based cadence. No delivery dates are invented here.

---

## Locked Planning Principles

| Principle | Roadmap effect |
|---|---|
| Repository is source of truth | Any conflict between this roadmap and accepted ADRs / current repo docs must be reconciled in repo |
| No AI model is project manager | Kerem remains final product/business approver |
| No implementation authorization | This roadmap does not create Pod C issues |
| Wallet and loyalty are append-only | No direct balance overwrite, no mutable balance as source of truth |
| All admin/sensitive actions auditable | Roadmap includes audit readiness before build |
| KVKK compliance required | Legal/KVKK closure is a launch and implementation gate for customer-data surfaces |
| Selcafe is legacy adapter | Phase 1 remains read-only toward Selcafe |
| Synthetic data only | Non-production docs, tests, prototypes, screenshots, UAT, and examples must use synthetic data |

---

## Phase 1 Exact Sequence

| Seq | Item | Responsible owner | Blocking dependencies | Required review | Required approval | Can proceed while legal/KVKK pending? | Work class |
|---:|---|---|---|---|---|---|---|
| 1 | Approve `ROADMAP.md` v0.1 as the Phase 1 planning sequence | Pod A drafts; Kerem approves | Pod B roadmap review | Pod B | Kerem | Yes | Documentation-only |
| 2 | Reconcile current repo status after new `DATA_PROCESSING_INVENTORY.md` and `SECURITY_REVIEW.md` context | Pod A + Pod B | Current repo may contain stale “absent” references in older security baseline text | Pod B | Kerem if status/gates change | Yes | Documentation-only |
| 3 | Maintain open legal/KVKK blocker register | Pod A | Legal advisor answers pending | Pod B for KVKK/security implications | Kerem | Yes | Documentation-only |
| 4 | Complete legal/KVKK advisor response cycle | Kerem + legal advisor | Advisor replies needed | Pod B reviews technical/security implications | Kerem | No | Decision-only |
| 5 | Finalize Turkish `PRIVACY_NOTICE_TR.md` text | Kerem + legal advisor; Pod A supports | Legal wording, legal sufficiency | Pod B if flow/data handling changes | Kerem + legal advisor | No | Documentation-only / legal decision |
| 6 | Confirm K-15/K-16 legal sufficiency before Pod C propagation | Kerem + legal advisor | Legal advisor confirmation | Pod B | Kerem | No | Decision-only |
| 7 | Resolve VERBİS registration or exemption position | Kerem + legal advisor | Legal advisor guidance | Pod B for data-processing impact | Kerem | No | Decision-only |
| 8 | Produce/approve `KVKK_LEGAL_BASIS.md` | Kerem + legal advisor; Pod A supports | Legal advisor legal-basis answers | Pod B | Kerem | No | Documentation-only / legal decision |
| 9 | Produce/approve `DATA_RETENTION_POLICY.md` | Kerem + legal advisor; Pod A supports | OQ-LEGAL-005 retention answers | Pod B | Kerem | No | Documentation-only / legal decision |
| 10 | Produce/approve `CROSS_BORDER_TRANSFER_ASSESSMENT.md` | Kerem + legal advisor + Pod B | Hosting, SMS provider, monitoring/logging vendors | Pod B | Kerem | No | Documentation-only / legal decision |
| 11 | Decide SMS provider after commercial replies and KVKK processor/cross-border review | Kerem + Pod A + Pod B + legal advisor | Provider prices/commercial terms; legal processor/cross-border assessment | Pod B | Kerem | No | Decision-only |
| 12 | Decide SMS provider outage / availability response path | Kerem + Pod B | SMS provider selection (BL-1); spend-volume ceiling values and `ADMIN` response-path owner decided at design level (`AUTH_THREAT_MODEL.md` v0.5 §15); outage/availability path depends on provider selection | Pod B | Kerem | Yes | Decision-only |
| 13 | Define initial ADMIN bootstrap procedure | Kerem + Pod B | Security-sensitive one-time admin setup | Pod B | Kerem | Yes, if no customer data is processed | Design-only / decision-only |
| 14 | Read-only Selcafe feasibility spike — completed 2026-06-23; status reconciled | Pod C executed; Pod B supplied script; Kerem supplied credentials securely | Completed under K-10; schema/metadata-only evidence; no row data copied | Pod B | Further Selcafe access or implementation still requires applicable Kerem approval | Completed with no real data copied into docs/AI | Spike-only |
| 15 | `/docs/SELCAFE_SPIKE_REPORT.md` — produced from the completed schema-only spike | Pod C produced execution findings; Pod B review/follow-on assessment remains separately routed | Completed read-only spike; schema/metadata only; no real data; report does not authorize implementation | Pod B | Kerem for further operational impact | Completed as documentation; no implementation authority | Spike-only / documentation-only |
| 16 | ADR-005 full Selcafe read-only adapter ADR — accepted 2026-06-23; integration view remains planned | Pod B | Accepted ADR-005; future adapter/integration work still requires product alignment, read-only credential/secrets prerequisites, `architecture/INTEGRATION_VIEW.md`, and a separately approved DoR issue | Pod B | Kerem required where ADR-009 or product/data/integration gates apply | Partial; legal/KVKK/cross-border gates apply where PII or cross-border is in scope | Design-only |
| 17 | Confirm Phase 1 remains read-only toward Selcafe | Kerem + Pod B | Any proposed change to Selcafe write posture | Pod B | Kerem explicit approval required for any change | Yes | Decision-only |
| 18 | Reconfirm Phase 1 MVP boundary: campaigns/subscriptions/ARPU outside Phase 1 | Pod A + Kerem | OQ-MVP-001 | Pod B only if architecture/data impact | Kerem | Yes | Decision-only |
| 19 | Finalize remaining wallet top-up business rules | Kerem + Pod A | Wallet top-up methods; top-up correction policy; daily report fields | Pod B | Kerem | Partial; implementation waits for legal/KVKK | Decision-only |
| 20 | Finalize remaining loyalty redemption/expiry/exclusion business rules | Kerem + Pod A + legal advisor for expiry/notifications | Redemption unit, targets, limits, expiry policy, notification classification | Pod B + legal advisor where customer notices/marketing apply | Kerem | Partial; expiry/notification cannot finalize without legal | Decision-only |
| 21 | Reconcile accepted ADR-006 wallet design with remaining legal/data gates | Pod B | Retention, legal basis, data inventory updates, security review, approved issue readiness | Pod B | Kerem for wallet implementation issues later | Partial; no implementation | Design-only |
| 22 | Reconcile accepted ADR-007 loyalty design with remaining legal/data gates | Pod B | Retention, legal basis, data inventory updates, security review, approved issue readiness | Pod B | Kerem for loyalty implementation issues later | Partial; no implementation | Design-only |
| 23 | Confirm F&B lifecycle implementation-readiness blockers | Pod B + Pod A | F&B state model accepted, but cross-domain legal/ledger/API/schema/issue gates remain | Pod B | Kerem for sensitive implementation issue later | Partial; no implementation | Design-only |
| 24 | Define reservation product rules | Kerem + Pod A | Slot length, limits, cancellation, no-show, manual approval criteria | Pod B | Kerem | Yes for product decisions; no implementation | Decision-only |
| 25 | Produce reservation state machine | Pod B | Approved reservation product rules; Selcafe spike if status-based criteria are considered | Pod B | Kerem if customer/staff policy affected | Partial | Design-only |
| 26 | Produce or reconcile security architecture view / Secure SDLC gaps | Pod B + Pod A as needed | `SECURITY_VIEW.md` / `SECURE_SDLC.md` reconciliation; SR-008/SR-009 | Pod B | Kerem if gates/process change | Yes | Documentation-only / design-only |
| 27 | Produce monitoring specification for 99.9% SLO readiness | Pod D + Pod B | Hosting/deployment model; operational view; alert ownership | Pod B | Kerem | Partial; final provider/hosting may depend on legal | Prototype/audit-only / design-only |
| 28 | Produce Pod D PWA UX prototype/review for onboarding, F&B order, reservation | Pod D | Kerem approval to prototype; current product flows | Pod A + Pod B if data/security implications | Kerem | Yes with synthetic data only | Prototype/audit-only |
| 29 | Produce Pod D pre-go-live consistency audit plan | Pod D | Roadmap approved; target docs identified | Pod A + Pod B for findings routing | Kerem for launch impact | Yes | Prototype/audit-only |
| 30 | Create implementation-ready issue packet candidates only after gates clear | Pod A + Pod B | Legal closure; SMS provider; ADR/API/schema/security state; accepted business rules | Pod B | Kerem where sensitive | No | Documentation-only; **not implementation-ready yet** |
| 31 | Pod C implementation | Pod C | Approved GitHub issues meeting Definition of Ready | Pod B as triggered | Kerem as triggered | No | Future implementation-ready only after gates |
| 32 | Staging/UAT with synthetic data | Pod C + staff + Kerem + Pod D | Implemented PRs; synthetic fixture set; release checklist | Pod B + Pod D | Kerem | No, because implementation must first clear legal/customer-data gates | Prototype/audit-only / release-readiness |
| 33 | Pre-go-live legal/security/monitoring/UX gate | Kerem + legal advisor + Pod B + Pod D | All launch blockers closed | Pod B + Pod D + legal advisor | Kerem | No | Decision-only |
| 34 | Go/no-go for controlled Phase 1 pilot | Kerem | Legal/KVKK closure, monitoring, rollback, staff fallback, Pod D audit, Definition of Done satisfied | Pod B + Pod D | Kerem | No | Decision-only |
| 35 | Phase 1 pilot operation and feedback capture | Kerem + staff + Pod A + Pod D | Go/no-go approved; staff trained; monitoring active | Pod B if security/data/integration issues arise | Kerem | No | Operational / audit-only |
| 36 | Post-pilot learning and backlog update | Pod A + Kerem + Pod D | Pilot data, staff feedback, monitoring results | Pod B if changes affect architecture/security/KVKK | Kerem | Yes after pilot | Documentation-only |

---

## Phase 1 Milestone Table

| Milestone | Entry Criteria | Exit Criteria | Owner | Required Review | Required Approval | Can proceed while legal pending? |
|---|---|---|---|---|---|---|
| M0 — Roadmap Control | Requested repo context loaded; roadmap draft prepared | `ROADMAP.md` approved as planning sequence; Pod B review recorded | Pod A | Pod B | Kerem | Yes |
| M1 — Legal/KVKK Closure Packet | Legal advisor questions known; data inventory exists; open legal blockers listed | Privacy notice text, legal basis, retention, VERBİS/exemption, cross-border, K-15/K-16 sufficiency resolved or explicitly deferred with launch impact recorded | Kerem + legal advisor + Pod A | Pod B | Kerem | No |
| M2 — SMS/Auth Readiness | ADR-015 accepted; Core user flow exists; provider report exists | Provider selected; processor/cross-border assessment completed; outage/spend ceiling response path approved; admin bootstrap decided | Kerem + Pod B | Pod B | Kerem | Partial |
| M3 — Selcafe Read-Only Discovery — partially complete / status reconciled | Read-only spike completed 2026-06-23; `SELCAFE_SPIKE_REPORT.md` exists; ADR-005 accepted | Discovery evidence, report, and ADR-005 full text are complete. Implementation remains blocked pending product alignment, dedicated read-only login/secrets prerequisites, planned `architecture/INTEGRATION_VIEW.md`, a separately approved Definition-of-Ready issue, Pod B + Kerem approval, and legal/KVKK/cross-border clearance where PII or cross-border is in scope. | Pod B + Pod C + Kerem | Pod B | Kerem for implementation or further access | Partial; discovery is complete, implementation is not authorized |
| M4 — Financial Ledger Readiness | ADR-006 and ADR-007 accepted; F&B settlement decisions locked | Legal/KVKK gates reconciled; top-up/redemption/report business rules resolved; no direct overwrite; issue-readiness checklist possible | Pod B + Pod A + Kerem | Pod B | Kerem | Partial; no implementation |
| M5 — F&B Order Readiness | F&B lifecycle state model accepted; price source/loyalty formula/correction policy locked | API/schema/audit trigger dependencies defined; wallet/loyalty settlement dependencies cleared; no Pod C ambiguity remains | Pod B | Pod B | Kerem for sensitive issue handoff | Partial; no implementation |
| M6 — Reservation Readiness | Reservation in MVP; open product rules listed | Kerem approves reservation rules; Pod B state machine completed; manual-only Phase 1 criteria preserved unless spike supports more | Pod A + Pod B + Kerem | Pod B | Kerem | Yes for decisions |
| M7 — Monitoring / SLO / Release Readiness | 99.9% SLO approved as target; monitoring owner identified | Monitoring spec, alerting, rollback, incident path, staff fallback, feature flag approach ready for release gate | Pod D + Pod B | Pod B + Pod D | Kerem | Partial; final hosting/provider may need legal |
| M8 — Pod D Pre-Go-Live Audit | Candidate implementation complete in future; docs/API/schema/UX available | Pod D consistency audit complete; findings triaged; blockers closed or accepted by Kerem | Pod D | Pod A + Pod B | Kerem | No |
| M9 — Controlled Pilot Go/No-Go | All legal/security/monitoring/DoD gates closed | Kerem records go/no-go; pilot cohort/staff process approved; no live customer data before KVKK controls | Kerem | Pod B + Pod D + legal advisor | Kerem | No |

---

## General Project Audit Points

| Audit Point | Current Roadmap Status | Required Gate |
|---|---|---|
| Legal/KVKK closure | Open | Legal advisor + Kerem approval before production customer-data use |
| Privacy notice and acknowledgment mechanics | K-14/K-15/K-16 locked; legal sufficiency still pending | Legal advisor confirmation before Pod C propagation |
| VERBİS / exemption | Open | Legal advisor determination + Kerem action |
| Retention and legal basis | Open | `DATA_RETENTION_POLICY.md` + `KVKK_LEGAL_BASIS.md` |
| Cross-border transfer | Open | `CROSS_BORDER_TRANSFER_ASSESSMENT.md`, dependent on SMS/hosting/monitoring vendors |
| SMS provider and provider outage response | Provider not selected (BL-1 open); spend-volume ceiling values and `ADMIN` response-path owner decided at design level (`AUTH_THREAT_MODEL.md` v0.5 §15); provider outage/availability response path: open | Kerem decision + Pod B review |
| Data-processing inventory | Exists and approved at inventory level only | Future changes need Pod B/Kerem; does not authorize implementation |
| Security review | Exists as design-level security review; implementation remains blocked | Pod B + Kerem gates remain for sensitive issues |
| Wallet ledger | ADR-006 accepted; implementation blocked | Legal/KVKK + Pod B/Kerem-approved issue required |
| Loyalty ledger | ADR-007 accepted; implementation blocked | Legal/KVKK + Pod B/Kerem-approved issue required |
| F&B order lifecycle/state/audit points | State model accepted; not Pod C-ready | API/schema/audit/ledger/legal gates still needed |
| Reservation state machine | Missing/planned | Pod B design after Kerem reservation rules |
| Selcafe read-only spike and adapter boundary | Spike/report complete; ADR-005 accepted 2026-06-23; Phase 1 remains read-only; no Pod C authorization | No direct writes; implementation requires a separate approved DoR issue, remaining prerequisites, and Pod B + Kerem approval |
| Monitoring and 99.9% SLO readiness | Required, not complete | Pod D monitoring spec + Pod B operational/deployment review |
| Pod D pre-go-live consistency audit | Required before go-live | Pod D audit report; findings routed |
| Definition of Ready before Pod C | Not satisfied for implementation areas | Every issue must link product docs, ADRs, schemas/API contracts, security/KVKK review, tests, risk class, approvals, synthetic examples |
| Definition of Done before PR completion | Future PR gate | Tests, CI, security/financial review if triggered, documentation updates, rollback notes, no real data |

---

## Blocked Until Legal Advisor Answers

| Blocked Item | Legal/KVKK Question | Impact |
|---|---|---|
| Production customer OTP registration/login | Legal basis, notice text, K-15/K-16 sufficiency, provider assessment | Blocks customer auth implementation/launch |
| `PRIVACY_NOTICE_TR.md` final content | Exact Turkish Aydınlatma Metni text | Blocks production privacy notice |
| K-15 acknowledgment persistence propagation | Is “persist only after successful OTP verification” legally sufficient? | Blocks Pod C auth issue derivation |
| K-16 same-session acknowledgment reuse propagation | Is same-session reuse legally sufficient? | Blocks Pod C auth issue derivation |
| VERBİS position | Register or exempt? | Blocks go-live with real customer data |
| Retention | Retention for phone, auth events, wallet, loyalty, orders, reservations, audit, source IP, reason notes | Blocks personal-data feature build and launch |
| Legal basis | Legal basis per data class | Blocks personal-data feature build and launch |
| Cross-border transfer | Hosting/SMS/monitoring/logging/support transfer status | Blocks provider/hosting production selection |
| SMS provider processor assessment | Provider as data processor and cross-border exposure | Blocks provider selection and OTP implementation |
| Loyalty expiry reminders if included | Marketing/notification classification and legal basis | Blocks expiry/reminder implementation |
| Audit reason notes / source IP retention | Personal-data risk and retention | Blocks audit implementation |

---

## Can Proceed Now Without Legal Closure

| Item | Owner | Limit |
|---|---|---|
| `ROADMAP.md` approval and Pod B review | Pod A + Pod B + Kerem | Planning only |
| Open-question cleanup and blocker register maintenance | Pod A | No legal answers invented |
| SMS provider outage/availability operational decision (spend-volume ceiling values and `ADMIN` response-path owner decided at design level — `AUTH_THREAT_MODEL.md` v0.5 §15; outage/availability path remains open) | Kerem + Pod B | Does not select provider |
| Initial ADMIN bootstrap policy | Kerem + Pod B | Security-sensitive; no implementation |
| Selcafe documentation/product-alignment follow-up after completed spike/report and accepted ADR-005 | Pod A + Pod B + Kerem | Read-only posture remains; reconcile product scope and planned integration view only; no implementation issue or direct Selcafe writes |
| Reservation product-rule decisions | Kerem + Pod A | No implementation; no automated Selcafe-dependent criteria before spike |
| Pod D UX prototype for onboarding/F&B/reservation | Pod D | Synthetic data only |
| Pod D monitoring/audit planning | Pod D + Pod B | Final hosting/provider details may remain pending |
| MVP boundary decision for campaigns/subscriptions/ARPU | Kerem + Pod A | Feature discovery only; not Phase 1 implementation |
| Documentation reconciliation after new inventory/security context | Pod A + Pod B | No behavior-changing gate changes unless explicitly reviewed |

---

## Must Not Go to Pod C Yet

The following must not be converted into Pod C implementation issues until the listed gates are closed.

| Area | Why Not Ready |
|---|---|
| Customer OTP/auth implementation | SMS provider not selected; legal/KVKK notice, legal basis, retention, K-15/K-16 sufficiency pending |
| Privacy notice implementation | Exact Turkish legal text pending |
| K-15/K-16 implementation | Legal sufficiency pending |
| Wallet ledger implementation | ADR-006 accepted but legal/KVKK and approved issue gates still open |
| Loyalty ledger implementation | ADR-007 accepted but legal/KVKK and approved issue gates still open |
| Wallet top-up | Top-up methods, correction policy, daily report fields still need Kerem + Pod B/legal review |
| Loyalty redemption/expiry | Redemption rules and expiry/notification policy unresolved |
| F&B settlement / correction implementation | Cross-domain legal/ledger/API/schema/audit gates remain |
| F&B order lifecycle implementation | State model accepted, but issue-level API/schema/audit/ledger readiness not complete |
| Reservation implementation | Product rules and Pod B state machine not complete |
| Selcafe sync/integration implementation | No approved Definition-of-Ready feature issue; Pod B + Kerem approval is required; dedicated read-only login, secrets handling, product alignment, and planned integration-view prerequisites remain; legal/KVKK/cross-border gates apply where PII or cross-border is in scope |
| Audit store implementation | Retention, legal basis, hash-chain implementation details, pseudonymization interaction, and approved issue gates pending |
| Hosting/deployment implementation | Hosting model, monitoring/SLO, cross-border assessment pending |
| Monitoring vendor/tool implementation | Vendor/data-processing/cross-border impact pending where applicable |
| Any use of real customer data in staging/tests/screenshots/prototypes | Locked synthetic-only rule prohibits it |

---

## Assumptions

[ASSUMPTION] Phase 1 continues as a customer PWA plus web cashier/admin foundation; no Selcafe replacement or PC client deployment is included.

[ASSUMPTION] Roadmap sequencing is milestone-based, not date-based.

[ASSUMPTION] Legal/KVKK advisor answers may change launch gates, privacy notice wording, retention, processor assessment, and cross-border handling, but they do not authorize implementation by themselves.

[ASSUMPTION] Accepted ADR-006 and ADR-007 settle ledger design direction but still require legal/KVKK closure and separately approved implementation issues before Pod C.

[ASSUMPTION] `SELCAFE_SPIKE_REPORT.md` records the completed 2026-06-23 schema/metadata-only spike; it does not authorize broader access or implementation, which still requires separate Pod B + Kerem-approved readiness gates.

---

## Open Questions

[OPEN QUESTION] What exact Turkish Aydınlatma Metni text will legal advisor approve for `/docs/PRIVACY_NOTICE_TR.md`?

[OPEN QUESTION] Does legal advisor confirm K-15 and K-16 as KVKK-sufficient for implementation?

[OPEN QUESTION] Is VERBİS registration required or is Adeks exempt?

[OPEN QUESTION] What legal basis applies to each Phase 1 data class?

[OPEN QUESTION] What retention periods apply to account, phone, auth, wallet, loyalty, order, reservation, audit, source IP, device digest, and reason-note data?

[OPEN QUESTION] Does the selected SMS/hosting/monitoring/logging provider create cross-border transfer?

[OPEN QUESTION] Which SMS provider is selected after commercial and legal/KVKK review?

[OPEN QUESTION] What is the provider outage/availability response path (secondary-provider policy, switchover posture) if the SMS provider is unavailable? (Spend-volume ceiling values and `ADMIN` response-path owner are decided at design level — `AUTH_THREAT_MODEL.md` v0.5 §15; this question covers provider availability only.)

[OPEN QUESTION] What are Phase 1 wallet top-up methods, top-up correction policy, and daily report fields?

[OPEN QUESTION] What are Phase 1 loyalty redemption, expiry, exclusion, and override rules?

[OPEN QUESTION] What are Phase 1 reservation slots, limits, cancellation, no-show, and approval criteria?

[OPEN QUESTION] Which remaining Selcafe product-alignment items must be resolved before a separately approved implementation issue can be prepared?

[OPEN QUESTION] Should campaigns/subscriptions/ARPU models remain outside Phase 1 and move to feature discovery?

---

## Review Routing

- Ready for commit: Yes — documentation-only roadmap status reconciliation.
- Requires Kerem approval: Yes.
- Requires Pod B review: Yes, narrowly, because Selcafe implementation-readiness wording is updated.
- Requires Pod C implementation: No — this roadmap explicitly does not authorize Pod C, does not create implementation issues, and remains planning-only.
- Requires Pod D prototype/audit/monitoring review: No for this correction.

---

## Post-Landing Routing Note

No active Pod A-to-Pod B handoff is open from this document solely because of this post-landing status/routing metadata reconciliation.

Route a future roadmap change to Pod B only if it changes any of the following:

1. Phase 1 sequence.
2. Gate ownership or review requirements.
3. Legal/KVKK, SMS provider, Selcafe spike, reservation, monitoring, or issue-readiness gate state.
4. Architecture, security, KVKK, Selcafe, wallet, loyalty, auth, SMS, hosting, monitoring, F&B state, reservation state, or implementation-readiness language.
5. Any statement that could be read as Pod C authorization.

The following remain open and are not resolved by this metadata reconciliation:

- legal/KVKK advisor closure;
- SMS provider selection; provider outage/availability response path (spend-volume ceiling values and ADMIN response-path owner decided at design level — AUTH_THREAT_MODEL.md v0.5 §15);
- Selcafe implementation readiness: product alignment, dedicated read-only login/secrets handling, planned `architecture/INTEGRATION_VIEW.md`, a separately approved Definition-of-Ready issue, and Pod B + Kerem approval; legal/KVKK/cross-border gates apply where PII or cross-border is in scope;
- reservation product rules and state-machine readiness;
- monitoring/SLO readiness;
- implementation issue Definition of Ready.

This document remains planning-only. It does not authorize Pod C, create implementation issues, select vendors, resolve legal/KVKK questions, approve schema/API contracts, approve direct Selcafe writes, or change wallet/loyalty ledger implementation readiness.
