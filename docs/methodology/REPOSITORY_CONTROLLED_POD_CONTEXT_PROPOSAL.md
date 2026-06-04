# Adeks Platform — Repository-Controlled Pod Context Proposal

**Version:** v0.2  
**Date:** 2026-06-04  
**Author:** Pod A — Product & Planning  
**Primary reviewer:** Pod B — Architecture, Logic & Risk  
**Approver:** Kerem  
**Status:** Ready for Kerem decision on MD-2…MD-6; **not ready to commit**  
**Intended repo path after approval:** `/docs/methodology/REPOSITORY_CONTROLLED_POD_CONTEXT_PROPOSAL.md` or `/docs/REPOSITORY_CONTROLLED_POD_CONTEXT_PROPOSAL.md`

---

## 0. Status and Scope of This v0.2 Draft

This v0.2 document revises Pod A's Repository-Controlled Pod Context proposal after Pod B review.

This file is a **proposal and decision packet**, not a final repository implementation package.

### 0.1 Current status

| Item | Status |
|---|---|
| Pod B review of v0.1 | Approved with comments |
| Required revisions REV-1…REV-7 | Applied in this v0.2 |
| Kerem decision state | MD-1 resolved; MD-2…MD-6 remain for Kerem |
| Ready to commit | No |
| Ready for Kerem decision | Yes |
| Ready for Pod C implementation PRs | No — only after Kerem approves MD-2…MD-6 |
| Manifest/templates produced as final repo files | No — intentionally deferred until Kerem approves direction |

### 0.2 Context freshness

| Item | Status |
|---|---|
| Repo context checked | No direct live GitHub access in this session |
| Context basis | Uploaded files supplied by Kerem |
| Relevant docs checked | `POD_B_REVIEW_REPOSITORY_CONTROLLED_POD_CONTEXT.md`, `PROJECT_DECISION_INDEX.md`, `ADEKS_REPOSITORY_CONTROLLED_POD_CONTEXT_PROPOSAL_v0.1.md`, `POD_TRAFFIC_WORKFLOW.md`, `PROJECT_METHODOLOGY.md`, `CLAUDE.md`, `KEREM_DECISIONS.md`, `POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` |
| Known stale areas | Must reconcile against latest `main` before any PR |
| Output status | Draft from provided context; ready for Kerem decision; not ready to commit |

---

## 1. Purpose

This proposal defines a practical methodology for keeping all Adeks Platform AI pods synchronized when repository documents, methodology rules, review gates, pod responsibilities, output formats, or external AI platform instructions change.

The core problem is not that the project lacks methodology. The problem is that methodology and agent-behavior rules have been spread across multiple documents and external AI platform instructions. That creates context drift when one file changes but another remains stale.

The proposed model is:

> GitHub owns durable project truth. External AI platform instructions act only as bootloaders that assign role, define boundaries, and tell each pod which repository files to load or request.

---

## 2. Inputs Reviewed

| Source | Role in v0.2 |
|---|---|
| `POD_B_REVIEW_REPOSITORY_CONTROLLED_POD_CONTEXT.md` | Primary review input; source of REV-1…REV-7 |
| `PROJECT_DECISION_INDEX.md` | Canonical decision-index instance drafted by Pod B; referenced, not recreated |
| `ADEKS_REPOSITORY_CONTROLLED_POD_CONTEXT_PROPOSAL_v0.1.md` | Source draft being revised |
| `POD_TRAFFIC_WORKFLOW.md` v1.1 | Workflow source to be stubbed/archived after migration |
| `PROJECT_METHODOLOGY.md` v0.3 | Canonical methodology target |
| `CLAUDE.md` | Pod C local repo instructions affected by sequencing |
| `KEREM_DECISIONS.md` | Canonical home for K-01…K-10 |
| `POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` | New Pod B instruction snapshot already committed by Kerem under `/docs/pod-instructions/` |

---

## 3. Decision-State Update Since v0.1

### 3.1 Tenancy strategy

Tenancy strategy is now:

> **Deferred / not locked.**

Canonical state:

| Item | Value |
|---|---|
| Decision | Tenancy strategy |
| Current status | Deferred / not locked |
| Decided by | Kerem |
| Date | 2026-06-04 |
| Canonical sources | `PROJECT_DECISION_INDEX.md` + ADR-008 marked deferred |
| Candidates retained | Schema-per-tenant / shared schema with `tenant_id` / database-per-tenant |
| Consequence | Blocks Pod C schema/migration/`TenantContext` work and blocks final ORM selection until revisited |
| v0.2 wording rule | Do not call tenancy "conflicting" and do not call tenancy "locked" |

### 3.2 Project decision index

`PROJECT_DECISION_INDEX.md` already exists as a Pod B-owned drafted file. This v0.2 proposal does **not** recreate it.

The proposal keeps the decision-index specification as an architectural/process requirement but treats the existing Pod B draft as the canonical instance to refine, review, and commit later.

Required rule for the decision index:

> `PROJECT_DECISION_INDEX.md` mirrors ADRs, methodology, and recorded Kerem decisions. It does not establish decisions.

If the index conflicts with an accepted ADR, the ADR wins and the index is stale. If an external AI platform instruction file says a decision is locked but the decision index and ADRs do not, the instruction file is stale until reconciled.

---

## 4. Resolved Open Questions from Pod B Review

| OQ | Resolution to carry into v0.2 |
|---|---|
| OQ-001 | `PROJECT_DECISION_INDEX.md` has Pod B as sole owner; Pod A reviews product/business-impacting rows; Kerem approves status transitions into or out of `Locked` for product/business-impacting rows. |
| OQ-002 | Methodology consolidation requires both ADR-013 and a methodology §28 revision. |
| OQ-003 | `POD_TRAFFIC_WORKFLOW.md` should remain as a permanent deprecation stub at the original path and be archived in full at `/docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md`. |
| OQ-005 | Tenancy is deferred / not locked. ADR-008 is deferred. |
| OQ-006 | `AGENT_CONTEXT_MANIFEST.md` rows must include fallbacks for absent files and status markers. |
| OQ-007 | Pod instruction snapshots must be reference-only; they must not embed locked-decision tables or volatile live-state lists. |

OQ-004 is carried into MD-6 because Kerem still needs to approve the final scope of the Pod Impact Matrix.

---

## 5. Remaining Kerem Decisions

The v0.1 decision labels K-1…K-6 are replaced with MD-1…MD-6 to avoid collision with the K-01…K-10 decision series in `KEREM_DECISIONS.md`.

| ID | Decision | Options | Pod A recommendation | Status |
|---|---|---|---|---|
| MD-1 | Tenancy strategy | Lock now / defer | Defer | Resolved by Kerem: deferred / not locked |
| MD-2 | Approve methodology-consolidation direction | Approve / revise / reject | Approve with REV-1…REV-7 applied | Open |
| MD-3 | Record consolidation as ADR-013 + methodology revision | ADR only / methodology revision only / both | Both | Open |
| MD-4 | Decision-index ownership | Pod B sole / Pod A+B joint | Pod B sole owner; Pod A reviewer where product-impacting | Open |
| MD-5 | Workflow file disposition | Permanent stub / archive-then-delete / both | Permanent stub + full archive | Open |
| MD-6 | Pod Impact Matrix scope | All PRs / conditional gate only | Conditional gate only | Open |

### 5.1 Required Kerem answer format

Kerem can approve the remaining direction by recording:

```md
## Kerem Decisions — Repository-Controlled Pod Context

| ID | Decision |
|---|---|
| MD-2 | Approved / revise / reject |
| MD-3 | ADR-013 + methodology revision approved? Yes / No |
| MD-4 | Project decision index ownership approved as Pod B sole owner? Yes / No |
| MD-5 | Workflow file disposition approved as permanent stub + archive? Yes / No |
| MD-6 | Pod Impact Matrix approved as conditional gate only? Yes / No |
```

---

## 6. Guiding Principles

| Principle | Meaning |
|---|---|
| Repository is authoritative | GitHub repository documents, ADRs, issues, PRs, and tests are the durable control plane. |
| External AI instructions are not live state | ChatGPT, Claude, Gemini, Claude Code, and Codex instructions must not become independent decision stores. |
| One canonical methodology source | `/docs/PROJECT_METHODOLOGY.md` owns methodology, lifecycle, review gates, approval gates, handoff, escalation, and AI-session continuity. |
| Context routing is separate from methodology | `/docs/AGENT_CONTEXT_MANIFEST.md` tells pods what to load/request; it does not create rules. |
| Decision state is indexed, not decided, in the index | `PROJECT_DECISION_INDEX.md` mirrors ADRs, methodology, and Kerem decisions; it does not establish decisions. |
| Behavior changes require propagation | If a PR changes pod behavior, it must include an instruction update path. |
| Attachments beat links when tool access is uncertain | A repo link is a pointer; an attached file, pasted content, Project Source, connector access, or local repo access is context. |
| Pod C works from issues | Implementation starts from approved GitHub issues with acceptance criteria and linked docs/ADRs. |
| High-risk areas remain gated | Wallet, loyalty, payment, refund, customer data, KVKK, Selcafe, auth, permissions, audit logs, schema, and security-sensitive admin flows require Pod B and/or Kerem review. |
| Git commands must be explicit | Whenever a pod asks Kerem to branch, commit, open a PR, merge, remove, move, archive, or otherwise run repository actions, the pod must provide exact git commands or state why commands are intentionally omitted. |

---

## 7. Proposed Repository-Controlled Pod Context Model

### 7.1 Layer model

| Layer | File(s) | Purpose | Establishes decisions? |
|---|---|---|---|
| Canonical methodology | `/docs/PROJECT_METHODOLOGY.md` | Rules of engagement, lifecycle, review gates, handoff, escalation, AI-session continuity | Yes, after Kerem approval |
| Context routing | `/docs/AGENT_CONTEXT_MANIFEST.md` | What files each pod should load/request by task type | No |
| Decision index | `/docs/PROJECT_DECISION_INDEX.md` | Current state of locked/deferred/not locked/superseded/conflicting decisions | No — mirrors ADRs/methodology/Kerem decisions |
| ADRs | `/docs/adr/ADR-*.md` | Durable architecture and methodology decisions | Yes, when accepted |
| Templates | `/docs/templates/*.md` | Standard output formats | No, except where methodology says a template is mandatory |
| Pod instruction snapshots | `/docs/pod-instructions/*.md`, `/CLAUDE.md` | Canonical text to paste/use in AI platforms | No — reference-only bootloaders |
| Deprecated workflow | `/docs/POD_TRAFFIC_WORKFLOW.md` + archive | Link-safe historical transition path | No |

---

## 8. Repository Structure Proposal

### 8.1 Canonical methodology layer

| File | Purpose | Owner | Reviewer | Approver |
|---|---|---|---|---|
| `/docs/PROJECT_METHODOLOGY.md` | Canonical methodology, lifecycle, review gates, approval gates, DoR, DoD, handoff, escalation, AI continuity | Pod A custodian | Pod B | Kerem |

Governance-sensitive sections require mandatory Pod B review before merge. These include review gates, approval triggers, ADR policy, security/KVKK process, escalation, AI-session continuity, methodology revision process, and pod behavior rules.

### 8.2 Context routing layer

| File | Purpose | Owner | Reviewer | Approver |
|---|---|---|---|---|
| `/docs/AGENT_CONTEXT_MANIFEST.md` | Tells each pod what files to load/request for each task type | Pod A | Pod B | Kerem |

The manifest must not become a second methodology document. It must route context, not define governance.

### 8.3 Decision state layer

| File | Purpose | Owner | Reviewer | Approver |
|---|---|---|---|---|
| `/docs/PROJECT_DECISION_INDEX.md` | Mirrors current decision state across ADRs, methodology, and Kerem decisions | Pod B | Pod A where product/business-impacting | Kerem for any status transition into or out of `Locked` on product/business-impacting rows |

`PROJECT_DECISION_INDEX.md` has already been drafted by Pod B. This proposal references it as the canonical decision-index instance and does not recreate it.

### 8.4 Templates layer

Each template must have an explicit owner.

| File | Purpose | Owner | Reviewer | Approver |
|---|---|---|---|---|
| `/docs/templates/HANDOFF_PACKET.md` | Standard pod-to-pod handoff format | Pod A custodian | Pod B | Kerem if methodology-impacting |
| `/docs/templates/POD_B_REVIEW.md` | Standard Pod B review format | Pod B | Pod A optional | Pod B |
| `/docs/templates/DECISION_ESCALATION.md` | Standard escalation format for conflicts or owner decisions | Pod A custodian | Pod B | Kerem if methodology-impacting |
| `/docs/templates/INSTRUCTION_UPDATE_PACKET.md` | Standard packet for pod-behavior and external instruction updates | Pod A custodian | Pod B | Kerem if behavior-changing |
| `/docs/templates/CONTEXT_FRESHNESS.md` | Standard context freshness declaration | Pod A custodian | Pod B | Kerem if methodology-impacting |

### 8.5 Pod instruction snapshot layer

| File | Purpose | Owner | Author | Reviewer | Approver |
|---|---|---|---|---|---|
| `/docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md` | Canonical copy of ChatGPT Project / Pod A instructions | Kerem | Pod A | Pod B | Kerem |
| `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` | Canonical copy of Claude Project / Pod B instructions | Kerem | Pod B | Pod A optional / Pod B self-check | Kerem |
| `/CLAUDE.md` | Claude Code / Pod C local repo instruction file | Kerem | Pod C or Pod A/B depending on change | Pod B | Kerem |
| `/docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md` | Canonical copy of Gemini Gem / Pod D instructions | Kerem | Pod D | Pod A + Pod B if behavior-sensitive | Kerem |

`POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` has already been committed by Kerem under `/docs/pod-instructions/`. Future changes to it should follow the snapshot anti-drift guardrails in Section 10.

### 8.6 Deprecated or archived workflow layer

| File | Proposed action | Notes |
|---|---|---|
| `/docs/POD_TRAFFIC_WORKFLOW.md` | Permanent deprecation stub after migration | Keeps existing links and references from breaking |
| `/docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md` | Full historical archive | Preserves original approved workflow content |

---

## 9. `POD_TRAFFIC_WORKFLOW.md` v1.1 Migration Map

This section satisfies REV-1.

The stub PR for `/docs/POD_TRAFFIC_WORKFLOW.md` must not be mergeable until every row below has a confirmed destination.

### 9.1 Required migration map

| Source content in `POD_TRAFFIC_WORKFLOW.md` v1.1 | Destination | Required action before stub merge | Merge-blocking? |
|---|---|---|---:|
| §14 Pull Request Approval Policy | `PROJECT_METHODOLOGY.md` PR-policy section + ADR-009 | Confirm all PR approval rules are represented in methodology or ADR-009 draft plan | Yes |
| §16 Agent Session Sync Protocol | `PROJECT_METHODOLOGY.md` §27 AI Session Continuity Protocol + `/docs/templates/CONTEXT_FRESHNESS.md` | Confirm start-of-session sync, freshness declaration, stale-context rule, sync-failure handling, end-of-session output rule, and minimum handoff gate are migrated | Yes |
| §17 Approved Governance Decisions | `PROJECT_DECISION_INDEX.md` | Confirm PQ-001…PQ-005 or equivalent governance decisions are represented as decision-index rows or referenced to canonical decision records | Yes |
| §8 Handoff Packet Format | `/docs/templates/HANDOFF_PACKET.md` + `PROJECT_METHODOLOGY.md` §16 reference | Confirm the template exists or is planned in the same PR sequence and methodology points to it | Yes |
| §10 Disagreement Resolution / §10.2 Escalation Format | `/docs/templates/DECISION_ESCALATION.md` + `PROJECT_METHODOLOGY.md` §17 reference | Confirm escalation format has a destination | Yes |
| §6.1 Pod B Review Format | `/docs/templates/POD_B_REVIEW.md` | Confirm Pod B review template owner is Pod B | Yes |
| §11 Commit Readiness Checklist | `PROJECT_METHODOLOGY.md` §14/§15 and/or methodology governance section | Confirm not-ready-to-commit logic survives, including stale context statuses | Yes |
| §12 Context Drift Rules | `PROJECT_METHODOLOGY.md` §1, §27 and `AGENT_CONTEXT_MANIFEST.md` | Confirm no hidden-source-of-truth and context hygiene rules survive | Yes |

### 9.2 Stub requirement

The replacement stub at `/docs/POD_TRAFFIC_WORKFLOW.md` should:

- state that the file is deprecated,
- point to `/docs/PROJECT_METHODOLOGY.md` as canonical methodology,
- point to `/docs/AGENT_CONTEXT_MANIFEST.md` for context loading,
- point to `/docs/PROJECT_DECISION_INDEX.md` for decision state,
- point to `/docs/templates/` for handoff/review/escalation/freshness templates,
- point to `/docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md` for the historical full version,
- state that the stub exists permanently to preserve old links.

---

## 10. Pod Instruction Snapshot Anti-Drift Guardrails

This section satisfies REV-2.

### 10.1 Canonical snapshot rule

The repository snapshot is canonical.

External AI platform instructions must be copied from the repository snapshot after any merged PR that changes a pod instruction file.

| Platform | Canonical repo file |
|---|---|
| ChatGPT Project / Pod A | `/docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md` |
| Claude Project / Pod B | `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` |
| Claude Code / Pod C | `/CLAUDE.md` |
| Gemini Gem / Pod D | `/docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md` |

### 10.2 Required snapshot header

Each platform-instruction snapshot must carry this header:

```md
<!--
  POD: Pod X — [Role]
  CANONICAL REPO PATH: /docs/pod-instructions/[file].md
  VERSION: x.y
  LAST UPDATED: YYYY-MM-DD
  LAST SYNCED TO PLATFORM: YYYY-MM-DD / Not yet synced
  SOURCE OF TRUTH: GitHub repository docs, ADRs, issues, PRs, and tests
  DECISION STATE SOURCE: /docs/PROJECT_DECISION_INDEX.md and /docs/adr/
  METHODOLOGY SOURCE: /docs/PROJECT_METHODOLOGY.md
-->
```

### 10.3 Reference-only rule

Instruction snapshots must contain:

- pod role,
- role boundaries,
- source-of-truth rule,
- context loading rule,
- output style,
- stop conditions,
- pointers to `PROJECT_METHODOLOGY.md`,
- pointers to `PROJECT_DECISION_INDEX.md`,
- pointers to relevant ADRs.

Instruction snapshots must not contain:

- full locked-decision tables,
- live open-question lists,
- volatile ADR counts,
- current sprint status,
- current blockers that belong in GitHub issues,
- copied methodology sections that can drift,
- duplicated review/approval trigger tables unless required as a short safety summary and explicitly marked as secondary to methodology.

### 10.4 Post-merge re-paste rule

If a PR changes a pod instruction snapshot, the PR is not operationally complete until Kerem or the assigned operator has re-pasted the updated text into the corresponding AI platform, where applicable.

The `INSTRUCTION_UPDATE_PACKET.md` must include:

```md
- [ ] Updated repo snapshot merged
- [ ] External platform text re-pasted from repo snapshot
- [ ] `LAST SYNCED TO PLATFORM` header updated
- [ ] Any stale platform instruction text replaced
```

---

## 11. `AGENT_CONTEXT_MANIFEST.md` Specification

This section satisfies REV-3.

### 11.1 Purpose

`AGENT_CONTEXT_MANIFEST.md` answers:

> What should each pod load or request before acting on this task?

It is a routing index, not a methodology replacement.

### 11.2 Required row fields

Every task-context row must include:

| Field | Required? | Description |
|---|---:|---|
| Task type | Yes | The work category, e.g. wallet, loyalty, F&B ordering, methodology change |
| Required files | Yes | Files to load/request |
| File status | Yes | `exists`, `planned`, `missing`, or `unknown` |
| Fallback if absent | Yes | What the pod should do if a file does not exist |
| Affected pods | Yes | Pods that may need to act or be informed |
| Required review | Yes | Pod B / Kerem / Pod D / none |
| Freshness requirement | Yes | Whether context freshness declaration is mandatory |

### 11.3 Example manifest row format

```md
| Task Type | Required Files | File Status | Fallback if Absent | Affected Pods | Required Review | Freshness Required |
|---|---|---|---|---|---|---|
| Wallet | `/docs/BUSINESS_RULES.md`, ADR-006, `/docs/SECURITY_REVIEW.md`, KVKK docs | mixed: exists/planned | If ADR/security docs are absent, proceed only with product draft and mark output `Needs repo reconciliation`; do not create implementation issue | A, B, C | Kerem + Pod B | Yes |
| Methodology change | `/docs/PROJECT_METHODOLOGY.md`, `/docs/PROJECT_DECISION_INDEX.md`, affected templates, affected snapshots | mixed | If any affected file is absent, list missing files and produce proposal only; do not mark ready to commit | A, B, C, D | Pod B + Kerem | Yes |
```

### 11.4 CI existence/link check recommendation

Pod B recommends, and Pod C should later implement, a cheap CI check that validates:

- manifest file paths exist when marked `exists`,
- files marked `planned` are allowed to be absent,
- links to templates and ADRs are not broken,
- deprecated paths point to stubs or archives,
- no manifest row references a removed file without fallback instructions.

This check should be introduced only after the manifest is approved and committed.

---

## 12. Conditional PR Pod Impact Matrix

This section satisfies REV-4.

### 12.1 Scope

The Pod Impact Matrix should not appear as a full matrix on every PR by default. That would create checkbox fatigue.

Instead, the standard PR template should include one universal gate question.

### 12.2 Universal gate question

Add this to `.github/PULL_REQUEST_TEMPLATE.md`:

```md
# Pod / Methodology Impact Gate

Does this PR change any pod's behavior, responsibilities, review or approval gates, context-loading rules, output format, locked/deferred decision state, methodology, templates, or external AI platform instructions?

- [ ] No
- [ ] Yes — full Pod Impact Matrix and Instruction Update Packet required
```

### 12.3 If the answer is yes

If the answer is `Yes`, the PR must include:

```md
## Pod Impact Matrix

| Pod | Impacted? | Reason | Required Follow-Up |
|---|---:|---|---|
| Pod A | Yes / No | | |
| Pod B | Yes / No | | |
| Pod C | Yes / No | | |
| Pod D | Yes / No | | |

## Instruction Update Requirement

| Question | Answer |
|---|---|
| Instruction Update Packet required? | Yes |
| Instruction Update Packet included? | Yes / No |
| Affected instruction snapshots | List paths |
| External platform re-paste required? | Yes / No |
| `PROJECT_DECISION_INDEX.md` update required? | Yes / No |
| `AGENT_CONTEXT_MANIFEST.md` update required? | Yes / No |
```

### 12.4 Integration with existing Review Triggers

This gate must be integrated with the existing PR template's `Review Triggers` section. It must not duplicate wallet, loyalty, auth, customer-data, Selcafe, audit-log, database-migration, payment, admin-privilege, or refund review triggers.

Interpretation:

| Existing Review Triggers | New Pod / Methodology Impact Gate |
|---|---|
| Determines business/security/financial/data review requirements | Determines whether pod behavior, methodology, manifest, decision index, templates, or instruction snapshots changed |
| Applies to high-risk implementation and docs | Applies to process/pod-behavior changes |
| Requires Pod B/Kerem based on content | Requires full impact matrix + instruction update packet when `Yes` |

---

## 13. Revised PR Sequencing

This section satisfies REV-5.

No PR should be opened until Kerem approves MD-2…MD-6.

### 13.1 Proposed sequence after Kerem approval

| PR | Purpose | Key files | Required reviews |
|---|---|---|---|
| PR-1 | Record methodology direction | `PROJECT_METHODOLOGY.md` §28 revision; ADR-013 draft/acceptance path; reference to decision index | Pod B + Kerem |
| PR-2 | Migrate workflow content, stub workflow file, and update Pod C pointer in the same PR | Archive `/docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md`; replace `/docs/POD_TRAFFIC_WORKFLOW.md` with permanent stub; update `/CLAUDE.md` so it no longer treats the old workflow file as a core methodology source; confirm migration map destinations | Pod B + Kerem |
| PR-3 | Add context routing and templates | `/docs/AGENT_CONTEXT_MANIFEST.md`; `/docs/templates/HANDOFF_PACKET.md`; `/docs/templates/POD_B_REVIEW.md`; `/docs/templates/DECISION_ESCALATION.md`; `/docs/templates/INSTRUCTION_UPDATE_PACKET.md`; `/docs/templates/CONTEXT_FRESHNESS.md` | Pod B + Kerem |
| PR-4 | Update PR template and process-change issue template | `.github/PULL_REQUEST_TEMPLATE.md`; optional `.github/ISSUE_TEMPLATE/process_change.md` or `governance_change.md` | Pod B + Kerem |
| PR-5 | Add/update pod instruction snapshots | `/docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md`; `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD`; `/docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md`; `/CLAUDE.md` if further snapshot alignment needed | Pod B + Kerem |

### 13.2 PR-2 merge preconditions

PR-2 must not merge unless:

- `/docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md` contains the full original v1.1 file,
- `/docs/POD_TRAFFIC_WORKFLOW.md` is replaced by a permanent stub,
- `/CLAUDE.md` is updated in the same PR,
- every row in the migration map in Section 9 has a confirmed destination,
- no Pod C instruction points to the deprecated workflow file as the primary methodology source,
- Kerem approval is recorded.

---

## 14. ADR-013 — Methodology Consolidation

This section satisfies REV-7.

The methodology-consolidation ADR should be:

```txt
ADR-013: Repository-Controlled Pod Context
```

ADR-013 should record:

| Field | Content |
|---|---|
| Context | Methodology and pod behavior rules were duplicated across `PROJECT_METHODOLOGY.md`, `POD_TRAFFIC_WORKFLOW.md`, `CLAUDE.md`, and external platform instructions. |
| Decision | Use `PROJECT_METHODOLOGY.md` as canonical methodology; use manifest for context routing; use decision index as decision-state mirror; use reference-only pod instruction snapshots; stub/archive `POD_TRAFFIC_WORKFLOW.md`. |
| Alternatives considered | Do nothing; delete workflow file immediately; keep both methodology and workflow as active rule sources; put all context in external platform instructions. |
| Consequences | Less drift, clearer ownership, more PR ceremony for behavior-changing changes, need to maintain manifest/index/templates. |
| Supersedes | Active use of `/docs/POD_TRAFFIC_WORKFLOW.md` as a methodology source. |
| Approver | Kerem |
| Reviewer | Pod B |

ADR-013 is required because the consolidation establishes a pattern all pods must follow and supersedes an existing process document.

---

## 15. Platform Applicability and Workflow

### 15.1 General rule

A file path in instructions is not access.

| Source | AI can read it? | Condition |
|---|---:|---|
| Local path mentioned in instructions | No | A path alone is not context. |
| File uploaded in chat | Yes | Available in that chat. |
| File uploaded as ChatGPT Project Source | Yes | Available to that ChatGPT Project, but may become stale if not re-uploaded after repo changes. |
| GitHub file link | Only if connector/browsing access exists | Otherwise it is just a pointer. |
| Claude Code local repo | Yes | Claude Code runs in the repo context. |
| Codex CLI local repo | Yes if run in repo | It can read local files when invoked in the repository. |
| Gemini uploaded file | Yes | Available in that Gemini session/project context. |

Rule:

> A repo link is a pointer. An attached file, pasted content, Project Source, GitHub connector access, or local repo access is context.

### 15.2 ChatGPT Project — Pod A

Use for:

- product planning,
- business rules,
- user stories,
- user roles,
- user flows,
- open questions,
- GitHub issue drafts,
- Pod B handoff packages.

Per-task context rule:

| Task risk | Provide |
|---|---|
| Low-risk question | No files, or one relevant excerpt |
| Normal product document | Project Sources + task-specific files |
| High-risk document | Methodology + manifest + decision index + task docs + relevant ADRs |
| Methodology change | Methodology + manifest + decision index + affected instruction files |

Pod A must mark outputs as `Needs repo reconciliation` if the needed repo files are not available.

### 15.3 Claude Project — Pod B

Use for:

- architecture review,
- domain model review,
- schema design,
- API contracts,
- wallet and loyalty ledger logic,
- reservation state machine,
- security/KVKK review,
- ADR drafting/review.

Per-task context rule:

| Task | Provide |
|---|---|
| Review Pod A doc | Reviewed doc + methodology + manifest + decision index |
| Wallet/loyalty | Business rules + relevant ADRs + security/KVKK docs + methodology |
| Selcafe | Selcafe notes/spike + adapter docs/ADR + methodology |
| Schema/API | Domain model + scope/business rules + ADRs |
| Methodology review | Methodology + proposed change files + instruction update packet |

### 15.4 Claude Code — Pod C / Build & DevOps

Use for:

- implementation,
- tests,
- migrations,
- CI/CD,
- Docker,
- environment setup,
- PRs.

Pod C normally reads repository files directly.

Prompt pattern:

```text
Implement GitHub issue #[number].

Before editing:
- Read CLAUDE.md.
- Read /docs/PROJECT_METHODOLOGY.md.
- Read /docs/AGENT_CONTEXT_MANIFEST.md if it exists.
- Read all docs and ADRs linked from the issue.
- Stop if Pod B approval is missing for any high-risk area.

Do not expand scope. Do not make architecture decisions. Do not write directly to Selcafe SQL Server in Phase 1. Do not overwrite wallet or loyalty balances.
```

### 15.5 Codex CLI — Pod C small-task implementer

Use for:

- small scoped fixes,
- narrow issues,
- single-module implementation,
- tests for clearly defined behavior.

Prompt pattern:

```text
Implement GitHub issue #[number].

Before editing:
- Read CLAUDE.md.
- Read /docs/PROJECT_METHODOLOGY.md.
- Read all linked docs in the issue.
- Do not expand scope.
- If the task requires schema, wallet, loyalty, customer data, auth, Selcafe, audit-log, or security-sensitive changes that are not already approved by Pod B, stop and report.

After editing:
- Run relevant tests.
- Summarize files changed, commands run, risk notes, and required reviews.
```

### 15.6 Gemini / Google AI Studio — Pod D

Use for:

- PWA prototypes,
- UI flow exploration,
- screenshot review,
- broad consistency audits,
- monitoring and observability specs.

Per-task context rule:

| Task | Provide |
|---|---|
| UI prototype | Product brief + flow doc + scope boundaries |
| UX audit | Screenshots/prototype + relevant flow docs |
| Consistency audit | Methodology + manifest + selected docs/code |
| Monitoring spec | NFR + release/incident docs + architecture/operational docs |

---

## 16. Git Command Requirement for Pod Outputs

This section incorporates Kerem's extra note.

Whenever any pod asks Kerem to perform a repository action, the pod must include exact commands.

### 16.1 Covered actions

This rule applies when a pod asks Kerem to:

- create a branch,
- switch branches,
- add files,
- commit files,
- push a branch,
- open a PR,
- merge a PR,
- delete a branch,
- remove files,
- move files,
- archive files,
- restore files,
- fetch or pull from remote,
- tag a release.

### 16.2 Command quality rules

Commands must be:

| Requirement | Meaning |
|---|---|
| Explicit | Do not say "commit this"; show `git add`, `git commit`, `git push`. |
| Safe | Do not include destructive commands unless clearly marked and justified. |
| Scoped | File paths should be exact. |
| Review-aware | Commands must not tell Kerem or Pod C to merge if required review/approval is missing. |
| Environment-aware | If command execution depends on repo root, say so. |
| Honest | If commands are not known, say which command must be confirmed by Pod C. |

### 16.3 Example command block for documentation PR

```bash
# Run from the repository root
git fetch --prune
git checkout main
git pull origin main
git checkout -b docs/repository-controlled-pod-context

git add docs/PROJECT_METHODOLOGY.md
git add docs/PROJECT_DECISION_INDEX.md
git add docs/methodology/REPOSITORY_CONTROLLED_POD_CONTEXT_PROPOSAL.md

git commit -m "docs: propose repository-controlled pod context methodology"
git push -u origin docs/repository-controlled-pod-context

# Then open a pull request from:
# docs/repository-controlled-pod-context -> main
```

### 16.4 Merge command rule

Pods should not casually provide merge commands unless all required reviews are complete.

If merge is approved, the pod may provide:

```bash
git checkout main
git pull origin main
git merge --no-ff docs/repository-controlled-pod-context
git push origin main
```

But the pod must also state:

> Only run merge commands after required Pod B review, CI, and Kerem approval are complete.

---

## 17. Instruction Update Packet Specification

This is a proposal-level spec only, not the final template file.

The template should include:

```md
# Instruction Update Packet — [Short Title]

## Trigger

What changed?

## Source PR / Issue

- PR:
- Issue:

## Canonical Files Changed

| File | Change |
|---|---|

## Behavior Impact

| Question | Answer |
|---|---|
| Does this change pod responsibilities? | Yes / No |
| Does this change required context loading? | Yes / No |
| Does this change review or approval triggers? | Yes / No |
| Does this change locked, deferred, or not-yet-locked decisions? | Yes / No |
| Does this change output format? | Yes / No |
| Does this change handoff routing? | Yes / No |

## Affected Pods

| Pod | Affected? | Required Update |
|---|---:|---|
| Pod A | Yes / No | |
| Pod B | Yes / No | |
| Pod C | Yes / No | |
| Pod D | Yes / No | |

## External Platform Updates Required

| Platform | Instruction File | Action |
|---|---|---|
| ChatGPT Project | `/docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md` | Replace / no change |
| Claude Project | `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` | Replace / no change |
| Claude Code | `/CLAUDE.md` | Commit update / no change |
| Gemini Gem | `/docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md` | Replace / no change |

## Ready-to-Paste Update Text

### Pod A

[Exact replacement text or diff]

### Pod B

[Exact replacement text or diff]

### Pod D

[Exact replacement text or diff]

## Verification Checklist

- [ ] `PROJECT_METHODOLOGY.md` updated if methodology changed
- [ ] `AGENT_CONTEXT_MANIFEST.md` updated if required context changed
- [ ] `PROJECT_DECISION_INDEX.md` updated if decision state changed
- [ ] Relevant templates updated if output format changed
- [ ] Pod instruction snapshots updated if pod behavior changed
- [ ] Updated repo snapshot merged
- [ ] External platform text re-pasted from repo snapshot
- [ ] `LAST SYNCED TO PLATFORM` header updated
- [ ] Manifest validated against repo tree
- [ ] External platform paste text included if needed
- [ ] Pod B reviewed architecture/risk/process impact
- [ ] Kerem approved behavior-changing process update
```

---

## 18. Review Routing

| Item | Status |
|---|---|
| Ready for Kerem decision on MD-2…MD-6 | Yes |
| Ready for Pod B review | Already reviewed v0.1; v0.2 applies required comments |
| Requires additional Pod B review before commit | Yes, after Kerem decisions and before implementation PRs |
| Requires Pod C implementation | Yes, later through PRs after Kerem approval |
| Requires Pod D prototype/audit/monitoring review | Optional; useful after files are drafted |
| Ready to commit | No |
| Reason not ready to commit | Kerem has not yet approved MD-2…MD-6; downstream files are intentionally not produced yet |

---

## 19. Changelog from v0.1 to v0.2

| Revision | Requirement | v0.2 change |
|---|---|---|
| REV-1 | Add explicit migration map for `POD_TRAFFIC_WORKFLOW.md` v1.1 unique content as PR-2 merge precondition | Added Section 9, mapping §14 → methodology PR-policy + ADR-009; §16 → methodology §27 + `CONTEXT_FRESHNESS.md`; §17 → `PROJECT_DECISION_INDEX.md`; added merge-blocking destination checks |
| REV-2 | Add snapshot anti-drift guardrails | Added Section 10: repo snapshot canonical, re-paste-after-merge rule, version + last-synced header, reference-only snapshots |
| REV-3 | Add per-row status/fallback to manifest spec and CI existence/link check recommendation | Added Section 11 with required row fields, fallback behavior, and CI check recommendation |
| REV-4 | Rescope PR Pod Impact Matrix as conditional and integrate with existing Review Triggers | Added Section 12 with one universal PR gate question and full matrix only when answer is yes |
| REV-5 | Re-sequence so `CLAUDE.md` edit lands in same PR as workflow stub | Added Section 13; PR-2 now includes archive, stub, and `/CLAUDE.md` update in same PR |
| REV-6 | Assign explicit owner to each template and add decision-index mirror rule | Added Section 8.4 template ownership; Section 3.2 and Section 8.3 state decision index mirrors ADRs/methodology and does not establish decisions |
| REV-7 | Number methodology-consolidation ADR as ADR-013 | Added Section 14 naming ADR-013 and its scope |

---

## 20. Kerem Decision Request

Please decide:

```md
## Kerem Decisions — Repository-Controlled Pod Context v0.2

| ID | Decision |
|---|---|
| MD-2 | Approve the methodology-consolidation direction? Approved / revise / reject |
| MD-3 | Record as both ADR-013 and methodology §28 revision? Yes / No |
| MD-4 | Approve Pod B as sole owner of `PROJECT_DECISION_INDEX.md`, with Pod A reviewer on product/business-impacting rows? Yes / No |
| MD-5 | Approve permanent stub at `/docs/POD_TRAFFIC_WORKFLOW.md` plus archive at `/docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md`? Yes / No |
| MD-6 | Approve conditional Pod Impact Matrix: one universal PR gate question, full matrix only when yes? Yes / No |
```

After Kerem records these decisions, Pod A can produce the actual repo-ready methodology revision plan and handoff to Pod C for PR sequencing.

---

<!-- END OF DOCUMENT -->
