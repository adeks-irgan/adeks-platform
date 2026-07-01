# ADR-009: Pull Request Approval Policy

<!--
  STATUS: Accepted
  AUTHOR: Pod B — Architecture, Logic & Risk
  REVIEWER: Pod B (self) + Pod A (required, per Kerem 2026-06-04)
  APPROVER: Kerem
  DATE: 2026-06-05
  CANONICAL REPO PATH: /docs/adr/ADR-009-pr-approval-policy.md
  RELATED DOCUMENTS:
    - /docs/adr/ADR-013-repository-controlled-pod-context.md (companion; §7 conditional gate)
    - /docs/PROJECT_METHODOLOGY.md (§19 ADR Policy, §27 AI Session Continuity, §28 Governance)
    - /docs/PROJECT_DECISION_INDEX.md
    - /docs/POD_TRAFFIC_WORKFLOW.md (v1.1 — §14 PR Approval Policy, §17 PQ-004; being deprecated by ADR-013)
    - /docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md (full archive)
    - .github/PULL_REQUEST_TEMPLATE.md (live enforcement of risk-category review triggers; PR-4 adds the §7 gate)
  IMPLEMENTATION PRs: lands in PR-2 (companion to ADR-013); the §7 conditional gate is enforced by PR-4
-->

---

## Status

Accepted — 2026-06-05 (Kerem approval; merged to `main` via PR #17).

Note on prior approval: the core PR approval policy recorded here was already approved by Kerem as `POD_TRAFFIC_WORKFLOW.md` §14 and governance decision PQ-004. This ADR does not change that policy; it gives it a durable, canonical home because the workflow file is being deprecated as a methodology source by ADR-013. The only genuinely new element is the **conditional Pod Impact Matrix gate**, which derives from ADR-013 §7 (Accepted, 2026-06-05). This ADR required Kerem approval to move to `Accepted` (recorded 2026-06-05), and must exist before PR-2 is committed.

Pod B review: Approved (self-review, process / governance ADR).

**Amendment — 2026-07-01 (risk-tiered §4 ceremony; Kerem-approved).** §4 gains a subsection (§4.1) that tiers the Pod Impact Matrix + `INSTRUCTION_UPDATE_PACKET.md` requirement by risk, reusing the §3 risk-category table as the activation boundary. Higher-risk and behavior-changing PRs keep full ceremony unchanged; pure decision-state mirroring that changes no gate, behavior, methodology, template, bootloader, or §3 category takes a one-line attestation instead. This weakens no §3 review trigger, no merge-is-Kerem-only rule, and no no-direct-`main` rule, and authorizes no Pod C implementation. Additive and dated to preserve ADR history (methodology §19). This ADR is the canonical record of the tiering decision — no separate MD-entry is created.

---

## Context

### The problem

The Adeks Platform control plane requires that no change reaches `main` without controlled review, and that high-risk changes (financial, security, customer-data, schema, integration) receive both architecture review (Pod B) and human approval (Kerem). These rules existed, but their authoritative text lived only in `POD_TRAFFIC_WORKFLOW.md` — §14 (PR Approval Policy), §17 PQ-004 (documentation-only vs code PR distinction), and §13 (high-risk area handling).

ADR-013 deprecates `POD_TRAFFIC_WORKFLOW.md` as an active methodology source and archives it. Its §14/§17 PR rules have no other canonical home. Without this ADR, archiving the workflow file would silently strip the PR approval policy out of the live rule set — exactly the migration-loss risk ADR-013 was written to prevent. ADR-013 §2 (Alternatives Considered) explicitly lists "PR approval policy (§14)" as unique content requiring a confirmed destination before PR-2 may merge, and names **ADR-009** as that destination.

A second gap is newer. ADR-013 §7 introduced a requirement that behavior-changing PRs carry a **Pod Impact Matrix** and an **Instruction Update Packet**, enforced through a single conditional question in the PR template (governance decision MD-6). That gate is a PR-merge rule and belongs in the PR approval policy, not only in the methodology consolidation ADR.

### Why this needs an ADR

This decision:

- preserves a Kerem-approved governance rule (PR approval policy) that would otherwise be lost when `POD_TRAFFIC_WORKFLOW.md` is archived,
- consolidates the PR-merge gates into a single authoritative record that the live `.github/PULL_REQUEST_TEMPLATE.md` operationalizes,
- records the conditional Pod Impact Matrix gate (MD-6 / ADR-013 §7) as a binding merge requirement, and
- is referenced as a hard precondition by ADR-013's implementation plan (PR-2).

---

## Decision

Adopt the following Pull Request Approval Policy as the canonical merge-gate policy for the repository.

### 1. No direct commits to `main`

`main` is protected. Every change reaches `main` only through a pull request that has passed the required reviews for its category (below). No pod merges directly to `main`. Merges are performed via `gh pr merge` or the GitHub UI after required reviews are complete. (Locked principle; `POD_TRAFFIC_WORKFLOW.md` §12.2 rule 10; ADR-013 Implementation.)

### 2. Baseline rule by PR class

| PR class | Baseline requirement before merge |
|---|---|
| Code PR | Always requires **Kerem approval** before merge. |
| Documentation-only PR | May use lighter review, but **must not merge without Kerem visibility**. |
| ADR PR | Requires **Kerem approval** when it records a strategic, security, financial, customer-data, or architecture decision. (In practice this covers essentially all ADRs.) |

"Documentation-only" means a PR that touches only `/docs` prose or comments and does **not** alter pod behavior, review/approval gates, locked or deferred decision state, methodology, templates, or external AI platform instructions. A PR that changes any of those is **behavior-changing** (see §4), not documentation-only, regardless of file type.

### 3. Risk-category review triggers

A PR touching any of the following areas requires the listed reviews **before merge**, in addition to the §2 baseline. These triggers are operationalized as the checklist in `.github/PULL_REQUEST_TEMPLATE.md` → "Review Triggers."

| Risk category | Required before merge |
|---|---|
| Wallet ledger logic | Pod B + Kerem |
| Loyalty ledger logic | Pod B + Kerem |
| Payment logic | Pod B + Kerem |
| Refund logic | Pod B + Kerem |
| Customer personal data handling | Pod B + Kerem |
| Security-sensitive PR (including security-sensitive admin actions) | Pod B + Kerem |
| Selcafe adapter or Selcafe integration changes | Pod B + Kerem |
| Database / schema migration | Pod B + Kerem |
| Authentication or authorization | Pod B |
| Audit log schema or logic | Pod B |
| Admin privilege changes | Kerem |
| None of the above | Standard review only |

Where a PR matches multiple rows, the strictest applicable requirement governs (e.g., a security-sensitive authentication change is Pod B + Kerem). These rows **preserve the approval strictness of `POD_TRAFFIC_WORKFLOW.md` §14** and the high-risk handling in §13 / mandatory-review set in §5.1 / §7.2 / PQ-001 — they do not weaken any existing gate.

**Template reconciliation (Pod B note).** The live `.github/PULL_REQUEST_TEMPLATE.md` "Review Triggers" section currently lists Selcafe adapter changes and database migration as **Pod B only**, which is looser than §14. PR-4 must bring the template into line with the table above (Selcafe and migration → Pod B + Kerem). Until PR-4 merges, this ADR is the stricter, authoritative source.

### 4. Conditional Pod Impact Matrix gate (behavior-changing PRs)

Any PR that changes **pod behavior, responsibilities, review or approval gates, context-loading rules, output format, locked or deferred decision state, methodology, templates, or external AI platform instructions** must include, before merge:

- a **Pod Impact Matrix** identifying which pods are affected and what follow-up each requires, and
- an **`INSTRUCTION_UPDATE_PACKET.md`** (a planned PR-3 artifact) specifying which instruction snapshots need updating and whether external platform re-paste is required.

This is enforced by a **single universal yes/no question** in `.github/PULL_REQUEST_TEMPLATE.md` ("Does this PR change pod behavior, gates, methodology, templates, decision state, or platform instructions?"). A `yes` answer triggers the full matrix and the update packet; a `no` answer skips them. This conditional design deliberately avoids checkbox fatigue on routine implementation PRs while guaranteeing process-changing PRs carry their impact accounting. (Source: ADR-013 §7; governance decision MD-6.)

#### 4.1 Risk-tiered ceremony (amendment — 2026-07-01)

The §4 requirement is tiered by risk, with the §3 risk-category table as the activation boundary. This refines MD-6's decision-state trigger; it does not remove the conditional gate.

**Heavy lane — full Pod Impact Matrix + `INSTRUCTION_UPDATE_PACKET.md`.** Any PR that (a) touches any §3 risk category, or (b) changes pod behavior, responsibilities, review or approval gates, context-loading rules, output format, methodology, templates, or external AI platform instructions. Scrutiny here is unchanged from §4.

**Fast lane — one-line attestation; no matrix, no update packet.** A PR that only mirrors already-Kerem-approved decision state into an index/mirror/status surface (e.g., `PROJECT_DECISION_INDEX.md`, `PROJECT_SEQUENCE_STATUS.md`, a status table) or edits gate-neutral `/docs` prose, and changes none of the heavy-lane items. The PR carries one line: *"Fast lane: decision-state mirror / gate-neutral docs; no pod-behavior, gate, methodology, template, bootloader, or §3-risk change; no re-paste."*

**Activation question.** *Does this PR touch money, law, security, Selcafe integration, schema/migration, pod behavior, or a gate?* Yes → heavy lane. No → fast lane. If ambiguous, take the heavy lane.

**Invariants (unchanged).** No §3 review trigger is weakened. Merge remains Kerem-only. No direct commits to `main`. No lane authorizes Pod C implementation, Definition-of-Ready / Definition-of-Done bypass, legal/KVKK bypass, or real-data use. Mirror drift is non-blocking and never a merge gate; a stale mirror is a correctable pointer fix under the fast lane.

**Template reconciliation (Pod B note).** The live `.github/PULL_REQUEST_TEMPLATE.md` universal question does not yet carry the lane split. A follow-on PR should add it; until that merges, this §4.1 is the authoritative source (same pattern as the §3 template-reconciliation note). That follow-on is itself heavy-lane.

### 5. Approval authority

Kerem is the sole final approver for any merge. Pod B is the architecture, logic, and risk reviewer and is a **required** reviewer for every §3 row that lists Pod B and for every §4 behavior-changing PR. Pod A is a required reviewer on product/business-impacting changes (per the 2026-06-04 Kerem decision). No pod resolves a high-impact disagreement unilaterally; escalation follows `PROJECT_METHODOLOGY.md`.

---

## Consequences

### What becomes easier

- **Durable, single-source merge policy.** When `POD_TRAFFIC_WORKFLOW.md` is archived, the PR approval rules survive in an authoritative ADR rather than being lost.
- **Auditable gates.** Every PR's required reviewers are determined by category, recorded in the PR template, and traceable.
- **Low-friction routine PRs.** The conditional §4 gate keeps the impact matrix off routine implementation PRs, so the heavy ceremony applies only where behavior actually changes.

### What becomes harder or more expensive

- **Kerem is a required approver on all code PRs.** Throughput is bounded by Kerem's availability. This is intentional: human approval of code merges is a locked control-plane principle.
- **Behavior-changing PRs carry more ceremony.** The Pod Impact Matrix plus `INSTRUCTION_UPDATE_PACKET.md` add overhead to any process change. This is the intended cost of preventing instruction drift.
- **PR template must stay in sync with this ADR.** If §3 or §4 changes here, `.github/PULL_REQUEST_TEMPLATE.md` must be updated in the same PR (itself a behavior-changing PR under §4).

### What is constrained

- No change reaches `main` outside a reviewed PR.
- A documentation-only PR cannot merge without Kerem visibility.
- A PR that touches behavior, gates, methodology, templates, or platform instructions cannot merge without its Pod Impact Matrix and update packet; decision-state changes follow the §4.1 lane split.

### Risks accepted

- **Approval bottleneck.** Concentrating merge approval in Kerem can slow delivery. Accepted as the price of human control; mitigated by the §2 lighter-review path for genuine documentation-only PRs.
- **Honest self-classification.** The §4 gate relies on PR authors truthfully answering the universal question. Mitigated by Pod B review on flagged categories and by Pod D / Pod A consistency audits catching mislabeled behavior changes after the fact.

---

## Alternatives Considered

### Alternative 1: Leave the PR policy only in `POD_TRAFFIC_WORKFLOW.md` §14

**Rejected.** That file is being deprecated and archived by ADR-013. Leaving the policy there would archive it out of the live rule set. ADR-013 explicitly requires a confirmed destination (this ADR) before PR-2 may merge.

### Alternative 2: Require Pod B + Kerem review on every PR

**Rejected.** Universal dual-review produces checkbox fatigue and stalls routine, low-risk implementation PRs, degrading the signal of the high-risk gates. The category-based model (§3) plus the conditional §4 gate targets scrutiny where risk actually lives.

### Alternative 3: Enforce everything through branch protection / CODEOWNERS only, with no policy ADR

**Rejected.** Tooling can require a reviewer but cannot encode the risk-category judgment (is this a "customer-data" change? a "behavior-changing" change?). The human-readable policy is needed for pods and Kerem to classify PRs; branch protection and the PR template are the enforcement layer beneath it, not a replacement for the policy.

### Alternative 4: Make the Pod Impact Matrix unconditional on all PRs

**Rejected.** An always-on matrix is the checkbox-fatigue failure mode ADR-013 §7 was written to avoid. The single conditional question preserves the guarantee for behavior-changing PRs at near-zero cost for the rest.

---

## Implementation

| Step | Where | PR |
|---|---|---|
| This ADR lands in `/docs/adr/` | `/docs/adr/ADR-009-pr-approval-policy.md` | **PR-2** (companion to ADR-013; ADR-009 must exist before PR-2 is committed) |
| Risk-category review triggers (§3) | `.github/PULL_REQUEST_TEMPLATE.md` → "Review Triggers" | Reconciled in PR-4 — template §3 triggers now match ADR-009 §3 (Selcafe + DB/schema migration → Pod B + Kerem; security-sensitive row added). |
| Conditional Pod Impact Matrix gate (§4) | `.github/PULL_REQUEST_TEMPLATE.md` → universal yes/no question + matrix + update-packet block | Added in PR-4. |
| Decision index row update | `/docs/PROJECT_DECISION_INDEX.md` — ADR-009 row → `Proposed (PR #17 open)` now; → `Accepted` on Kerem approval | This PR (Proposed) + approving PR (Accepted) |
| Branch protection on `main` | GitHub repo settings (no direct pushes; PR required) | Recommended; aligns with §1 |

Each ADR-013 implementation PR requires the reviews and approvals specified by this ADR, ADR-013, and the PR template. No PR may be merged directly to `main`.

---

## Approval

- **Author:** Pod B — Architecture, Logic & Risk
- **Reviewer:** Pod B (self-review, process / governance ADR) + Pod A (required, per Kerem decision 2026-06-04)
- **Approver:** Kerem
- **Date proposed:** 2026-06-05
- **Date approved:** 2026-06-05
- **Amended:** 2026-07-01 — risk-tiered §4 ceremony (fast + heavy lanes); Kerem-approved.
