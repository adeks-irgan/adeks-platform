# Pod Traffic Workflow

Version: 1.1  
Project: Adeks Platform  
Owner: Kerem  
Status: Approved; ready to commit  
Path: `/docs/POD_TRAFFIC_WORKFLOW.md`

---

## 1. Purpose

This document defines the practical operating workflow between:

- Kerem
- Pod A / ChatGPT
- Pod B / Claude
- Pod C / Claude Code + Codex
- Pod D / Gemini

The goal is to prevent context drift, unclear ownership, duplicated work, and unsafe implementation decisions as the Adeks Platform moves from planning to architecture, implementation, review, and deployment.

This workflow applies to:

- Product documents
- Architecture documents
- ADRs
- GitHub issues
- Implementation tasks
- Pull requests
- Tests
- Review cycles
- Prototype and audit feedback
- Monitoring specifications

---

## 2. Core Principle: The Control Plane

The control plane for the Adeks Platform is not any AI model.

The control plane is:

| Control Element | Purpose |
|---|---|
| Kerem | Product owner, business owner, final decision maker |
| GitHub repository | Source of truth for committed project state |
| Markdown docs | Product, business, architecture, and process documentation |
| ADRs | Record of important architecture and technical decisions |
| GitHub issues | Work tracking and implementation units |
| Tests | Verifiable behavior and regression protection |
| Pull requests | Controlled change process before merge |

No pod is the project manager.

Each pod is a specialist contributor. All durable project decisions must be reflected in the repository through docs, ADRs, issues, tests, or pull requests.

---

## 3. Pod Responsibilities

### 3.1 Kerem

Kerem is the final authority for:

- Business priorities
- Scope approval
- Operational rules
- Staff workflows
- Wallet, payment, refund, and customer-data decisions
- Phase boundaries
- Go/no-go decisions
- Approving commits, pull requests, and production-impacting changes

Kerem may use pod outputs as recommendations, but approval remains human-owned.

---

### 3.2 Pod A — Product & Planning / ChatGPT

Pod A owns product and planning clarity.

Primary responsibilities:

| Area | Pod A Responsibility |
|---|---|
| Product vision | Define what is being built and why |
| MVP scope | Define Phase 1 boundaries |
| Business rules | Translate café operations into explicit rules |
| User stories | Prepare clear implementation-ready stories |
| User roles | Define permissions and operational responsibilities |
| Core flows | Describe customer, cashier, admin, and staff journeys |
| Open questions | Track unresolved business/product questions |
| GitHub issue drafts | Prepare issue-ready implementation tasks |
| Planning docs | Produce structured markdown under `/docs` |

Pod A may propose product-level assumptions, but must mark them clearly.

Pod A must not:

- Implement production code
- Finalize high-risk architecture decisions
- Invent unknown Adeks operational details
- Override locked principles
- Directly decide wallet, payment, refund, security, or customer-data logic without Kerem approval

---

### 3.3 Pod B — Architecture, Logic & Risk / Claude

Pod B owns architecture, logic, and risk review.

Primary responsibilities:

| Area | Pod B Responsibility |
|---|---|
| System architecture | Validate architecture direction |
| Domain model | Review entities, boundaries, invariants, and dependencies |
| Database design | Review schema, migrations, constraints, and data integrity |
| API contracts | Review backend/frontend interface design |
| Wallet ledger | Validate append-only wallet logic |
| Loyalty ledger | Validate append-only loyalty logic |
| Reservation state machine | Validate states, transitions, and edge cases |
| Security | Review authentication, authorization, auditability, and abuse cases |
| Threat modeling | Identify operational, technical, and privacy risks |
| ADRs | Draft or review architecture decision records |
| KVKK/privacy | Review customer-data handling risks and privacy-sensitive flows |

Pod B should identify risks, contradictions, missing decisions, and unsafe assumptions before implementation reaches Pod C.

---

### 3.4 Pod C — Build & DevOps / Claude Code + Codex

Pod C owns implementation and delivery mechanics.

Primary tools:

- Claude Code
- OpenAI Codex CLI

Primary responsibilities:

| Area | Pod C Responsibility |
|---|---|
| Code implementation | Build approved issues |
| Database migrations | Create and test schema changes |
| Tests | Add unit, integration, and regression tests |
| Refactoring | Improve implementation while preserving behavior |
| CI/CD | Maintain build, lint, test, and deployment pipelines |
| Docker | Prepare and maintain containerized development/runtime setup |
| Environments | Support local, staging, and future production environment setup |
| Local debugging | Diagnose implementation failures |
| Pull requests | Submit implementation changes for review |

Tool usage rule:

| Tool | Best Used For |
|---|---|
| Claude Code | Multi-file codebase reasoning, larger implementation, local debugging |
| Codex | Small, well-defined GitHub issues with clear acceptance criteria |

Pod C must not implement from vague planning notes. It should work from approved issues, reviewed docs, or explicit Kerem direction.

---

### 3.5 Pod D — Prototype, Audit & Monitoring / Gemini

Pod D owns prototype exploration, broad audit, and monitoring-oriented review.

Primary responsibilities:

| Area | Pod D Responsibility |
|---|---|
| PWA prototypes | Explore customer-facing app flows |
| UI flow exploration | Test screen logic and interaction ideas |
| Screenshot review | Review UI clarity and usability |
| Large-context review | Audit docs/code for consistency across the project |
| Global consistency audit | Find contradictions, missing pieces, and naming drift |
| Monitoring spec | Propose observability, alerts, dashboards, and operational checks |
| Future client exploration | Support later Android or PC-client prototype thinking |

Pod D feedback should return as structured findings, not direct uncontrolled changes.

---

## 4. Which Pod Handles Which Type of Question?

| Question Type | Primary Pod | Secondary Pod |
|---|---:|---:|
| What should Phase 1 include? | Pod A | Kerem |
| Is this business rule correct? | Pod A | Kerem |
| Is this wallet logic safe? | Pod B | Kerem |
| Is this loyalty ledger design valid? | Pod B | Kerem |
| How should the database schema work? | Pod B | Pod C |
| Should this be an ADR? | Pod B | Pod A |
| Can this be implemented now? | Pod C | Pod B |
| Why is CI failing? | Pod C | Pod B |
| Is this UI flow understandable? | Pod D | Pod A |
| Does the whole project have context drift? | Pod D | Pod A |
| What should be monitored in production? | Pod D | Pod B / Pod C |
| Is this a KVKK or customer data privacy question? | Pod B | Kerem |
| Is this ready to merge? | Kerem | Pod B / Pod C / Pod D as needed |
| Is this safe for customer data? | Pod B | Kerem |
| Is this acceptable for Adeks operations? | Kerem | Pod A |

---

## 5. Standard Document Workflow

The standard document workflow is:

```text
Kerem request
→ Pod A draft
→ Kerem clarification if needed
→ Pod B review required for defined high-risk document types
→ Pod B review optional for pure product/planning documents
→ Pod A revision if needed
→ Kerem approval
→ Commit to repo
```

---

## 5.1 Document Types That Require Pod B Review

Pod B review is required before commit for documents that define, alter, or materially affect any of the following:

| Area | Reason |
|---|---|
| Wallet | Financial correctness and append-only ledger requirement |
| Loyalty | Ledger integrity and customer balance correctness |
| Payments | Financial, compliance, and operational risk |
| Refunds | Financial, fraud, and audit risk |
| Authentication | Account security |
| Authorization | Staff/customer permission boundaries |
| Customer data | KVKK/privacy implications |
| Selcafe integration | Legacy system risk and Phase 1 read-only constraint |
| Audit logs | Admin accountability and traceability |
| Schema migrations | Data integrity and rollback risk |
| Reservation state machine | Operational correctness and edge cases |
| Security-sensitive admin flows | Abuse prevention and auditability |
| ADRs | Durable architecture decision record |

For pure product/planning documents that do not touch the areas above, Pod B review is optional and may be requested by Kerem or Pod A.

---

## 5.2 Pod A Drafting Rules

Each Pod A document should include:

- Clear title
- Version number
- Status
- Intended file path
- Purpose
- Scope
- Assumptions
- Business rules where relevant
- Open questions where relevant
- Review routing
- Commit readiness status

Pod A should produce a v0.1 draft even when some information is missing, provided assumptions and open questions are clearly marked.

---

## 5.3 Review Routing in Documents

Each major document should identify what happens next.

Recommended section:

```markdown
## Review Routing

| Item | Status |
|---|---|
| Ready for Kerem review | Yes / No |
| Requires Pod B review | Yes / No |
| Requires Pod C implementation | Yes / No |
| Requires Pod D audit/prototype review | Yes / No |
| Repo context checked (freshness) | Yes / No / N/A |
| Ready to commit | Yes / No |
```

---

## 6. Standard Review Workflow

Reviews should be structured, not conversationally scattered.

---

## 6.1 Pod B Review Format

When Pod B reviews a document, feedback should be returned in this format:

```markdown
# Pod B Review — [Document Name]

## Summary Decision

- Approved
- Approved with comments
- Needs revision
- Blocked

## Critical Issues

| ID | Issue | Required Action |
|---|---|---|

## Architecture Notes

| ID | Note | Impact |
|---|---|---|

## Risk Notes

| ID | Risk | Severity | Recommendation |
|---|---|---|---|

## Suggested Edits for Pod A

| Section | Suggested Change |
|---|---|

## ADR Candidates

| Topic | Reason |
|---|---|
```

---

## 6.2 Pod A Response to Pod B Review

Pod A should classify Pod B feedback into:

| Feedback Type | Pod A Action |
|---|---|
| Clear correction | Apply revision |
| Architecture decision | Mark for ADR or Pod B ownership |
| Product ambiguity | Ask Kerem or mark open question |
| Implementation detail | Move to issue draft or Pod C handoff |
| Disagreement | Use disagreement workflow |

Pod A should not silently ignore Pod B feedback.

---

## 7. Standard Implementation Workflow

The standard implementation workflow is:

```text
Approved doc or decision
→ Pod A creates issue draft
→ Kerem approves issue
→ Pod B reviews issue if it touches mandatory-review areas
→ Pod C implements in branch
→ Tests added or updated
→ Pull request opened
→ Review by appropriate pod(s)
→ Kerem approval
→ Merge
```

---

## 7.1 Implementation Input Requirements

Pod C should receive a clear handoff packet before implementation.

Minimum required inputs:

- Issue title
- Business context
- Scope
- Non-goals
- Acceptance criteria
- Relevant docs
- Required tests
- Risk notes
- Approval requirements

Pod C should not be expected to infer business rules from chat history.

---

## 7.2 Issue Types That Require Pod B Sign-Off Before Pod C Starts

Pod B sign-off is required before a handoff packet is issued to Pod C for implementation work touching any of the following:

| Issue Type | Pod B Review Required? |
|---|---:|
| Wallet | Yes |
| Loyalty | Yes |
| Authentication | Yes |
| Authorization | Yes |
| Customer data | Yes |
| KVKK/privacy data handling | Yes |
| Selcafe integration | Yes |
| Payment | Yes |
| Refund | Yes |
| Audit log | Yes |
| Schema migration | Yes |
| Reservation state machine | Yes |
| Security-sensitive admin action | Yes |

For all other issue types, Pod B review is optional and may be requested by Kerem, Pod A, or Pod C.

Decision status: **Approved by Kerem.**

---

## 8. Handoff Packet Format

Use this format when transferring work between pods.

```markdown
# Handoff Packet — [Short Title]

## From

Pod A / Pod B / Pod C / Pod D

## To

Pod A / Pod B / Pod C / Pod D / Kerem

## Purpose

Short explanation of why this handoff exists.

## Source Material

| Source | Path / Link | Notes |
|---|---|---|

## Current Status

- Draft
- Reviewed
- Approved
- Blocked
- In implementation
- In PR
- Merged

## Scope

What is included.

## Non-Goals

What is explicitly excluded.

## Key Decisions Already Made

| Decision | Source |
|---|---|

## Assumptions

| ID | Assumption | Owner to Confirm |
|---|---|---|

## AI-Assumption Control

| Question | Answer |
|---|---|
| Does this packet contain AI-generated assumptions? | Yes / No |
| Are all assumptions explicitly marked? | Yes / No |
| Have any assumptions been approved as project facts? | Yes / No / Not applicable |
| Where are approved assumptions documented? | Path / link / Not applicable |

## Open Questions

| ID | Question | Owner |
|---|---|---|

## Required Output

What the receiving pod should produce.

## Acceptance Criteria

| ID | Criterion |
|---|---|

## Risks / Warnings

| ID | Risk | Severity | Suggested Handling |
|---|---|---|---|

## Required Reviews Before Implementation

| Review Area | Required? | Reviewer |
|---|---:|---|
| Pod B architecture/risk review | Yes / No | Pod B |
| Kerem approval | Yes / No | Kerem |
| Pod D prototype/audit review | Yes / No | Pod D |

## Approval Needed

| Approver | Required For |
|---|---|
```

---

## 9. How Pod B Feedback Returns to Pod A

Pod B feedback returns to Pod A when:

- A product document has architecture implications
- A business rule creates technical risk
- A domain model needs correction
- A workflow is missing important edge cases
- A locked principle is threatened
- An ADR is needed
- Implementation would be unsafe without revision

Pod A should then produce one of the following:

| Pod B Feedback Result | Pod A Output |
|---|---|
| Minor edits | Revised document |
| Missing business decision | Question for Kerem |
| Architecture issue | Mark section for Pod B ownership or ADR |
| Scope problem | Revised MVP or non-goal section |
| Implementation ambiguity | Improved issue draft |
| Major conflict | Escalation summary for Kerem |

Pod A should preserve the distinction between:

- Product decision
- Architecture decision
- Implementation detail
- Operational policy
- Legal/privacy requirement

---

## 10. Disagreement Resolution

Disagreements must be resolved through the control plane.

---

## 10.1 Types of Disagreement

| Type | Example | Resolution Owner |
|---|---|---|
| Product disagreement | Whether a feature belongs in Phase 1 | Kerem |
| Architecture disagreement | Whether to use polling, SSE, or WebSocket | Pod B recommends, Kerem approves if strategic |
| Implementation disagreement | Which service/module should own a function | Pod C proposes, Pod B reviews |
| UX disagreement | Whether a flow is too complex for customers | Pod D proposes, Pod A/Kerem decide |
| Security disagreement | Whether a shortcut is acceptable | Pod B reviews, Kerem approves only if acceptable |
| Compliance disagreement | Whether customer data handling is allowed | Kerem with legal/compliance input |

---

## 10.2 Escalation Format

When pods disagree, use this format:

```markdown
# Decision Escalation — [Topic]

## Decision Needed

Clear statement of the decision.

## Options

| Option | Description | Pros | Cons |
|---|---|---|---|

## Pod Positions

| Pod | Recommendation | Reason |
|---|---|---|

## Risk Summary

| Risk | Severity | Notes |
|---|---|---|

## Recommended Next Step

One recommended action.

## Final Decision

To be completed by Kerem.
```

No pod should resolve a high-impact disagreement by acting unilaterally.

---

## 11. When a Document Is Ready to Commit

A document is ready to commit when all required conditions are met.

---

## 11.1 Commit Readiness Checklist

| Requirement | Required? |
|---|---:|
| File path is clear | Yes |
| Purpose is clear | Yes |
| Scope and non-goals are defined where relevant | Yes |
| Assumptions are marked | Yes |
| Open questions are marked | Yes |
| Locked principles are respected | Yes |
| Synthetic data only | Yes |
| Pod B review completed if document touches mandatory-review areas | Yes |
| Freshness declaration present for §5.1 mandatory-review documents | Yes |
| Kerem approval received | Yes |
| Status updated | Yes |

---

## 11.2 Not Ready to Commit

A document is not ready to commit if:

- It contains unresolved contradictions
- It changes a locked principle without explicit escalation
- It includes real customer data
- It makes unapproved wallet, payment, refund, security, or customer-data decisions
- It contains architecture decisions that Pod B has not reviewed
- It assigns implementation work without acceptance criteria
- It relies on chat context that is not captured in the document
- It is tagged `Needs repo reconciliation` or `Blocked by missing repo context` under §16.4

---

## 12. Rules to Prevent Context Drift

Context drift is when pods start acting on outdated, incomplete, or conflicting assumptions.

---

## 12.1 Source-of-Truth Rules

| Rule | Explanation |
|---|---|
| Repository beats chat | If it is not in the repo, it is not durable project state |
| Committed docs beat draft docs | Drafts may change; committed docs are current baseline |
| ADRs beat informal architecture notes | Important technical decisions must be recorded |
| Issues beat vague implementation requests | Pod C should work from clear issues |
| Tests beat assumptions | Expected behavior should be verified when possible |
| Kerem approval beats pod preference | Final product authority remains with Kerem |

---

## 12.2 Context Hygiene Rules

All pods should follow these rules:

1. Do not rely on old chat messages when a committed document exists.
2. Do not create new terminology without checking existing docs.
3. Do not rename domains, roles, or modules casually.
4. Do not treat Selcafe as the core domain model.
5. Do not bypass the vendor-neutral architecture principle.
6. Do not write directly to Selcafe in Phase 1 unless Kerem explicitly approves a later change.
7. Do not overwrite wallet or loyalty balances directly.
8. Do not use real customer data in examples.
9. Do not implement high-risk flows without approval.
10. Do not merge directly to `main`.
11. Do not let AI-generated assumptions become project facts unless approved and documented.
12. Do not leave important decisions only in chat.

---

## 12.3 Naming Consistency Rules

The following names should be used consistently:

| Concept | Approved Name |
|---|---|
| Project | Adeks Platform |
| Current legacy café software | Selcafe |
| Phase 1 customer app | Customer PWA |
| Cashier/admin app | Web-based cashier/admin interface |
| Future PC software | Adeks PC Client |
| Integration abstraction | CafeManagementAdapter |
| Current legacy adapter | SelcafeAdapter |
| Future native engine | AdeksNativeCafeEngine |
| Product/planning pod | Pod A — Product & Planning |
| Architecture/risk pod | Pod B — Architecture, Logic & Risk |
| Implementation pod | Pod C — Build & DevOps |
| Prototype/audit pod | Pod D — Prototype, Audit & Monitoring |

---

## 13. Special Rules for High-Risk Areas

The following areas require stricter handling:

| Area | Required Handling |
|---|---|
| Wallet | Append-only ledger; no direct balance overwrite; human approval required; Pod B review required |
| Loyalty | Append-only ledger; no direct balance overwrite; human approval required; Pod B review required |
| Payments | Kerem approval and Pod B review required |
| Refunds | Kerem approval and Pod B review required |
| Customer data | KVKK-aware handling; Pod B review required |
| Authentication | Pod B review required |
| Authorization | Pod B review required |
| Admin actions | Must be auditable |
| Audit logs | Pod B review required when structure, retention, or security impact is involved |
| Schema migrations | Pod B review required before implementation |
| Selcafe integration | Read-only in Phase 1 unless Kerem explicitly approves otherwise |
| Production deployment | Pod C implementation with Pod B risk review as needed |
| Monitoring | Pod D monitoring spec, Pod C implementation, Pod B review if security/reliability impact exists |

---

## 14. Pull Request Approval Policy

This section records the approved PR approval policy.

| PR Type | Requirement |
|---|---|
| Code PR | Always requires Kerem approval before merge |
| Documentation-only PR | May use lighter review, but Kerem must have visibility before merge |
| ADR PR | Requires Kerem approval if it records a strategic, security, financial, customer-data, or architecture decision |
| Security-sensitive PR | Requires Pod B review and Kerem approval |
| Wallet/loyalty/payment/refund PR | Requires Pod B review and Kerem approval |
| Selcafe integration PR | Requires Pod B review and Kerem approval |
| Schema migration PR | Requires Pod B review and Kerem approval |

Decision status: **Approved by Kerem.**

A formal ADR should be created for the PR approval policy.

---

## 15. Practical Examples

---

### 15.1 Example: New Business Rule

```text
Kerem explains rule
→ Pod A writes BUSINESS_RULES.md update
→ Pod B reviews if rule affects wallet, loyalty, reservation, security, data, audit, or Selcafe integration
→ Kerem approves
→ Commit
```

---

### 15.2 Example: New Architecture Decision

```text
Pod B identifies decision needed
→ ADR draft created
→ Kerem reviews business impact
→ Pod B finalizes recommendation
→ Kerem approves
→ Commit ADR
```

---

### 15.3 Example: New Feature Implementation

```text
Approved MVP scope
→ Pod A drafts GitHub issue
→ Pod B reviews if issue touches mandatory-review areas
→ Kerem approves issue
→ Pod C implements
→ Tests pass
→ PR opened
→ Review
→ Kerem approves merge
```

---

### 15.4 Example: UI Flow Concern

```text
Pod A defines flow
→ Pod D prototypes or audits flow
→ Pod D returns structured feedback
→ Pod A revises flow document
→ Kerem approves
→ Commit
```

---

## 16. Agent Session Sync Protocol

Agents do not have reliable dynamic shared memory. Every pod session must reconstruct current project state from GitHub before producing durable output.

This section defines the minimum sync protocol for starting and ending agent sessions.

A **substantial session/output** means any pod work that produces or materially changes a document, ADR, GitHub issue draft, PR description, PR review comment, implementation handoff, decision note, or other project artifact intended to guide future work.

---

### 16.1 Start-of-Session Sync

Before starting meaningful work, each pod must inspect the latest available project context.

| Source | Required? | Purpose |
|---|---:|---|
| `/docs/POD_TRAFFIC_WORKFLOW.md` | Yes | Workflow, routing, approval rules |
| Relevant `/docs/*.md` files | Yes | Current product, planning, architecture, and process state |
| Relevant ADRs | When applicable | Durable architecture and technical decisions |
| Relevant GitHub issues | When applicable | Work scope, implementation units, and acceptance criteria |
| Relevant PRs | When applicable | Current implementation and review state |
| Latest Kerem instruction | Yes | Current human direction |

If an agent cannot access GitHub directly, Kerem should paste the relevant file excerpts or provide a handoff/context packet.

---

### 16.2 Freshness Declaration

Every substantial pod output should include a short freshness note.

For documents or outputs that define, alter, or materially affect any §5.1 mandatory-review area, the freshness declaration **must** be present.

The freshness note should live inside the output document, GitHub issue draft, PR description, or PR review comment. It should not be created as a separate file unless Kerem explicitly asks for a separate reconciliation artifact.

Recommended format:

```markdown
## Context Freshness

| Item | Status |
|---|---|
| Repo context checked | Yes / No |
| Relevant docs checked | List paths |
| Relevant ADRs checked | List paths / Not applicable |
| Relevant issues checked | List issue numbers / Not applicable |
| Relevant PRs checked | List PR numbers / Not applicable |
| Known stale areas | None / List |
```

The freshness declaration does not make an output automatically approved. It only states what context the pod checked before producing the output.

---

### 16.3 Stale Context Rule

An agent output should be treated as stale if it was produced without checking the relevant committed docs, ADRs, issues, or PRs.

Stale output may still be useful as a draft, but it should not be treated as authoritative until reconciled with GitHub.

---

### 16.4 Sync Failure Handling

If a pod cannot verify the latest GitHub state, it must clearly mark its output with one of the following statuses.

| Status | Meaning |
|---|---|
| Draft from provided context | Based only on pasted, uploaded, or otherwise provided context |
| Needs repo reconciliation | Must be checked against GitHub before commit, implementation, or approval |
| Blocked by missing repo context | Cannot safely proceed without current repo state |

Outputs tagged `Needs repo reconciliation` or `Blocked by missing repo context` are not ready to commit under §11.2.

---

### 16.5 End-of-Session Output Rule

At the end of a substantial session, the pod should produce one of the following durable outputs:

- Commit-ready markdown
- GitHub issue draft
- ADR draft
- PR review comment
- Handoff packet
- Open question for Kerem
- Reconciliation note explaining what changed

Important decisions must not remain only in chat.

---

### 16.6 No Hidden Source-of-Truth Rule

This section does not create a separate source-of-truth rule. It applies the control-plane principle in §2 and the source-of-truth rules in §12.1 to individual agent sessions.

Agent memory, chat history, local reasoning, and uncommitted drafts are not durable project state.

If a decision, requirement, rule, or approval matters, it must be captured in one of the repository-backed control-plane artifacts described in §2 and §12.1.

---

### 16.7 Minimum Handoff Requirement

When transferring work from one pod to another, the sending pod must provide enough context for the receiving pod to continue without relying on hidden chat history.

Field definitions are governed by §7.1 and §8. This subsection defines only the minimum gate for handoff completeness.

Minimum handoff content:

| Item | Required? |
|---|---:|
| Source documents or links | Yes |
| Current task objective | Yes |
| Scope | Yes |
| Non-goals | Yes |
| Assumptions | Yes, if any |
| Open questions | Yes, if any |
| Required review path | Yes |
| Expected output | Yes |

The existing handoff packet format in §8 should be used for larger or higher-risk transfers.

---

### 16.8 Practical Rule

Before acting, each pod should ask:

> “What is the latest committed source of truth for this topic?”

After acting, each pod should ask:

> “Where will this output live in GitHub?”

If the answer to the second question is unclear, the output should be treated as temporary and non-authoritative.

---

## 17. Approved Governance Decisions

The following governance decisions are approved by Kerem.

| ID | Decision | Approved Rule |
|---|---|---|
| PQ-001 | Which issue types require mandatory Pod B review before Pod C implementation? | Pod B review is mandatory for wallet, loyalty, authentication, authorization, payments, refunds, customer data, Selcafe integration, audit logs, schema migrations, reservation state machine, and security-sensitive admin actions. Other issues are discretionary. |
| PQ-002 | Should Pod D perform periodic full-project consistency audits? | Yes. Minimum audits should occur before Phase 1 go-live, before Phase 2 begins, and before Phase 3 tenant architecture is implemented. |
| PQ-003 | Should the repo include `/docs/templates/`? | Yes. The repo should include `/docs/templates/` to reduce handoff and review format drift. |
| PQ-004 | Should PR approval rules differ between documentation-only PRs and code PRs? | Yes. Code PRs always require Kerem approval. Documentation-only PRs may use lighter review but must not merge without Kerem visibility. The final PR approval rule should be captured in an ADR. |
| PQ-005 | Should every agent session sync to GitHub and declare freshness before producing durable output? | Every substantial pod session must reconstruct current project state from GitHub before producing durable output. Freshness declarations are required for documents and outputs touching §5.1 mandatory-review areas. Outputs tagged `Needs repo reconciliation` or `Blocked by missing repo context` are not ready to commit until reconciled. |

---

## 18. Document Status

| Item | Status |
|---|---|
| Ready for Kerem review | Completed |
| Requires Pod B review | Completed |
| Requires Pod C implementation | No |
| Requires Pod D audit/prototype review | Optional |
| Ready to commit | Yes |

---

## 19. Summary

The Adeks Platform workflow depends on a clear separation of responsibilities:

- Kerem decides.
- The repository records.
- Pod A plans.
- Pod B reviews architecture, logic, privacy, and risk.
- Pod C builds and operates delivery mechanics.
- Pod D prototypes, audits, and supports monitoring clarity.

The purpose of this workflow is to keep the project controlled, reviewable, auditable, and resistant to context drift as it moves from Phase 1 planning toward implementation and future commercialization.
