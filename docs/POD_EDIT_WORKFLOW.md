# POD_EDIT_WORKFLOW.md

<!--
  STATUS: Draft — documentation-only operator guide
  AUTHOR: Pod A — Product & Planning
  REVIEWER: Pod B — Architecture, Logic & Risk
  APPROVER: Kerem
  CANONICAL REPO PATH: /docs/POD_EDIT_WORKFLOW.md
  DOCUMENT TYPE: Operator guide; not an ADR; not a methodology change
-->

---

## Purpose

This document defines the default lightweight operator workflow for applying routine pod-generated documentation and design edits to the Adeks Platform repository.

It is an operator guide only.

`/docs/PROJECT_METHODOLOGY.md` remains the canonical methodology authority for lifecycle, pod responsibilities, review gates, approval gates, handoff rules, escalation, ADR policy, security/KVKK process, Definition of Ready, Definition of Done, and AI session continuity.

If this document conflicts with `/docs/PROJECT_METHODOLOGY.md`, `/docs/adr/ADR-009-pr-approval-policy.md`, `/docs/adr/ADR-013-repository-controlled-pod-context.md`, or `.github/PULL_REQUEST_TEMPLATE.md`, the canonical source governs and this document must be corrected.

---

## Scope

### Included

This guide covers:

- how a pod prepares a repo-edit package;
- how Kerem receives and applies a repo-edit package locally;
- how Kerem checks citation integrity before applying edits;
- how PR review triggers are classified against ADR-009 §3;
- how the ADR-009 §4 behavior-change gate is answered before edits are applied;
- how the default repo-edit package path coexists with explicitly authorized pod write sessions.

### Excluded

This guide does not:

- authorize Pod C implementation;
- weaken Definition of Ready or Definition of Done;
- replace `/docs/PROJECT_METHODOLOGY.md`;
- create a new ADR;
- change methodology;
- change pod responsibilities;
- change review or approval gates;
- change external AI platform instructions;
- authorize direct commits to `main`;
- authorize direct writes to Selcafe SQL Server;
- authorize wallet, loyalty, payment, refund, security, customer-data, KVKK, schema, deployment, rollback, or integration decisions without the required review and approval path.

---

## Operating Principle

Pod outputs are drafts until committed to the repository through the normal PR path.

For routine documentation and design edits, the default path is:

1. Pod produces a repo-edit package.
2. Kerem applies the edits locally.
3. Kerem reviews the diff.
4. Kerem opens a PR using `.github/PULL_REQUEST_TEMPLATE.md`.
5. Required reviews and approvals occur through the normal repo gates.

Exception path:

- Kerem may explicitly authorize a Pod B or Pod C write session for that session only.
- The authorization must be explicit for the session.
- The pod must still follow repository gates, PR review triggers, Definition of Ready, Definition of Done, and Kerem approval requirements.
- This exception path does not become the default.

---

## Allowed Paths

| Path | Default? | Who applies edits? | When used | Notes |
|---|---:|---|---|---|
| Repo-edit package | Yes | Kerem | Routine pod-generated documentation/design edits | Lightweight path. Pod produces exact package; Kerem applies locally and opens PR. |
| Authorized pod write session | No | Explicitly authorized Pod B or Pod C | Only when Kerem enables it per session | Exception path. Does not remove review, approval, CI, or PR gates. |

---

## Repo-Edit Package Format

Every pod-generated repo-edit package must use the following structure.

```md
# Repo-Edit Package — [Short Name]

## Source Pod

- Pod:
- Date:
- Session context loaded:
  - /docs/PROJECT_METHODOLOGY.md
  - /docs/adr/ADR-009-pr-approval-policy.md
  - /docs/adr/ADR-013-repository-controlled-pod-context.md
  - /docs/AGENT_CONTEXT_MANIFEST.md
  - .github/PULL_REQUEST_TEMPLATE.md
  - Other relevant repo files:

## Target Branch

- Suggested branch name:
- Base branch: main

## Exact File Paths to Change

| Path | Action | Intended change |
|---|---|---|
| /docs/example.md | Create / Update / Delete | Plain-language description |

## Included Scope

-

## Excluded Scope

-

## Citation Integrity Check

Before applying edits, confirm every repo path cited in the PR body or edited files either:

1. exists at current HEAD on the base branch; or
2. is being created in the same commit push.

Result:

- [ ] Passed
- [ ] Failed — do not apply until resolved

Notes:

-

## Review Triggers per ADR-009 §3

Authoritative source: `/docs/adr/ADR-009-pr-approval-policy.md` §3.

Check every category that applies:

- [ ] Wallet ledger logic → Pod B + Kerem required before merge
- [ ] Loyalty ledger logic → Pod B + Kerem required before merge
- [ ] Payment logic → Pod B + Kerem required before merge
- [ ] Refund logic → Pod B + Kerem required before merge
- [ ] Customer personal data handling → Pod B + Kerem required before merge
- [ ] Security-sensitive PR, including security-sensitive admin actions → Pod B + Kerem required before merge
- [ ] Selcafe adapter or Selcafe integration changes → Pod B + Kerem required before merge
- [ ] Database / schema migration → Pod B + Kerem required before merge
- [ ] Authentication or authorisation → Pod B required before merge
- [ ] Audit log schema or logic → Pod B required before merge
- [ ] Admin privilege changes → Kerem required before merge
- [ ] None of the above → Standard review only

If multiple triggers apply, use the strictest applicable review path.

## Behavior-Change Gate per ADR-009 §4

Authoritative source: `/docs/adr/ADR-009-pr-approval-policy.md` §4.

Question:

**Does this PR change pod behavior, responsibilities, review/approval gates, context-loading rules, output format, locked or deferred decision state, methodology, templates, or external AI platform instructions?**

Answer before applying edits:

- [ ] No
- [ ] Yes

If yes:

- [ ] Pod Impact Matrix included
- [ ] Instruction Update Packet included using `/docs/templates/INSTRUCTION_UPDATE_PACKET.md`
- [ ] `PROJECT_DECISION_INDEX.md` update noted if decision state changes
- [ ] `AGENT_CONTEXT_MANIFEST.md` update noted if required context changes
- [ ] Affected pod instruction snapshots listed
- [ ] External platform re-paste requirement listed where applicable

## Kerem Approval / Visibility Requirement

- [ ] Kerem review path stated
- [ ] Kerem visibility or approval required before merge per ADR-009 §2
- [ ] Explicit Kerem approval required if the PR affects code, ADRs, strategic decisions, architecture, security, financial logic, customer data, operational policy, scope, wallet, loyalty, payments, refunds, Selcafe integration, schema, KVKK, or go-live risk

## Local Checks Suggested

- Documentation-only:
  - [ ] Markdown rendered/reviewed
  - [ ] Links and cited repo paths checked
- Code-impacting package, if ever applicable:
  - [ ] Lint
  - [ ] Type-check
  - [ ] Tests
  - [ ] Build

## PR Body Notes

Use `.github/PULL_REQUEST_TEMPLATE.md` as the canonical PR body template.

Suggested summary:

-

Suggested included scope:

-

Suggested excluded scope:

-

Suggested review trigger selection:

-

Suggested behavior-change gate answer:

-

## Review Routing

- Ready for commit:
- Requires Kerem approval:
- Requires Pod B review:
- Requires Pod C implementation:
- Requires Pod D prototype/audit/monitoring review:
```

---

## Required Corrections Embedded in This Workflow

This guide incorporates the following Pod B blocking corrections.

| Correction | Required handling in this guide |
|---|---|
| Review triggers must cite ADR-009 §3 as authoritative | Every repo-edit package must classify triggers against ADR-009 §3, not from memory. |
| Pod D is not a routine per-PR gate | Pod D is not listed as a routine PR reviewer. Pod D review applies only when separately routed or at mandatory milestone audits defined in methodology. |
| Behavior-change gate must be answered before applying edits | The ADR-009 §4 universal question must be answered before Kerem applies the package locally. |

---

## Pod D Routing Clarification

Pod D is not a routine per-PR gate.

Pod D may be routed when a change needs UX review, PWA prototype review, broad consistency audit, monitoring review, screenshot/UI audit, or another Pod D-owned audit/prototype function.

Pod D milestone audits remain governed by `/docs/PROJECT_METHODOLOGY.md`.

A PR body may note that a follow-up Pod D review is useful, but that does not automatically create a per-PR approval gate.

---

## Kerem Local Application Workflow

### 1. Receive the repo-edit package

Kerem checks that the producing pod supplied:

- exact repo paths;
- action per file;
- intended change per file;
- excluded scope;
- citation integrity result;
- ADR-009 §3 review trigger classification;
- ADR-009 §4 behavior-change gate answer;
- Kerem approval/visibility requirement;
- review routing.

If any required field is missing, Kerem should stop and ask the producing pod to correct the package before applying edits.

### 2. Create a feature branch

Use a branch from `main`.

Example:

```bash
git checkout main
git pull --ff-only origin main
git checkout -b docs/pod-edit-workflow
```

### 3. Apply edits exactly as packaged

Do not expand scope while applying the package.

If a new issue appears, record it as a follow-up note, issue, or separate package.

### 4. Review the diff

```bash
git diff
```

Confirm:

- only the listed files changed;
- each changed file matches the package intent;
- excluded scope was not touched;
- synthetic data only;
- no real customer names, phone numbers, transaction data, staff records, secrets, or operational credentials are present.

### 5. Run applicable checks

For documentation-only changes, review Markdown rendering and links where practical.

For code-impacting work, use the relevant lint, type-check, test, and build commands required by the repository.

### 6. Commit and push

Example:

```bash
git status
git add docs/POD_EDIT_WORKFLOW.md
git commit -m "docs: add pod edit workflow guide"
git push -u origin docs/pod-edit-workflow
```

### 7. Open PR

Use `.github/PULL_REQUEST_TEMPLATE.md` as the canonical PR body template.

The PR body must complete:

- Summary;
- Scope included;
- Scope excluded;
- Review Triggers;
- Process / Behavior-Change Gate;
- Documentation;
- Tests / checks run;
- Data Safety;
- Risk Notes;
- Open Questions;
- Definition of Done checklist.

---

## Pod-Output Edit Package Intake Checklist

Use this for every set of pod-produced edits before applying locally and opening a PR.

Authoritative sources:

- `/docs/adr/ADR-009-pr-approval-policy.md`
- `/docs/PROJECT_METHODOLOGY.md` §15
- `.github/PULL_REQUEST_TEMPLATE.md`

---

### A — Package Receipt

- [ ] Pod has specified exact file paths, relative to repo root, for every file to be changed.
- [ ] Pod has described the intended change per file in plain language.
- [ ] Pod has stated explicitly what is excluded from this package.

---

### B — Citation Integrity Before Applying Edits

- [ ] Every repo path cited in the PR body or within the edited files either:
  - already exists at current HEAD on `main` or the base branch; or
  - is being created in this same commit push.

If any cited path fails this check:

- [ ] Stop.
- [ ] Resolve the missing file before applying.

---

### C — Review Trigger Classification — ADR-009 §3 Authoritative Source

Check every category that applies to this edit package:

- [ ] Wallet ledger logic → **Pod B + Kerem** required before merge
- [ ] Loyalty ledger logic → **Pod B + Kerem** required before merge
- [ ] Payment logic → **Pod B + Kerem** required before merge
- [ ] Refund logic → **Pod B + Kerem** required before merge
- [ ] Customer personal data handling → **Pod B + Kerem** required before merge
- [ ] Security-sensitive PR, including security-sensitive admin actions → **Pod B + Kerem** required before merge
- [ ] Selcafe adapter or Selcafe integration changes → **Pod B + Kerem** required before merge
- [ ] Database / schema migration → **Pod B + Kerem** required before merge
- [ ] Authentication or authorisation → **Pod B** required before merge
- [ ] Audit log schema or logic → **Pod B** required before merge
- [ ] Admin privilege changes → **Kerem** required before merge
- [ ] None of the above → Standard review only

---

### D — Behavior-Change Gate — ADR-009 §4

**Does this PR change pod behavior, responsibilities, review/approval gates, context-loading rules, output format, locked or deferred decision state, methodology, templates, or external AI platform instructions?**

- [ ] **No** → skip to Section E.
- [ ] **Yes** → complete the following before applying edits:
  - [ ] Pod Impact Matrix produced by the producing pod, covering all four pods.
  - [ ] Instruction Update Packet produced using `/docs/templates/INSTRUCTION_UPDATE_PACKET.md`.
  - [ ] `PROJECT_DECISION_INDEX.md` update noted if decision state changes.
  - [ ] `AGENT_CONTEXT_MANIFEST.md` update noted if required context changes.
  - [ ] If a pod instruction snapshot changes, post-merge platform re-paste listed as a to-do item.

---

### E — Apply and Verify

- [ ] Create feature branch from `main`.
- [ ] Apply edits exactly as specified in the package.
- [ ] Review `git diff`.
- [ ] Confirm changes match package scope.
- [ ] Confirm nothing extra was modified.
- [ ] Confirm no real personal data in any changed file, fixture, screenshot, or example.
- [ ] Confirm synthetic examples only, such as:
  - Customer A
  - +90 555 000 00 01
  - PC-001
  - Order #SYN-001
- [ ] Run local checks where applicable.

---

### F — PR Body

- [ ] Open PR using `.github/PULL_REQUEST_TEMPLATE.md` as the template base.
- [ ] Summary paragraph states what changed and why.
- [ ] Review Triggers section in PR body completed to match Section C.
- [ ] Process / Behavior-Change Gate section in PR body answered to match Section D.
- [ ] Excluded scope stated under Excluded in PR body.
- [ ] Any new repo paths referenced in the PR body confirmed to exist at HEAD or be created in the same commit push.

---

### G — Pre-Merge Gate

Do not merge until all required items are checked.

- [ ] Required reviews obtained per Section C trigger classification.
- [ ] Kerem visibility or approval recorded per ADR-009 §2.
- [ ] CI passes where configured.
- [ ] Definition of Done in `/docs/PROJECT_METHODOLOGY.md` §15 is satisfied.
- [ ] All open questions in the PR body are resolved or explicitly deferred with a reason.
- [ ] If behavior-changing, Pod Impact Matrix and Instruction Update Packet are confirmed in the PR before merge.

---

### H — Post-Merge

- [ ] If pod instruction snapshots were updated, re-paste updated text to the relevant AI platform and update the `LAST SYNCED TO PLATFORM` date in the snapshot file.
- [ ] Decision index updated if decision state changed.
- [ ] Context manifest updated if required context routing changed.

---

## Example Repo-Edit Package

Synthetic example only.

```md
# Repo-Edit Package — Add Staff FAQ Draft

## Source Pod

- Pod: Pod A
- Date: 2026-06-16
- Session context loaded:
  - /docs/PROJECT_METHODOLOGY.md
  - /docs/adr/ADR-009-pr-approval-policy.md
  - /docs/adr/ADR-013-repository-controlled-pod-context.md
  - /docs/AGENT_CONTEXT_MANIFEST.md
  - .github/PULL_REQUEST_TEMPLATE.md

## Target Branch

- Suggested branch name: docs/staff-faq-draft
- Base branch: main

## Exact File Paths to Change

| Path | Action | Intended change |
|---|---|---|
| /docs/STAFF_FAQ.md | Create | Add initial staff-facing FAQ draft using synthetic examples only. |

## Included Scope

- Staff FAQ draft.
- Synthetic examples only.

## Excluded Scope

- No implementation issue.
- No customer-data policy change.
- No auth, wallet, loyalty, payment, refund, Selcafe, schema, or KVKK decision.

## Citation Integrity Check

- [x] Passed

## Review Triggers per ADR-009 §3

- [x] None of the above → Standard review only

## Behavior-Change Gate per ADR-009 §4

- [x] No

## Kerem Approval / Visibility Requirement

- [x] Kerem visibility required before merge.

## Review Routing

- Ready for commit: Yes, after Kerem local diff review.
- Requires Kerem approval: Kerem visibility required before merge.
- Requires Pod B review: No ADR-009 §3 trigger identified.
- Requires Pod C implementation: No.
- Requires Pod D prototype/audit/monitoring review: No.
```

---

## Relationship to Pod C

This document does not authorize Pod C implementation.

Pod C implementation still requires:

- a GitHub issue meeting Definition of Ready;
- linked source documents;
- acceptance criteria;
- risk classification;
- required Pod B review where triggered;
- Kerem approval where triggered;
- PR completion under Definition of Done.

A repo-edit package is not an implementation issue.

---

## Relationship to Definition of Ready and Definition of Done

This guide does not weaken existing Definition of Ready or Definition of Done gates.

For implementation work:

- Definition of Ready remains the entry gate before Pod C begins.
- Definition of Done remains the PR completion gate before merge.

For documentation-only operator packages:

- the PR must still satisfy the applicable parts of the live PR template;
- review triggers must still be classified against ADR-009 §3;
- the behavior-change gate must still be answered against ADR-009 §4;
- Kerem visibility or approval must still be recorded as required.

---

## Review Routing

- Ready for commit: Yes, as a documentation-only draft after Kerem confirms Option A — coexistence is the intended operating model.
- Requires Kerem approval: Yes. Kerem must approve the PR before merge or record required visibility per ADR-009 §2.
- Requires Pod B review: Yes. This is a new process-adjacent operator guide and should receive Pod B review before merge.
- Requires Pod C implementation: No.
- Requires Pod D prototype/audit/monitoring review: No routine per-PR Pod D gate. Pod D review only if Kerem or a pod routes a specific audit/prototype need.
