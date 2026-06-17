# POD_EDIT_WORKFLOW.md

<!--
  STATUS: Active — approved operator guide with Command Keyword Gate
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
- how Kerem's Command Keyword Gate controls whether pods may produce executable repo-edit/write material;
- how repo-edit packages and execution packets declare the selected keyword, actors, environment, and authorization boundaries;
- how executor-facing prompts are separated into their own file from post-execution review handoffs;
- how Complete Repo Execution Packet requirements are folded into this guide's repo-edit / execution package format.

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
- authorize merge by any pod, Codex, or executor other than Kerem;
- allow command keywords to bypass ADR-009, Definition of Ready, Definition of Done, Kerem approval, Pod B review where required, legal/KVKK blockers, or the synthetic-data-only rule;
- convert a repo-edit package into Pod C implementation authorization.

---

## Operating Principle

Pod outputs are drafts until committed to the repository through the normal PR path.

For routine documentation and design edits, the default path is:

1. Pod produces a repo-edit package.
2. Kerem applies the edits locally.
3. Kerem reviews the diff.
4. Kerem opens a PR using `.github/PULL_REQUEST_TEMPLATE.md`.
5. Required reviews and approvals occur through the normal repo gates.

Exception path: Kerem may select a keyword-gated execution mode (see Command Keyword Gate) in which a write actor other than Kerem-by-default applies edits — a pod under `gitpp` (only with explicit per-session Kerem authorization) or Codex under `gitcc`. In all modes: merge remains Kerem-only; no keyword authorizes direct commits to `main`; a `gitcc`/Codex write executes repo-edit / process changes only and never authorizes Pod C feature implementation (separately gated); all repository gates, PR review triggers, Definition of Ready, Definition of Done, and Kerem approval still apply. This exception path does not become the default.

---

## Command Keyword Gate

### Purpose

The Command Keyword Gate prevents pods from unintentionally producing executable repository-edit or repository-write material before Kerem selects the execution mode.

It controls output mode only. It does not change approval authority, review gates, merge authority, Definition of Ready, Definition of Done, legal/KVKK blockers, or the synthetic-data-only rule.

### Gate Rule

Before preparing any executable repo-edit/write material, a pod must verify that Kerem has provided a valid command keyword in the current request or handoff.

If no valid keyword is present, the pod may still discuss:

- concepts;
- risks;
- review findings;
- alternatives;
- recommendations;
- non-executable planning notes.

If no valid keyword is present, the pod must stop and ask Kerem for a command keyword before producing any of the following:

- exact edits;
- patch text;
- file replacement text;
- CLI commands;
- Codex prompts;
- direct repo-write instructions;
- branch, commit, push, or PR execution instructions;
- downloadable execution files.

### Command Keyword Table

| Edit actor | Write actor | CLI / environment | Keyword |
|---|---|---|---|
| Pod | Pod | n/a | `gitpp` |
| Pod | Kerem | PowerShell | `gitpkp` |
| Pod | Kerem | macOS | `gitpkm` |
| Codex | Codex | n/a | `gitcc` |
| Kerem | Kerem | PowerShell | `gitkkp` |
| Kerem | Kerem | macOS | `gitkkm` |

Definitions:

- Edit actor = who prepares or changes the file content.
- Write actor = who applies the changes to the repo, commits, pushes, or opens the PR.
- CLI / environment = command style required when Kerem is executing locally.
- Merge is always Kerem's. No keyword authorizes merge by a pod, Codex, or any other executor.
- No keyword authorizes direct commits to `main`.
- No keyword overrides ADR-009, Definition of Ready, Definition of Done, Kerem approval, Pod B review where required, legal/KVKK blockers, or the synthetic-data-only rule.

### Required Keyword Declaration

Every repo-edit package or execution packet must state:

| Field | Required content |
|---|---|
| Selected keyword | One valid keyword from the Command Keyword Table. |
| Edit actor | Pod, Codex, or Kerem. |
| Write actor | Pod, Codex, or Kerem. |
| CLI / environment | `n/a`, PowerShell, or macOS. |
| Allowed output | What the pod is allowed to produce under the selected keyword. |
| Prohibited output | What the pod must not produce under the selected keyword. |
| Merge excluded? | Must state that merge is Kerem-only. |
| Direct repo write authorized? | Must state whether direct branch/commit/push/PR work is authorized for the selected write actor. |

### Keyword Mode Behavior

| Keyword | Required behavior |
|---|---|
| `gitpp` | Pod prepares exact edits and may attempt direct repo-write only if Kerem explicitly authorized pod write access for this session. Direct repo-write means branch, commit, push, and PR only. Merge remains Kerem-only. If direct repo-write fails or the pod lacks write tooling, the pod must ask Kerem which platform to use: PowerShell or macOS. After Kerem answers, the pod must provide exact edits plus the appropriate commands for Kerem to apply. |
| `gitpkp` | Pod prepares exact edits plus one PowerShell command block for Kerem to apply. |
| `gitpkm` | Pod prepares exact edits plus one macOS shell command block for Kerem to apply. |
| `gitcc` | Pod prepares one complete Codex-ready prompt as one downloadable `.md` text file. The Codex-ready prompt file must contain only executor-facing material. Post-execution review handoffs must be provided in a separate file. If the platform cannot produce downloadable files, provide two complete fenced markdown blocks with intended filenames: one for Codex/executor and one for post-execution review. The Codex prompt must include: `show diff before commit`. Codex must prioritize the GitHub connector as the repository read/context path when available, and must prioritize GitHub CLI (`gh`) as the repository write path for branch creation, commits, pushes, and PR creation; if either path is unavailable, Codex must state the fallback before proceeding, and no fallback may authorize direct commits to `main` or merge. |
| `gitkkp` | Pod prepares checklist and constraints only. Kerem edits and writes using PowerShell. Commands are optional and, if provided, must remain checklist-style and must not attempt to perform edits automatically. |
| `gitkkm` | Pod prepares checklist and constraints only. Kerem edits and writes using macOS shell. Commands are optional and, if provided, must remain checklist-style and must not attempt to perform edits automatically. |

### Non-Override Rule

The selected keyword does not override:

- ADR-009 review triggers;
- ADR-009 behavior-change gate;
- Definition of Ready;
- Definition of Done;
- Kerem approval;
- Pod B review where required;
- the no-direct-main rule;
- the merge-is-Kerem-only rule;
- the synthetic-data-only rule;
- legal/KVKK blockers.

### Executor / Review File Separation Rule

Repo-edit packages and execution packets must keep executor-facing content in a separate file from post-execution review handoffs.

For `gitcc`:

- the Codex-ready handoff file must contain only executor-facing instructions;
- the post-execution review handoff must be a separate file;
- do not include review handoff text inside the Codex-ready prompt file;
- do not place `DO NOT SEND THIS SECTION TO CODEX` content in a file intended for Codex.

For non-`gitcc` modes, apply the same principle where separate files are practical. Executor-facing material and review handoff material must be clearly separated so the executor does not receive instructions intended only for later review routing.

---

## Allowed Paths

| Path | Default? | Who applies edits (write actor)? | When used | Notes |
|---|---:|---|---|---|
| Repo-edit package (`gitpkp` / `gitpkm`) | Yes | Kerem | Routine pod-generated documentation/design edits | Lightweight path. Pod produces exact package; Kerem applies locally and opens PR. |
| Authorized pod write session (`gitpp`) | No | Explicitly authorized pod (e.g. Pod B or Pod C) | Only when Kerem enables it per session | Exception. Merge Kerem-only; no direct commits to `main`. Does not remove review, approval, CI, or PR gates. |
| Codex execution (`gitcc`) | No | Codex | When Kerem selects `gitcc` | Codex executes repo-edit / process changes only (branch/commit/push/PR). Merge Kerem-only; no direct commits to `main`. Never authorizes Pod C feature implementation. |
| Kerem direct (`gitkkp` / `gitkkm`) | No | Kerem | When Kerem edits and writes himself | Pod supplies checklist/constraints only. |

---

## Repo-Edit / Execution Package Format

Every pod-generated repo-edit package or execution packet that contains executable repo-edit/write material must use the following structure.

The selected Command Keyword determines what Section A may contain.

````md
# Repo-Edit / Execution Package — [Short Name]

## Source Pod

- Pod:
- Date:
- Session context loaded:
  - /docs/POD_EDIT_WORKFLOW.md
  - /docs/PROJECT_METHODOLOGY.md
  - /docs/adr/ADR-009-pr-approval-policy.md
  - /docs/adr/ADR-013-repository-controlled-pod-context.md
  - /docs/AGENT_CONTEXT_MANIFEST.md
  - .github/PULL_REQUEST_TEMPLATE.md
  - Other relevant repo files:

## Command Keyword Declaration

| Field | Value |
|---|---|
| Selected keyword | |
| Edit actor | |
| Write actor | |
| CLI / environment | |
| What the pod is allowed to produce under this mode | |
| What the pod must not produce under this mode | |
| Merge excluded? | Yes — merge remains Kerem-only. |
| Direct repo write authorized? | |

## Target Branch

- Suggested branch name:
- Base branch: main

## A — EXECUTOR PACKAGE

- This is the only section to send to Codex, the pod writer, or Kerem-as-executor.
- For `gitcc`, this section must be provided as a separate downloadable `.md` file containing only Codex/executor-facing instructions.
- Post-execution review handoffs must be provided in a separate file and must not be included in the Codex/executor file.
- If file output is not supported, provide separate complete fenced markdown blocks with intended filenames.
- Must include exact file paths, branch name, base branch, included scope, excluded scope, and executor-specific instructions based on the selected keyword.

Keyword-specific Section A rules:

| Keyword | Section A content |
|---|---|
| `gitpp` | Exact edits and, only if explicitly authorized for this session, pod direct-write instructions for branch/commit/push/PR. Merge excluded. If pod write fails or tooling is unavailable, ask Kerem whether to use PowerShell or macOS before producing local commands. |
| `gitpkp` | Exact edits plus one PowerShell command block for Kerem to apply. |
| `gitpkm` | Exact edits plus one macOS shell command block for Kerem to apply. |
| `gitcc` | One complete Codex-ready prompt in its own file. It must include: `show diff before commit`. Do not include post-execution review handoff text in this file. Codex must prioritize the GitHub connector as the repository read/context path when available, and must prioritize GitHub CLI (`gh`) as the repository write path for branch creation, commits, pushes, and PR creation; if either path is unavailable, Codex must state the fallback before proceeding, and no fallback may authorize direct commits to `main` or merge. |
| `gitkkp` | Checklist and constraints only. Kerem edits and writes using PowerShell. Do not provide auto-edit commands. |
| `gitkkm` | Checklist and constraints only. Kerem edits and writes using macOS shell. Do not provide auto-edit commands. |

## B — EXPECTED FILE CHANGES

| Path | Action | Intended change |
|---|---|---|
| /docs/example.md | Create / Update / Delete | Plain-language description |

Include exact replacement text or insertion location where available.

## C — COMMANDS

- If the selected keyword requires Kerem to run commands, provide commands as exactly one copy/paste box.
- For `gitpkp`, commands must be PowerShell.
- For `gitpkm`, commands must be macOS shell.
- For `gitkkp` and `gitkkm`, commands are optional because Kerem is both editor and writer; if provided, they must remain checklist-style and must not attempt to perform edits automatically.
- For `gitcc`, do not provide local shell commands unless they are inside the Codex-ready prompt and clearly marked for Codex.

## D — PR BODY DRAFT

Use `.github/PULL_REQUEST_TEMPLATE.md` as the canonical PR body template.

Must include:

- ready-to-use PR summary;
- included scope;
- excluded scope;
- review triggers per ADR-009 §3;
- behavior-change gate answer per ADR-009 §4;
- tests/checks run;
- risk notes;
- open questions;
- Pod Impact Matrix and Instruction Update Packet references when required.

## E — POST-EXECUTION REVIEW HANDOFF

- Must be a separate file from the executor package when file output is supported.
- Must not be included in the Codex-ready prompt file.
- Include the prompt for Pod B, Pod D, or Kerem after Codex/pod/Kerem produces the diff or PR.

## F — KEREM AFTER-EXECUTION CHECKLIST

- [ ] Review `git diff`.
- [ ] Confirm only expected files changed.
- [ ] Confirm excluded scope was not touched.
- [ ] Confirm no real personal data, secrets, credentials, transaction data, staff records, or operational data were added.
- [ ] Confirm PR body matches the required review triggers and behavior-change gate.
- [ ] Route to Pod B, Kerem, or Pod D if required.
- [ ] Confirm merge remains Kerem-only.
````

### Citation Integrity Check

Before applying edits, confirm every repo path cited in the PR body or edited files either:

1. exists at current HEAD on the base branch; or
2. is being created in the same commit push.

Result:

- [ ] Passed
- [ ] Failed — do not apply until resolved

Notes:

-

### Review Triggers per ADR-009 §3

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

### Behavior-Change Gate per ADR-009 §4

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

### Kerem Approval / Visibility Requirement

- [ ] Kerem review path stated
- [ ] Kerem visibility or approval required before merge per ADR-009 §2
- [ ] Explicit Kerem approval required if the PR affects code, ADRs, strategic decisions, architecture, security, financial logic, customer data, operational policy, scope, wallet, loyalty, payments, refunds, Selcafe integration, schema, KVKK, or go-live risk

### Local Checks Suggested

- Documentation-only:
  - [ ] Markdown rendered/reviewed
  - [ ] Links and cited repo paths checked
- Code-impacting package, if ever applicable:
  - [ ] Lint
  - [ ] Type-check
  - [ ] Tests
  - [ ] Build

### Review Routing

- Ready for commit:
- Requires Kerem approval:
- Requires Pod B review:
- Requires Pod C implementation:
- Requires Pod D prototype/audit/monitoring review:

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

### 0. Confirm Command Keyword Gate

Before accepting executable repo-edit/write material, confirm that the producing pod declared a valid command keyword.

If no valid keyword is declared, Kerem should ask the pod to regenerate the package under the correct keyword before applying any executable content.

If the package uses `gitcc`, Kerem should send only the separate Codex-ready executor file to Codex. Kerem should not send the separate post-execution review handoff file to Codex.

### 1. Receive the repo-edit package

Kerem checks that the producing pod supplied:

- selected command keyword;
- edit actor;
- write actor;
- CLI/environment;
- direct repo write authorization status;
- merge exclusion statement;
- executor-facing file clearly separated from post-execution review handoff file;
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

### A — Command Keyword Gate and Package Receipt

- [ ] Pod has declared a valid command keyword.
- [ ] Pod has stated edit actor, write actor, and CLI/environment.
- [ ] Pod has stated what it is allowed to produce under the selected keyword.
- [ ] Pod has stated what it must not produce under the selected keyword.
- [ ] Pod has stated whether direct repo write is authorized.
- [ ] Pod has stated explicitly that merge remains Kerem-only.
- [ ] If the selected keyword is `gitcc`, the Codex-ready executor prompt is in its own file.
- [ ] If the selected keyword is `gitcc`, the post-execution review handoff is in a separate file and excluded from the Codex prompt.
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

````md
# Repo-Edit / Execution Package — Add Staff FAQ Draft

## Source Pod

- Pod: Pod A
- Date: 2026-06-16
- Session context loaded:
  - /docs/POD_EDIT_WORKFLOW.md
  - /docs/PROJECT_METHODOLOGY.md
  - /docs/adr/ADR-009-pr-approval-policy.md
  - /docs/adr/ADR-013-repository-controlled-pod-context.md
  - /docs/AGENT_CONTEXT_MANIFEST.md
  - .github/PULL_REQUEST_TEMPLATE.md

## Command Keyword Declaration

| Field | Value |
|---|---|
| Selected keyword | `gitpkp` |
| Edit actor | Pod |
| Write actor | Kerem |
| CLI / environment | PowerShell |
| What the pod is allowed to produce under this mode | Exact edits plus one PowerShell command block for Kerem to apply. |
| What the pod must not produce under this mode | Direct repo-write actions, merge instructions, direct commits to `main`, or implementation authorization. |
| Merge excluded? | Yes — merge remains Kerem-only. |
| Direct repo write authorized? | No. Kerem applies, commits, pushes, and opens the PR. |

## Target Branch

- Suggested branch name: docs/staff-faq-draft
- Base branch: main

## A — EXECUTOR PACKAGE

For `gitpkp`, provide exact edits plus one PowerShell command block for Kerem to apply. Keep any post-execution review handoff outside this executor package when a separate file is practical.

## B — EXPECTED FILE CHANGES

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

## C — COMMANDS

```powershell
# Kerem applies the packaged edits locally, reviews the diff, then commits through the normal PR path.
git checkout main
git pull --ff-only origin main
git checkout -b docs/staff-faq-draft
git diff
```

## D — PR BODY DRAFT

Use `.github/PULL_REQUEST_TEMPLATE.md` as the canonical PR body template.

## E — POST-EXECUTION REVIEW HANDOFF

Provide any Pod B, Pod D, or Kerem review handoff separately from the executor-facing material.

## F — KEREM AFTER-EXECUTION CHECKLIST

- [ ] Review `git diff`.
- [ ] Confirm only expected files changed.
- [ ] Confirm no real personal data, secrets, credentials, transaction data, staff records, or operational data were added.
- [ ] Confirm merge remains Kerem-only.

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
````

---

## Relationship to Pod C

This document does not authorize Pod C implementation.

A command keyword may authorize a pod or Codex to prepare or execute repository edits under the selected mode, but it never authorizes Pod C feature implementation unless a separate GitHub issue satisfies Definition of Ready and the required reviews and approvals are complete.

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

- Ready for commit: Yes, as a keyword-gated operator guide after Kerem confirms the selected execution mode.
- Requires Kerem approval: Yes. Kerem must approve the PR before merge or record required visibility per ADR-009 §2.
- Requires Pod B review: Yes. This is a new process-adjacent operator guide and should receive Pod B review before merge.
- Requires Pod C implementation: No.
- Requires Pod D prototype/audit/monitoring review: No routine per-PR Pod D gate. Pod D review only if Kerem or a pod routes a specific audit/prototype need.
