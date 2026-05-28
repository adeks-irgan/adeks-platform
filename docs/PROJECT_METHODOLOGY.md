# PROJECT_METHODOLOGY.md
<!-- 
  STATUS: SKELETON — Ready for Pod A prose completion
  AUTHOR: Pod B (Architecture, Logic & Risk)
  REVIEWER: Pod B (before merge)
  APPROVER: Kerem (product owner)
  VERSION: 0.1-skeleton
  LAST UPDATED: [DATE]
  PATH: /docs/PROJECT_METHODOLOGY.md

  INSTRUCTIONS FOR POD A:
  Fill every section marked [POD A: FILL] with complete prose.
  Do not alter section headings, IDs, or the [LOCKED] / [NEEDS KEREM APPROVAL] tags.
  Do not add features, scope decisions, or architectural decisions — those belong in
  separate documents. This document describes HOW the project runs, not WHAT it builds.
  When complete, return to Pod B for review before Pod C commits.
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

| Authority Layer | Owner | Role |
|---|---|---|
| Product owner and final decision maker | Kerem | Approves all product, scope, and business decisions |
| Repository | GitHub (`adeks-platform`) | Single source of truth. Repository always beats chat. |
| Architecture decisions | ADRs in `/docs/adr/` | ADRs beat informal architecture notes in any medium |
| Work items | GitHub Issues | Issues beat vague implementation requests |
| Quality gate | Tests and CI | Tests beat assumptions |
| Sensitive action gate | Human approval required | See Section 20 for trigger list |

### 1.1 What the Control Plane Means in Practice

[POD A: FILL — Explain in plain language what it means that the repository is the
single source of truth. Cover: what happens when a chat session says one thing and
a committed document says another; what happens when two pods disagree; why no AI
session output is binding until it is committed to the repository.]

---

## 2. Pod Structure and Responsibilities

### 2.1 Pod Overview

| Pod | Tool | Primary Role |
|---|---|---|
| Pod A | ChatGPT | Product & Planning |
| Pod B | Claude | Architecture, Logic & Risk |
| Pod C | Claude Code / Codex CLI | Build & DevOps |
| Pod D | Gemini / Google AI Studio | Prototype, Audit & Monitoring |

### 2.2 Pod A — Product and Planning

**Produces:** Business rules, user stories, user roles, user flows, open questions,
planning documents, feature opportunity notes, product metrics, UX research briefs.

**Does not:** Finalise architecture decisions, write implementation code, approve
security-sensitive changes, or propose architecture without Pod B review.

[POD A: FILL — Expand on Pod A's daily working rhythm. How does Pod A receive input
from Kerem? What format does Pod A use to deliver documents to Pod B? What is the
standard document structure Pod A follows?]

### 2.3 Pod B — Architecture, Logic and Risk

**Produces:** ADRs, domain model reviews, database schemas, API contracts, state
machine designs, security and KVKK risk assessments, wallet and loyalty ledger
specifications, bounded context maps, assumption maps.

**Does not:** Write application code, make product decisions, approve go-live
unilaterally, or override Kerem's product decisions.

[POD A: FILL — Expand on Pod B's review triggers. When must Pod A send a document
to Pod B before it is considered final? What turnaround is expected?]

### 2.4 Pod C — Build and DevOps

**Produces:** Application code, database migrations, CI/CD pipelines, Docker
configuration, automated tests, environment setup.

**Does not:** Make architectural decisions independently, choose libraries without
Pod B approval for significant dependencies, merge to main without PR review,
or write to Selcafe SQL Server without explicit Kerem approval.

[POD A: FILL — Expand on Pod C's intake process. What must an issue contain before
Pod C begins work? What does Pod C do when a spec is ambiguous?]

### 2.5 Pod D — Prototype, Audit and Monitoring

**Produces:** PWA and UI prototypes, large-context codebase audits, monitoring
specifications, observability recommendations, UX flow explorations.

**Does not:** Make architectural decisions, gate other pods' work, propose product
scope changes as authoritative, or begin building features without Kerem direction.

[POD A: FILL — Clarify Pod D's audit trigger. When is Pod D asked to audit?
What format does a Pod D audit report take? How are audit findings actioned?]

### 2.6 Kerem — Product Owner

[POD A: FILL — Describe Kerem's decision-making role in plain terms.
Cover: what decisions only Kerem can make, what Kerem delegates to pods,
how Kerem signals approval (e.g. GitHub issue comment, PR approval), and
what happens when Kerem is unavailable.]

---

## 3. The Full Development Lifecycle

<!-- [POD A: FILL — Introduce the ten-phase lifecycle at a high level.
Explain that Phases 1-5 (discovery through scoping) were not executed at
project start and that the remediation plan for each is covered in the
relevant section. Make clear that for future features and for Phase 2 and
Phase 3 planning, all ten phases will be executed in sequence.] -->

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

| Output | Document | Status |
|---|---|---|
| Product vision statement | `/docs/VISION.md` | [NEEDS KEREM APPROVAL] |
| Problem statement | `/docs/PROBLEM_STATEMENT.md` | [NEEDS KEREM APPROVAL] |
| North star metric | `/docs/VISION.md` (section) | [NEEDS KEREM APPROVAL] |
| Stakeholder map | `/docs/STAKEHOLDER_MAP.md` | [NEEDS KEREM APPROVAL] |
| Competitive analysis | `/docs/COMPETITIVE_ANALYSIS.md` | [NEEDS KEREM APPROVAL] |

### 4.1 Product Vision Statement

[POD A: FILL — Define the format of the vision statement. Include a template:
"For [customer segment] who [need or problem], [Adeks Platform] is a [category]
that [key benefit]. Unlike [alternative], our product [differentiator]."
Note that this must be written and approved before MVP_SCOPE.md is finalised.]

### 4.2 North Star Metric

[POD A: FILL — Define what a north star metric is and why one is required.
Leave a placeholder for Kerem to fill in the actual metric with a note:
"[NEEDS KEREM APPROVAL — what single number, if increasing, tells us Phase 1 worked?]"]

### 4.3 Problem Statement

[POD A: FILL — Provide the problem statement template and explain that problems
must be written as problems, not as features. Example format:
"[Customer type] currently experiences [friction] when [activity], which causes
[impact]. We believe [intervention] will address this because [reasoning]."]

### 4.4 Stakeholder Map

[POD A: FILL — List all stakeholders beyond Kerem: cashier staff, regular customers,
kitchen/F&B staff, future SaaS operator buyers, Selcafe vendor relationship.
For each: their stake, their ability to block or enable the platform, and what
they need from the platform to adopt it.]

### 4.5 Competitive Analysis

[POD A: FILL — Describe the scope of the competitive analysis for Phase 3 SaaS
ambitions. Identify key platforms to analyse. Note that this is not required before
Phase 1 build, but must exist before Phase 3 planning begins.]

### 4.6 Phase 1 Remediation Note

<!-- [LOCKED PROCESS NOTE — Do not remove] -->

The original project did not execute Phase 1 before beginning planning. The
following remediation actions are required before MVP_SCOPE.md is finalised:

- [ ] Kerem to narrate and Pod A to document: what problem are we solving?
- [ ] Kerem to define the north star metric for Phase 1
- [ ] Pod A to produce VISION.md draft for Kerem approval
- [ ] Pod A to produce STAKEHOLDER_MAP.md draft for Kerem approval

---

## 5. Phase 2: User Research

**Purpose:** Understand users as people, not just as roles. Document current
(as-is) workflows before designing replacements.

**Responsible pod:** Pod A for facilitation and documentation.
Pod D for physical café observation (Selcafe Friction Audit).
Kerem to authorise staff participation.

**Outputs required before Phase 3 begins:**

| Output | Document | Status |
|---|---|---|
| Deep persona definitions | `/docs/PERSONAS.md` | Missing |
| As-is process maps | `/docs/AS_IS_FLOWS.md` | Missing |
| Customer journey map (current) | `/docs/CUSTOMER_JOURNEY_CURRENT.md` | Missing |
| Jobs-to-be-Done analysis | `/docs/JTBD_ANALYSIS.md` | Missing |

### 5.1 Persona Definitions

[POD A: FILL — Explain the difference between a role and a persona. A role is a
permission set. A persona is a person. Provide the persona template:
Name (synthetic), age range, daily context, primary goal at Adeks, biggest
frustration, biggest fear, what success looks like for them.
Define personas for: Gaming Customer, Cashier, F&B Staff, Manager/Admin.]

### 5.2 As-Is Process Maps

[POD A: FILL — Explain why as-is mapping must happen before to-be design.
Define the scope: wallet top-up, F&B ordering, reservation request, session
start and end, loyalty earn and redemption. Note that the Selcafe Friction Audit
(Pod D physically observing café operations with Kerem's authorisation) is the
primary research method for this section.]

### 5.3 Selcafe Friction Audit

<!-- [NEEDS KEREM APPROVAL — physical café observation requires staff awareness
and Kerem's authorisation] -->

[POD A: FILL — Describe the Selcafe Friction Audit process: who participates,
what is observed, what is recorded, how findings feed into as-is maps.
This was identified by Pod D as a high-value research method and adopted
by Pod B as the preferred as-is research approach.]

### 5.4 Jobs-to-be-Done Analysis

[POD A: FILL — Explain the JTBD framework in plain language. The core question:
"What job is a customer hiring Adeks Platform to do?" Note that the answer
is almost never the feature itself — a customer is not hiring a wallet; they
are hiring frictionless access to their gaming session. Provide the JTBD
template and example for each persona.]

---

## 6. Phase 3: Ideation and Brainstorm

**Purpose:** Explore the complete possibility space of what the platform could do
before any filter is applied. No idea is rejected in this phase.

**Responsible pod:** Pod A facilitates. Kerem is the primary voice.
All pods may contribute ideas to the backlog but not filter them.

**Outputs required before Phase 4 begins:**

| Output | Document | Status |
|---|---|---|
| Feature Possibility Map (raw, unfiltered) | `/docs/FEATURE_POSSIBILITY_MAP.md` | Missing |
| Opportunity Map (value vs feasibility) | `/docs/OPPORTUNITY_MAP.md` | Missing |

### 6.1 Feature Brainstorm Process

<!-- [NEEDS KEREM APPROVAL — 90-minute session to be scheduled before
MVP_SCOPE.md is finalised] -->

[POD A: FILL — Define the brainstorm format. Recommended: a 90-minute time-boxed
session. Rules: no filtering, no "that's Phase 3," no cost objections. Every
idea is captured. Roles, horizons, and user types are all prompts.
The output is a flat list — the Feature Possibility Map — not a prioritised
backlog. Prioritisation happens in Phase 5.]

### 6.2 Feature Possibility Map

[POD A: FILL — Describe the format of the Feature Possibility Map document.
It is a flat list of every conceivable feature grouped by domain area
(wallet, loyalty, F&B, reservations, session management, analytics, SaaS).
No priority column at this stage. No phase assignment at this stage.
Just: what could this platform do?]

### 6.3 Opportunity Mapping

[POD A: FILL — After the brainstorm, opportunities are mapped on two axes:
customer/operator value (high/medium/low) versus implementation feasibility
(high/medium/low). This produces four quadrants. Quick wins (high value,
high feasibility) are Phase 1 or 2 candidates. Strategic bets (high value,
low feasibility) are Phase 3 candidates. Everything else is documented and
deprioritised with a reason.]

---

## 7. Phase 4: Assumption Validation

**Purpose:** Before any architecture is locked, identify every assumption the
project rests on, rate its confidence level, and validate low-confidence
assumptions through spikes or research before committing to build.

**Responsible pod:** Pod B produces the assumption map.
Pod A validates product assumptions with Kerem.
Pod C executes technical spikes.

**Outputs required before Phase 5 begins:**

| Output | Document | Status |
|---|---|---|
| Assumption Map | `/docs/ASSUMPTION_MAP.md` | Missing |
| Selcafe Feasibility Spike Report | `/docs/SELCAFE_SPIKE_REPORT.md` | Missing [NEEDS KEREM APPROVAL] |
| MVP Hypothesis Document | `/docs/MVP_HYPOTHESIS.md` | Missing |

### 7.1 Assumption Map

[POD A: FILL — Describe the assumption map format. Each assumption has:
the assumption statement, the decision it supports, the confidence level
(high/medium/low), the evidence behind the confidence rating, and the
action if confidence is low (spike / prototype / defer / accept risk).
Note that Pod B will populate this for architectural assumptions;
Pod A should populate it for product and user assumptions.]

### 7.2 Selcafe Feasibility Spike

<!-- [NEEDS KEREM APPROVAL — requires authorised access to Selcafe SQL Server
for read-only schema inspection. This must not be treated as a write operation.
See locked principle: No direct writes to Selcafe SQL Server in Phase 1.] -->

[POD A: FILL — Describe what the Selcafe feasibility spike must answer:
Is the SQL Server accessible from the same local network? What tables and
columns exist? What data quality is present? What does the schema reveal about
session, customer, and wallet data structures? The spike is time-boxed to
one working day. Output is SELCAFE_SPIKE_REPORT.md committed to the repo.]

### 7.3 MVP Hypothesis

[POD A: FILL — Define the MVP hypothesis format. For each feature cluster,
the hypothesis is: "We believe that [feature] will cause [user type] to
[behaviour change], which we will measure by [metric]. We will know this
hypothesis is confirmed if [success threshold] within [timeframe]."
This document is the foundation for the Phase 10 post-launch review.]

---

## 8. Phase 5: Prioritisation and Scoping

**Purpose:** Apply filters to the Feature Possibility Map to produce a
principled, reasoned scope. Every inclusion and exclusion must be recorded
with its reasoning.

**Responsible pod:** Pod A drafts. Kerem approves. Pod B validates for
architectural and dependency conflicts.

**Outputs required before Phase 6 begins:**

| Output | Document | Status |
|---|---|---|
| MVP Scope (with reasoning) | `/docs/MVP_SCOPE.md` | Partial — reasoning missing |
| Scope Boundary Document | `/docs/SCOPE_BOUNDARIES.md` | Missing |
| Feature Dependency Map | `/docs/FEATURE_DEPENDENCY_MAP.md` | Missing |
| Phase Gate Criteria | `/docs/PHASE_GATES.md` | Missing |

### 8.1 MoSCoW Prioritisation with Reasoning

[POD A: FILL — For every feature in MVP_SCOPE.md, the reasoning for its
MoSCoW classification must be recorded. "Must Have" requires a justification.
"Won't Have in Phase 1" requires a reason (e.g., "requires payment provider,"
"needs user validation first," "architectural dependency not ready").
Without recorded reasoning, scope cannot be challenged or defended correctly.]

### 8.2 Scope Boundary Document

[POD A: FILL — Define the explicit scope boundary document format.
It records: what we are NOT building in this phase, and specifically why.
This document is as important as the scope document itself. It prevents
scope creep and allows future phases to revisit exclusions with context.]

### 8.3 Feature Dependency Map

[POD A: FILL — Describe the dependency map. Which features cannot exist
without other features? Which architectural components must exist before
a feature can be built? This map reveals the true critical path and
prevents impossible sequencing mid-sprint.]

### 8.4 Phase Gate Criteria

[POD A: FILL — Define what phase gates are and why they exist. For each
phase transition (Phase 1 → 2, Phase 2 → 3), measurable criteria must
be met before the next phase begins. Reference /docs/PHASE_GATES.md
for the specific criteria per transition. Note that gate criteria
require Kerem's explicit approval to pass.]

---

## 9. Phase 6: Planning and Roadmap

**Purpose:** Translate the approved scope into a delivery plan with milestones,
priorities, and a work rhythm that all pods can operate within.

**Responsible pod:** Pod A drafts. Kerem approves.

**Outputs required before Phase 7 begins:**

| Output | Document | Status |
|---|---|---|
| Delivery roadmap | `/docs/ROADMAP.md` | Partial |
| Sprint or iteration cadence | This document, Section 9.1 | Missing |
| Dependency and risk register | `/docs/DELIVERY_RISK_REGISTER.md` | Missing |

### 9.1 Work Rhythm and Cadence

<!-- [NEEDS KEREM APPROVAL] -->

[POD A: FILL — Define the iteration rhythm. Recommended: two-week iterations.
Each iteration has: a planning session (Kerem + Pod A define the iteration goal),
a mid-point check (Pod B flags any emerging risks), and a close (Pod D audits
output, Kerem reviews). Define what happens between iterations: retrospective,
backlog grooming, and metrics review.]

### 9.2 Delivery Risk Register

[POD A: FILL — Define what belongs in the delivery risk register. Distinct from
the architectural risk register (Pod B's domain): this covers delivery risks
such as unavailable stakeholders, unclear requirements, third-party delays,
and Selcafe integration unknowns.]

---

## 10. Phase 7: Architecture and Design

**Purpose:** Translate approved scope into implementable architectural
specifications, domain models, API contracts, and database schemas.

**Responsible pod:** Pod B. All significant decisions captured in ADRs.

**Outputs required before Phase 8 begins:**

| Output | Document | Owner |
|---|---|---|
| Architecture viewpoints | `/docs/architecture/` | Pod B |
| Domain model | `/docs/DOMAIN_MODEL.md` | Pod B review |
| API contracts | `/docs/api/` | Pod B |
| Database schemas | `/docs/schema/` | Pod B |
| ADR backlog resolved | `/docs/adr/` | Pod B |
| Security and KVKK review | `/docs/SECURITY_REVIEW.md` | Pod B |

[POD A: FILL — Describe what happens in Phase 7 from the perspective of other
pods. What does Pod A deliver to Pod B to initiate architecture work?
What does Pod B return? How does Kerem review architectural outputs that
require product decisions?]

### 10.1 Architecture Viewpoints Required

Per ISO/IEC/IEEE 42010, Pod B must produce or review the following views
before Phase 8 begins:

| View | Purpose | Document |
|---|---|---|
| Context view | System boundary, external actors | `/docs/architecture/CONTEXT_VIEW.md` |
| Container view | NestJS, Next.js, PostgreSQL, local gateway | `/docs/architecture/CONTAINER_VIEW.md` |
| Module view | Domain modules and boundaries | `/docs/architecture/MODULE_VIEW.md` |
| Data view | Ledgers, orders, reservations, audit logs | `/docs/architecture/DATA_VIEW.md` |
| Integration view | SelcafeAdapter, CafeManagementAdapter | `/docs/architecture/INTEGRATION_VIEW.md` |
| Deployment view | Local network, staging, production | `/docs/architecture/DEPLOYMENT_VIEW.md` |
| Security view | Auth, RBAC, audit, data protection | `/docs/architecture/SECURITY_VIEW.md` |
| Operational view | Monitoring, logging, backup, recovery | `/docs/architecture/OPERATIONAL_VIEW.md` |

---

## 11. Phase 8: Build and Test

**Purpose:** Implement specifications produced in Phase 7, with full test
coverage and CI/CD gates.

**Responsible pod:** Pod C. Pod B reviews security-sensitive and
financially-sensitive PRs before merge.

[POD A: FILL — Describe the build phase workflow in plain language.
Cover: how issues are drafted, how Pod C picks up work, the branch and
PR process, what CI must pass, and when human review is required.
Reference the Definition of Ready (Section 14) and Definition of Done
(Section 15).]

### 11.1 Mandatory Human Approval Triggers

<!-- [LOCKED] The following PR categories require human approval before merge. -->

| Trigger Category | Required Approver |
|---|---|
| Wallet ledger logic | Kerem + Pod B |
| Loyalty ledger logic | Kerem + Pod B |
| Authentication and authorisation | Pod B |
| Customer personal data handling | Pod B + Kerem |
| Selcafe adapter changes | Pod B |
| Audit log schema or logic | Pod B |
| Database migrations | Pod B |
| Payment logic (Phase 2+) | Kerem + Pod B |
| Admin privilege changes | Kerem |
| Refund logic | Kerem + Pod B |

### 11.2 Hardware-in-the-Loop Testing (Phase 2)

<!-- Phase 2 specific — not required for Phase 1 -->

[POD A: FILL — Describe the Hardware-in-the-Loop (HIL) testing process for
Phase 2 Electron client. This was identified by Pod D as a critical gap:
the CI/CD pipeline must include mock local network environments simulating
Electron-to-hardware communication before any code is deployed to physical PCs.
Detail the mock environment setup and the testing checklist.]

---

## 12. Phase 9: Release and Operate

**Purpose:** Deliver built and tested software to production safely, with
rollback capability, monitoring, and incident response ready before go-live.

**Responsible pod:** Pod C for release execution.
Pod D for monitoring specification.
Kerem for go/no-go approval.

### 12.1 Environment Model

| Environment | Purpose | Real Data Allowed? |
|---|---|---|
| Local | Developer testing | Synthetic only |
| Test | Automated CI validation | Synthetic only |
| Staging | Kerem and staff UAT | Synthetic only [LOCKED — KVKK] |
| Production | Live Adeks operation | Yes, with full KVKK controls |
| Demo / Sandbox | Future SaaS sales (Phase 3) | Synthetic only |

[POD A: FILL — Explain the rationale for synthetic-only data in non-production
environments, grounding it in KVKK requirements. Describe how synthetic test
data is generated and maintained.]

### 12.2 Release Process

[POD A: FILL — Define the release steps: staging deployment, UAT sign-off by
Kerem, release notes, go/no-go gate, production deployment, post-deployment
smoke test, and monitoring check. Reference /docs/RELEASE_PROCESS.md for the
detailed checklist.]

### 12.3 Zero-Downtime Migration Policy

<!-- [LOCKED PROCESS] -->

All PostgreSQL schema migrations must follow the Expand-and-Contract pattern.
No migration may lock tables during production hours.

[POD A: FILL — Explain the Expand-and-Contract pattern in plain language for
non-technical readers. Explain what "production hours" means for Adeks
(when the café is open and PCs are in use) and how migrations are scheduled
around them.]

### 12.4 Rollback Policy

[POD A: FILL — Define when and how a rollback is triggered. Who can call a
rollback? What is the maximum acceptable downtime before rollback is mandated?
Reference /docs/ROLLBACK_POLICY.md for the detailed runbook.]

### 12.5 Feature Flagging and Staged Rollout

<!-- [NEEDS KEREM APPROVAL — tool selection for feature flagging] -->

[POD A: FILL — Describe the feature flagging strategy. The café operates 24/7.
New features must be testable with a subset of users (e.g., staff first,
then VIP customers, then all customers) before full rollout.
Pod B will produce the tool recommendation ADR. Pod A should describe
the business process: who enables a flag, who monitors it, what triggers
full rollout or rollback of a flag.]

---

## 13. Phase 10: Learn and Iterate

**Purpose:** Measure whether the platform is achieving its goals, capture
learning, and feed insights back into Phase 1 of the next iteration.

**Responsible pod:** Pod A owns the learning process.
Kerem reviews metrics and approves next iteration direction.
Pod D owns the analytics and monitoring data collection.

### 13.1 Post-Launch Validation Plan

[POD A: FILL — For each MVP hypothesis defined in Section 7.3, define:
who reviews the outcome, at what cadence (recommended: two weeks,
one month, three months post-launch), and what the confirmation or
refutation threshold is. Reference /docs/MVP_HYPOTHESIS.md.]

### 13.2 Product Metrics

[POD A: FILL — List the Phase 1 product metrics. Minimum required:

| Area | Metric | Target | Review Cadence |
|---|---|---|---|
| Wallet | [NEEDS KEREM APPROVAL] | | Weekly |
| F&B ordering | [NEEDS KEREM APPROVAL] | | Weekly |
| Loyalty | [NEEDS KEREM APPROVAL] | | Weekly |
| Reservations | [NEEDS KEREM APPROVAL] | | Weekly |
| PWA adoption | [NEEDS KEREM APPROVAL] | | Weekly |
| System reliability | Uptime SLO | [NEEDS KEREM APPROVAL] | Daily |

Reference /docs/PRODUCT_METRICS.md for the full metrics specification.]

### 13.3 Retrospective Cadence

[POD A: FILL — Define the retrospective process. Recommended: end of each
two-week iteration. Format: what went well, what did not, what we learned,
what changes to the methodology. Findings are committed to
/docs/retrospectives/RETRO_[DATE].md and acted on in the next iteration.]

### 13.4 Feedback Capture Mechanism

<!-- [NEEDS KEREM APPROVAL] -->

[POD A: FILL — Define how cashier staff complaints, customer confusion, and
operational friction get back to the product team. Who is the intake point?
What is the triage process? How quickly must critical bugs be acknowledged?
Reference /docs/BUG_TRIAGE_PROCESS.md.]

---

## 14. Definition of Ready

An issue is ready for Pod C to begin work only when all of the following
are confirmed. Pod C must reject issues that do not meet this standard
and request the missing items from Pod A before starting.

| Criterion | Required |
|---|---|
| Business context — why this feature exists | ✅ |
| Scope — what is included | ✅ |
| Non-goals — what is explicitly excluded | ✅ |
| Acceptance criteria — specific, testable | ✅ |
| Required tests — unit, integration, E2E as applicable | ✅ |
| Linked documents — ADRs, schemas, API contracts | ✅ |
| Risk category — standard / security-sensitive / financially-sensitive | ✅ |
| Pod B review status — approved / not required (with reason) | ✅ |
| Kerem approval status — approved / not required (with reason) | ✅ |
| Synthetic data examples where relevant | ✅ |

[POD A: FILL — Add the issue template that enforces this checklist.
The template should be placed at `.github/ISSUE_TEMPLATE/feature.md`
and linked from this section.]

---

## 15. Definition of Done

A PR is done only when all of the following are confirmed.
Pod C must not merge a PR that does not meet this standard.

| Criterion | Required |
|---|---|
| All acceptance criteria from the issue are met | ✅ |
| Unit tests written and passing | ✅ |
| Integration tests written and passing where applicable | ✅ |
| CI pipeline passes (lint, type-check, test, build) | ✅ |
| Security-sensitive areas reviewed by Pod B (if triggered) | ✅ |
| Financially-sensitive areas approved by Kerem (if triggered) | ✅ |
| Documentation updated if behaviour changed | ✅ |
| Migration reviewed by Pod B if schema changed | ✅ |
| Rollback notes included if deployment-impacting | ✅ |
| No real personal data used in tests or examples | ✅ |
| PR description explains what changed and why | ✅ |

[POD A: FILL — Add the PR template that enforces this checklist.
The template should be placed at `.github/PULL_REQUEST_TEMPLATE.md`
and linked from this section.]

---

## 16. Inter-Pod Handoff Protocol

[POD A: FILL — Define the handoff process for each pod-to-pod transition.
For each transition below, specify: the trigger, the format of the handoff
package, the expected turnaround, and the acceptance check.

Transitions to cover:
- Kerem → Pod A (new feature or product question)
- Pod A → Pod B (document ready for architecture review)
- Pod B → Pod A (architecture findings requiring product decisions)
- Pod B → Pod C (specification ready for implementation)
- Pod C → Pod B (PR requiring security or architecture review)
- Pod D → Pod B (audit finding requiring architecture response)
- Pod D → Pod A (UX finding requiring product response)
- Any pod → Kerem (decision requiring product owner approval)]

---

## 17. Escalation and Conflict Resolution

[POD A: FILL — Define the escalation path when pods disagree or when a
specification is unclear. Cover:
1. Pod-level resolution: the two pods involved attempt to resolve in writing
   with documented options.
2. Pod B arbitration: for technical disagreements, Pod B's recommendation
   is advisory.
3. Kerem escalation: for product-impacting disagreements, Kerem makes the
   final decision and it is recorded in a GitHub issue comment.
4. Locked principle conflicts: if any pod identifies a genuine conflict
   with a locked principle, it must be flagged with [LOCKED PRINCIPLE CONFLICT]
   tag and escalated to Kerem immediately. Work on the affected area pauses
   until resolved.

Note that no AI pod can unilaterally resolve a conflict affecting product
scope, financial logic, security posture, or KVKK compliance.]

---

## 18. Feature Discovery Pipeline

[POD A: FILL — Define the end-to-end pipeline for new feature ideas, from
first mention to backlog entry or rejection. The pipeline must prevent two
failure modes: (a) good ideas being lost because they were mentioned
informally and never recorded, and (b) unvalidated ideas entering the
build queue without proper assessment.

Pipeline steps:
1. Idea capture → /docs/FEATURE_POSSIBILITY_MAP.md (any pod or Kerem)
2. Opportunity note → /docs/FEATURE_BACKLOG.md (Pod A drafts)
3. Pod B scan for architectural implications
4. Kerem prioritisation decision
5. Phase assignment (1 / 2 / 3 / later / rejected)
6. If approved for current phase: enters Definition of Ready process
7. If deferred: recorded in backlog with reason and review trigger

Reference /docs/FEATURE_DISCOVERY_WORKFLOW.md for the detailed template.]

---

## 19. ADR Policy

[POD A: FILL — Describe the ADR process in plain language. Cover:
- What qualifies as a decision that needs an ADR
- The standard ADR template (Context / Decision / Consequences / Alternatives Considered)
- Where ADRs live (/docs/adr/)
- Who authors an ADR (Pod B for technical decisions; Pod A for product decisions)
- Who approves an ADR (Kerem for product-impacting decisions; Pod B for pure architecture)
- What happens when an ADR needs to be amended (a new ADR supersedes it — old ADRs are never deleted)

Current ADR backlog (to be resolved by Pod B in priority order):

| ID | Decision | Priority |
|---|---|---|
| ADR-001 | Modular monolith architecture | High |
| ADR-002 | TypeScript / NestJS / Next.js stack | High |
| ADR-003 | PostgreSQL database family | High |
| ADR-004 | ORM selection (Prisma vs Drizzle) | **Critical — blocks Pod C** |
| ADR-005 | Selcafe read-only Phase 1 adapter | High |
| ADR-006 | Wallet append-only ledger | High |
| ADR-007 | Loyalty append-only ledger | High |
| ADR-008 | Schema-per-tenant tenancy strategy | High |
| ADR-009 | PR approval policy | High |
| ADR-010 | Real-time transport selection | Phase 2 |
| ADR-011 | Payment provider | Phase 2 |
| ADR-012 | Feature flag tool selection | Before Phase 1 go-live |
]

---

## 20. Security and KVKK Process

<!-- [LOCKED PRINCIPLE — Human approval required for all items in this section] -->

### 20.1 Secure SDLC

[POD A: FILL — Describe the secure development lifecycle process grounded in
NIST SSDF and OWASP SAMM. Cover: threat modelling per high-risk feature,
abuse case definition for wallet and loyalty, SAST/DAST in CI pipeline,
dependency scanning (Trivy or Snyk), and security regression tests.
Reference /docs/SECURE_SDLC.md for the detailed process.]

### 20.2 KVKK Compliance Process

[POD A: FILL — Define the KVKK compliance process. Cover all nine obligations
identified in the gap analysis:
- VERBİS registration (legal — Kerem must action)
- Data processing inventory
- Legal basis documentation per data type
- Privacy notice (Aydınlatma Metni) in the PWA
- Data subject rights process (Art. 11)
- 72-hour breach notification process
- Data retention policy
- Cross-border transfer rules (hosting-dependent)
- Phone number as primary PII identifier

Note that KVKK compliance is not satisfied by a principle statement.
Each obligation requires a completed document and an assigned owner.]

### 20.3 Mandatory Security Review Triggers

The following code areas require Pod B security review before merge:

- Authentication and session management
- Authorisation and RBAC logic
- Wallet and loyalty ledger writes
- Customer personal data access or mutation
- Audit log logic
- Selcafe adapter data ingestion
- Admin privilege escalation
- Any new third-party integration

---

## 21. QA and Test Strategy

[POD A: FILL — Describe the test strategy at a high level. Cover:

Test pyramid:
- Unit tests: pure business logic, domain services, ledger calculations
- Integration tests: API endpoints, database interactions, adapter contracts
- E2E tests: critical user flows (Playwright for PWA, Playwright for Electron Phase 2)
- Contract tests: PWA ↔ backend API, backend ↔ SelcafeAdapter
- Manual UAT: Kerem and staff validate workflows in staging before each release

Critical regression flows that must never break:
- Wallet top-up (cashier-initiated)
- Loyalty earn on eligible purchase
- Loyalty redemption (cashier-handled)
- F&B order from seat
- Reservation request and staff approval
- Audit log for all sensitive actions

Test data policy: All test data must be synthetic. No real customer names,
phone numbers, or transaction data. Use Customer A, Customer B, +90 555 000 00 01.

Reference /docs/QA_STRATEGY.md and /docs/UAT_PLAN.md for full detail.]

---

## 22. Release and Environment Management

[POD A: FILL — Reference /docs/ENVIRONMENT_STRATEGY.md and /docs/RELEASE_PROCESS.md.
Summarise the key points here:
- Five environments: local, test, staging, production, demo/sandbox
- Release cadence and versioning scheme (semantic versioning recommended)
- Staged rollout via feature flags before general availability
- Emergency hotfix process (bypasses normal iteration cadence with Kerem approval)
- Post-release monitoring window (minimum 24 hours before next release)
Reference the zero-downtime migration policy in Section 12.3.]

---

## 23. Incident Response and Business Continuity

<!-- [NEEDS KEREM APPROVAL — manual fallback procedures require staff training] -->

[POD A: FILL — Define the incident response process. Cover:
1. Detection: how is an incident identified (monitoring alert, staff report, customer report)?
2. Severity classification: P1 (platform down), P2 (critical feature broken), P3 (degraded)
3. Escalation: who is contacted at each severity level?
4. Manual fallback: how does the café operate if the platform is unavailable?
   - Wallet: cashier uses manual log
   - F&B ordering: verbal/paper orders
   - Reservations: phone or walk-in only
5. Resolution and post-incident review
6. Communication to customers and staff

Reference /docs/INCIDENT_RESPONSE_PLAN.md and /docs/MANUAL_FALLBACK_PROCEDURES.md.]

---

## 24. Roles and Responsibility Map

### 24.1 Current Roles

| Role | Person / Pod | Responsibilities |
|---|---|---|
| Product Owner | Kerem | All product decisions, final approvals, go/no-go |
| Product & Planning | Pod A (ChatGPT) | Discovery, user stories, flows, planning docs |
| Architecture & Risk | Pod B (Claude) | ADRs, schemas, API contracts, security review |
| Build & DevOps | Pod C (Claude Code) | Implementation, CI/CD, migrations, tests |
| Prototype, Audit & Monitoring | Pod D (Gemini) | Prototypes, audits, monitoring spec |

### 24.2 Missing or Underdefined Roles

[POD A: FILL — For each missing role below, define: who currently covers
it (even informally), what the gap risk is, and the recommended coverage.

| Missing Role | Gap Risk | Recommended Coverage |
|---|---|---|
| QA Lead | Test strategy undefined, coverage arbitrary | Pod B defines strategy; Pod C executes; Kerem signs UAT |
| KVKK / Legal Compliance Owner | Legal obligation without an owner | Kerem + external legal/privacy advisor [NEEDS KEREM APPROVAL] |
| Operations / SRE Owner | No incident response owner | Pod C + Pod D shared; Kerem as escalation |
| UX / Service Designer | Staff workflows unvalidated | Pod D observation + Pod A synthesis |
| Data / Analytics Role | No OLTP/OLAP strategy | Pod A + Kerem for Phase 1; dedicated role before Phase 3 |
| Release Manager | Release readiness ad hoc | Pod C owns; Kerem approves go/no-go |
| Documentation Owner | Docs drift from code | Pod A owns; all pods responsible for their own section |
| Delivery Coordinator | No work rhythm owner | Kerem owns; Pod A supports |
| SaaS Product Strategist | Phase 3 commercialisation undefined | Kerem owns; Pod A supports |
]

---

## 25. Pilot and Staged Rollout Policy

<!-- [NEEDS KEREM APPROVAL] -->

[POD A: FILL — Define the pilot programme for Phase 1 go-live. Recommended
structure:
Week 1: Staff only (cashiers and admin test all flows in production with
         real but controlled transactions)
Week 2: Invited regular customers (a defined subset, with Kerem's selection)
Week 3: All customers

Define: how pilot participants are selected, what feedback is collected,
what would cause the pilot to be paused, and what criteria confirm readiness
for full rollout. Reference the feature flag strategy in Section 12.5.]

---

## 26. Vendor and Dependency Selection Process

[POD A: FILL — Define the process for evaluating and approving new vendors
and significant npm dependencies. Cover:
- Who proposes a new vendor or dependency?
- What criteria are evaluated (security track record, KVKK data processing
  implications, licence compatibility, maintenance activity, bundle size)?
- Who approves (Pod B for architectural dependencies; Kerem for vendors with
  data processing implications)?
- How is the decision recorded (ADR for significant dependencies)?
- What is the dependency update cadence (recommended: automated Dependabot PRs
  with Pod C review)?

Reference /docs/DEPENDENCY_POLICY.md.]

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

---

## 28. Document Governance and Revision History

### 28.1 Document Ownership

| Document | Owner | Reviewer | Approver |
|---|---|---|---|
| PROJECT_METHODOLOGY.md (this document) | Pod A | Pod B | Kerem |
| PROJECT_BRIEF.md | Pod A | Pod B | Kerem |
| MVP_SCOPE.md | Pod A | Pod B | Kerem |
| BUSINESS_RULES.md | Pod A | Pod B | Kerem |
| DOMAIN_MODEL.md | Pod B | Pod A | Kerem |
| ADRs (`/docs/adr/`) | Pod B | — | Kerem (product-impacting only) |
| API Contracts (`/docs/api/`) | Pod B | Pod C | — |
| Database Schemas (`/docs/schema/`) | Pod B | Pod C | — |
| MONITORING_AND_ALERTING_SPEC.md | Pod D | Pod B | Kerem |
| All test strategy docs | Pod B (strategy) | Pod C (execution) | Kerem |

### 28.2 Revision Rules

- This document may not be changed without Kerem's explicit approval.
- All changes must be recorded in the revision log below.
- Locked sections (marked `[LOCKED]`) require a formal [LOCKED PRINCIPLE CONFLICT]
  flag and Kerem's explicit approval to amend.

### 28.3 Revision Log

| Version | Date | Author | Summary of Changes |
|---|---|---|---|
| 0.1-skeleton | [DATE] | Pod B | Initial skeleton produced. Awaiting Pod A prose completion. |

---

<!-- END OF DOCUMENT -->
<!-- 
  NEXT STEPS:
  1. Pod A: Fill all [POD A: FILL] sections with complete prose.
  2. Pod B: Review completed draft for architectural accuracy and completeness.
  3. Kerem: Approve all [NEEDS KEREM APPROVAL] items.
  4. Pod C: Commit approved version to /docs/PROJECT_METHODOLOGY.md via PR.
  5. All pods: Load this document at the start of every new session.
-->
