# ADR-013: Repository-Controlled Pod Context

<!--
  STATUS: Proposed
  AUTHOR: Pod B — Architecture, Logic & Risk
  REVIEWER: Pod B (self) + Pod A (required, per Kerem 2026-06-04)
  APPROVER: Kerem
  DATE: 2026-06-04
  CANONICAL REPO PATH: /docs/adr/ADR-013-repository-controlled-pod-context.md
  RELATED DOCUMENTS:
    - /docs/methodology/REPOSITORY_CONTROLLED_POD_CONTEXT_PROPOSAL.md (v0.2)
    - /docs/PROJECT_METHODOLOGY.md (§19 ADR Policy, §27 AI Session Continuity Protocol, §28 Governance)
    - /docs/PROJECT_DECISION_INDEX.md
    - /docs/POD_TRAFFIC_WORKFLOW.md (v1.1 — being deprecated by this ADR)
    - /docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md (full archive)
    - /docs/AGENT_CONTEXT_MANIFEST.md (to be created — PR-3)
    - ADR-009 (PR approval policy — companion ADR, PR-2)
  IMPLEMENTATION PRs: PR-1 (this ADR lands here) through PR-5
-->

---

## Status

Proposed — awaiting Kerem approval.
Pod B review: Approved (self-review, methodology / process ADR).
Pod A review: Approved-with-comments (2026-06-04); comment addressed in this revision.

---

## Context

### The problem

The Adeks Platform is developed by a multi-pod AI agent team (Pod A — Product & Planning, Pod B — Architecture Logic & Risk, Pod C — Build & DevOps, Pod D — Prototype Audit & Monitoring) with Kerem as product owner and sole decision authority.

All AI pods are stateless between sessions. Durable project truth must live in the repository. However, over the course of early project work, methodology rules and pod-behavior rules became fragmented across several locations simultaneously:

| Location | Content duplicated or overlapping |
|---|---|
| `/docs/PROJECT_METHODOLOGY.md` | Lifecycle, review gates, escalation, session continuity |
| `/docs/POD_TRAFFIC_WORKFLOW.md` | PR approval policy, handoff format, Pod B review format, session sync, context drift rules, commit readiness, governance decisions |
| `/CLAUDE.md` | Pod C local instructions; referenced the workflow file as a methodology source |
| External AI platform instructions (ChatGPT Project, Claude Project, Gemini Gem) | Pod role definitions, locked decisions, open questions — partly duplicating repo state, partly ahead of it, with no formal sync rule |

This fragmentation created a **context drift risk**: when one file changed, others could remain stale, and no pod had a reliable way to know which source was authoritative for a given rule. A specific manifestation was that `POD_TRAFFIC_WORKFLOW.md` held unique governance rules (PR approval policy, session-sync protocol, approved governance decisions) that were not present in any other canonical document, meaning those rules would be silently lost if the workflow file were archived without a migration map.

A secondary problem was that external AI platform instructions had begun to embed volatile live state — locked-decision tables, open-question lists, ADR counts — that was certain to drift from repository truth and had no re-sync mechanism.

### Why this needs an ADR

This decision:

- establishes a structural pattern that all four pods must follow in every future session,
- supersedes the active use of `POD_TRAFFIC_WORKFLOW.md` as a methodology source,
- defines document ownership and authority hierarchy across multiple files,
- creates a new class of mandatory process artifact (the `AGENT_CONTEXT_MANIFEST.md` and the `INSTRUCTION_UPDATE_PACKET.md`), and
- introduces a behavioral constraint on what external AI platform instructions may contain.

It is expensive to reverse once pods have adopted the pattern and the workflow file has been archived.

---

## Decision

**Adopt the Repository-Controlled Pod Context model**, as specified in `/docs/methodology/REPOSITORY_CONTROLLED_POD_CONTEXT_PROPOSAL.md` v0.2, with the following structural decisions:

### 1. Repository is the only source of truth

The GitHub repository — documents, ADRs, issues, PRs, and tests — is the durable control plane. External AI platform instructions (ChatGPT Project, Claude Project, Gemini Gem) are not control-plane documents. A decision that exists only in a chat session does not exist.

### 2. One canonical methodology source

`/docs/PROJECT_METHODOLOGY.md` is the sole canonical source for:

- lifecycle and phase definitions,
- review and approval gates,
- pod responsibilities and role boundaries,
- handoff protocol and automatic handoff prompt rule,
- escalation and conflict resolution,
- ADR policy,
- security and KVKK process,
- AI session continuity protocol,
- document governance.

No other file may establish methodology rules in parallel. A section in another document that would function as methodology must be migrated to `PROJECT_METHODOLOGY.md` or replaced with a pointer to it.

### 3. Context routing is separate from methodology

`/docs/AGENT_CONTEXT_MANIFEST.md` tells each pod what files to load or request before acting on a given task type. It routes context; it does not define governance. Every row in the manifest must include: task type, required files, file status (`exists` / `planned` / `missing` / `unknown`), fallback behavior if a file is absent, affected pods, required review, and whether a context freshness declaration is mandatory.

### 4. Decision state is indexed, not established, in the decision index

`/docs/PROJECT_DECISION_INDEX.md` mirrors the current status of decisions across ADRs, `PROJECT_METHODOLOGY.md`, and recorded Kerem decisions. It does not establish decisions. If the index conflicts with an accepted ADR, the ADR is authoritative and the index is stale. Pod B is the sole owner of the decision index; Pod A reviews rows that have product or business impact; Kerem approves any status transition into or out of `Locked` on product/business-impacting rows.

### 5. Pod instruction snapshots are reference-only bootloaders

Files under `/docs/pod-instructions/` and `/CLAUDE.md` are canonical copies of the text pasted into each AI platform. They must contain: pod role, role boundaries, source-of-truth rule, context-loading rule, output style, stop conditions, and pointers to `PROJECT_METHODOLOGY.md`, `PROJECT_DECISION_INDEX.md`, and relevant ADRs.

They must **not** contain: full locked-decision tables, live open-question lists, volatile ADR counts, current sprint or blocker status, or duplicated methodology sections that can drift. Any content that belongs in methodology belongs in `PROJECT_METHODOLOGY.md`, not in a snapshot.

The repository snapshot is canonical. External platform instruction text must be re-pasted from the repository snapshot after any merged PR that changes a pod instruction file. An `INSTRUCTION_UPDATE_PACKET.md` must accompany any such PR and include a post-merge re-paste checklist.

### 6. `POD_TRAFFIC_WORKFLOW.md` is deprecated as a methodology source

`/docs/POD_TRAFFIC_WORKFLOW.md` v1.1 is archived in full at `/docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md`. The original path is replaced by a permanent deprecation stub that:

- states the file is deprecated,
- points to `PROJECT_METHODOLOGY.md` as canonical methodology,
- points to `AGENT_CONTEXT_MANIFEST.md` for context loading,
- points to `PROJECT_DECISION_INDEX.md` for decision state,
- points to `/docs/templates/` for handoff, review, escalation, and freshness templates,
- points to the archive for the full historical version, and
- exists permanently at the original path to preserve existing links.

The stub PR (PR-2) must not be merged until every unique content section of `POD_TRAFFIC_WORKFLOW.md` v1.1 has a confirmed destination, per the migration map in `REPOSITORY_CONTROLLED_POD_CONTEXT_PROPOSAL.md` §9.

### 7. Behavior-changing PRs require a Pod Impact Matrix and Instruction Update Packet

Any PR that changes pod behavior, responsibilities, review or approval gates, context-loading rules, output format, locked or deferred decision state, methodology, templates, or external AI platform instructions must include:

- a Pod Impact Matrix identifying which pods are affected and what follow-up is required, and
- an `INSTRUCTION_UPDATE_PACKET.md` specifying which instruction snapshots need updating and whether external platform re-paste is required.

This requirement is enforced via a conditional gate in the standard PR template (`.github/PULL_REQUEST_TEMPLATE.md`): one universal yes/no question triggers the full matrix only when the answer is yes. This avoids checkbox fatigue on routine implementation PRs.

---

## Consequences

### What becomes easier

- **Context reliability.** Any pod can determine the authoritative version of a rule by reading `PROJECT_METHODOLOGY.md`. There is no ambiguity about which document wins.
- **Drift detection.** Because snapshots must not embed volatile state, the surface area for snapshot drift is reduced to bootloader-level content that rarely changes.
- **Onboarding new sessions.** The manifest tells any pod exactly what to load for a given task, reducing session startup errors.
- **Decision auditability.** The decision index provides a single current-state view across all ADRs and Kerem decisions, without being the decision authority itself.
- **Link preservation.** The permanent stub at the original workflow path means internal references to that file do not produce 404s.

### What becomes harder or more expensive

- **Behavior-changing PRs require more ceremony.** Any PR touching pod behavior must include a Pod Impact Matrix and Instruction Update Packet. This adds review overhead for process changes, which is intentional.
- **External platform re-paste is a manual step.** Because AI platforms do not have a live sync mechanism, Kerem or the assigned operator must manually re-paste updated instruction text after relevant PRs merge. This is a permanent operational responsibility.
- **Manifest maintenance.** `AGENT_CONTEXT_MANIFEST.md` must be kept current as new task types, files, and ADRs are added. A stale manifest produces incorrect context-loading guidance.
- **Template set requires upkeep.** Five templates (`HANDOFF_PACKET.md`, `POD_B_REVIEW.md`, `DECISION_ESCALATION.md`, `INSTRUCTION_UPDATE_PACKET.md`, `CONTEXT_FRESHNESS.md`) must be maintained. Format changes require the same PR ceremony as methodology changes.
- **Pod A takes on artifact custodianship.** Pod A becomes author/custodian of `AGENT_CONTEXT_MANIFEST.md`, the Pod-A-owned templates (`HANDOFF_PACKET.md`, `DECISION_ESCALATION.md`, `INSTRUCTION_UPDATE_PACKET.md`, `CONTEXT_FRESHNESS.md`), and the Pod A instruction snapshot, subject to Pod B review and Kerem approval where the change is behavior-changing. Pod B remains owner of `POD_B_REVIEW.md` and `PROJECT_DECISION_INDEX.md`.

### What is constrained

- External AI platform instructions may not establish decisions or hold volatile live state. Any instruction file that embeds locked-decision tables, open-question lists, or ADR counts is non-conformant and must be cleaned up (PR-5).
- `PROJECT_DECISION_INDEX.md` may not establish decisions. If it appears to contradict an ADR, the ADR wins.
- The manifest may not define governance. If a manifest row creates a rule rather than routing context, it must be moved to `PROJECT_METHODOLOGY.md`.

### Risks accepted

- The re-paste step is a manual operational dependency. If Kerem does not re-paste after a relevant PR merges, the external platform instructions will be transiently stale. Mitigated by the `INSTRUCTION_UPDATE_PACKET.md` checklist, which makes the outstanding step explicit.
- The manifest is a new file that must be validated. A CI existence/link check is recommended (proposal §11.4) and should be implemented after the manifest is committed and stable.

---

## Alternatives Considered

### Alternative 1: Do nothing — continue with fragmented methodology sources

**Rejected.** Context drift was already occurring between `POD_TRAFFIC_WORKFLOW.md`, `PROJECT_METHODOLOGY.md`, and external platform instructions. The workflow file held unique governance rules that were not represented elsewhere. Continuing without a consolidation model would have accelerated drift as more documents and pods were added.

### Alternative 2: Delete `POD_TRAFFIC_WORKFLOW.md` immediately without a migration map

**Rejected.** The file contained unique content — PR approval policy (§14), session sync protocol (§16), approved governance decisions (§17), handoff format (§8), escalation format (§10), Pod B review format (§6.1), commit readiness rules (§11), and context drift rules (§12) — that had no confirmed destination. Immediate deletion would have silently destroyed governance rules that were in active use. The migration-map-first approach (chosen decision) ensures no unique content is lost.

### Alternative 3: Keep both `POD_TRAFFIC_WORKFLOW.md` and `PROJECT_METHODOLOGY.md` as active rule sources

**Rejected.** Dual active sources is the root cause of the problem, not a solution to it. Any divergence between the two files would produce an unresolvable ambiguity for pods trying to determine which rule to follow. Rule authority must be singular.

### Alternative 4: Put all context and rules into external AI platform instructions

**Rejected.** External platform instructions are not in version control, cannot be reviewed via PRs, and have no audit trail. Pods cannot reliably reference platform instructions from other pods. This approach inverts the control-plane principle: AI platform state would become authoritative over repository state, which eliminates the human control layer.

### Alternative 5: Merge `POD_TRAFFIC_WORKFLOW.md` content into `PROJECT_METHODOLOGY.md` without creating a manifest or decision index

**Rejected** as incomplete. Migration of workflow content into methodology is necessary but not sufficient. Without the manifest, pods have no structured guidance on what files to load for which task types. Without the decision index, decision state is scattered across individual ADRs and Kerem decision records with no current-state summary. Both artifacts address distinct coordination needs.

---

## Implementation

This ADR is implemented through five sequenced PRs:

| PR | Purpose | Key change | This ADR |
|---|---|---|---|
| PR-1 | Record methodology direction | `PROJECT_METHODOLOGY.md` §28 revision; this ADR; decision index update | **Lands in this PR** |
| PR-2 | Archive and stub workflow file; update Pod C pointer | Archive, stub, `CLAUDE.md` update, ADR-009 | Referenced as companion |
| PR-3 | Add context manifest and templates | `AGENT_CONTEXT_MANIFEST.md`; five templates | Delivers §3 artifacts |
| PR-4 | Update PR template with conditional impact gate | `.github/PULL_REQUEST_TEMPLATE.md` | Enforces §7 |
| PR-5 | Normalize pod instruction snapshots; clean committed Pod B snapshot | `/docs/pod-instructions/` files; `CLAUDE.md` if needed | Enforces §5 |

PR-2 must not merge until the migration map in `REPOSITORY_CONTROLLED_POD_CONTEXT_PROPOSAL.md` §9 is fully satisfied. Each PR requires Pod B review and Kerem approval before merge. No PR may be merged directly to `main`; all merges use `gh pr merge` or the GitHub UI after required reviews are complete.

The companion ADR for PR approval policy is **ADR-009**, which must exist before PR-2 is committed.

---

## Approval

- **Author:** Pod B — Architecture, Logic & Risk
- **Reviewer:** Pod B (self-review, methodology / process ADR) + Pod A (required, per Kerem decision 2026-06-04)
- **Approver:** Kerem
- **Date proposed:** 2026-06-04
- **Date approved:** _pending Kerem approval_
