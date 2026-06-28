# PHASE_GATES.md

## Status

| Field | Value |
|---|---|
| Document | `PHASE_GATES.md` |
| Version | v0.1 |
| Owner | Pod A — Product & Planning |
| Reviewer | Pod B — Architecture, Logic & Risk |
| Approver | Kerem |
| Current status | Draft phase-gate criteria for review |
| Target repo path | `/docs/PHASE_GATES.md` |
| Source context | `/docs/PROJECT_METHODOLOGY.md`; `/docs/ROADMAP.md`; `/docs/AGENT_CONTEXT_MANIFEST.md`; `/docs/PROJECT_DECISION_INDEX.md`; relevant accepted ADRs and current product/planning docs |
| Change class | Planning/control document creation |
| Implementation status | Does **not** authorize Pod C implementation |
| Data rule | Synthetic examples only; no real customer, phone, transaction, wallet, loyalty, reservation, staff, screenshot, test, credential, or secret data |
| Issue link | GitHub planning/review issue `#98` |

---

## Purpose

This document defines the phase-gate criteria for the Adeks Platform ten-phase lifecycle.

It is the companion home referenced by `/docs/PROJECT_METHODOLOGY.md` for entry and exit criteria. It converts the lifecycle into practical gate checks so the project does not move from discovery to build, release, or iteration based on chat-only assumptions.

This document is a planning/control artifact only. It does not create implementation work, does not authorize Pod C, does not approve schema/API contracts, does not select vendors, does not change accepted ADRs, and does not permit direct writes to Selcafe SQL Server.

---

## Scope / Non-Goals

### In Scope

- Defines entry criteria for each of the existing ten lifecycle phases.
- Defines exit criteria for each of the existing ten lifecycle phases.
- Defines authority rules for phase movement.
- Preserves the current roadmap sequence.
- Preserves current blockers before Pod C implementation.
- Records the current Product Phase 1 gate status.
- Marks incomplete or uncertain gate criteria with `[NEEDS KEREM APPROVAL]` or `[NEEDS POD B REVIEW]`.

### Non-Goals

- Does not change the ten-phase lifecycle.
- Does not change the Phase 1 roadmap sequence.
- Does not approve implementation.
- Does not create Pod C-ready feature issues.
- Does not approve any architecture, schema, API, ledger, security, KVKK, hosting, monitoring, or rollback decision.
- Does not reopen accepted ADRs.
- Does not authorize direct writes to Selcafe SQL Server.
- Does not select SMS, hosting, monitoring, payment, or other vendors.
- Does not define final legal/KVKK positions.
- Does not replace `/docs/PROJECT_METHODOLOGY.md`, accepted ADRs, or Kerem decisions.

---

## Gate Authority Rules

| Rule | Authority |
|---|---|
| Phase movement requires explicit repo-visible approval | Kerem |
| Product direction, business scope, customer experience, financial policy, wallet/loyalty value, refunds, campaigns, pricing, promotions, and pilot/go-live decisions | Kerem |
| Architecture, schema, API contracts, ledger design, state machines, security, KVKK, Selcafe integration, deployment, hosting, monitoring, rollback, and ADR-impacting decisions | Pod B review required; Kerem approval required where product, legal, financial, customer-data, operational, or vendor impact exists |
| Product/planning documents | Pod A drafts; Pod B reviews where risk-sensitive; Kerem approves where product/business impact exists |
| UX prototype, PWA flow review, broad consistency audit, monitoring/audit review | Pod D where triggered |
| Implementation begins | Only from a separate GitHub issue that satisfies Definition of Ready |
| PR completion | Must satisfy Definition of Done and applicable ADR-009 review triggers |
| Merge | Kerem only |
| Real customer/staff/transaction data in non-production docs, tests, screenshots, prototypes, or AI sessions | Prohibited |
| Selcafe Phase 1 access posture | Read-only only unless Kerem explicitly approves a later change after Pod B review |
| Wallet/loyalty balances | Append-only ledger logic; no direct balance overwrite |
| Legal/KVKK gate | Legal advisor inputs, Pod B risk review, and Kerem approval required before personal-data implementation or production customer-data use |

---

## Pod Impact Matrix

| Pod | Impact | Required Follow-Up |
|---|---|---|
| Pod A | None beyond authoring this document. Phase gate criteria apply to Pod A's product/planning outputs. | None. |
| Pod B | Phase 8 entry criteria formalize when Pod B review is required before Pod C implementation begins. No new review obligation beyond existing ADR-009 §3 and methodology gates. | None beyond acknowledging this document routes architecture/security/KVKK areas to Pod B. |
| Pod C | Phase 8 entry criteria define the DoR threshold Pod C must satisfy before implementation begins. No behavioral change to Pod C implementation process; DoR gate already existed. | None. Pod C must not implement from this planning document. |
| Pod D | Phase 9 entry/exit criteria route pre-go-live audit and consistency audit gates to Pod D. No behavioral change beyond formalizing existing Pod D scope. | None. |

**Instruction Update Required:** No. This document does not change Pod A, B, C, or D external platform instructions. No external pod instruction update or re-paste is required.

**Update (PR #110, Operating Slice Checkpoint).** PR #110 added the Operating Slice Checkpoint as a Phase 7 entry criterion (see "Operating Slice Checkpoint (Phase 7 entry)" under Phase-by-Phase Entry Criteria). That is a light behavior-changing gate: Pod A must ensure a Kerem-approved, reconciled end-to-end operating-slice model is committed before slice-level Phase 7 work, and Pod B must apply the checkpoint and its boundary test before authoring or reviewing component-level ADRs, schema/API, or implementation-ready issues for a slice. The Pod Impact Matrix and Instruction Update Packet for that change are recorded in the PR #110 body. No external pod-instruction snapshot change or re-paste is required; snapshots remain pointer-only.

---

### Gate Evidence Rule

A phase is not considered complete because a chat session says it is complete. Gate evidence must be recorded in the repository as one or more of:

- committed document;
- accepted ADR;
- GitHub issue comment;
- PR review;
- Kerem approval note;
- audit report;
- spike report;
- test/CI evidence;
- release record;
- retrospective.

### Phase Numbering Note

This document uses two meanings of “phase”:

1. **Lifecycle phases** — the ten methodology phases: Strategic Discovery through Learn and Iterate.
2. **Product Phase 1** — the current Adeks release scope: customer PWA plus web cashier/admin foundation.

The section “Current Phase 1 Gate Status” refers to **Product Phase 1**, not lifecycle Phase 1 only. Product Phase 1 spans multiple lifecycle phases and does not map 1:1 to lifecycle Phase 1.

---

## Phase-by-Phase Entry Criteria

| Lifecycle Phase | Name | Entry Criteria |
|---:|---|---|
| 1 | Strategic Discovery | Kerem has identified a product/business concern or strategic direction; Pod A has loaded current repo context; existing locked decisions and constraints are known; no implementation commitment is implied. |
| 2 | User Research | Phase 1 discovery outputs are committed or explicitly marked as remediation gaps; target user/stakeholder groups are identified; Kerem authorizes staff/customer observation or interview activity where needed. |
| 3 | Ideation and Brainstorm | User-research context, as-is flows, stakeholder needs, or current remediation gaps are available; ideation is explicitly non-committal; ideas are captured without prioritization. |
| 4 | Assumption Validation | Candidate ideas/opportunities exist; assumptions are identified; low-confidence assumptions affecting scope, architecture, personal data, Selcafe, wallet, loyalty, payments, launch, or operations are marked for validation. |
| 5 | Prioritisation and Scoping | Assumptions are mapped or explicitly accepted as unresolved; candidate opportunities are documented; Pod A can draft scope boundaries; Pod B can identify architecture/risk dependencies. |
| 6 | Planning and Roadmap | Scope candidate exists; dependencies are visible; roadmap can be milestone-based; blockers and review owners are known; no build start is implied. |
| 7 | Architecture and Design | Product scope and business rules are sufficiently stable for Pod B review; architecture-sensitive areas are routed to Pod B; required ADR candidates are identified; legal/KVKK-sensitive flows are flagged; for an operating slice, the **Operating Slice Checkpoint** (see subsection below this table) must also be satisfied. |
| 8 | Build and Test | A separate implementation issue satisfies Definition of Ready; required product docs, business rules, ADRs, API/schema contracts, security/KVKK review, synthetic data examples, test expectations, and approvals are linked; Pod C can implement without guessing. |
| 9 | Release and Operate | Candidate implementation satisfies Definition of Done; CI passes; staging/UAT evidence exists; release, rollback, monitoring, incident, legal/KVKK, security, Pod D audit, and Kerem go/no-go gates are ready. |
| 10 | Learn and Iterate | Product has launched or completed a controlled pilot; monitoring, feedback, support, incident, and usage data are available; post-launch review cadence is defined; Kerem is ready to decide continue/revise/defer/expand. |

---

### Operating Slice Checkpoint (Phase 7 entry)

Operating Slice Checkpoint — Before component-level ADRs, schema/API design, or implementation-ready issue drafting for an operating slice, a Kerem-approved end-to-end operating-slice model for that slice must be committed and reconciled against locked ADRs and decisions, with no open [LOCKED PRINCIPLE CONFLICT] for the slice.

Foundational platform decisions that are not tied to a specific operating slice — such as ledgers, tenancy, authentication, and the read-only Selcafe posture — are locked independently and are out of scope for this checkpoint.

This criterion authorizes nothing by itself and changes no other gate.

**Boundary test:**
- If the decision can be reused across many future slices without depending on this slice's café workflow, it is foundational.
- If the decision changes because of this slice's actors, steps, data shown, settlement path, customer-visible behavior, staff workflow, or Selcafe read surface, it is tied to the operating slice and must pass the checkpoint.

---

## Phase-by-Phase Exit Criteria

| Lifecycle Phase | Name | Exit Criteria |
|---:|---|---|
| 1 | Strategic Discovery | Product vision, problem framing, north star metric, stakeholder framing, and strategic constraints are recorded or explicitly listed as remediation gaps; Kerem approves moving to research. |
| 2 | User Research | Personas, as-is flows, current customer/staff journeys, and Jobs-to-be-Done inputs are documented or explicitly marked as gaps; no real personal data is exposed; Kerem approves moving to ideation. |
| 3 | Ideation and Brainstorm | Feature Possibility Map or equivalent idea inventory is recorded; ideas are not prematurely treated as scope; deferred ideas remain visible; Kerem approves moving to validation. |
| 4 | Assumption Validation | Assumption Map, spike outputs, MVP hypotheses, and low-confidence risk actions are recorded; any unresolved high-risk assumption is either resolved or explicitly accepted/deferred by Kerem with Pod B review where needed. |
| 5 | Prioritisation and Scoping | MVP scope, scope boundaries, feature dependency map, and phase-gate criteria are documented; included/excluded items have reasons; architecture/security/KVKK-sensitive dependencies are routed; Kerem approves scope movement. |
| 6 | Planning and Roadmap | Roadmap is approved as milestone sequence; blockers are explicit; sequencing does not bypass legal/KVKK, architecture/security, SMS/provider, hosting/cross-border, or DoR gates; Kerem approves architecture/design planning. |
| 7 | Architecture and Design | Required ADRs, domain/state models, API/schema contracts, security/KVKK reviews, integration boundaries, audit/monitoring/release constraints, and risk decisions are complete enough to create DoR issues; Pod B review is recorded; Kerem approval is recorded where triggered. |
| 8 | Build and Test | Implementation PRs satisfy Definition of Done; tests/CI pass; docs are updated; security/financial/customer-data/Selcafe/schema/deployment review triggers are closed; no real data is used outside production; Kerem approval is recorded where triggered. |
| 9 | Release and Operate | Go/no-go approval is recorded; release is deployed through approved process; monitoring and rollback are active; post-deployment checks pass; incidents are recorded; pilot/full rollout status is clear. |
| 10 | Learn and Iterate | Product metrics, support feedback, staff/customer feedback, incidents, and operational learnings are reviewed; follow-up decisions are recorded; next-cycle ideas return to Phase 1 rather than bypassing discovery. |

---

## Current Phase 1 Gate Status

This section covers the current **Product Phase 1** release scope: customer PWA plus web cashier/admin foundation.

| Gate Area | Current Status | Required Before Pod C Implementation / Launch |
|---|---|---|
| Roadmap control | `ROADMAP.md` exists as a planning-only Phase 1 sequence. | Keep milestone sequence unchanged unless Kerem approves a documented change. |
| Implementation authorization | Not authorized. | Separate GitHub issues must satisfy Definition of Ready before Pod C starts. |
| Operating-spine scope reconciliation | K-21 approved on 2026-06-28; KD-1/KD-2 post-Pod-B-review constraints recorded. Product Phase 1 spine is Selcafe-linked customer visibility and ordering. | Product documents may record the direction, but active visit/bill/order-line visibility cannot become implementation-ready until ADR-005 read-surface expansion, KVKK/legal review, auditability, retention, data-minimization review, and later Pod B review are complete. The operating model remains provisional for feasibility/risk review. Pod D later reviews 2% mismatch / pilot pause / first-week check UX or monitoring where relevant. |
| Legal/KVKK | Blocking. `DATA_PROCESSING_INVENTORY.md`, `KVKK_LEGAL_BASIS.md`, and `CROSS_BORDER_TRANSFER_ASSESSMENT.md` remain required KVKK control artifacts before personal-data implementation/launch claims. | Legal advisor input, Pod B review, and Kerem approval. |
| Retention policy | Open. `DATA_RETENTION_POLICY.md` remains needed for retention periods where current repo context requires retention closure. | Legal advisor input, Pod B review, and Kerem approval. |
| Privacy notice | K-14/K-15/K-16 mechanics are locked, but legal text and legal sufficiency confirmation remain open. | Final Turkish `PRIVACY_NOTICE_TR.md`; confirmation of K-15/K-16 sufficiency; Kerem approval. |
| VERBİS / exemption | Open. | Legal advisor determination and Kerem action. |
| SMS provider | Not selected. | Provider selection after commercial and legal/KVKK processor/cross-border review; outage/availability path approved. |
| Hosting / cross-border | Not locked. | Hosting/deployment model plus cross-border assessment; Pod B review; Kerem approval. |
| Security/architecture | Review-level security artifact exists; architecture-sensitive implementation still blocked by issue-level readiness. | Pod B review for auth, audit, Selcafe, wallet, loyalty, F&B, reservation, deployment, monitoring, rollback, schema/API, and ADR-triggered areas. |
| Authentication | ADR-015 accepted; implementation blocked. | SMS provider, legal/KVKK closure, admin bootstrap, approved DoR issues. |
| Selcafe | Phase 1 posture remains read-only. ADR-005 accepted; implementation remains spike/report/integration-view dependent. | Read-only spike/report where required; Pod B review; Kerem approval for further access; no write posture change without explicit approval. |
| Wallet | ADR-006 accepted; implementation blocked. | Legal/KVKK closure, remaining top-up business rules, security/DoR packets, Pod B + Kerem-approved implementation issue. |
| Loyalty | ADR-007 accepted; F&B accrual formula locked; implementation blocked. | Legal/KVKK closure, redemption/expiry/exclusion rules, security/DoR packets, Pod B + Kerem-approved implementation issue. |
| F&B ordering | Lifecycle/state model accepted; not Pod C-ready. | API/schema/audit/ledger/legal/security gates; issue-level DoR; Pod B + Kerem approval where sensitive. |
| Reservations | Included in MVP; detailed product rules and state machine remain incomplete. | Kerem approval of reservation rules; Pod B state machine; approved DoR issue before implementation. |
| Monitoring/SLO/release | 99.9% target exists as planning target; monitoring/release readiness incomplete. | Pod D monitoring spec, Pod B operational/deployment review, rollback path, incident path, Kerem go/no-go. |
| Pod D pre-go-live audit | Required before go-live. | Full consistency audit; findings triaged; blockers closed or explicitly accepted by Kerem. |
| Kerem approval | Required for phase movement and go/no-go. | Repo-visible approval before moving through gates that affect scope, implementation, release, or launch. |

### Product Phase 1 Current Gate Classification

| Gate | Classification |
|---|---|
| Discovery / planning | Partially complete; remediation artifacts remain. |
| Scope / roadmap | Planning sequence exists; not implementation authorization. |
| Architecture/design | Partially complete; several accepted ADRs exist, but implementation packets remain blocked. |
| Build readiness | Not ready. |
| Release readiness | Not ready. |
| Launch readiness | Not ready. |

---

## Blockers Before Pod C Implementation

The following blockers must be closed before any Product Phase 1 implementation issue is treated as Pod C-ready.

| Blocker | Why It Blocks | Owner / Review |
|---|---|---|
| Legal/KVKK closure | Customer authentication, wallet, loyalty, F&B, reservations, audit, logs, retention, and provider processing involve personal data or compliance exposure. | Legal advisor + Kerem; Pod B review |
| `KVKK_LEGAL_BASIS.md` | Legal basis per data class is not yet recorded. | Kerem/legal advisor; Pod B review |
| `DATA_PROCESSING_INVENTORY.md` | Data-processing inventory must remain the KVKK control artifact for personal-data classes, purposes, and processing surfaces; inventory status does not by itself authorize implementation. | Kerem/legal advisor; Pod B review |
| `DATA_RETENTION_POLICY.md` | Retention periods for personal-data-bearing records remain needed where current repo context requires retention closure. | Kerem/legal advisor; Pod B review |
| `CROSS_BORDER_TRANSFER_ASSESSMENT.md` | Hosting, SMS, monitoring, logging, and support vendors may create cross-border transfer exposure. | Kerem/legal advisor; Pod B review |
| SMS provider selection | Customer OTP depends on provider choice, processor terms, cost, deliverability, and outage handling. | Kerem + Pod B |
| SMS outage/availability path | OTP failure handling affects customer login and staff support. | Kerem + Pod B |
| Hosting/deployment model | Production posture, secrets backend, cross-border, monitoring, backup, and rollback depend on hosting. | Pod B + Kerem |
| Security/architecture review | Auth, RBAC, audit, ledgers, Selcafe integration, schema/API, deployment, and rollback require risk review. | Pod B |
| Approved API/schema contracts | Pod C must not infer interfaces or database structure from product text alone. | Pod B |
| Accepted ADRs where triggered | Architecture, security, ledger, provider, deployment, and integration decisions must be durable. | Pod B + Kerem where required |
| Approved Definition-of-Ready issues | Pod C starts only from a separate issue with business context, scope, non-goals, acceptance criteria, tests, linked docs, risk class, review status, approvals, and synthetic examples. | Pod A + Pod B + Kerem as applicable |
| Reservation product rules/state machine | Reservation implementation cannot proceed from incomplete rules. | Pod A + Kerem; Pod B |
| Wallet and loyalty remaining business rules | Value-affecting flows require explicit policy and review. | Kerem + Pod A; Pod B |
| Selcafe spike/integration readiness | Phase 1 integration must remain read-only and adapter-bounded. | Pod B + Kerem |
| Monitoring/release/rollback readiness | Release must not occur without observability, rollback, incident, and staff fallback posture. | Pod D + Pod B + Kerem |
| Pod D audit before go-live | Pre-go-live consistency, UX, monitoring, and cross-document audit are required. | Pod D; Pod A/Pod B routing; Kerem |

---

## Review Routing

| Review Area | Required? | Owner |
|---|---:|---|
| Pod B review for architecture/security/KVKK/Selcafe/wallet/loyalty/auth/hosting/release gates | Yes | Pod B |
| Kerem approval for phase gates and phase movement | Yes | Kerem |
| Pod C implementation | No | Not authorized by this document |
| Pod D prototype/audit/monitoring review | Conditional | Pod D where PWA prototype, UX review, monitoring specification, pre-go-live audit, or broad consistency audit gates are triggered |
| Legal advisor review | Conditional | Kerem/legal advisor where legal/KVKK gate criteria require legal input; Pod B reviews technical/security implications |
| ADR update | No by default | Pod B only if this document is found to change or conflict with an accepted ADR or methodology gate |

---

## Open Questions

| ID | Open Question | Owner | Routing |
|---|---|---|---|
| PG-OQ-001 | Does Kerem approve this v0.1 phase-gate structure as the working gate framework? | Kerem | `[NEEDS KEREM APPROVAL]` |
| PG-OQ-002 | [RESOLVED] Pod B confirmed the Operating Slice Checkpoint (Phase 7 entry, added in PR #110) is a behavior-changing criterion that tightens the Phase 7 entry/approval gate; it was gated with a Pod Impact Matrix and Instruction Update Packet in the PR #110 body, with no external pod-instruction snapshot change (snapshots remain pointer-only). No other current criterion changes methodology, review gates, or ADR-009 behavior-change posture. | Pod B | Resolved; matrix/IUP recorded in PR #110; no external snapshot update required |
| PG-OQ-003 | Should Product Phase 1 gate status remain in this document, or should future product-phase status move to a separate release-readiness tracker? | Kerem + Pod A | `[NEEDS KEREM APPROVAL]` |
| PG-OQ-004 | What exact evidence threshold is sufficient for Phase 1 discovery remediation artifacts such as `VISION.md`, `PROBLEM_STATEMENT.md`, `STAKEHOLDER_MAP.md`, and user-research documents? | Kerem + Pod A | `[NEEDS KEREM APPROVAL]` |
| PG-OQ-005 | Which legal/KVKK closure outputs must be treated as implementation blockers versus launch blockers after legal advisor feedback arrives? | Kerem + legal advisor + Pod B | `[NEEDS KEREM APPROVAL]` / `[NEEDS POD B REVIEW]` |
| PG-OQ-006 | Should Pod D’s pre-go-live audit criteria be expanded into a separate checklist document before release planning? | Pod D + Kerem | `[NEEDS KEREM APPROVAL]` |
| PG-OQ-007 | [RESOLVED] Pod B confirmed a Pod Impact Matrix is required for this PR because the document defines phase-gate criteria. The matrix is included in this document. | Pod B + Kerem | Resolved for v0.1; no external pod instruction update required |

---

## Implementation Authorization Notice

This document is planning/control only.

It does not authorize:

- Pod C implementation;
- feature issue creation for implementation;
- code changes;
- schema/API creation;
- migration work;
- provider selection;
- hosting selection;
- wallet/loyalty/payment/refund behavior;
- security-sensitive admin behavior;
- personal-data processing implementation;
- direct Selcafe SQL Server writes;
- release or go-live.

Any implementation must proceed through a separate GitHub issue that satisfies Definition of Ready and all required Pod B, Kerem, legal/KVKK, and review gates.

---

## Handoff Prompt to Pod B

You are Pod B — Architecture, Logic & Risk for the Adeks Platform.

### Handoff Summary

Pod A drafted `docs/PHASE_GATES.md` v0.1 and created planning/review issue #98.

### Source Pod

Pod A — Product & Planning

### Target Pod

Pod B — Architecture, Logic & Risk

### Trigger

`PROJECT_METHODOLOGY.md` references `/docs/PHASE_GATES.md` as the home for phase-gate criteria, but the file was absent/planned. Kerem requested a v0.1 planning/control draft.

### Relevant Links / Files

- Planning/review issue: #98
- `docs/PHASE_GATES.md` in the PR
- `docs/PROJECT_METHODOLOGY.md`
- `docs/ROADMAP.md`
- `docs/AGENT_CONTEXT_MANIFEST.md`
- `docs/PROJECT_DECISION_INDEX.md`
- `docs/POD_EDIT_WORKFLOW.md`
- `docs/adr/ADR-009-pr-approval-policy.md`
- `docs/adr/ADR-013-repository-controlled-pod-context.md`

### Decision or Review Needed

Review `docs/PHASE_GATES.md` v0.1 for:

1. Whether it preserves the existing ten-phase lifecycle without changing roadmap sequence.
2. Whether architecture/security/KVKK/Selcafe/wallet/loyalty/auth/hosting/release gate logic is correctly routed to Pod B.
3. Whether it preserves current blockers before Pod C implementation:
   - legal/KVKK;
   - SMS/provider;
   - hosting/cross-border;
   - security/architecture review;
   - approved DoR issues;
   - Kerem approval.
4. Whether any wording accidentally authorizes Pod C implementation.
5. Whether this PR should include a Pod Impact Matrix because the document defines gate criteria.

### Constraints

- Planning/review only — does not authorize Pod C implementation.
- Any implementation requires a separate Definition-of-Ready feature issue.
- Do not reopen accepted ADRs.
- Do not approve direct writes to Selcafe SQL Server.
- Do not resolve legal/KVKK, SMS provider, hosting, or security decisions in this review unless they already have canonical approval.
- Route final phase movement approval to Kerem.

### Expected Output

Return a written review with findings classified as:

- Blocking
- Needs Change
- Advisory
- Needs Kerem Decision

End with:

- recommended next status;
- required owner action;
- whether Kerem must decide;
- whether another pod must review;
- whether a canonical artifact must be updated;
- confirmation that implementation is not authorized.
