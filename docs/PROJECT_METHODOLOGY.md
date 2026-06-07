# PROJECT_METHODOLOGY.md

<!-- 
  STATUS: DRAFT — Awaiting Kerem approval of [NEEDS KEREM APPROVAL] items
  AUTHOR: Pod A
  REVIEWER: Pod B (before merge)
  APPROVER: Kerem (product owner)
  VERSION: 0.6
  LAST UPDATED: 2026-06-07
  PATH: /docs/PROJECT_METHODOLOGY.md

  POD A: Completed v0.5 draft. RCPC bundle migrated PQ-002 mandatory Pod D audit cadence and workflow archive/stub references. Pod B review required.
  POD B (v0.6): BC-2 Option A — aligned §11.1 approval gates to ADR-009 §3; removed stale embedded PR template from §15. Kerem-approved 2026-06-07.
-->

---

## Document Purpose

This document defines the operating methodology for the Adeks Platform project. It
governs how all pods, roles, and processes interact throughout the full software
development lifecycle — from initial discovery through to post-launch learning.

This document is not a product brief, a roadmap, or an architecture document.
It is the rules of engagement for everyone who contributes to the project.

All pods, and Kerem as product owner, are bound by the processes defined here.
Changes to this document require Kerem's approval and must be recorded in a
dated revision entry at the bottom of this file.

---

## Table of Contents

1. [Project Control Plane](#1-project-control-plane)
2. [Pod Structure and Responsibilities](#2-pod-structure-and-responsibilities)
3. [The Full Development Lifecycle](#3-the-full-development-lifecycle)
4. [Phase 1: Strategic Discovery](#4-phase-1-strategic-discovery)
5. [Phase 2: User Research](#5-phase-2-user-research)
6. [Phase 3: Ideation and Brainstorm](#6-phase-3-ideation-and-brainstorm)
7. [Phase 4: Assumption Validation](#7-phase-4-assumption-validation)
8. [Phase 5: Prioritisation and Scoping](#8-phase-5-prioritisation-and-scoping)
9. [Phase 6: Planning and Roadmap](#9-phase-6-planning-and-roadmap)
10. [Phase 7: Architecture and Design](#10-phase-7-architecture-and-design)
11. [Phase 8: Build and Test](#11-phase-8-build-and-test)
12. [Phase 9: Release and Operate](#12-phase-9-release-and-operate)
13. [Phase 10: Learn and Iterate](#13-phase-10-learn-and-iterate)
14. [Definition of Ready](#14-definition-of-ready)
15. [Definition of Done](#15-definition-of-done)
16. [Inter-Pod Handoff Protocol](#16-inter-pod-handoff-protocol)
    - [16.1 Automatic Handoff Prompt Rule](#161-automatic-handoff-prompt-rule)
17. [Escalation and Conflict Resolution](#17-escalation-and-conflict-resolution)
18. [Feature Discovery Pipeline](#18-feature-discovery-pipeline)
19. [ADR Policy](#19-adr-policy)
20. [Security and KVKK Process](#20-security-and-kvkk-process)
21. [QA and Test Strategy](#21-qa-and-test-strategy)
22. [Release and Environment Management](#22-release-and-environment-management)
23. [Incident Response and Business Continuity](#23-incident-response-and-business-continuity)
24. [Roles and Responsibility Map](#24-roles-and-responsibility-map)
25. [Pilot and Staged Rollout Policy](#25-pilot-and-staged-rollout-policy)
26. [Vendor and Dependency Selection Process](#26-vendor-and-dependency-selection-process)
27. [AI Session Continuity Protocol](#27-ai-session-continuity-protocol)
28. [Document Governance and Revision History](#28-document-governance-and-revision-history)

---

## 1. Project Control Plane

<!-- [LOCKED] This section reflects the locked control plane. Do not alter. -->

The control plane is the final authority on all project decisions. It is always human.
No AI pod is the project manager. No AI pod can make final decisions.

| Authority Layer                        | Owner                     | Role                                                  |
| -------------------------------------- | ------------------------- | ----------------------------------------------------- |
| Product owner and final decision maker | Kerem                     | Approves all product, scope, and business decisions   |
| Repository                             | GitHub (`adeks-platform`) | Single source of truth. Repository always beats chat. |
| Architecture decisions                 | ADRs in `/docs/adr/`      | ADRs beat informal architecture notes in any medium   |
| Work items                             | GitHub Issues             | Issues beat vague implementation requests             |
| Quality gate                           | Tests and CI              | Tests beat assumptions                                |
| Sensitive action gate                  | Human approval required   | See Section 20 for trigger list                       |

### 1.1 What the Control Plane Means in Practice

The repository is the operating record of the project. A chat session can produce useful analysis, drafts, ideas, issue text, or review comments, but that output is not binding until it is committed to the repository as a document, ADR, GitHub issue, pull request, or test.

If a chat session says one thing and a committed repository document says another, the committed repository document wins. The correct action is not to follow the chat output informally. The correct action is to open a documented change proposal, update the relevant file through the normal review path, and record the reason for the change.

If two pods disagree, the disagreement must be written down in the appropriate GitHub issue, PR comment, ADR discussion, or document review note. Pod B may recommend a resolution for technical, architectural, security, or KVKK matters. Pod A may recommend a resolution for product, scope, user, or business-rule matters. Kerem makes the final decision whenever the disagreement affects product direction, operational policy, customer experience, financial logic, legal exposure, or scope.

No AI session output is binding by itself because AI sessions are temporary, incomplete records. They may miss prior context, be superseded by repository changes, or contain unreviewed assumptions. The repository prevents drift by making decisions durable, reviewable, and auditable.

### 1.2 Repository-Controlled Pod Context Principles

The project adopts the Repository-Controlled Pod Context model (ADR-013). The following structural rules govern how pods load and handle context:

| Principle | Rule |
|---|---|
| One canonical methodology source | `/docs/PROJECT_METHODOLOGY.md` is the sole canonical source for methodology, lifecycle, review gates, approval gates, handoff, escalation, ADR policy, security/KVKK process, and AI session continuity. No other file may establish parallel methodology rules. |
| Context routing is separate from methodology | `/docs/AGENT_CONTEXT_MANIFEST.md` (to be added in PR-3) tells each pod what files to load for a given task type. It routes context; it does not define governance. |
| Decision state is indexed, not established, in the decision index | `/docs/PROJECT_DECISION_INDEX.md` mirrors ADRs, methodology, and Kerem decisions. It does not establish decisions. If the index conflicts with an ADR, the ADR wins. |
| Pod instruction snapshots are reference-only | Files under `/docs/pod-instructions/` and `/CLAUDE.md` are canonical copies of platform instructions. They must not embed volatile live state such as full locked-decision tables, open-question lists, or current sprint status. |
| Behaviour-changing PRs require a Pod Impact Matrix | Any PR that changes pod behaviour, responsibilities, review or approval gates, context-loading rules, output format, methodology, templates, or external platform instructions must include a Pod Impact Matrix and Instruction Update Packet. |

---

## 2. Pod Structure and Responsibilities

### 2.1 Pod Overview

| Pod   | Tool                      | Primary Role                  |
| ----- | ------------------------- | ----------------------------- |
| Pod A | ChatGPT                   | Product & Planning            |
| Pod B | Claude                    | Architecture, Logic & Risk    |
| Pod C | Claude Code / Codex CLI   | Build & DevOps                |
| Pod D | Gemini / Google AI Studio | Prototype, Audit & Monitoring |

### 2.2 Pod A — Product and Planning

**Produces:** Business rules, user stories, user roles, user flows, open questions,
planning documents, feature opportunity notes, product metrics, UX research briefs.

**Does not:** Finalise architecture decisions, write implementation code, approve
security-sensitive changes, or propose architecture without Pod B review.

Pod A receives input from Kerem in the form of product goals, operational concerns, feature ideas, business constraints, customer observations, and decisions. Pod A converts those inputs into structured repository-ready markdown: business rules, user stories, user flows, scope documents, open questions, issue drafts, and handoff packages.

Pod A's normal working rhythm is:

1. Load the relevant repository context before producing output.
2. Identify what is known, unknown, assumed, and blocked.
3. Draft the requested product or planning document in clean markdown.
4. Mark assumptions explicitly.
5. Route architectural, security, data, wallet, loyalty, payment, and KVKK-sensitive material to Pod B.
6. Mark Kerem approval points clearly where the decision is business-sensitive.
7. Produce a commit-ready draft or a Pod B review package.

Pod A delivers documents to Pod B as markdown drafts with the following standard structure unless the target document defines a stricter format:

```md
# DOCUMENT_TITLE.md

## Status
- Owner:
- Reviewer:
- Approver:
- Current status:
- Required next review:

## Purpose

## Scope

## Assumptions

## Business Rules / Requirements / Flows

## Open Questions

## Review Routing
- Ready for commit:
- Requires Kerem approval:
- Requires Pod B review:
- Requires Pod C implementation:
- Requires Pod D prototype/audit/monitoring review:
```

Pod A must not hide uncertainty. If information is missing, Pod A produces a v0.1 draft with assumptions and open questions instead of blocking the process.

### 2.3 Pod B — Architecture, Logic and Risk

**Produces:** ADRs, domain model reviews, database schemas, API contracts, state
machine designs, security and KVKK risk assessments, wallet and loyalty ledger
specifications, bounded context maps, assumption maps.

**Does not:** Write application code, make product decisions, approve go-live
unilaterally, or override Kerem's product decisions.

Pod A must send a document to Pod B before it is considered final when the document includes or affects any of the following:

* Domain models, entities, aggregates, state machines, or lifecycle rules.
* Wallet, loyalty, refund, payment, or balance-affecting logic.
* Authentication, authorisation, RBAC, admin permissions, or audit logs.
* Customer personal data, phone numbers, consent, retention, or KVKK obligations.
* Selcafe integration, data sync, adapter behavior, or SQL Server access.
* Database schema, API contract, event model, queueing, caching, or real-time transport.
* Deployment, environments, rollback, monitoring, backup, or incident response.
* Any decision likely to become an ADR.

Pod B's expected response is a written review, not an informal approval. The review should classify findings as blocking, non-blocking, advisory, or requires Kerem decision. The expected turnaround should be the next review cycle or the next active project session, unless the document blocks Pod C implementation or contains a high-risk security/KVKK issue, in which case it should be treated as priority review.

Pod B review does not replace Kerem approval. Pod B validates architecture, logic, risk, and technical consistency. Kerem approves product direction, business impact, go/no-go decisions, and sensitive operational choices.

### 2.4 Pod C — Build and DevOps

**Produces:** Application code, database migrations, CI/CD pipelines, Docker
configuration, automated tests, environment setup.

**Does not:** Make architectural decisions independently, choose libraries without
Pod B approval for significant dependencies, merge to main without PR review,
or write to Selcafe SQL Server without explicit Kerem approval.

Pod C begins work only from a GitHub issue that meets the Definition of Ready in Section 14. The issue must contain business context, scope, non-goals, acceptance criteria, required tests, linked documents, risk classification, review status, and synthetic example data where relevant.

Before starting implementation, Pod C checks whether the issue references the required planning document, ADR, API contract, schema, or business-rule source. If any of those are missing, contradictory, or unclear, Pod C must stop and request clarification in the issue. Pod C must not guess business rules, invent edge-case behavior, select significant dependencies, or bypass Pod B review to keep development moving.

If ambiguity appears during implementation, Pod C should document the ambiguity in the issue or PR and tag the responsible pod:

* Product or scope ambiguity goes to Pod A and Kerem.
* Architecture, schema, security, or integration ambiguity goes to Pod B.
* UX ambiguity or interface-flow ambiguity may go to Pod D.
* Approval-sensitive ambiguity goes to Kerem.

Pod C's output is not complete until the PR satisfies the Definition of Done in Section 15.

### 2.5 Pod D — Prototype, Audit and Monitoring

**Produces:** PWA and UI prototypes, large-context codebase audits, monitoring
specifications, observability recommendations, UX flow explorations.

**Does not:** Make architectural decisions, gate other pods' work, propose product
scope changes as authoritative, or begin building features without Kerem direction.

Pod D is asked to audit when the project needs broad consistency review, UX flow review, prototype exploration, monitoring specification, or large-context inspection across many files. Pod D is especially useful before implementation of complex customer-facing flows, before pilot rollout, and after Pod C produces a substantial PR affecting user experience or operational behavior.

A Pod D audit report should be structured as:

```md
# POD_D_AUDIT_REPORT_[TOPIC].md

## Scope Reviewed

## Method

## Findings Summary

## Findings Table
| ID | Severity | Area | Finding | Evidence | Recommended Action | Owner |
|---|---|---|---|---|---|---|

## UX / Prototype Notes

## Monitoring / Observability Notes

## Open Questions

## Routing
- Pod A:
- Pod B:
- Pod C:
- Kerem:
```

Audit findings are not automatically scope changes or architecture decisions. Each finding must be routed. Product findings go to Pod A and Kerem. Architecture or security findings go to Pod B. Implementation defects go to Pod C. Monitoring gaps go to Pod D and Pod B. Kerem decides whether major findings change scope, launch timing, or operational policy.

**Mandatory audit cadence — PQ-002 (Kerem-approved).** Pod D MUST run a full-project consistency audit at the following minimum gates:

| Gate | Required Pod D audit |
|---|---|
| Before Phase 1 go-live | Full-project consistency audit covering product, methodology, UX, monitoring, release-readiness, and cross-document alignment. |
| Before Phase 2 begins | Full-project consistency audit covering Phase 1 learnings, PC-client readiness, Selcafe transition implications, monitoring, and cross-document alignment. |
| Before Phase 3 tenant architecture is implemented | Full-project consistency audit covering SaaS readiness, tenant-management assumptions, commercialization implications, monitoring, and cross-document alignment. |

The audit report must return structured findings and routing. It does not replace Pod B architecture/security review, Pod C implementation review, or Kerem approval.

### 2.6 Kerem — Product Owner

Kerem is the product owner and final decision maker. Kerem decides what the platform is for, what business outcomes matter, what is in or out of scope, when a phase is approved, and whether the product is ready to launch.

Only Kerem can approve:

* Product vision and strategic direction.
* MVP scope and phase gates.
* Business rules affecting customer money, wallet value, loyalty value, refunds, campaigns, pricing, or promotions.
* Any write access to Selcafe SQL Server.
* Any use of real customer data outside approved production operation.
* Go/no-go release decisions.
* Pilot participant selection and full rollout approval.
* Legal/compliance decisions requiring business ownership, including KVKK obligations.
* Vendor choices with cost, contract, data-processing, or operational lock-in impact.

Kerem delegates structured analysis to the pods. Pod A drafts product and planning documents. Pod B evaluates architecture, logic, security, and risk. Pod C implements approved issues. Pod D prototypes, audits, and defines monitoring needs.

Kerem signals approval through repository-visible actions: GitHub issue comments, PR approvals, explicit markdown approval notes, ADR approval comments, or direct instruction that is later recorded in the relevant repository artifact. Verbal or chat approval should be captured in the repository before it becomes binding.

If Kerem is unavailable, work may continue only on already-approved, non-sensitive, low-risk tasks that meet the Definition of Ready. Work must pause for decisions involving product scope, wallet, loyalty, payments, refunds, security posture, customer data, Selcafe writes, KVKK compliance, or go-live approval.

---

## 3. The Full Development Lifecycle

The Adeks project uses a ten-phase lifecycle to prevent premature building, undocumented assumptions, and feature decisions made only through chat. The lifecycle moves from strategic intent to user research, idea generation, validation, scoping, planning, architecture, build, release, and learning.

Phases 1-5 were not fully executed before early project planning began. That is now treated as a methodology gap, not as a reason to discard existing work. Each of the relevant sections below includes a remediation plan to backfill missing discovery, research, ideation, validation, and scoping artifacts before documents such as `MVP_SCOPE.md` are treated as final.

For future features, Phase 2 planning, and Phase 3 SaaS planning, all ten phases must be executed in sequence. A feature idea must not jump directly from brainstorm to build. The project must first record the problem, user evidence, assumptions, prioritisation reasoning, architecture review, issue readiness, implementation, release, and post-launch learning.

The Adeks project follows a ten-phase development lifecycle:

```
Phase 1:  Strategic Discovery
Phase 2:  User Research
Phase 3:  Ideation and Brainstorm
Phase 4:  Assumption Validation
Phase 5:  Prioritisation and Scoping
Phase 6:  Planning and Roadmap
Phase 7:  Architecture and Design
Phase 8:  Build and Test
Phase 9:  Release and Operate
Phase 10: Learn and Iterate
          ↑________________________↓  (continuous loop)
```

Each phase has defined inputs, outputs, responsible pods, and completion criteria.
No phase begins without the previous phase's outputs being committed to the repository.

**Phase Gate Rule:** [LOCKED] A phase gate requires Kerem's explicit approval before
the next phase begins. Gate criteria are defined in `/docs/PHASE_GATES.md`.

---

## 4. Phase 1: Strategic Discovery

**Purpose:** Establish why the platform exists, what it must achieve, and the full
universe of possible directions before any scope is locked.

**Responsible pod:** Pod A, with Kerem as primary input source.

**Outputs required before Phase 2 begins:**

| Output                   | Document                        | Status                 |
| ------------------------ | ------------------------------- | ---------------------- |
| Product vision statement | `/docs/VISION.md`               | [NEEDS KEREM APPROVAL] |
| Problem statement        | `/docs/PROBLEM_STATEMENT.md`    | [NEEDS KEREM APPROVAL] |
| North star metric        | `/docs/VISION.md` (section)     | [NEEDS KEREM APPROVAL] |
| Stakeholder map          | `/docs/STAKEHOLDER_MAP.md`      | [NEEDS KEREM APPROVAL] |
| Competitive analysis     | `/docs/COMPETITIVE_ANALYSIS.md` | [NEEDS KEREM APPROVAL] |

### 4.1 Product Vision Statement

The product vision statement defines the strategic purpose of Adeks Platform in one concise paragraph. It should describe the target customer segment, the core need or problem, the product category, the primary benefit, the current alternative, and the differentiator.

The required format is:

> For [customer segment] who [need or problem], [Adeks Platform] is a [category] that [key benefit]. Unlike [alternative], our product [differentiator].

The vision statement must be written in `/docs/VISION.md` and approved by Kerem before `MVP_SCOPE.md` is finalised. Without an approved vision, scope decisions become arbitrary because there is no agreed standard for deciding whether a feature supports the product direction.

The vision statement must stay at product-strategy level. It should not list individual features, implementation choices, or architecture decisions. Those belong in separate scope, roadmap, and ADR documents.

### 4.2 North Star Metric

A north star metric is the single primary measure that indicates whether the product is creating the intended value. It does not replace supporting metrics, but it gives the project one main direction when trade-offs arise.

The north star metric is required because Phase 1 must prove more than "software was built." It must show that the platform improved a meaningful business or customer outcome. A feature may be technically complete and still fail if it does not move the intended behavior.

The metric must be specific, measurable, and reviewed after launch. It should answer:

> If this number increases, can we reasonably say Phase 1 worked?

Placeholder for Kerem:

> [NEEDS KEREM APPROVAL — what single number, if increasing, tells us Phase 1 worked?]

Examples of candidate metric categories, not final decisions:

* Share of eligible customers using the PWA.
* Number of successful F&B orders from seat.
* Repeat customer engagement through wallet or loyalty visibility.
* Reduction in cashier interruptions for status, wallet, or order questions.
* Reservation requests successfully handled through the new workflow.

Pod A may propose candidates, but Kerem must choose the final north star metric.

### 4.3 Problem Statement

Problem statements must describe user or business friction, not preferred solutions. A valid problem statement does not begin with "we need a wallet" or "we need a reservation system." Those are features. The problem statement must explain who is experiencing friction, when it happens, what impact it creates, and why the proposed intervention may help.

The required format is:

> [Customer type] currently experiences [friction] when [activity], which causes [impact]. We believe [intervention] will address this because [reasoning].

Example using synthetic language:

> Customer A currently experiences uncertainty when trying to order food without leaving the PC, which causes session interruption and extra cashier workload. We believe seat-based F&B ordering will address this because it lets the customer request items without physically leaving the gaming session.

Each problem statement should include:

| Field                  | Description                                             |
| ---------------------- | ------------------------------------------------------- |
| Customer or staff type | Who experiences the problem                             |
| Current activity       | What they are trying to do                              |
| Friction               | What makes the current workflow difficult               |
| Impact                 | Why the problem matters                                 |
| Proposed intervention  | The general type of improvement                         |
| Evidence               | Observation, staff input, customer input, or assumption |
| Status                 | Validated, partially validated, or assumption           |

### 4.4 Stakeholder Map

The stakeholder map records every group that can affect or be affected by the platform. It must include stakeholders beyond Kerem because adoption depends on staff, customers, and future buyers, not only the product owner.

| Stakeholder                    | Stake                                                                                      | Ability to Block or Enable                                                                  | What They Need to Adopt                                                                      |
| ------------------------------ | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| Cashier staff                  | Must use web-based cashier/admin workflows without slowing down front-desk operation       | Can block adoption if workflows are slower than Selcafe or create double entry              | Fast flows, clear permissions, minimal extra clicks, reliable audit trail, fallback process  |
| F&B staff                      | Must receive, prepare, and update seat-based orders                                        | Can block adoption if order routing is unclear or increases kitchen confusion               | Simple order queue, clear seat/customer context, item status, cancellation handling          |
| Regular customers              | Use PCs frequently and are likely early adopters of wallet, loyalty, F&B, and reservations | Can enable adoption through repeat usage and feedback; can block if onboarding is confusing | Fast login, visible wallet/loyalty status, simple ordering, trustworthy balance display      |
| Casual customers               | May use the platform with little explanation                                               | Can reduce adoption if the first-use flow is too heavy                                      | Low-friction onboarding, clear value, minimal required data                                  |
| Manager/Admin                  | Needs operational visibility and control                                                   | Can enable adoption by enforcing process and reviewing reports                              | Role-based access, audit logs, operational dashboards, clear exception handling              |
| Future SaaS operator buyers    | Potential Phase 3 customers if Adeks Platform becomes commercialized                       | Can shape future packaging requirements                                                     | Multi-location support, reliable deployment, support model, tenant management, pricing model |
| Selcafe vendor relationship    | Current dependency and legacy system context                                               | Can affect integration feasibility, support, and migration risk                             | Clear read-only Phase 1 posture, no unsupported writes, documented adapter boundaries        |
| External legal/privacy advisor | Supports KVKK compliance                                                                   | Can block launch if legal obligations are not met                                           | Data inventory, privacy notices, retention policy, breach process, processing records        |
| Future payment provider        | Potential Phase 2+ dependency                                                              | Can constrain payment, refund, settlement, and compliance workflows                         | Clear payment requirements, reconciliation model, error handling, data-processing review     |

### 4.5 Competitive Analysis

Competitive analysis is required for the Phase 3 SaaS ambition, not as a blocker for the Phase 1 build. Phase 1 may proceed without a complete competitive analysis if the Phase 1 scope is explicitly local to Adeks operations and does not assume SaaS packaging decisions.

Before Phase 3 planning begins, `/docs/COMPETITIVE_ANALYSIS.md` must examine the market for internet café, gaming lounge, venue management, POS-integrated, loyalty, and customer self-service platforms. The analysis should identify what competing products already provide, where they are weak, how they price and deploy, and what differentiation Adeks Platform can credibly claim.

Platforms and categories to analyse should include:

| Category                          | Examples / Targets to Research                     | Purpose                                                                       |
| --------------------------------- | -------------------------------------------------- | ----------------------------------------------------------------------------- |
| Internet café management software | Selcafe and comparable café-management tools       | Understand current market expectations and migration risks                    |
| Gaming venue management           | Gaming lounge and esports venue platforms          | Understand session, seat, event, and customer engagement models               |
| POS and F&B ordering systems      | Local and international POS/order management tools | Understand order routing, cashier workflows, receipts, and stock implications |
| Loyalty and wallet platforms      | Consumer wallet and loyalty systems                | Understand ledger, campaign, and customer retention patterns                  |
| Multi-tenant SaaS admin tools     | SaaS platforms serving location-based businesses   | Understand tenant management, support, billing, and deployment models         |

The output should not copy competitors. It should inform positioning, packaging, commercial risk, and Phase 3 feature priorities.

### 4.6 Phase 1 Remediation Note

<!-- [LOCKED PROCESS NOTE — Do not remove] -->

The original project did not execute Phase 1 before beginning planning. The
following remediation actions are required before MVP_SCOPE.md is finalised:

* [ ] Kerem to narrate and Pod A to document: what problem are we solving?
* [ ] Kerem to define the north star metric for Phase 1
* [ ] Pod A to produce VISION.md draft for Kerem approval
* [ ] Pod A to produce STAKEHOLDER_MAP.md draft for Kerem approval

---

## 5. Phase 2: User Research

**Purpose:** Understand users as people, not just as roles. Document current
(as-is) workflows before designing replacements.

**Responsible pod:** Pod A for facilitation and documentation.
Pod D for physical café observation (Selcafe Friction Audit).
Kerem to authorise staff participation.

**Outputs required before Phase 3 begins:**

| Output                         | Document                            | Status  |
| ------------------------------ | ----------------------------------- | ------- |
| Deep persona definitions       | `/docs/PERSONAS.md`                 | Missing |
| As-is process maps             | `/docs/AS_IS_FLOWS.md`              | Missing |
| Customer journey map (current) | `/docs/CUSTOMER_JOURNEY_CURRENT.md` | Missing |
| Jobs-to-be-Done analysis       | `/docs/JTBD_ANALYSIS.md`            | Missing |

### 5.1 Persona Definitions

A role is a permission set. A persona is a person.

For example, "cashier" as a role defines what actions a user can perform in the system. "Cashier working a busy evening shift" as a persona describes goals, pressures, frustrations, fears, and success criteria. Both are needed, but they serve different purposes.

Personas must be synthetic. They must not use real Adeks customer or staff names.

Persona template:

```md
## Persona: [Synthetic Name]

| Field | Description |
|---|---|
| Persona type | Gaming Customer / Cashier / F&B Staff / Manager/Admin |
| Age range | Synthetic range, not exact real person |
| Daily context | Where and how this person interacts with Adeks |
| Primary goal at Adeks | What they are trying to accomplish |
| Biggest frustration | Main source of friction in current workflow |
| Biggest fear | What they worry could go wrong |
| What success looks like | Observable outcome that means the platform works for them |
| Digital comfort level | Low / medium / high |
| Critical workflows | Wallet, F&B, reservation, session, loyalty, admin, etc. |
| Evidence status | Observed / reported by Kerem / assumption |
```

Required personas:

| Persona         | Purpose                                                                                                   |
| --------------- | --------------------------------------------------------------------------------------------------------- |
| Gaming Customer | Understand customer-facing PWA needs, session continuity, F&B ordering, wallet/loyalty visibility         |
| Cashier         | Understand operational speed, exception handling, wallet top-up, loyalty redemption, reservation approval |
| F&B Staff       | Understand order queue, preparation flow, seat delivery, cancellation, item availability                  |
| Manager/Admin   | Understand reporting, audit logs, permissions, staff controls, operational oversight                      |

Personas are not permanent. They should be updated after observation, staff interviews, pilot feedback, and production learning.

### 5.2 As-Is Process Maps

As-is mapping must happen before to-be design because the platform is replacing, extending, or sitting beside real café workflows. If the current workflow is not documented, the project risks building a clean digital flow that fails during real operation.

The as-is maps must show what currently happens, who performs each step, what system is used, where manual work occurs, what data is captured, where errors happen, and where customers or staff wait.

The required scope includes:

| Workflow                    | As-Is Questions                                                                                          |
| --------------------------- | -------------------------------------------------------------------------------------------------------- |
| Wallet top-up               | Who receives payment, where is value recorded, what receipt or record exists, how are mistakes corrected |
| F&B ordering                | How customers order today, who receives the request, how preparation and delivery are tracked            |
| Reservation request         | How requests arrive, who approves, what conflicts occur, how customers are informed                      |
| Session start and end       | How a PC session begins, how time is tracked, how end-of-session is handled                              |
| Loyalty earn and redemption | How points/value are earned, viewed, adjusted, and redeemed today                                        |

The Selcafe Friction Audit is the primary research method for this section. Pod D should observe real workflows with Kerem's authorisation. Pod A should convert findings into as-is maps and open questions. Pod B should review areas where the observed workflow implies state machines, ledger logic, integrations, or audit requirements.

### 5.3 Selcafe Friction Audit

<!-- [NEEDS KEREM APPROVAL — physical café observation requires staff awareness
and Kerem's authorisation] -->

The Selcafe Friction Audit is a structured observation of current café operations. Its purpose is not to criticise staff or Selcafe. Its purpose is to identify where the current operating model creates delay, double entry, uncertainty, manual workaround, customer interruption, or missing auditability.

Participants:

| Participant   | Role in Audit                                                                   |
| ------------- | ------------------------------------------------------------------------------- |
| Kerem         | Authorises observation, explains business context, approves staff participation |
| Cashier staff | Demonstrate current cashier workflows and pain points                           |
| F&B staff     | Demonstrate current order intake, preparation, and delivery flow                |
| Pod D         | Observes and records workflow friction, screenshots or diagrams where permitted |
| Pod A         | Converts observations into product requirements, as-is maps, and open questions |
| Pod B         | Reviews technical implications after findings are documented                    |

What is observed:

* Customer arrival and session start.
* PC assignment and session tracking.
* Cashier interactions during busy periods.
* Wallet/top-up-like value handling if applicable.
* Loyalty-like tracking if applicable.
* F&B order request, preparation, delivery, and cancellation.
* Reservation inquiry and approval/rejection.
* Customer questions about balance, time, order, or reservation.
* Staff workarounds outside Selcafe.
* Any duplicated entry between tools or paper/manual processes.

What is recorded:

* Workflow steps.
* Actor responsible for each step.
* System or tool used.
* Data captured.
* Delay points.
* Error-prone points.
* Manual workaround.
* Customer-visible friction.
* Staff-visible friction.
* Potential audit or compliance concern.
* Evidence status: observed, reported, inferred, or assumption.

No real customer personal data should be copied into research notes. Synthetic examples must be used in all documentation.

Findings feed into `/docs/AS_IS_FLOWS.md`, `/docs/CUSTOMER_JOURNEY_CURRENT.md`, `/docs/OPEN_QUESTIONS.md`, and later to feature opportunity notes.

### 5.4 Jobs-to-be-Done Analysis

Jobs-to-be-Done means describing what progress a person is trying to make in a situation. The "job" is not the feature. A customer is not hiring a wallet. The customer is hiring confidence that they can access, pay for, and continue a gaming session without avoidable friction.

JTBD template:

```md
When [situation],
I want to [motivation],
so I can [desired progress/outcome].
```

Expanded template:

```md
## JTBD: [Persona]

| Field | Description |
|---|---|
| Situation | When does the need appear? |
| Motivation | What is the person trying to accomplish? |
| Desired progress | What outcome do they want? |
| Current workaround | What do they do today? |
| Friction | What makes the current approach painful? |
| Success signal | What observable behavior proves improvement? |
```

Examples:

| Persona         | JTBD Example                                                                                                                                                            |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Gaming Customer | When I am in the middle of a session, I want to order food or check value without leaving the PC, so I can keep playing without interruption.           |
| Cashier         | When the café is busy, I want customer requests to arrive in a structured queue, so I can handle them accurately without repeated verbal clarification. |
| F&B Staff       | When a customer orders from a seat, I want clear item and seat information, so I can prepare and deliver the order correctly.                           |
| Manager/Admin   | When reviewing operations, I want auditable records of sensitive actions, so I can understand what happened and resolve disputes.                       |

JTBD analysis should be used before prioritisation. It ensures that features are chosen because they solve real progress needs, not because they are interesting to build.

---

## 6. Phase 3: Ideation and Brainstorm

**Purpose:** Explore the complete possibility space of what the platform could do
before any filter is applied. No idea is rejected in this phase.

**Responsible pod:** Pod A facilitates. Kerem is the primary voice.
All pods may contribute ideas to the backlog but not filter them.

**Outputs required before Phase 4 begins:**

| Output                                    | Document                           | Status  |
| ----------------------------------------- | ---------------------------------- | ------- |
| Feature Possibility Map (raw, unfiltered) | `/docs/FEATURE_POSSIBILITY_MAP.md` | Missing |
| Opportunity Map (value vs feasibility)    | `/docs/OPPORTUNITY_MAP.md`         | Missing |

### 6.1 Feature Brainstorm Process

<!-- [NEEDS KEREM APPROVAL — 90-minute session to be scheduled before
MVP_SCOPE.md is finalised] -->

The brainstorm is a deliberately unfiltered session. Its purpose is to capture the full possibility space before priority, feasibility, architecture, or phase boundaries are applied.

Recommended format:

| Segment           |   Time | Activity                                                                   |
| ----------------- | -----: | -------------------------------------------------------------------------- |
| Context reset     | 10 min | Re-state platform vision, known user groups, and current pain points       |
| Customer ideas    | 15 min | What could improve customer experience before, during, and after a session |
| Staff ideas       | 15 min | What could reduce cashier, F&B, and manager workload                       |
| Revenue ideas     | 15 min | Campaigns, subscriptions, loyalty, upsell, ARPU, retention                 |
| Operational ideas | 15 min | Reporting, audit, stock, support, monitoring, incident fallback            |
| SaaS ideas        | 10 min | What another café operator would need to buy this later                    |
| Capture review    | 10 min | Confirm that every idea was recorded without prioritisation                |

Rules:

* No filtering during the session.
* No "that's Phase 3" objections during capture.
* No cost or feasibility objections during capture.
* No architecture decisions during capture.
* Every idea is recorded.
* Ideas may come from Kerem, any pod, staff observation, customer feedback, or competitor analysis.
* The output is a flat Feature Possibility Map, not a prioritised backlog.

Prioritisation happens later in Phase 5.

### 6.2 Feature Possibility Map

The Feature Possibility Map is a raw inventory of what Adeks Platform could eventually do. It is not a commitment, roadmap, or MVP scope. It exists to prevent good ideas from being lost and to prevent premature narrowing.

The document should be located at `/docs/FEATURE_POSSIBILITY_MAP.md`.

Recommended format:

| ID | Domain Area | Idea | Source | User / Stakeholder | Problem or Opportunity | Notes |
| -- | ----------- | ---- | ------ | ------------------ | ---------------------- | ----- |

Domain areas should include at least:

* Wallet.
* Loyalty.
* F&B.
* Reservations.
* Session management.
* Customer PWA.
* Cashier/admin.
* PC client.
* Campaigns.
* Subscriptions.
* Reporting and analytics.
* Audit and compliance.
* Operations and monitoring.
* Multi-location SaaS.
* Tenant management.
* Payments.
* Support and onboarding.

At this stage, the map must not include a priority column, phase assignment, feasibility rating, or rejection status. It asks only: what could this platform do?

### 6.3 Opportunity Mapping

After the brainstorm, Pod A converts the raw list into an Opportunity Map. The map evaluates each opportunity on two axes:

1. Customer/operator value: high, medium, or low.
2. Implementation feasibility: high, medium, or low.

The purpose is not to produce final scope. The purpose is to make trade-offs visible before scoping.

Recommended format:

| Idea ID | Opportunity | Value | Feasibility | Evidence | Risks | Candidate Treatment |
| ------- | ----------- | ----- | ----------- | -------- | ----- | ------------------- |

Interpretation:

| Quadrant                      | Meaning                                        | Candidate Treatment                      |
| ----------------------------- | ---------------------------------------------- | ---------------------------------------- |
| High value / high feasibility | Useful and practical                           | Candidate for Phase 1 or Phase 2         |
| High value / low feasibility  | Strategically important but expensive or risky | Candidate for Phase 3 or discovery spike |
| Low value / high feasibility  | Easy but not strategically important           | Deprioritise unless needed for adoption  |
| Low value / low feasibility   | Weak business case and difficult               | Reject or defer with reason              |

Everything that is deprioritised must remain documented with a reason. Rejected or deferred ideas should have review triggers, such as "revisit after Phase 1 pilot" or "revisit when payment provider is selected."

---

## 7. Phase 4: Assumption Validation

**Purpose:** Before any architecture is locked, identify every assumption the
project rests on, rate its confidence level, and validate low-confidence
assumptions through spikes or research before committing to build.

**Responsible pod:** Pod B produces the assumption map.
Pod A validates product assumptions with Kerem.
Pod C executes technical spikes.

**Outputs required before Phase 5 begins:**

| Output                           | Document                        | Status                         |
| -------------------------------- | ------------------------------- | ------------------------------ |
| Assumption Map                   | `/docs/ASSUMPTION_MAP.md`       | Missing                        |
| Selcafe Feasibility Spike Report | `/docs/SELCAFE_SPIKE_REPORT.md` | Missing [NEEDS KEREM APPROVAL] |
| MVP Hypothesis Document          | `/docs/MVP_HYPOTHESIS.md`       | Missing                        |

### 7.1 Assumption Map

The assumption map records what the project believes to be true before those beliefs become implementation commitments. It prevents hidden assumptions from turning into late-stage defects.

Each assumption must use this format:

| Field                    | Description                                                                    |
| ------------------------ | ------------------------------------------------------------------------------ |
| Assumption ID            | Stable identifier, e.g. `ASM-001`                                              |
| Assumption statement     | The belief being relied on                                                     |
| Decision supported       | Which product, scope, architecture, or delivery decision depends on it         |
| Assumption type          | Product / user / technical / legal / operational / integration                 |
| Confidence               | High / medium / low                                                            |
| Evidence                 | Observation, data, Kerem input, staff input, spike, external research, or none |
| Risk if wrong            | What breaks if this assumption is false                                        |
| Action if low confidence | Spike / prototype / research / defer / accept risk                             |
| Owner                    | Pod A, Pod B, Pod C, Pod D, Kerem                                              |
| Status                   | Open / validating / confirmed / disproven / accepted risk                      |

Pod B owns architectural and technical assumptions. Pod A owns product and user assumptions. Pod C may execute technical spikes. Pod D may validate UX or operational assumptions through prototype review or observation.

Low-confidence assumptions that affect scope, architecture, customer money, personal data, Selcafe integration, or launch readiness must be resolved or explicitly accepted by Kerem before build begins.

### 7.2 Selcafe Feasibility Spike

<!-- [NEEDS KEREM APPROVAL — requires authorised access to Selcafe SQL Server
for read-only schema inspection. This must not be treated as a write operation.
See locked principle: No direct writes to Selcafe SQL Server in Phase 1.] -->

The Selcafe feasibility spike answers whether and how Phase 1 can safely discover or sync data from Selcafe without replacing Selcafe and without writing to Selcafe SQL Server.

The spike must answer:

| Question                                              | Required Output                                                                       |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------- |
| Is SQL Server accessible from the same local network? | Connection feasibility and constraints                                                |
| What authentication method is required?               | Access method, account type, permissions                                              |
| What tables and columns exist?                        | Read-only schema inventory                                                            |
| What data quality is present?                         | Completeness, consistency, nulls, duplicates, encoding issues                         |
| What does the schema reveal about sessions?           | Session-related tables and likely state model                                         |
| What does the schema reveal about customers?          | Customer-related tables and PII fields                                                |
| What does the schema reveal about wallet/value?       | Any stored balance, transaction, package, credit, or payment structures               |
| What does the schema reveal about PCs?                | PC identifiers, station status, groups, session relation                              |
| What are the risks?                                   | Fragile schema, missing keys, unclear semantics, performance concerns                 |
| Is Phase 1 read-only sync feasible?                   | Recommendation: feasible / partially feasible / not feasible / requires further spike |

The spike is time-boxed to one working day. It must be read-only. It must not create tables, update data, run destructive queries, change Selcafe configuration, or interrupt live operation.

The output is `/docs/SELCAFE_SPIKE_REPORT.md`, committed to the repository. Pod B reviews the findings. Kerem approves any further access or operational impact.

### 7.3 MVP Hypothesis

The MVP hypothesis document converts scope into measurable expectations. Each feature cluster must have a hypothesis explaining what behavior should change and how success will be measured.

Required format:

> We believe that [feature] will cause [user type] to [behaviour change], which we will measure by [metric]. We will know this hypothesis is confirmed if [success threshold] within [timeframe].

Recommended table:

| Hypothesis ID | Feature Cluster | User Type | Expected Behavior Change | Metric | Success Threshold | Timeframe | Owner | Status |
| ------------- | --------------- | --------- | ------------------------ | ------ | ----------------- | --------- | ----- | ------ |

Examples using placeholders:

| Feature Cluster      | Example Hypothesis                                                                                                                                                                                                                                                             |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| F&B ordering         | We believe that seat-based F&B ordering will cause gaming customers to place more orders without leaving their session, which we will measure by successful PWA-originated F&B orders. We will know this is confirmed if [NEEDS KEREM APPROVAL] within [NEEDS KEREM APPROVAL]. |
| Wallet visibility    | We believe that wallet visibility will cause customers to ask cashiers fewer balance-related questions, which we will measure by cashier-reported balance inquiries. We will know this is confirmed if [NEEDS KEREM APPROVAL] within [NEEDS KEREM APPROVAL].                   |
| Reservation requests | We believe that digital reservation requests will cause staff to handle reservation intent more consistently, which we will measure by request completion and staff response time. We will know this is confirmed if [NEEDS KEREM APPROVAL] within [NEEDS KEREM APPROVAL].     |

This document becomes the basis for Phase 10 post-launch review.

---

## 8. Phase 5: Prioritisation and Scoping

**Purpose:** Apply filters to the Feature Possibility Map to produce a
principled, reasoned scope. Every inclusion and exclusion must be recorded
with its reasoning.

**Responsible pod:** Pod A drafts. Kerem approves. Pod B validates for
architectural and dependency conflicts.

**Outputs required before Phase 6 begins:**

| Output                     | Document                          | Status                      |
| -------------------------- | --------------------------------- | --------------------------- |
| MVP Scope (with reasoning) | `/docs/MVP_SCOPE.md`              | Partial — reasoning missing |
| Scope Boundary Document    | `/docs/SCOPE_BOUNDARIES.md`       | Missing                     |
| Feature Dependency Map     | `/docs/FEATURE_DEPENDENCY_MAP.md` | Missing                     |
| Phase Gate Criteria        | `/docs/PHASE_GATES.md`            | Missing                     |

### 8.1 MoSCoW Prioritisation with Reasoning

MoSCoW prioritisation is only useful when each classification includes reasoning. A "Must Have" label without a reason becomes a preference, not a decision. A "Won't Have in Phase 1" label without a reason causes future confusion and repeated debate.

Every feature in `MVP_SCOPE.md` must include:

| Field                  | Description                                              |
| ---------------------- | -------------------------------------------------------- |
| Feature                | Name of feature or feature cluster                       |
| MoSCoW classification  | Must / Should / Could / Won't                            |
| Reason                 | Why this classification was chosen                       |
| User or business value | What outcome it supports                                 |
| Dependency             | What must exist first                                    |
| Risk                   | Product, technical, operational, legal, or security risk |
| Evidence               | User research, Kerem input, observation, assumption      |
| Review status          | Kerem approval / Pod B review / Pod D review / pending   |
| Revisit trigger        | When this classification should be reconsidered          |

"Must Have" requires a clear justification such as business-critical operation, foundational dependency, compliance requirement, or necessary pilot capability.

"Won't Have in Phase 1" requires a clear reason, such as:

* Requires payment provider.
* Needs user validation first.
* Depends on Phase 2 PC client.
* Depends on multi-tenant SaaS architecture.
* Requires legal/compliance review.
* Requires Selcafe write access, which is not approved in Phase 1.
* Architectural dependency not ready.

### 8.2 Scope Boundary Document

The Scope Boundary Document records what the project is not building in a given phase and why. It is as important as the scope document because it protects the project from uncontrolled expansion.

The document should be located at `/docs/SCOPE_BOUNDARIES.md`.

Required format:

| Excluded Item | Phase Excluded From | Reason for Exclusion | Dependency / Revisit Trigger | Owner |
| ------------- | ------------------- | -------------------- | ---------------------------- | ----- |

The document should distinguish between:

| Exclusion Type           | Meaning                                                    |
| ------------------------ | ---------------------------------------------------------- |
| Not now                  | Valuable but intentionally deferred                        |
| Not enough evidence      | Needs research or validation                               |
| Blocked by dependency    | Cannot be built until another decision or component exists |
| Out of strategy          | Does not support the approved vision                       |
| Legally/security blocked | Requires compliance or risk work before consideration      |
| Rejected                 | Explicitly not planned unless Kerem reopens                |

Scope boundaries must be reviewed before every phase gate. A deferred item may later become in-scope, but only through the Feature Discovery Pipeline and Kerem approval.

### 8.3 Feature Dependency Map

The Feature Dependency Map shows which features depend on other features, architectural components, decisions, or external providers. It reveals the true critical path and prevents impossible sequencing mid-sprint.

The document should be located at `/docs/FEATURE_DEPENDENCY_MAP.md`.

Recommended format:

| Feature | Depends On | Dependency Type | Blocking? | Owner | Resolution Needed |
| ------- | ---------- | --------------- | --------- | ----- | ----------------- |

Dependency types include:

* Product decision.
* Architecture decision.
* API contract.
* Database schema.
* ADR.
* External vendor.
* Selcafe feasibility.
* KVKK/legal review.
* UX prototype.
* Monitoring/observability requirement.
* Staff training or operational change.

Examples:

| Feature              | Possible Dependency                                           |
| -------------------- | ------------------------------------------------------------- |
| Wallet ledger        | ADR for append-only ledger model and Pod B review             |
| Loyalty redemption   | Loyalty ledger design and Kerem approval of redemption policy |
| F&B ordering         | Product rules for order lifecycle and staff workflow          |
| Reservation approval | Reservation state machine and staff permission model          |
| PC client            | Phase 2 Electron architecture and HIL testing strategy        |
| Online payment       | Payment provider ADR and compliance review                    |

No Pod C issue should be created for implementation until its blocking dependencies are resolved or explicitly accepted as risk.

### 8.4 Phase Gate Criteria

Phase gates are formal decision points between lifecycle phases. They exist to prevent the project from advancing when the required thinking, validation, review, or approval has not happened.

For each transition, `/docs/PHASE_GATES.md` must define measurable criteria. At minimum, it should include:

| Gate                    | Example Criteria                                                         |
| ----------------------- | ------------------------------------------------------------------------ |
| Phase 1 → Phase 2       | Vision, problem statement, north star metric, stakeholder map approved   |
| Phase 2 → Phase 3       | Personas, as-is flows, current journey map, JTBD analysis completed      |
| Phase 3 → Phase 4       | Feature Possibility Map and Opportunity Map completed                    |
| Phase 4 → Phase 5       | Assumption Map completed; low-confidence blockers resolved or accepted   |
| Phase 5 → Phase 6       | MVP scope, scope boundaries, dependency map approved                     |
| Phase 6 → Phase 7       | Roadmap, cadence, risk register approved                                 |
| Phase 7 → Phase 8       | Architecture views, ADRs, schemas, API contracts, security review ready  |
| Phase 8 → Phase 9       | Build complete, tests pass, Definition of Done satisfied                 |
| Phase 9 → Phase 10      | Release completed, monitoring active, pilot/go-live decision recorded    |
| Phase 10 → Next Phase 1 | Metrics reviewed, learning documented, next iteration direction approved |

Gate criteria require Kerem's explicit approval to pass. Pod B may block a gate for unresolved architecture, data, security, or KVKK risk. Pod C may block a gate if implementation readiness is insufficient. Pod D may flag UX, audit, or monitoring gaps, but Kerem decides whether those gaps block phase transition unless the gap is security/KVKK-related.

Per PQ-002, the mandatory Pod D full-project consistency audit must be completed before Phase 1 go-live, before Phase 2 begins, and before Phase 3 tenant architecture is implemented.

---

## 9. Phase 6: Planning and Roadmap

**Purpose:** Translate the approved scope into a delivery plan with milestones,
priorities, and a work rhythm that all pods can operate within.

**Responsible pod:** Pod A drafts. Kerem approves.

**Outputs required before Phase 7 begins:**

| Output                       | Document                          | Status  |
| ---------------------------- | --------------------------------- | ------- |
| Delivery roadmap             | `/docs/ROADMAP.md`                | Partial |
| Sprint or iteration cadence  | This document, Section 9.1        | Missing |
| Dependency and risk register | `/docs/DELIVERY_RISK_REGISTER.md` | Missing |

### 9.1 Work Rhythm and Cadence

<!-- [NEEDS KEREM APPROVAL] -->

The recommended work rhythm is two-week iterations. This cadence is short enough to expose issues early and long enough to complete meaningful planning, architecture review, implementation, test, and feedback loops.

Each iteration should include:

| Moment                  | Participants                                        | Purpose                                                         | Output                                   |
| ----------------------- | --------------------------------------------------- | --------------------------------------------------------------- | ---------------------------------------- |
| Iteration planning      | Kerem + Pod A, with Pod B if architecture-sensitive | Define iteration goal and candidate issues                      | Iteration goal and scoped issue list     |
| Architecture/risk check | Pod B + relevant pod                                | Identify blockers, ADR needs, security/KVKK concerns            | Risk notes and review requirements       |
| Mid-point check         | Kerem + Pod A + Pod B as needed                     | Confirm progress and surface ambiguity                          | Updated issue comments and risk register |
| Build/PR review         | Pod C + Pod B/Kerem as triggered                    | Implement and review work                                       | PRs satisfying Definition of Done        |
| Closeout                | Kerem + relevant pods                               | Review completed work, failed work, and learning                | Iteration summary                        |
| Audit/monitoring review | Pod D as needed                                     | Check UX consistency, monitoring, observability, and audit gaps | Pod D audit report or monitoring notes   |

Between iterations, the project should run:

* Retrospective: what went well, what did not, what changed.
* Backlog grooming: clarify issues, close duplicates, update priority.
* Metrics review: compare actual outcomes to MVP hypotheses.
* Risk register review: update open delivery risks.
* Documentation cleanup: ensure committed docs match decisions made during the iteration.

Iteration cadence may be changed only with Kerem approval.

### 9.2 Delivery Risk Register

The delivery risk register records risks that threaten schedule, clarity, coordination, or rollout. It is distinct from Pod B's architecture/security risk work. Delivery risks are about whether the project can move through the lifecycle reliably.

The document should be located at `/docs/DELIVERY_RISK_REGISTER.md`.

Required format:

| Risk ID | Risk | Category | Impact | Likelihood | Owner | Mitigation | Status |
| ------- | ---- | -------- | ------ | ---------- | ----- | ---------- | ------ |

Delivery risk categories include:

* Unavailable stakeholder.
* Ambiguous requirement.
* Missing approval.
* Third-party/vendor delay.
* Selcafe integration unknown.
* Staff training gap.
* Insufficient test coverage.
* Release timing conflict.
* Scope creep.
* Documentation drift.
* Dependency between pods unclear.

A delivery risk must be updated whenever it becomes more likely, becomes blocked, is mitigated, or requires Kerem approval.

---

## 10. Phase 7: Architecture and Design

**Purpose:** Translate approved scope into implementable architectural
specifications, domain models, API contracts, and database schemas.

**Responsible pod:** Pod B. All significant decisions captured in ADRs.

**Outputs required before Phase 8 begins:**

| Output                   | Document                   | Owner        |
| ------------------------ | -------------------------- | ------------ |
| Architecture viewpoints  | `/docs/architecture/`      | Pod B        |
| Domain model             | `/docs/DOMAIN_MODEL.md`    | Pod B review |
| API contracts            | `/docs/api/`               | Pod B        |
| Database schemas         | `/docs/schema/`            | Pod B        |
| ADR backlog resolved     | `/docs/adr/`               | Pod B        |
| Security and KVKK review | `/docs/SECURITY_REVIEW.md` | Pod B        |

In Phase 7, Pod A hands Pod B the approved product inputs needed to design the system safely. These inputs include the product brief, MVP scope, business rules, user roles and permissions, core user flows, assumptions, open questions, feature dependency map, and any Kerem-approved scope boundaries.

Pod B returns architecture outputs that translate product intent into implementable design. These outputs include domain model review, API contracts, database schema, state machines, ADRs, integration boundaries, security review, and KVKK risk review.

Kerem does not need to approve every technical detail, but Kerem must review architecture outputs when they affect product behavior, operational policy, data handling, cost, vendor lock-in, customer experience, staff workflow, wallet/loyalty/payment logic, or launch risk. Pod B should clearly mark which architecture decisions are purely technical and which require Kerem approval.

Pod A remains involved during Phase 7 to clarify requirements, update open questions, and ensure that architecture outputs still match the approved product intent. Pod A does not approve architecture.

### 10.1 Architecture Viewpoints Required

Per ISO/IEC/IEEE 42010, Pod B must produce or review the following views
before Phase 8 begins:

| View             | Purpose                                    | Document                                 |
| ---------------- | ------------------------------------------ | ---------------------------------------- |
| Context view     | System boundary, external actors           | `/docs/architecture/CONTEXT_VIEW.md`     |
| Container view   | NestJS, Next.js, PostgreSQL, local gateway | `/docs/architecture/CONTAINER_VIEW.md`   |
| Module view      | Domain modules and boundaries              | `/docs/architecture/MODULE_VIEW.md`      |
| Data view        | Ledgers, orders, reservations, audit logs  | `/docs/architecture/DATA_VIEW.md`        |
| Integration view | SelcafeAdapter, CafeManagementAdapter      | `/docs/architecture/INTEGRATION_VIEW.md` |
| Deployment view  | Local network, staging, production         | `/docs/architecture/DEPLOYMENT_VIEW.md`  |
| Security view    | Auth, RBAC, audit, data protection         | `/docs/architecture/SECURITY_VIEW.md`    |
| Operational view | Monitoring, logging, backup, recovery      | `/docs/architecture/OPERATIONAL_VIEW.md` |

---

## 11. Phase 8: Build and Test

**Purpose:** Implement specifications produced in Phase 7, with full test
coverage and CI/CD gates.

**Responsible pod:** Pod C. Pod B reviews security-sensitive and
financially-sensitive PRs before merge.

Pod C builds only from GitHub issues that satisfy the Definition of Ready. Each issue should reference the product document, business rule, user flow, ADR, API contract, database schema, or security review that defines the work.

The build workflow is:

1. Pod A or Pod B drafts an implementation-ready GitHub issue.
2. Kerem approval is recorded if the issue affects scope, operations, customer data, wallet, loyalty, payment, refund, or permissions.
3. Pod B review is recorded if the issue affects architecture, schema, integration, security, or KVKK.
4. Pod C creates a feature branch from the approved base branch.
5. Pod C implements the issue without expanding scope beyond the acceptance criteria.
6. Pod C adds or updates required tests.
7. Pod C opens a PR with a clear description of what changed and why.
8. CI must pass linting, type-checking, tests, build, and any configured security/dependency checks.
9. Required human reviews are completed.
10. The PR is merged only when the Definition of Done is satisfied.

Pod C must not merge directly to `main`. Pod C must not make hidden scope decisions in code. If the implementation reveals a missing business rule, unclear state, inconsistent API expectation, or compliance risk, Pod C must stop and route the issue back to the appropriate pod.

Reference the Definition of Ready in Section 14 and the Definition of Done in Section 15.

### 11.1 Mandatory Human Approval Triggers

<!-- [LOCKED] The following PR categories require human approval before merge.
     Authoritative source: ADR-009 §3. In the event of any conflict between
     this table and ADR-009 §3, ADR-009 §3 governs.
     This table was aligned to ADR-009 §3 in v0.6 (2026-06-07, BC-2 Option A,
     Kerem-approved). Issue #26 / PR-A documents the correction. -->

| Trigger Category                                              | Required Approver |
| ------------------------------------------------------------- | ----------------- |
| Wallet ledger logic                                           | Kerem + Pod B     |
| Loyalty ledger logic                                          | Kerem + Pod B     |
| Authentication and authorisation                              | Pod B             |
| Customer personal data handling                               | Pod B + Kerem     |
| Security-sensitive PR (incl. security-sensitive admin actions) | Pod B + Kerem    |
| Selcafe adapter or Selcafe integration changes                | Pod B + Kerem     |
| Audit log schema or logic                                     | Pod B             |
| Database / schema migration                                   | Pod B + Kerem     |
| Payment logic (Phase 2+)                                      | Kerem + Pod B     |
| Admin privilege changes                                       | Kerem             |
| Refund logic                                                  | Kerem + Pod B     |

### 11.2 Hardware-in-the-Loop Testing (Phase 2)

<!-- Phase 2 specific — not required for Phase 1 -->

Hardware-in-the-Loop testing is required before any Phase 2 Electron PC client code is deployed to physical Adeks PCs. The purpose is to test PC-client behavior in a controlled environment that simulates the local network, backend communication, and device-specific constraints without risking live café operation.

The HIL approach should include a mock local network environment with:

| Component                      | Purpose                                                    |
| ------------------------------ | ---------------------------------------------------------- |
| Mock Electron client           | Simulates the PC client application                        |
| Mock local gateway             | Simulates local network communication and adapter behavior |
| Test backend                   | Validates API and session state interaction                |
| Synthetic PC inventory         | Represents the 130 gaming PCs without using live machines  |
| Network condition simulation   | Tests latency, disconnects, retries, and offline states    |
| Logging and monitoring capture | Confirms observability before physical deployment          |

Testing checklist:

* Client starts and identifies its PC using synthetic station data.
* Client displays assigned session state correctly.
* Client handles backend unavailable state safely.
* Client handles local gateway unavailable state safely.
* Client does not expose admin functions to customer users.
* Client does not store sensitive data locally beyond approved design.
* Client recovers from network interruption.
* Client logs errors without leaking personal data.
* Client cannot perform wallet, loyalty, or session mutations outside approved API paths.
* Client can be disabled or rolled back centrally.
* Client behavior is tested against synthetic examples only.
* Pod B reviews security and architecture implications before physical pilot.
* Kerem approves any deployment to live PCs.

HIL test results must be documented before Phase 2 pilot deployment.

---

## 12. Phase 9: Release and Operate

**Purpose:** Deliver built and tested software to production safely, with
rollback capability, monitoring, and incident response ready before go-live.

**Responsible pod:** Pod C for release execution.
Pod D for monitoring specification.
Kerem for go/no-go approval.

### 12.1 Environment Model

| Environment    | Purpose                     | Real Data Allowed?             |
| -------------- | --------------------------- | ------------------------------ |
| Local          | Developer testing           | Synthetic only                 |
| Test           | Automated CI validation     | Synthetic only                 |
| Staging        | Kerem and staff UAT         | Synthetic only [LOCKED — KVKK] |
| Production     | Live Adeks operation        | Yes, with full KVKK controls   |
| Demo / Sandbox | Future SaaS sales (Phase 3) | Synthetic only                 |

Non-production environments must use synthetic-only data to reduce KVKK exposure and prevent accidental leakage of real customer names, phone numbers, transaction history, wallet records, loyalty records, or staff activity. Staging is for UAT, not for copying production data.

Synthetic test data should be maintained as a documented fixture set. It should include realistic but fake customers, phone numbers, orders, sessions, wallet events, loyalty events, reservations, staff users, and audit logs. Examples must use synthetic values such as Customer A, Customer B, and +90 555 000 00 01.

Synthetic data should be versioned with the codebase where appropriate, resettable, and safe to use in automated tests. Any request to use production data outside production must be treated as a KVKK-sensitive exception requiring Kerem and Pod B review.

### 12.2 Release Process

The release process must be repeatable and documented. The detailed checklist belongs in `/docs/RELEASE_PROCESS.md`.

Minimum release steps:

1. Confirm the release candidate has passed CI.
2. Confirm all PRs satisfy Definition of Done.
3. Confirm required Pod B and Kerem approvals are recorded.
4. Deploy to staging.
5. Run staging smoke tests.
6. Run UAT with Kerem and selected staff using synthetic data.
7. Prepare release notes.
8. Confirm rollback plan.
9. Confirm monitoring and alerting are active.
10. Hold go/no-go gate with Kerem.
11. Deploy to production.
12. Run post-deployment smoke test.
13. Verify monitoring, logs, and error tracking.
14. Keep the release under observation during the post-release monitoring window.
15. Record release outcome and any follow-up issues.

No production release should occur without a rollback path and an incident contact path.

### 12.3 Zero-Downtime Migration Policy

<!-- [LOCKED PROCESS] -->

All PostgreSQL schema migrations must follow the Expand-and-Contract pattern.
No migration may lock tables during production hours.

The Expand-and-Contract pattern means database changes are made in safe steps instead of one risky breaking change.

In plain language:

1. **Expand:** Add the new table, column, index, or structure while keeping the old one.
2. **Run compatible code:** Deploy application code that can work with both old and new structures.
3. **Backfill:** Move or copy data safely if needed.
4. **Switch usage:** Confirm the application now uses the new structure.
5. **Contract:** Remove the old structure only after it is no longer needed and rollback risk is acceptable.

This avoids breaking the application while users are active.

For Adeks, "production hours" means any period when the café is open, PCs are in use, customers may be ordering, and staff may be using operational screens. Migrations that can affect availability, performance, table locks, wallet/loyalty records, orders, reservations, or audit logs must be scheduled outside active business operation where possible and must have a rollback or mitigation plan.

If the café operates continuously, migration scheduling must be handled as a controlled maintenance window approved by Kerem. Staff must be informed before any maintenance that may affect live operation.

### 12.4 Rollback Policy

A rollback is triggered when a release causes unacceptable operational, financial, security, data, or customer-experience impact and a fast forward-fix is not safer than reverting.

Rollback may be called by:

| Role                  | Can Call Rollback?                                                    | Scope                                                     |
| --------------------- | --------------------------------------------------------------------- | --------------------------------------------------------- |
| Kerem                 | Yes                                                                   | Any production release                                    |
| Pod C                 | Yes, for technical release failure, with Kerem notified immediately   | Deployment, build, environment failure                    |
| Pod B                 | Yes, for security, data, schema, integration, or financial logic risk | Security-sensitive or data-sensitive release              |
| Pod D                 | Can recommend rollback                                                | UX, monitoring, observability, or operational degradation |
| Cashier/manager staff | Can escalate rollback need                                            | Operational failure observed during live use              |

Rollback is mandatory when one of the following occurs:

* Wallet or loyalty balances/events appear incorrect.
* Authentication or authorisation failure exposes restricted functionality.
* Customer personal data is exposed incorrectly.
* Cashier/admin workflows become unusable.
* F&B ordering causes significant operational confusion or lost orders.
* Reservation workflow creates duplicate or conflicting commitments.
* Monitoring shows repeated critical errors after deployment.
* Data migration causes unexpected data loss, corruption, or severe performance degradation.
* The platform cannot recover within [NEEDS KEREM APPROVAL — recommended maximum downtime threshold].

Detailed rollback execution belongs in `/docs/ROLLBACK_POLICY.md`.

### 12.5 Feature Flagging and Staged Rollout

<!-- [NEEDS KEREM APPROVAL — tool selection for feature flagging] -->

Feature flags allow the project to enable or disable specific features without a full redeploy. This is important because the café may be operating continuously and new features should be tested with limited exposure before full rollout.

Pod B will recommend the feature flag tool through an ADR. This section defines the business process.

Rollout stages:

| Stage                     | Audience                                          | Purpose                               |
| ------------------------- | ------------------------------------------------- | ------------------------------------- |
| Internal staff            | Kerem, cashiers, admins                           | Verify operational behavior           |
| Controlled customer group | Invited regular customers or selected pilot users | Validate real usage with limited risk |
| Expanded customer group   | Larger subset                                     | Confirm scale and support readiness   |
| General availability      | All eligible users                                | Full rollout                          |

Responsibilities:

| Action                      | Owner                                        |
| --------------------------- | -------------------------------------------- |
| Request feature flag        | Pod A or Pod C                               |
| Approve business exposure   | Kerem                                        |
| Review risk before enabling | Pod B                                        |
| Configure and deploy flag   | Pod C                                        |
| Monitor behavior            | Pod D + Pod C                                |
| Review product outcome      | Pod A + Kerem                                |
| Disable flag if needed      | Pod C, with Kerem/Pod B depending on trigger |

A feature flag should move to full rollout only when acceptance criteria, monitoring, support readiness, staff feedback, and pilot metrics are acceptable. A flag must be rolled back or disabled if it creates operational confusion, financial inconsistency, security risk, customer-data risk, or repeated support issues.

---

## 13. Phase 10: Learn and Iterate

**Purpose:** Measure whether the platform is achieving its goals, capture
learning, and feed insights back into Phase 1 of the next iteration.

**Responsible pod:** Pod A owns the learning process.
Kerem reviews metrics and approves next iteration direction.
Pod D owns the analytics and monitoring data collection.

### 13.1 Post-Launch Validation Plan

Each MVP hypothesis in `/docs/MVP_HYPOTHESIS.md` must be reviewed after launch. The review determines whether the hypothesis was confirmed, partially confirmed, refuted, or inconclusive.

Recommended review cadence:

| Review Point             | Purpose                                                     |
| ------------------------ | ----------------------------------------------------------- |
| Two weeks post-launch    | Detect early adoption, friction, bugs, and staff confusion  |
| One month post-launch    | Evaluate whether behavior is changing beyond novelty effect |
| Three months post-launch | Decide whether to double down, revise, defer, or remove     |

For each hypothesis, the review must record:

| Field           | Description                                              |
| --------------- | -------------------------------------------------------- |
| Hypothesis ID   | Link to `/docs/MVP_HYPOTHESIS.md`                        |
| Metric reviewed | The agreed measurement                                   |
| Target          | Success threshold approved by Kerem                      |
| Actual result   | Measured outcome                                         |
| Status          | Confirmed / partially confirmed / refuted / inconclusive |
| Interpretation  | Why the result happened                                  |
| Decision        | Continue / improve / remove / defer / expand             |
| Follow-up issue | Link to GitHub issue if action is needed                 |

Kerem reviews the outcomes and approves the next iteration direction. Pod A documents product interpretation. Pod D provides analytics and monitoring data. Pod B is involved if the learning implies architecture, security, data, or compliance changes.

### 13.2 Product Metrics

Phase 1 product metrics must be defined before launch and reviewed after release. Targets require Kerem approval because they express business expectations, not just technical measurements.

Minimum required metrics:

| Area               | Metric                                                                 | Target                 | Review Cadence |
| ------------------ | ---------------------------------------------------------------------- | ---------------------- | -------------- |
| Wallet             | Wallet visibility usage rate or cashier-assisted top-up success rate   | [NEEDS KEREM APPROVAL] | Weekly         |
| F&B ordering       | Successful seat-originated F&B orders                                  | [NEEDS KEREM APPROVAL] | Weekly         |
| Loyalty            | Loyalty visibility usage or eligible loyalty events recorded correctly | [NEEDS KEREM APPROVAL] | Weekly         |
| Reservations       | Reservation requests submitted and staff response completion           | [NEEDS KEREM APPROVAL] | Weekly         |
| PWA adoption       | Active PWA users among eligible customers                              | [NEEDS KEREM APPROVAL] | Weekly         |
| System reliability | Uptime SLO                                                             | [NEEDS KEREM APPROVAL] | Daily          |

Reference `/docs/PRODUCT_METRICS.md` for the full metrics specification.

Each metric must define:

* Event source.
* Calculation method.
* Owner.
* Review cadence.
* Target.
* Alert threshold if applicable.
* Known limitations.
* Whether it uses personal data.
* Whether it requires KVKK review.

### 13.3 Retrospective Cadence

A retrospective should occur at the end of each two-week iteration. The retrospective is not a blame process. It is a method for improving how the project runs.

Standard format:

```md
# RETRO_[DATE].md

## Iteration Summary

## What Went Well

## What Did Not Go Well

## What We Learned

## Methodology Changes Proposed

## Decisions Needed from Kerem

## Action Items
| Action | Owner | Due / Review Point | Status |
|---|---|---|---|
```

Retrospectives are committed to `/docs/retrospectives/RETRO_[DATE].md`.

Action items from a retrospective must be assigned to an owner. Methodology changes must not be applied informally. If they change this document, they require Kerem approval and a revision log entry.

### 13.4 Feedback Capture Mechanism

<!-- [NEEDS KEREM APPROVAL] -->

Feedback must have a single visible intake path so that cashier complaints, customer confusion, and operational friction do not remain informal comments.

Recommended intake model:

| Feedback Source    | Intake Point                                                       | Recording Location                      |
| ------------------ | ------------------------------------------------------------------ | --------------------------------------- |
| Cashier staff      | Kerem or assigned shift lead                                       | GitHub issue or feedback log            |
| F&B staff          | Kerem or assigned shift lead                                       | GitHub issue or feedback log            |
| Customers          | Staff report, PWA feedback form if approved, or direct Kerem input | Feedback log with synthetic description |
| Monitoring alerts  | Pod D / Pod C                                                      | Incident or bug issue                   |
| Pod audit findings | Pod D                                                              | Audit report and linked issue           |

Triage process:

1. Feedback is captured in writing.
2. Personal data is removed or replaced with synthetic references.
3. Pod A classifies the feedback as product issue, bug, operational friction, feature idea, or support/training issue.
4. Pod B is tagged if the feedback affects architecture, data, security, Selcafe, or KVKK.
5. Pod C is tagged if it is a confirmed implementation bug.
6. Kerem decides priority if the feedback affects scope, customer promise, staff policy, or launch readiness.

Critical bugs must be acknowledged as soon as they are seen by the responsible project owner and recorded in the issue tracker. Severity definitions and response expectations should be defined in `/docs/BUG_TRIAGE_PROCESS.md`.

---

## 14. Definition of Ready

An issue is ready for Pod C to begin work only when all of the following
are confirmed. Pod C must reject issues that do not meet this standard
and request the missing items from Pod A before starting.

| Criterion                                                             | Required |
| --------------------------------------------------------------------- | -------- |
| Business context — why this feature exists                            | ✅        |
| Scope — what is included                                              | ✅        |
| Non-goals — what is explicitly excluded                               | ✅        |
| Acceptance criteria — specific, testable                              | ✅        |
| Required tests — unit, integration, E2E as applicable                 | ✅        |
| Linked documents — ADRs, schemas, API contracts                       | ✅        |
| Risk category — standard / security-sensitive / financially-sensitive | ✅        |
| Pod B review status — approved / not required (with reason)           | ✅        |
| Kerem approval status — approved / not required (with reason)         | ✅        |
| Synthetic data examples where relevant                                | ✅        |

The feature issue template should be placed at `.github/ISSUE_TEMPLATE/feature.md`.

Required template:

```md
---
name: Feature
about: Implementation-ready feature or product requirement
title: "[Feature]: "
labels: ["feature", "needs-triage"]
assignees: ""
---

## Business Context

Explain why this feature exists and what user or business problem it addresses.

## Scope

List what is included.

## Non-Goals

List what is explicitly excluded.

## User Story

As a [user type], I want [capability], so that [benefit].

## Acceptance Criteria

- [ ] Given [context], when [action], then [expected result].
- [ ] Given [context], when [action], then [expected result].

## Required Tests

- [ ] Unit tests:
- [ ] Integration tests:
- [ ] E2E tests:
- [ ] Contract tests:
- [ ] Manual UAT:

## Linked Documents

- Product / planning document:
- Business rules:
- User flow:
- ADR:
- API contract:
- Database schema:
- Security/KVKK review:

## Risk Category

Select one:

- [ ] Standard
- [ ] Security-sensitive
- [ ] Financially-sensitive
- [ ] Customer-data-sensitive
- [ ] Selcafe-integration-sensitive
- [ ] Operationally critical

## Review Status

### Pod B Review

- [ ] Approved
- [ ] Not required

Reason:

### Kerem Approval

- [ ] Approved
- [ ] Not required

Reason:

## Synthetic Data Examples

Use synthetic examples only. No real customer names, phone numbers, transaction data, or staff records.

Example:

- Customer A
- +90 555 000 00 01
- PC-001
- Order #SYN-001

## Open Questions

- [ ] None
- [ ] Listed below

## Definition of Ready Checklist

- [ ] Business context included
- [ ] Scope included
- [ ] Non-goals included
- [ ] Acceptance criteria are specific and testable
- [ ] Required tests listed
- [ ] Linked documents included
- [ ] Risk category selected
- [ ] Pod B review status recorded
- [ ] Kerem approval status recorded
- [ ] Synthetic data examples included where relevant
```

---

## 15. Definition of Done

A PR is done only when all of the following are confirmed.
Pod C must not merge a PR that does not meet this standard.

| Criterion                                                    | Required |
| ------------------------------------------------------------ | -------- |
| All acceptance criteria from the issue are met               | ✅        |
| Unit tests written and passing                               | ✅        |
| Integration tests written and passing where applicable       | ✅        |
| CI pipeline passes (lint, type-check, test, build)           | ✅        |
| Security-sensitive areas reviewed by Pod B (if triggered)    | ✅        |
| Financially-sensitive areas approved by Kerem (if triggered) | ✅        |
| Documentation updated if behaviour changed                   | ✅        |
| Migration reviewed by Pod B if schema changed                | ✅        |
| Rollback notes included if deployment-impacting              | ✅        |
| No real personal data used in tests or examples              | ✅        |
| PR description explains what changed and why                 | ✅        |

The live PR template is maintained at `.github/PULL_REQUEST_TEMPLATE.md`.
That file is the single source of truth for PR structure, checklist items,
and review triggers. Do not maintain a duplicate template here — divergence
creates inconsistency.

Authoritative review triggers and approval requirements are defined in
**ADR-009 §3**. Authoritative behavior-change gate requirements (Pod Impact
Matrix, Instruction Update Packet) are defined in **ADR-009 §4**. In the
event of any conflict between this document and ADR-009, ADR-009 governs.

---

## 16. Inter-Pod Handoff Protocol

Every handoff must be written, traceable, and linked to a repository artifact. A chat message can initiate a handoff, but the durable handoff package must live in a document, issue, PR, ADR, audit report, or review comment.

| Transition      | Trigger                                                                                          | Handoff Package                                                                                  | Expected Turnaround                                  | Acceptance Check                                                        |
| --------------- | ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ | ---------------------------------------------------- | ----------------------------------------------------------------------- |
| Kerem → Pod A   | New feature idea, product question, business concern, scope decision, or operational observation | Plain-language prompt, existing context, desired output, decision constraints, known approvals   | Next active Pod A session                            | Pod A confirms knowns, assumptions, open questions, and target document |
| Pod A → Pod B   | Product/planning document ready for architecture, risk, security, data, or integration review    | Markdown draft, review routing, assumptions, open questions, sensitive areas, required decisions | Next review cycle; priority if blocking Pod C        | Pod B returns blocking/non-blocking/advisory findings                   |
| Pod B → Pod A   | Architecture findings require product decision, scope change, or business-rule clarification     | Written finding with options, trade-offs, risk, and recommended product question                 | Next active Pod A/Kerem session                      | Pod A updates docs or routes decision to Kerem                          |
| Pod B → Pod C   | Specification ready for implementation                                                           | Approved ADRs, API contracts, schemas, state machines, security notes, linked issue              | When issue meets Definition of Ready                 | Pod C confirms issue is implementable without guessing                  |
| Pod C → Pod B   | PR requires security, architecture, schema, integration, or financial review                     | PR link, summary, risk trigger, test evidence, migration notes if any                            | Before merge; priority if release-blocking           | Pod B approves, requests changes, or escalates                          |
| Pod D → Pod B   | Audit finding requires architecture, monitoring, security, or operational response               | Audit report with evidence, severity, recommended action, affected documents                     | Next review cycle; urgent if launch/security-related | Pod B classifies risk and decides architecture response                 |
| Pod D → Pod A   | UX, journey, staff workflow, or prototype finding requires product response                      | Audit/prototype note with affected user, flow, evidence, and product question                    | Next active Pod A session                            | Pod A updates product docs, backlog, or open questions                  |
| Any pod → Kerem | Decision requires product owner approval                                                         | Written decision request with options, recommendation, impact, and default if no action          | As soon as decision is blocking                      | Kerem records approval/rejection in GitHub-visible form                 |

Handoff package minimum fields:

```md
## Handoff Summary

## Source Pod

## Target Pod

## Trigger

## Relevant Links

## Decision or Review Needed

## Assumptions

## Open Questions

## Risk / Sensitivity

## Expected Output
```

A handoff is accepted only when the receiving pod can act without relying on unstated context.

### 16.1 Automatic Handoff Prompt Rule

At the end of any AI pod session that produces outputs requiring action
from another pod, the producing pod must automatically generate a
ready-to-send handoff prompt for each receiving pod, without waiting to
be asked.

Each generated prompt must:
- Be copy-paste ready into the receiving pod's tool, with no editing required
- Follow the handoff package minimum fields defined in Section 16
- Name the exact input files to attach (repository paths)
- State the exact task and the expected output artifact
- Reference the constraints and locked principles relevant to the task as
  they exist in the current /docs — reference them, do not restate a
  private copy that can drift
- Specify the reviewer and approver per the Section 16 transition table
  and the Section 28.1 ownership table; do not invent a reviewer

This rule applies whenever a session produces an artifact another pod must
act on, including: reviewed documents, ADRs, decision records, schemas,
API contracts, state machines, audit reports, monitoring specs, and
prototype/spike specifications.

If a required handoff prompt was already produced earlier in the same
session and nothing changed after it, the pod reuses it verbatim rather
than regenerating it.

Handoffs to Kerem follow the "Any pod → Kerem" row of the Section 16
table: a written decision request with options, recommendation, impact,
and the default if no action is taken — not a tool prompt.

---

## 17. Escalation and Conflict Resolution

When pods disagree or a specification is unclear, the project follows a written escalation path. No AI pod can unilaterally resolve a conflict affecting product scope, financial logic, security posture, or KVKK compliance.

Escalation path:

1. **Pod-level resolution.**
   The two pods involved attempt to resolve the issue in writing. They must document the options, trade-offs, affected files, and proposed resolution.

2. **Pod B arbitration for technical disagreements.**
   For technical, architectural, data, security, integration, or infrastructure disagreements, Pod B provides a recommendation. This recommendation is advisory unless it concerns a security, KVKK, or locked-principle risk that requires escalation.

3. **Kerem escalation for product-impacting disagreements.**
   If the disagreement affects product scope, business rules, customer experience, staff workflow, financial logic, launch timing, or commercial strategy, Kerem makes the final decision. The decision must be recorded in a GitHub issue comment, PR comment, ADR approval, or committed document.

4. **Locked principle conflicts.**
   If any pod identifies a genuine conflict with a locked principle, it must tag the issue with `[LOCKED PRINCIPLE CONFLICT]` and escalate to Kerem immediately. Work on the affected area pauses until resolved.

Conflict record template:

```md
## Conflict Summary

## Pods Involved

## Affected Area

## Options

| Option | Pros | Cons | Risk |
|---|---|---|---|

## Recommendation

## Required Decision Owner

## Final Decision

## Follow-Up Actions
```

No conflict should be resolved only in chat. The final decision must be captured in the repository.

---

## 18. Feature Discovery Pipeline

The feature discovery pipeline controls how new ideas move from first mention to backlog entry, deferral, rejection, or build readiness. It prevents two failure modes:

1. Good ideas being lost because they were mentioned informally and never recorded.
2. Unvalidated ideas entering the build queue without proper assessment.

Pipeline:

| Step                           | Owner                           | Output                                         |
| ------------------------------ | ------------------------------- | ---------------------------------------------- |
| 1. Idea capture                | Any pod or Kerem                | Entry in `/docs/FEATURE_POSSIBILITY_MAP.md`    |
| 2. Opportunity note            | Pod A                           | Entry in `/docs/FEATURE_BACKLOG.md`            |
| 3. Architecture/risk scan      | Pod B                           | Risk/dependency notes                          |
| 4. Prioritisation decision     | Kerem                           | Priority and decision status                   |
| 5. Phase assignment            | Pod A drafts, Kerem approves    | Phase 1 / Phase 2 / Phase 3 / later / rejected |
| 6. Definition of Ready process | Pod A + Pod B + Kerem as needed | GitHub issue ready for Pod C                   |
| 7. Deferred/rejected recording | Pod A                           | Backlog entry with reason and review trigger   |

The Feature Possibility Map is raw. The Feature Backlog is assessed. GitHub issues are implementation-ready only after the Definition of Ready is satisfied.

Opportunity note template:

```md
## Opportunity: [Name]

| Field | Description |
|---|---|
| Source | Kerem / Pod / staff / customer / audit / competitor |
| User or stakeholder | Who benefits |
| Problem or opportunity | What this addresses |
| Expected value | Business or user value |
| Evidence | Observation, data, assumption |
| Risks | Product, technical, operational, legal, security |
| Dependencies | Required decisions, components, vendors, research |
| Pod B scan needed | Yes / no |
| Kerem decision | Approved / deferred / rejected / pending |
| Phase assignment | 1 / 2 / 3 / later / rejected |
| Review trigger | When to revisit |
```

Reference `/docs/FEATURE_DISCOVERY_WORKFLOW.md` for the detailed template.

---

## 19. ADR Policy

An Architecture Decision Record is the durable record of an important decision. ADRs prevent the project from re-litigating the same choices across chat sessions, pods, and future phases.

A decision needs an ADR when it:

* Affects system architecture, data model, deployment, integration, security, or operations.
* Creates long-term constraints or migration cost.
* Selects a major framework, library, provider, or infrastructure pattern.
* Affects wallet, loyalty, payment, refund, audit, or customer-data handling.
* Establishes a pattern other teams or pods must follow.
* Changes or supersedes a previous ADR.
* Is expensive or risky to reverse.

Standard ADR template:

```md
# ADR-[ID]: [Decision Title]

## Status

Proposed / Accepted / Superseded

## Context

What problem or decision point exists?

## Decision

What decision was made?

## Consequences

What becomes easier, harder, safer, riskier, or constrained?

## Alternatives Considered

What alternatives were evaluated and why were they not chosen?

## Approval

- Author:
- Reviewer:
- Approver:
- Date:
```

ADRs live in `/docs/adr/`.

Authorship:

| ADR Type                         | Author         | Reviewer                         | Approver      |
| -------------------------------- | -------------- | -------------------------------- | ------------- |
| Technical architecture           | Pod B          | Pod C as needed                  | Pod B         |
| Product-impacting architecture   | Pod B          | Pod A                            | Kerem         |
| Product/process decision         | Pod A          | Pod B if technical impact exists | Kerem         |
| Security/KVKK-sensitive decision | Pod B          | Kerem                            | Kerem + Pod B |
| Vendor/data-processing decision  | Pod B or Pod A | Pod C as needed                  | Kerem         |

Old ADRs are never deleted. If an ADR needs to change, a new ADR supersedes the old one and explains why.

Current ADR backlog to be resolved by Pod B in priority order:

| ID      | Decision                            | Priority                    |
| ------- | ----------------------------------- | --------------------------- |
| ADR-001 | Modular monolith architecture       | High                        |
| ADR-002 | TypeScript / NestJS / Next.js stack | High                        |
| ADR-003 | PostgreSQL database family          | High                        |
| ADR-004 | ORM selection (Prisma vs Drizzle)   | **Critical — blocks Pod C** |
| ADR-005 | Selcafe read-only Phase 1 adapter   | High                        |
| ADR-006 | Wallet append-only ledger           | High                        |
| ADR-007 | Loyalty append-only ledger          | High                        |
| ADR-008 | Schema-per-tenant tenancy strategy  | High                        |
| ADR-009 | PR approval policy                  | High                        |
| ADR-010 | Real-time transport selection       | Phase 2                     |
| ADR-011 | Payment provider                    | Phase 2                     |
| ADR-012 | Feature flag tool selection         | Before Phase 1 go-live      |

---

## 20. Security and KVKK Process

<!-- [LOCKED PRINCIPLE — Human approval required for all items in this section] -->

### 20.1 Secure SDLC

The secure development lifecycle applies security thinking from discovery through release. Security is not a final checklist after implementation. It must be included in requirements, architecture, issue readiness, code review, tests, deployment, and operations.

The process is grounded in NIST SSDF and OWASP SAMM principles at a practical project level:

| Stage               | Required Security Activity                                                                        |
| ------------------- | ------------------------------------------------------------------------------------------------- |
| Discovery and scope | Identify sensitive workflows, customer data, money-like value, staff permissions, and abuse cases |
| Architecture        | Pod B threat model for high-risk features                                                         |
| Issue readiness     | Risk category recorded before Pod C starts                                                        |
| Build               | Secure coding, least privilege, input validation, safe error handling                             |
| CI                  | SAST, dependency scanning, tests, build gates                                                     |
| Review              | Pod B review for mandatory trigger areas                                                          |
| Release             | Monitoring, rollback, incident path, access control verification                                  |
| Operate             | Security regression tracking, incident review, dependency update cadence                          |

Threat modelling is required for high-risk features, including wallet, loyalty, payments, authentication, authorisation, admin actions, audit logs, customer data access, Selcafe adapter ingestion, and third-party integrations.

Wallet and loyalty require abuse cases, not only normal use cases. Examples:

* Staff attempts unauthorised balance adjustment.
* Duplicate top-up event is submitted.
* Customer attempts to redeem more value than allowed.
* Ledger event is replayed.
* Admin role grants itself extra privileges.
* Audit log is missing for sensitive action.

CI should include SAST/DAST where appropriate, dependency scanning such as Trivy or Snyk, and security regression tests for critical flows. Tool selection belongs to Pod B and Pod C, with Kerem approval where vendor/data-processing impact exists.

Reference `/docs/SECURE_SDLC.md` for the detailed process.

### 20.2 KVKK Compliance Process

KVKK compliance is not satisfied by saying the project values privacy. Each obligation must be documented, assigned, implemented, and reviewed.

The KVKK process must cover these obligations:

| Obligation                                   | Owner                                                                           | Required Artifact / Action                     |
| -------------------------------------------- | ------------------------------------------------------------------------------- | ---------------------------------------------- |
| VERBİS registration                          | Kerem + external legal/privacy advisor                                          | [NEEDS KEREM APPROVAL — legal action required] |
| Data processing inventory                    | Pod A drafts, Pod B reviews, Kerem approves                                     | `/docs/DATA_PROCESSING_INVENTORY.md`           |
| Legal basis documentation per data type      | Kerem + legal/privacy advisor, Pod A supports                                   | `/docs/KVKK_LEGAL_BASIS.md`                    |
| Privacy notice (Aydınlatma Metni) in the PWA | Kerem + legal/privacy advisor, Pod C implements approved text                   | `/docs/PRIVACY_NOTICE_TR.md` and PWA copy      |
| Data subject rights process (Art. 11)        | Kerem owns, Pod A documents workflow, Pod C implements support if needed        | `/docs/DATA_SUBJECT_RIGHTS_PROCESS.md`         |
| 72-hour breach notification process          | Kerem owns, Pod B defines security incident criteria, Pod C/D support detection | `/docs/BREACH_NOTIFICATION_PROCESS.md`         |
| Data retention policy                        | Kerem approves, Pod B reviews data impact                                       | `/docs/DATA_RETENTION_POLICY.md`               |
| Cross-border transfer rules                  | Kerem + legal/privacy advisor; depends on hosting/provider decisions            | `/docs/CROSS_BORDER_TRANSFER_ASSESSMENT.md`    |
| Phone number as primary PII identifier       | Pod B reviews, Pod A documents usage rules, Kerem approves                      | Included in data inventory and privacy notice  |

Every feature that collects, displays, stores, transmits, or modifies personal data must link to the data processing inventory. Phone number handling requires explicit care because it is likely to be the primary customer identifier.

No real customer personal data may be used in local, test, staging, demo, screenshots, documentation examples, or AI prompts. Production data may only be used in production with approved access controls and auditability.

### 20.3 Mandatory Security Review Triggers

The following code areas require Pod B security review before merge:

* Authentication and session management
* Authorisation and RBAC logic
* Wallet and loyalty ledger writes
* Customer personal data access or mutation
* Audit log logic
* Selcafe adapter data ingestion
* Admin privilege escalation
* Any new third-party integration

---

## 21. QA and Test Strategy

The test strategy follows a layered model. The goal is not only to prove that code runs, but to protect critical business workflows from regression.

Test pyramid:

| Test Type         | Scope                                                   | Examples                                                  |
| ----------------- | ------------------------------------------------------- | --------------------------------------------------------- |
| Unit tests        | Pure business logic and domain services                 | Ledger calculations, eligibility rules, state transitions |
| Integration tests | API endpoints, database interactions, adapter contracts | Order creation API, reservation approval, audit log write |
| E2E tests         | Critical user flows                                     | PWA F&B order, cashier top-up, reservation request        |
| Contract tests    | Boundaries between components                           | PWA ↔ backend API, backend ↔ SelcafeAdapter               |
| Manual UAT        | Realistic staff/customer workflow validation in staging | Kerem and staff validate end-to-end operation             |

Critical regression flows that must never break:

* Wallet top-up (cashier-initiated).
* Loyalty earn on eligible purchase.
* Loyalty redemption (cashier-handled).
* F&B order from seat.
* Reservation request and staff approval.
* Audit log for all sensitive actions.
* Authentication and role-based access.
* Customer personal data display and update.
* Selcafe read-only sync/discovery behavior where applicable.

Minimum testing expectations:

| Area             | Required Tests                                                                   |
| ---------------- | -------------------------------------------------------------------------------- |
| Wallet           | Unit tests for ledger rules; integration tests for cashier flow; audit log tests |
| Loyalty          | Unit tests for earn/redeem rules; integration tests for ledger event creation    |
| F&B              | E2E flow from customer order to staff handling; cancellation/error tests         |
| Reservations     | State machine tests; staff approval/rejection tests                              |
| Admin/RBAC       | Permission tests for each role                                                   |
| Audit logs       | Tests that sensitive actions always produce audit records                        |
| Selcafe adapter  | Contract tests with synthetic/mock data; no writes in Phase 1                    |
| PWA              | Playwright tests for critical customer flows                                     |
| Phase 2 Electron | Playwright or equivalent E2E plus Hardware-in-the-Loop testing                   |

Test data policy: All test data must be synthetic. No real customer names,
phone numbers, or transaction data. Use Customer A, Customer B, +90 555 000 00 01.

Reference `/docs/QA_STRATEGY.md` and `/docs/UAT_PLAN.md` for full detail.

---

## 22. Release and Environment Management

Release and environment management is governed by `/docs/ENVIRONMENT_STRATEGY.md` and `/docs/RELEASE_PROCESS.md`. This section summarises the required operating model.

The project uses five environments:

| Environment    | Purpose                              | Data Rule                            |
| -------------- | ------------------------------------ | ------------------------------------ |
| Local          | Developer testing                    | Synthetic only                       |
| Test           | Automated CI validation              | Synthetic only                       |
| Staging        | Kerem and staff UAT                  | Synthetic only                       |
| Production     | Live Adeks operation                 | Real data allowed with KVKK controls |
| Demo / Sandbox | Future SaaS sales and demonstrations | Synthetic only                       |

Release cadence should follow the approved iteration rhythm. Semantic versioning is recommended:

```txt
MAJOR.MINOR.PATCH
```

Suggested interpretation:

| Version Part | Meaning                              |
| ------------ | ------------------------------------ |
| MAJOR        | Breaking or major phase-level change |
| MINOR        | New backward-compatible feature      |
| PATCH        | Bug fix or small safe correction     |

New features should use staged rollout through feature flags before general availability. Staff-first and pilot-user exposure should happen before all-customer rollout for operationally sensitive features.

Emergency hotfixes may bypass normal iteration cadence only with Kerem approval, or with immediate escalation to Kerem if a production incident requires urgent action. Hotfixes still require review for security, wallet, loyalty, payment, refund, customer-data, migration, or Selcafe-triggered categories.

Every production release must have a post-release monitoring window of at least 24 hours before the next planned release. During that window, Pod C and Pod D review errors, logs, alerts, support reports, and operational feedback.

Zero-downtime migration policy is defined in Section 12.3.

---

## 23. Incident Response and Business Continuity

<!-- [NEEDS KEREM APPROVAL — manual fallback procedures require staff training] -->

The incident response process defines how the café responds when the platform is unavailable, degraded, unsafe, or producing incorrect operational results.

Incident detection sources:

| Source            | Example                                                    |
| ----------------- | ---------------------------------------------------------- |
| Monitoring alert  | Elevated errors, downtime, latency, failed jobs            |
| Staff report      | Cashier cannot access admin screen, F&B queue not updating |
| Customer report   | Customer cannot place order or see expected information    |
| Pod C observation | Deployment or infrastructure failure                       |
| Pod B observation | Security, data, or logic risk                              |
| Pod D observation | Monitoring gap or UX failure during pilot                  |

Severity classification:

| Severity | Definition                                    | Examples                                                               |
| -------- | --------------------------------------------- | ---------------------------------------------------------------------- |
| P1       | Platform down or unsafe to operate            | Admin unavailable, customer data exposed, wallet/loyalty inconsistency |
| P2       | Critical feature broken but fallback possible | F&B ordering down, reservation workflow broken, audit log issue        |
| P3       | Degraded experience or non-critical defect    | Slow page, confusing UI, non-blocking display issue                    |

Escalation:

| Severity | Escalation                                                                    |
| -------- | ----------------------------------------------------------------------------- |
| P1       | Kerem, Pod C, Pod B immediately; Pod D if monitoring/observability involved   |
| P2       | Kerem, Pod C, relevant pod owner; Pod B if security/data/integration affected |
| P3       | Logged as issue; triaged in next bug review unless repeated or growing        |

Manual fallback:

| Area                    | Fallback                                                                                              |
| ----------------------- | ----------------------------------------------------------------------------------------------------- |
| Wallet                  | Cashier uses manual log approved by Kerem; reconciliation required after recovery                     |
| F&B ordering            | Verbal or paper orders; staff records seat, item, and payment/status manually                         |
| Reservations            | Phone or walk-in only until system recovers                                                           |
| Loyalty                 | Pause redemption/earn if ledger correctness cannot be guaranteed, unless Kerem approves manual policy |
| Audit-sensitive actions | Avoid manual sensitive actions where possible; record manual action log if unavoidable                |

Resolution process:

1. Detect and classify incident.
2. Assign incident owner.
3. Activate manual fallback if needed.
4. Investigate root cause.
5. Decide fix-forward or rollback.
6. Communicate staff instructions.
7. Resolve or mitigate.
8. Confirm recovery.
9. Reconcile manual records if any.
10. Produce post-incident review.

Customer and staff communication must be clear and operational. Staff need to know what to do, what not to do, and how to record fallback actions. Customers should receive simple explanations where service is affected.

Reference `/docs/INCIDENT_RESPONSE_PLAN.md` and `/docs/MANUAL_FALLBACK_PROCEDURES.md`.

---

## 24. Roles and Responsibility Map

### 24.1 Current Roles

| Role                          | Person / Pod        | Responsibilities                                 |
| ----------------------------- | ------------------- | ------------------------------------------------ |
| Product Owner                 | Kerem               | All product decisions, final approvals, go/no-go |
| Product & Planning            | Pod A (ChatGPT)     | Discovery, user stories, flows, planning docs    |
| Architecture & Risk           | Pod B (Claude)      | ADRs, schemas, API contracts, security review    |
| Build & DevOps                | Pod C (Claude Code) | Implementation, CI/CD, migrations, tests         |
| Prototype, Audit & Monitoring | Pod D (Gemini)      | Prototypes, audits, monitoring spec              |

### 24.2 Missing or Underdefined Roles

The following roles are missing or underdefined. Until dedicated people are assigned, responsibility must be explicitly covered by the current pods and Kerem. These assignments are not permanent hiring decisions; they are operating coverage for the current project stage.

| Missing Role                  | Who Currently Covers It                                       | Gap Risk                                    | Recommended Coverage                                                                                |
| ----------------------------- | ------------------------------------------------------------- | ------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| QA Lead                       | Pod B defines strategy; Pod C executes tests; Kerem signs UAT | Test strategy undefined, coverage arbitrary | Pod B owns strategy; Pod C owns execution; Kerem owns UAT sign-off                                  |
| KVKK / Legal Compliance Owner | Kerem informally                                              | Legal obligation without an owner           | Kerem + external legal/privacy advisor [NEEDS KEREM APPROVAL]                                       |
| Operations / SRE Owner        | Pod C + Pod D informally                                      | No incident response owner                  | Pod C owns release/runtime response; Pod D owns monitoring spec; Kerem escalates business decisions |
| UX / Service Designer         | Pod D + Pod A                                                 | Staff workflows unvalidated                 | Pod D observes/prototypes; Pod A synthesises product rules and open questions                       |
| Data / Analytics Role         | Pod A + Kerem for Phase 1                                     | No OLTP/OLAP strategy                       | Pod A defines product metrics; Pod B reviews data model; dedicated role before Phase 3              |
| Release Manager               | Pod C informally                                              | Release readiness ad hoc                    | Pod C owns release checklist; Kerem approves go/no-go                                               |
| Documentation Owner           | Pod A informally                                              | Docs drift from code                        | Pod A owns planning docs; each pod owns updates to its artifacts                                    |
| Delivery Coordinator          | Kerem + Pod A                                                 | No work rhythm owner                        | Kerem owns priorities; Pod A supports iteration planning and routing                                |
| SaaS Product Strategist       | Kerem + Pod A                                                 | Phase 3 commercialisation undefined         | Kerem owns commercial direction; Pod A supports SaaS discovery and packaging research               |

Role gaps should be reviewed at every major phase gate. If a gap becomes a launch blocker, it must be escalated to Kerem.

---

## 25. Pilot and Staged Rollout Policy

<!-- [NEEDS KEREM APPROVAL] -->

The Phase 1 pilot should reduce rollout risk by exposing the platform gradually. The pilot is not only a technical test. It validates staff readiness, customer comprehension, operational fallback, monitoring, support workflow, and product value.

Recommended pilot structure:

| Week   | Audience                  | Purpose                                                                           |
| ------ | ------------------------- | --------------------------------------------------------------------------------- |
| Week 1 | Staff only                | Cashiers and admin test flows in production with real but controlled transactions |
| Week 2 | Invited regular customers | Kerem-selected subset validates customer-facing flows                             |
| Week 3 | All customers             | Full rollout if readiness criteria are met                                        |

Pilot participant selection:

* Staff participants should include cashiers and F&B staff who will use the workflows directly.
* Customer participants should be regular customers selected by Kerem.
* Participants should be informed that the feature is in pilot and that feedback is expected.
* No customer should receive access to sensitive or admin-only functions.

Feedback collected:

| Area                          | Feedback                                                |
| ----------------------------- | ------------------------------------------------------- |
| Customer comprehension        | Can customers understand what to do without staff help? |
| Staff workload                | Does the feature reduce or increase operational burden? |
| Order/reservation correctness | Are requests clear and actionable?                      |
| Wallet/loyalty trust          | Do customers and staff trust displayed values?          |
| Error handling                | What happens when something fails?                      |
| Performance                   | Is the experience fast enough during real operation?    |
| Support burden                | How many explanations or interventions are needed?      |

Pause triggers:

* Incorrect wallet or loyalty value.
* Customer personal data exposure or access-control issue.
* Repeated failed orders or reservation conflicts.
* Staff unable to operate fallback.
* Monitoring shows unresolved critical errors.
* Customer confusion creates unacceptable cashier burden.
* Kerem decides business risk is too high.

Readiness for full rollout requires:

* Required pilot metrics meet Kerem-approved thresholds.
* P1/P2 pilot issues are resolved or explicitly accepted.
* Staff know fallback procedures.
* Monitoring is active.
* Rollback process is ready.
* Pod B has cleared security/KVKK concerns.
* Kerem approves rollout.

Reference the feature flag strategy in Section 12.5.

---

## 26. Vendor and Dependency Selection Process

New vendors and significant npm dependencies must be evaluated before adoption. The goal is to prevent security exposure, KVKK risk, maintenance burden, licence conflict, or unnecessary lock-in.

Who may propose:

| Proposer | Examples                                                            |
| -------- | ------------------------------------------------------------------- |
| Pod A    | Product tool, analytics need, customer communication provider       |
| Pod B    | Architecture library, security tool, data or integration dependency |
| Pod C    | Build, test, CI/CD, framework, package, infrastructure dependency   |
| Pod D    | Prototyping, monitoring, observability, UX analytics tool           |
| Kerem    | Business vendor, payment provider, SMS/email/push provider          |

Evaluation criteria:

| Criterion              | Questions                                                                                      |
| ---------------------- | ---------------------------------------------------------------------------------------------- |
| Security track record  | Is the vendor/library actively maintained? Known vulnerabilities? Security disclosure process? |
| KVKK impact            | Does it process personal data? Where is data stored? Any cross-border transfer?                |
| Licence compatibility  | Is the licence compatible with Adeks Platform and future SaaS commercialization?               |
| Maintenance activity   | Recent releases, maintainers, issue response, ecosystem adoption                              |
| Architecture fit       | Does it fit the locked stack and modular monolith direction?                                   |
| Bundle/runtime impact  | Does it add unacceptable frontend size or backend complexity?                                  |
| Operational complexity | Does it require new infrastructure, monitoring, backup, or support process?                    |
| Cost and lock-in       | What are pricing, migration difficulty, and exit options?                                      |
| Data ownership         | Who controls the data and export path?                                                         |
| Phase relevance        | Is it needed now, or can it be deferred?                                                       |

Approval:

| Dependency Type                                        | Required Approval                                                   |
| ------------------------------------------------------ | ------------------------------------------------------------------- |
| Minor development dependency                           | Pod C, unless security concern exists                               |
| Significant technical dependency                       | Pod B                                                               |
| Architecture-defining dependency                       | Pod B through ADR                                                   |
| Vendor processing personal data                        | Kerem + Pod B + legal/privacy review as needed                      |
| Payment, SMS, email, push, hosting, analytics provider | Kerem + Pod B                                                       |
| Monitoring/observability vendor                        | Pod D recommends, Pod B reviews, Kerem approves if cost/data impact |

Significant decisions must be recorded as ADRs. Dependency updates should use automated Dependabot PRs where practical, with Pod C review and Pod B review for security-sensitive updates.

Reference `/docs/DEPENDENCY_POLICY.md`.

---

## 27. AI Session Continuity Protocol

<!-- [LOCKED PROCESS — unique risk of an AI-assisted development system] -->

All AI pods are stateless between sessions. A decision made in a chat session
that is not committed to the repository does not exist.

The following rules are mandatory:

1. **Repository is the only source of truth.** No AI session output is binding
   until it is committed to the repository as a document, ADR, issue, or PR.

2. **Every session must begin with context loading.** Before any pod produces
   output in a new session, the relevant project documents must be loaded into
   context. Pod B sessions must load: this document, PROJECT_BRIEF.md, and any
   relevant ADRs. Pod A sessions must load: this document and the current
   planning document under review.

3. **No decision is re-litigated without a reason.** If a locked decision exists
   in the repository, no AI pod may informally re-open it in a chat session.
   Challenges to locked decisions must be raised as a formal flag with the
   [LOCKED PRINCIPLE CONFLICT] tag and escalated to Kerem.

4. **Session outputs are drafts until committed.** Anything produced in a
   chat session is a draft. It becomes canonical only when Kerem or Pod B
   approves it and Pod C commits it to the repository.

5. **Pod identity must be maintained.** Each pod operates within its defined
   role. A pod that begins performing another pod's function (e.g., an audit
   pod proposing architecture, or a planning pod approving security decisions)
   is operating outside its role. Kerem is the check on this.

6. **Git commands must be explicit.** Whenever any pod asks Kerem to branch,
   commit, open a PR, merge, remove, move, archive, restore, tag, fetch, or
   pull, the pod must provide exact git or GitHub CLI commands. Commands must
   be scoped, safe, and review-aware. A pod must not tell Kerem to merge until
   all required review, CI, and approval gates are complete. If an exact
   command cannot be confirmed, the pod must say so explicitly rather than
   omitting the step. This rule applies to all pods (Pod A, Pod B, Pod C,
   Pod D) whenever they direct repository actions.

---

## 28. Document Governance and Revision History

### 28.1 Document Ownership

| Document                               | Owner            | Reviewer          | Approver                       |
| -------------------------------------- | ---------------- | ----------------- | ------------------------------ |
| PROJECT_METHODOLOGY.md (this document) | Pod A            | Pod B             | Kerem                          |
| PROJECT_BRIEF.md                       | Pod A            | Pod B             | Kerem                          |
| MVP_SCOPE.md                           | Pod A            | Pod B             | Kerem                          |
| BUSINESS_RULES.md                      | Pod A            | Pod B             | Kerem                          |
| DOMAIN_MODEL.md                        | Pod B            | Pod A             | Kerem                          |
| ADRs (`/docs/adr/`)                    | Pod B            | —                 | Kerem (product-impacting only) |
| API Contracts (`/docs/api/`)           | Pod B            | Pod C             | —                              |
| Database Schemas (`/docs/schema/`)     | Pod B            | Pod C             | —                              |
| MONITORING_AND_ALERTING_SPEC.md        | Pod D            | Pod B             | Kerem                          |
| All test strategy docs                 | Pod B (strategy) | Pod C (execution) | Kerem                          |

### 28.2 Revision Rules

* This document may not be changed without Kerem's explicit approval.
* All changes must be recorded in the revision log below.
* Locked sections (marked `[LOCKED]`) require a formal [LOCKED PRINCIPLE CONFLICT]
  flag and Kerem's explicit approval to amend.

### 28.3 Revision Log

| Version      | Date   | Author | Summary of Changes                                          |
| ------------ | ------ | ------ | ----------------------------------------------------------- |
| 0.1 | unknown | Pod B | Initial skeleton produced |
| 0.2 | 2026-06-02 | Pod A | All sections completed. Pod B review passed. Awaiting Kerem approval. |
| 0.3 | 2026-06-03 | Pod A | Added §16.1 Automatic Handoff Prompt Rule (unified, all pods). Pod B drafted, Pod B reviewed. |
| 0.4 | 2026-06-04 | Pod A / Pod C | Added §1.2 Repository-Controlled Pod Context Principles and §27 rule 6 git-command requirement. Records Kerem-approved MD-2…MD-6 in §28.4. Commits ADR-013, proposal v0.2, and implementation plan v0.1. Pod B reviewed. |
| 0.5 | 2026-06-05 | Pod A | RCPC bundle: migrated PQ-002 Pod D audit cadence; workflow file archived/stubbed. |
| 0.6 | 2026-06-07 | Pod B | BC-2 Option A (Kerem-approved): aligned §11.1 approval gates to ADR-009 §3 (Selcafe adapter + DB/schema migration → Pod B + Kerem; security-sensitive PR row added). Removed stale embedded PR template from §15; replaced with pointer to live `.github/PULL_REQUEST_TEMPLATE.md` and ADR-009. K-11 recorded in KEREM_DECISIONS.md. |

### 28.4 Kerem Decisions — Repository-Controlled Pod Context

**Decision date:** 2026-06-04
**Decision source:** Kerem chat approval to Pod A
**Scope:** Repository-Controlled Pod Context methodology consolidation
**Canonical record:** This section; mirrored in `/docs/PROJECT_DECISION_INDEX.md` §4

| ID | Decision | Kerem Decision |
|---|---|---|
| MD-2 | Approve methodology-consolidation direction | Approved |
| MD-3 | Record consolidation as both ADR-013 and methodology §28 revision | Approved |
| MD-4 | Approve `PROJECT_DECISION_INDEX.md` ownership as Pod B sole owner, with Pod A reviewer on product/business-impacting rows | Approved |
| MD-5 | Approve `/docs/POD_TRAFFIC_WORKFLOW.md` permanent stub plus full archive at `/docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md` | Approved |
| MD-6 | Approve conditional Pod Impact Matrix: one universal PR gate question, full matrix + Instruction Update Packet only when yes | Approved |

### 28.5 Kerem Decisions — BC-2 Approval Gate Alignment

**Decision date:** 2026-06-07
**Decision source:** Kerem chat approval to Pod B
**Scope:** BC-2 Option A — correcting §11.1 and §15 conflicts with ADR-009 §3
**Canonical record:** This section; full detail in `/docs/KEREM_DECISIONS.md` K-11

| ID | Decision | Kerem Decision |
|---|---|---|
| K-11 | BC-2 Option A: align §11.1 gates to ADR-009 §3; remove stale §15 embedded template | Approved |

---

<!-- END OF DOCUMENT -->
