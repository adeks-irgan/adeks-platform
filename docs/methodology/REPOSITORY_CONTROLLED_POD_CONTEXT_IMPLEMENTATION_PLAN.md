# Adeks Platform — Repository-Controlled Pod Context Implementation Plan

> Committed 2026-06-04 (PR-1) as the implementation-of-record for PR-1…PR-5. Pod B review is complete. The "Ready to commit: No" status in §13 reflects the pre-review drafting state and is retained for history.

**Version:** v0.1  
**Date:** 2026-06-04  
**Author:** Pod A — Product & Planning  
**Reviewer:** Pod B — Architecture, Logic & Risk  
**Approver:** Kerem  
**Status:** Repo-ready implementation plan draft; **requires Pod B review before Pod C executes PRs**  
**Intended repo path:** `/docs/methodology/REPOSITORY_CONTROLLED_POD_CONTEXT_IMPLEMENTATION_PLAN.md`

---

## 0. Context Freshness

| Item | Status |
|---|---|
| Live GitHub checked | No |
| Context basis | Files attached by Kerem in the current Pod A session |
| Primary inputs | `ADEKS_REPOSITORY_CONTROLLED_POD_CONTEXT_PROPOSAL_v0.2.md`, `POD_B_REVIEW_REPOSITORY_CONTROLLED_POD_CONTEXT_v0.2.md`, `PROJECT_DECISION_INDEX.md`, `PROJECT_METHODOLOGY.md`, `POD_TRAFFIC_WORKFLOW.md`, `CLAUDE.md` |
| Kerem decisions | MD-2…MD-6 approved by Kerem in chat; must be captured in repo-visible form in PR-1 |
| Output status | Draft from provided context; ready for Pod B review; not yet approved for Pod C execution |

---

## 1. Purpose

This document converts the approved Repository-Controlled Pod Context direction into a repo-ready implementation plan.

It does **not** implement the methodology files itself. It defines the PR sequence, file ownership, gating rules, merge preconditions, and Pod C handoff required to implement the methodology safely.

---

## 2. Kerem Recorded Decisions — MD-2…MD-6

Kerem has approved Pod B's recommendations on MD-2…MD-6.

This decision block must be captured in a repo-visible artifact during PR-1.

```md
# Kerem Decisions — Repository-Controlled Pod Context

**Decision date:** 2026-06-04  
**Decision source:** Kerem chat approval to Pod A  
**Scope:** Repository-Controlled Pod Context methodology consolidation

| ID | Decision | Kerem Decision |
|---|---|---|
| MD-2 | Approve methodology-consolidation direction | Approved |
| MD-3 | Record consolidation as both ADR-013 and methodology §28 revision | Approved |
| MD-4 | Approve `PROJECT_DECISION_INDEX.md` ownership as Pod B sole owner, with Pod A reviewer on product/business-impacting rows | Approved |
| MD-5 | Approve `/docs/POD_TRAFFIC_WORKFLOW.md` permanent stub plus full archive at `/docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md` | Approved |
| MD-6 | Approve conditional Pod Impact Matrix: one universal PR gate question, full matrix + Instruction Update Packet only when yes | Approved |
```

### 2.1 Still requiring Kerem approval

| Item | Kerem approval still required? | Notes |
|---|---:|---|
| PR-1 merge | Yes | Records the methodology direction and decisions into repo |
| ADR-013 acceptance | Yes | Product/process decision affecting all pods |
| ADR-009 acceptance | Yes | PR approval policy |
| PR-2 merge | Yes | Archives/stubs workflow file and changes Pod C instructions |
| PR-3 merge | Yes | Adds manifest and templates |
| PR-4 merge | Yes | Changes PR/process templates |
| PR-5 merge | Yes | Changes pod instruction snapshots |
| External platform instruction re-paste | Yes / operator action | After PR-5, Kerem or assigned operator must re-paste snapshots into AI platforms |

---

## 3. Pod B v0.2 Review Items Applied

Pod B reviewed v0.2 as **Approved with minor comments for Kerem decision**. The implementation plan applies the optional polish items and routes non-Pod-A work appropriately.

| Item | Pod B comment | Applied in this plan |
|---|---|---|
| OPT-1 / G-1 | Add note that the already-committed Pod B snapshot owes §10-compliance retrofit in PR-5 | Applied in PR-5 plan |
| OPT-2 / G-2 | Replace direct merge-to-main example with `gh pr merge` or GitHub UI merge | Applied across all merge command examples |
| OPT-3 / G-4 | Normalize pod-instruction filename extensions to `.md` | Applied in PR-5 plan |
| G-3 | Propagate git-command rule into `PROJECT_METHODOLOGY.md` and every snapshot | Applied in PR-1 and PR-5 plan |
| ADR-013 | Route methodology consolidation ADR to Pod B | Routed to Pod B |
| ADR-009 | Route PR approval policy ADR to Pod B | Routed to Pod B |

---

## 4. Global Implementation Rules

### 4.1 No direct implementation before Pod B review

This implementation plan must be reviewed by Pod B before Pod C opens PRs.

### 4.2 No direct push to `main`

All changes must go through branches and PRs.

### 4.3 Merge command policy

When merge is approved, use GitHub PR merge, not a direct local merge to `main`.

Preferred CLI form:

```bash
gh pr merge <PR_NUMBER> --merge --delete-branch
```

Alternative:

```text
Use the GitHub web UI: Pull Request → Merge pull request → Confirm merge → Delete branch.
```

### 4.4 Git command requirement

Whenever any pod asks Kerem to branch, commit, open a PR, merge, remove, move, archive, restore, tag, fetch, or pull, the pod must provide exact commands.

This rule must be added to:

- `/docs/PROJECT_METHODOLOGY.md`
- `/docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md`
- `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.md`
- `/CLAUDE.md`
- `/docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md`

---

## 5. PR Sequence Overview

| PR | Purpose | Pod C execution allowed before Pod B review of this plan? | Required reviews |
|---|---|---:|---|
| PR-1 | Record methodology direction | No | Pod B + Kerem |
| PR-2 | Archive/stub `POD_TRAFFIC_WORKFLOW.md` and update `/CLAUDE.md` in same PR | No | Pod B + Kerem |
| PR-3 | Add manifest and templates | No | Pod B + Kerem |
| PR-4 | Update PR template and process-change issue template | No | Pod B + Kerem |
| PR-5 | Add/update pod instruction snapshots and clean up committed Pod B snapshot | No | Pod B + Kerem |

---

## 6. PR-1 — Record Methodology Direction

### 6.1 Purpose

Record the approved Repository-Controlled Pod Context direction into the repo control plane.

### 6.2 Files

| Action | File |
|---|---|
| Add | `/docs/methodology/REPOSITORY_CONTROLLED_POD_CONTEXT_IMPLEMENTATION_PLAN.md` |
| Add or update | `/docs/methodology/REPOSITORY_CONTROLLED_POD_CONTEXT_PROPOSAL.md` |
| Update | `/docs/PROJECT_METHODOLOGY.md` |
| Update | `/docs/PROJECT_DECISION_INDEX.md` if needed to reflect MD-2…MD-6 / ADR-013 status |
| Add, by Pod B | `/docs/adr/ADR-013-repository-controlled-pod-context.md` |

### 6.3 Required content

`PROJECT_METHODOLOGY.md` should receive a Section 28 revision entry recording:

- MD-2 methodology-consolidation direction approved,
- MD-3 ADR-013 + methodology revision approved,
- MD-4 decision-index ownership approved,
- MD-5 workflow stub + archive approved,
- MD-6 conditional Pod Impact Matrix approved,
- git-command requirement approved.

The methodology body should add or reference:

- repository-controlled pod context principle,
- canonical methodology source rule,
- decision-index mirror rule,
- context-manifest routing rule,
- git-command requirement for all pods.

### 6.4 ADR routing

Pod A must not draft ADR-013.

Pod B owns ADR-013:

| ADR | Owner | Reviewer | Approver |
|---|---|---|---|
| ADR-013 — Repository-Controlled Pod Context | Pod B | Pod A | Kerem |

### 6.5 Commands for PR-1

```bash
# Run from repository root
git fetch --prune
git checkout main
git pull origin main
git checkout -b docs/repository-controlled-pod-context-pr1

# After files are edited/added
git add docs/methodology/REPOSITORY_CONTROLLED_POD_CONTEXT_IMPLEMENTATION_PLAN.md
git add docs/methodology/REPOSITORY_CONTROLLED_POD_CONTEXT_PROPOSAL.md
git add docs/PROJECT_METHODOLOGY.md
git add docs/PROJECT_DECISION_INDEX.md
git add docs/adr/ADR-013-repository-controlled-pod-context.md

git commit -m "docs: record repository-controlled pod context direction"
git push -u origin docs/repository-controlled-pod-context-pr1

gh pr create \
  --base main \
  --head docs/repository-controlled-pod-context-pr1 \
  --title "docs: record repository-controlled pod context direction" \
  --body "Records Kerem-approved MD-2…MD-6 methodology decisions, adds the implementation plan, updates methodology governance, and routes ADR-013 for review."
```

### 6.6 Merge command after approval

Only after Pod B review, CI if applicable, and Kerem approval:

```bash
gh pr merge <PR_NUMBER> --merge --delete-branch
```

---

## 7. PR-2 — Archive/Stub Workflow File and Update Pod C Pointer

### 7.1 Purpose

Safely retire `/docs/POD_TRAFFIC_WORKFLOW.md` as an active methodology source while preserving old links and migrating unique content.

### 7.2 Files

| Action | File |
|---|---|
| Add | `/docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md` |
| Replace | `/docs/POD_TRAFFIC_WORKFLOW.md` with permanent deprecation stub |
| Update | `/CLAUDE.md` |
| Update if needed | `/docs/PROJECT_METHODOLOGY.md` |
| Add, by Pod B | `/docs/adr/ADR-009-pr-approval-policy.md` |

### 7.3 PR-2 merge-blocking migration map

PR-2 must not merge until every row has a confirmed destination.

| Source content in `POD_TRAFFIC_WORKFLOW.md` v1.1 | Destination | Required action before PR-2 merge | Merge-blocking |
|---|---|---|---:|
| §14 Pull Request Approval Policy | `PROJECT_METHODOLOGY.md` PR-policy section + ADR-009 | Confirm PR approval rules are represented in methodology and ADR-009 draft/acceptance path | Yes |
| §16 Agent Session Sync Protocol | `PROJECT_METHODOLOGY.md` §27 + `/docs/templates/CONTEXT_FRESHNESS.md` | Confirm start-of-session sync, freshness declaration, stale-context rule, sync-failure handling, end-of-session output rule, and minimum handoff gate are migrated | Yes |
| §17 Approved Governance Decisions | `PROJECT_DECISION_INDEX.md` or referenced canonical decision records | Confirm PQ-001…PQ-005 are enumerated or explicitly mapped to canonical records | Yes |
| §8 Handoff Packet Format | `/docs/templates/HANDOFF_PACKET.md` + methodology §16 reference | Confirm template destination exists or is created in PR-3 with interim reference | Yes |
| §10 Disagreement Resolution / §10.2 Escalation Format | `/docs/templates/DECISION_ESCALATION.md` + methodology §17 reference | Confirm escalation destination exists or is created in PR-3 with interim reference | Yes |
| §6.1 Pod B Review Format | `/docs/templates/POD_B_REVIEW.md` | Confirm Pod B review template owner is Pod B | Yes |
| §11 Commit Readiness Checklist | `PROJECT_METHODOLOGY.md` §14/§15 or governance section | Confirm not-ready-to-commit logic survives, including stale-context statuses | Yes |
| §12 Context Drift Rules | `PROJECT_METHODOLOGY.md` §1/§27 and `AGENT_CONTEXT_MANIFEST.md` | Confirm source-of-truth and context hygiene rules survive | Yes |

### 7.4 Stub requirements

The new `/docs/POD_TRAFFIC_WORKFLOW.md` stub must:

- state that the file is deprecated,
- state that it remains permanently to preserve links,
- point to `/docs/PROJECT_METHODOLOGY.md` for canonical methodology,
- point to `/docs/AGENT_CONTEXT_MANIFEST.md` for context loading,
- point to `/docs/PROJECT_DECISION_INDEX.md` for decision state,
- point to `/docs/templates/` for handoff/review/escalation/freshness templates,
- point to `/docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md` for full historical content.

### 7.5 `/CLAUDE.md` update requirement

`/CLAUDE.md` currently lists `/docs/POD_TRAFFIC_WORKFLOW.md` as a required core document. PR-2 must update this so Pod C reads:

- `/docs/PROJECT_METHODOLOGY.md`
- `/docs/AGENT_CONTEXT_MANIFEST.md` if present
- `/docs/PROJECT_DECISION_INDEX.md`
- `/docs/PROJECT_BRIEF.md`
- relevant `/docs/*`
- relevant ADRs

`/docs/POD_TRAFFIC_WORKFLOW.md` may be referenced only as a deprecated historical stub, not as a core methodology source.

### 7.6 ADR routing

Pod A must not draft ADR-009.

Pod B owns ADR-009:

| ADR | Owner | Reviewer | Approver |
|---|---|---|---|
| ADR-009 — PR approval policy | Pod B | Pod A where process/product-impacting | Kerem |

### 7.7 Commands for PR-2

```bash
# Run from repository root
git fetch --prune
git checkout main
git pull origin main
git checkout -b docs/archive-pod-traffic-workflow

mkdir -p docs/archive

# Preserve full v1.1 content before replacing the original with a stub
cp docs/POD_TRAFFIC_WORKFLOW.md docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md

# Edit docs/POD_TRAFFIC_WORKFLOW.md into a permanent deprecation stub.
# Edit CLAUDE.md so it no longer treats POD_TRAFFIC_WORKFLOW.md as a core methodology source.
# Edit PROJECT_METHODOLOGY.md if needed to absorb PR policy/session-sync references.
# Add ADR-009 if Pod B has supplied it.

git add docs/archive/POD_TRAFFIC_WORKFLOW_v1.1.md
git add docs/POD_TRAFFIC_WORKFLOW.md
git add CLAUDE.md
git add docs/PROJECT_METHODOLOGY.md
git add docs/adr/ADR-009-pr-approval-policy.md

git commit -m "docs: archive pod traffic workflow and update pod c context"
git push -u origin docs/archive-pod-traffic-workflow

gh pr create \
  --base main \
  --head docs/archive-pod-traffic-workflow \
  --title "docs: archive pod traffic workflow and update Pod C context" \
  --body "Archives POD_TRAFFIC_WORKFLOW.md v1.1, replaces the original path with a permanent stub, updates CLAUDE.md in the same PR, and confirms migration destinations for unique workflow content."
```

### 7.8 Merge command after approval

Only after Pod B review, migration map confirmation, CI if applicable, and Kerem approval:

```bash
gh pr merge <PR_NUMBER> --merge --delete-branch
```

---

## 8. PR-3 — Add Context Manifest and Templates

### 8.1 Purpose

Add the new routing and template layer after the canonical direction is recorded and the old workflow file has been safely handled.

### 8.2 Files

| Action | File | Owner | Reviewer |
|---|---|---|---|
| Add | `/docs/AGENT_CONTEXT_MANIFEST.md` | Pod A | Pod B |
| Add | `/docs/templates/HANDOFF_PACKET.md` | Pod A custodian | Pod B |
| Add | `/docs/templates/POD_B_REVIEW.md` | Pod B | Pod A optional |
| Add | `/docs/templates/DECISION_ESCALATION.md` | Pod A custodian | Pod B |
| Add | `/docs/templates/INSTRUCTION_UPDATE_PACKET.md` | Pod A custodian | Pod B |
| Add | `/docs/templates/CONTEXT_FRESHNESS.md` | Pod A custodian | Pod B |

### 8.3 Manifest requirements

Every manifest row must include:

- task type,
- required files,
- file status: `exists`, `planned`, `missing`, or `unknown`,
- fallback if absent,
- affected pods,
- required review,
- freshness requirement.

### 8.4 Template requirements

`INSTRUCTION_UPDATE_PACKET.md` must include:

- behavior impact questions,
- affected pods table,
- external platform update table,
- ready-to-paste update text sections,
- post-merge re-paste checklist,
- `LAST SYNCED TO PLATFORM` update checkbox,
- manifest validation checkbox,
- decision-index update checkbox.

`CONTEXT_FRESHNESS.md` must include:

- repo context checked,
- relevant docs checked,
- relevant ADRs checked,
- relevant issues checked,
- relevant PRs checked,
- known stale areas,
- output status.

### 8.5 Commands for PR-3

```bash
# Run from repository root
git fetch --prune
git checkout main
git pull origin main
git checkout -b docs/add-agent-context-manifest-templates

mkdir -p docs/templates

git add docs/AGENT_CONTEXT_MANIFEST.md
git add docs/templates/HANDOFF_PACKET.md
git add docs/templates/POD_B_REVIEW.md
git add docs/templates/DECISION_ESCALATION.md
git add docs/templates/INSTRUCTION_UPDATE_PACKET.md
git add docs/templates/CONTEXT_FRESHNESS.md

git commit -m "docs: add agent context manifest and templates"
git push -u origin docs/add-agent-context-manifest-templates

gh pr create \
  --base main \
  --head docs/add-agent-context-manifest-templates \
  --title "docs: add agent context manifest and templates" \
  --body "Adds the context-routing manifest and standard templates for handoff, Pod B review, escalation, instruction updates, and context freshness."
```

### 8.6 Merge command after approval

Only after Pod B review, CI if applicable, and Kerem approval:

```bash
gh pr merge <PR_NUMBER> --merge --delete-branch
```

---

## 9. PR-4 — Update PR Template and Process Change Issue Template

### 9.1 Purpose

Add the conditional pod/methodology impact gate to the PR process without duplicating existing Review Triggers.

### 9.2 Files

| Action | File |
|---|---|
| Update | `.github/PULL_REQUEST_TEMPLATE.md` |
| Add or update | `.github/ISSUE_TEMPLATE/process_change.md` or `.github/ISSUE_TEMPLATE/governance_change.md` |

### 9.3 PR template requirement

Add this universal gate:

```md
# Pod / Methodology Impact Gate

Does this PR change any pod's behavior, responsibilities, review or approval gates, context-loading rules, output format, locked/deferred decision state, methodology, templates, or external AI platform instructions?

- [ ] No
- [ ] Yes — full Pod Impact Matrix and Instruction Update Packet required
```

If `Yes`, require:

- Pod Impact Matrix,
- Instruction Update Packet,
- affected snapshot list,
- external platform re-paste requirement,
- decision-index update requirement,
- manifest update requirement.

Do not duplicate the existing wallet/loyalty/auth/customer-data/Selcafe/audit/database/payment/admin/refund review triggers.

### 9.4 Commands for PR-4

```bash
# Run from repository root
git fetch --prune
git checkout main
git pull origin main
git checkout -b docs/update-pr-template-pod-impact-gate

git add .github/PULL_REQUEST_TEMPLATE.md
git add .github/ISSUE_TEMPLATE/process_change.md
git add .github/ISSUE_TEMPLATE/governance_change.md

git commit -m "docs: add conditional pod impact gate to PR template"
git push -u origin docs/update-pr-template-pod-impact-gate

gh pr create \
  --base main \
  --head docs/update-pr-template-pod-impact-gate \
  --title "docs: add conditional pod impact gate to PR template" \
  --body "Adds a universal pod/methodology impact gate and process-change issue template without duplicating existing high-risk Review Triggers."
```

### 9.5 Note on optional issue-template path

If only one process-change issue template is created, use one of these paths and remove the unused `git add` command:

```bash
git add .github/ISSUE_TEMPLATE/process_change.md
```

or:

```bash
git add .github/ISSUE_TEMPLATE/governance_change.md
```

### 9.6 Merge command after approval

Only after Pod B review, CI if applicable, and Kerem approval:

```bash
gh pr merge <PR_NUMBER> --merge --delete-branch
```

---

## 10. PR-5 — Pod Instruction Snapshot Normalization and Anti-Drift Cleanup

### 10.1 Purpose

Add or normalize pod instruction snapshots and make them compliant with the reference-only anti-drift rule.

### 10.2 Files

| Action | File |
|---|---|
| Add/update | `/docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md` |
| Rename/update | `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` → `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.md` |
| Add/update | `/docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md` |
| Update if needed | `/CLAUDE.md` |

### 10.3 G-1 cleanup for committed Pod B snapshot

The already-committed Pod B snapshot must be cleaned up in PR-5.

Required changes:

- Add the required snapshot header from proposal §10.2.
- Normalize filename extension to `.md`.
- Remove embedded full `Locked Technical Decisions` table.
- Remove embedded full `Not Yet Locked` table.
- Remove embedded full `D-001…D-011` product-decision table.
- Remove or reword responsibility text that presumes schema-per-tenant.
- Replace embedded decision tables with pointers to:
  - `/docs/PROJECT_DECISION_INDEX.md`
  - `/docs/adr/`
  - `/docs/PROJECT_METHODOLOGY.md`
  - relevant product docs when needed.

### 10.4 Snapshot header requirement

Every snapshot must include:

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

### 10.5 Reference-only rule

Snapshots must contain:

- pod role,
- role boundaries,
- source-of-truth rule,
- context loading rule,
- output style,
- stop conditions,
- pointers to methodology, decision index, and ADRs.

Snapshots must not contain:

- full locked-decision tables,
- full not-yet-locked tables,
- live open questions,
- volatile ADR counts,
- copied methodology sections,
- current sprint state,
- current blockers that belong in issues.

### 10.6 Git-command rule propagation

Each snapshot must include this rule:

> When asking Kerem to branch, commit, open a PR, merge, remove, move, archive, restore, tag, fetch, pull, or perform any repository action, provide exact git or GitHub CLI commands. Do not ask Kerem to merge until required review, CI, and approval gates are complete.

### 10.7 Commands for PR-5

```bash
# Run from repository root
git fetch --prune
git checkout main
git pull origin main
git checkout -b docs/normalize-pod-instruction-snapshots

mkdir -p docs/pod-instructions

# Normalize Pod B snapshot filename extension if the uppercase .MD file exists
git mv docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.md

# Edit/add all snapshot files according to the reference-only rule.
# Edit CLAUDE.md if additional alignment is needed.

git add docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md
git add docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.md
git add docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md
git add CLAUDE.md

git commit -m "docs: normalize pod instruction snapshots"
git push -u origin docs/normalize-pod-instruction-snapshots

gh pr create \
  --base main \
  --head docs/normalize-pod-instruction-snapshots \
  --title "docs: normalize pod instruction snapshots" \
  --body "Adds reference-only pod instruction snapshots, normalizes filename casing, cleans up the committed Pod B snapshot, and propagates the git-command rule."
```

### 10.8 If `git mv` fails

If the uppercase `.MD` file is not present in the working tree, use:

```bash
git status --short docs/pod-instructions
ls docs/pod-instructions
```

Then apply the correct rename or add path.

### 10.9 Merge command after approval

Only after Pod B review, CI if applicable, Kerem approval, and external platform re-paste plan is ready:

```bash
gh pr merge <PR_NUMBER> --merge --delete-branch
```

### 10.10 Post-merge operational steps

After PR-5 merges, Kerem or the assigned operator must re-paste the updated snapshot contents into the corresponding AI platforms.

Required checklist:

```md
- [ ] ChatGPT Project instructions updated from `/docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md`
- [ ] Claude Project instructions updated from `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.md`
- [ ] Gemini Gem instructions updated from `/docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md`
- [ ] `/CLAUDE.md` is committed and does not require external paste
- [ ] `LAST SYNCED TO PLATFORM` headers updated in a follow-up commit if needed
```

Suggested follow-up commands if header dates are updated after platform paste:

```bash
# Run from repository root
git fetch --prune
git checkout main
git pull origin main
git checkout -b docs/update-pod-snapshot-sync-dates

git add docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md
git add docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.md
git add docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md

git commit -m "docs: record pod instruction platform sync dates"
git push -u origin docs/update-pod-snapshot-sync-dates

gh pr create \
  --base main \
  --head docs/update-pod-snapshot-sync-dates \
  --title "docs: record pod instruction platform sync dates" \
  --body "Records platform sync dates after Kerem/operator pasted updated pod instruction snapshots into external AI platforms."
```

Merge after Pod B/Kerem approval if required:

```bash
gh pr merge <PR_NUMBER> --merge --delete-branch
```

---

## 11. Pod B Work Items

Pod B owns the following outputs. Pod A must not draft them.

| Work item | Owner | Reviewer | Approver | Needed before |
|---|---|---|---|---|
| ADR-013 — Repository-Controlled Pod Context | Pod B | Pod A | Kerem | PR-1 merge |
| ADR-009 — PR approval policy | Pod B | Pod A if needed | Kerem | PR-2 merge |
| Pod B snapshot cleanup review | Pod B | Pod A optional | Kerem | PR-5 merge |

---

## 12. Pod C Execution Guardrails

Pod C must:

- execute only after Pod B reviews this implementation plan,
- work PR-by-PR in order,
- not combine PRs except where this plan explicitly combines files,
- not draft ADR-013 or ADR-009 independently,
- not merge PRs,
- stop if a planned file path conflicts with the actual repository tree,
- stop if the GitHub issue or PR description contradicts committed methodology,
- provide exact commands in all handoffs and PR summaries.

---

## 13. Review Routing

| Item | Status |
|---|---|
| Ready for Pod B review | Yes |
| Ready for Pod C execution | No — wait for Pod B review of this plan |
| Requires Kerem approval | Yes, before each PR merge |
| Requires Pod B ADR work | Yes — ADR-013 and ADR-009 |
| Requires Pod D review | Optional after files are created |
| Ready to commit | No — this is a plan pending Pod B review |

---

## 14. Pod B Review Request

Pod B should review this implementation plan for:

1. Correct application of OPT-1, OPT-2, OPT-3.
2. Correct routing of ADR-013 and ADR-009 to Pod B.
3. Correct PR-1…PR-5 sequencing.
4. Correct PR-2 merge-blocking migration map.
5. Correct inclusion of G-1 Pod B snapshot cleanup in PR-5.
6. Correct propagation of the git-command rule.
7. Correct avoidance of direct push/merge to `main`.
8. Whether Pod C can execute from the handoff after Pod B approval.

---

<!-- END OF DOCUMENT -->
