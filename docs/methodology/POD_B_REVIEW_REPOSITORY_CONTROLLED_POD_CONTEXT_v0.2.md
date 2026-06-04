# Pod B Review — Repository-Controlled Pod Context Proposal v0.2

**Reviewer:** Pod B — Architecture, Logic & Risk
**Source:** `ADEKS_REPOSITORY_CONTROLLED_POD_CONTEXT_PROPOSAL_v0.2.md` (Pod A)
**Date:** 2026-06-04
**Status:** Pod B re-review complete — returned to Pod A + Kerem
**Intended repo path:** `/docs/methodology/POD_B_REVIEW_REPOSITORY_CONTROLLED_POD_CONTEXT_v0.2.md`

---

## Repo Reconciliation Note

Reviewed against the files attached this session (no live GitHub connector). If any differs from `main`, treat the committed repo version as authoritative and re-check. The Pod B snapshot referenced in finding **G-1** is the version Kerem has already committed to `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD`.

---

## Summary Decision

**Approved with minor comments for Kerem decision.**

All seven required revisions (REV-1…REV-7) are correctly applied — several exceed the original ask. Tenancy is correctly represented as **deferred / not locked**, the decision index is referenced as an existing Pod B-owned file (not recreated), and Kerem's git-command rule is properly incorporated. **v0.2 is ready for Kerem to decide MD-2…MD-6.**

The comments below are **non-blocking**. The only one of substance (G-1) concerns an *already-committed* file, not the proposal text, and is scheduled as a PR-5 cleanup. The rest are minor polish.

---

## REV-1…REV-7 Verification

| REV | Status | Notes |
|---|---|---|
| REV-1 — workflow migration map | **Pass** | §9 maps every unique block of `POD_TRAFFIC_WORKFLOW.md` v1.1, all marked merge-blocking, reinforced by §13.2 PR-2 preconditions. Exceeds the ask: also maps §6.1, §8, §10, §11, §12 (I only required §14/§16/§17). One verify-at-PR-2 detail: the §17 row references "PQ-001…PQ-005 or equivalent" — confirm the actual §17 governance decisions are enumerated, not just referenced generically, when PR-2 is built. |
| REV-2 — snapshot anti-drift guardrails | **Pass** | §10 has all four pieces: canonical-snapshot rule (§10.1), required version + last-synced header (§10.2), reference-only do/don't lists (§10.3), and post-merge re-paste checklist (§10.4). See **G-1** — the rule is correct, but the already-committed Pod B snapshot does not yet comply with it. |
| REV-3 — manifest status + fallback | **Pass** | §11.2 requires `File status` (exists/planned/missing/unknown) and `Fallback if absent` per row, plus a freshness flag; §11.4 adds the CI existence/link check. Example rows (§11.3) show real fallback behavior. |
| REV-4 — conditional Pod Impact Matrix | **Pass** | §12 uses one universal gate question; the full matrix + Instruction Update Packet are required only on "Yes." §12.4 explicitly integrates with — and forbids duplicating — the existing PR `Review Triggers`. |
| REV-5 — CLAUDE.md sequencing | **Pass** | §13.1 PR-2 bundles archive + stub + `/CLAUDE.md` update in one PR; §13.2 lists "CLAUDE.md updated in the same PR" as a hard merge precondition. The transient broken-pointer window is closed. |
| REV-6 — template ownership + index-mirror rule | **Pass** | §8.4 assigns explicit owner/reviewer/approver to all five templates (POD_B_REVIEW.md → Pod B). The "index mirrors ADRs/methodology, does not establish decisions" rule appears in §3.2, §6, §7.1, and §8.3. |
| REV-7 — ADR-013 numbering | **Pass** | §14 names **ADR-013** with full Context/Decision/Alternatives/Consequences/Supersedes/Approver/Reviewer. No number collision. |

---

## Tenancy Decision-State Check

Confirmed correct on all four required points:

- **Deferred / not locked** — §3.1 states exactly this.
- **Canonical source** — §3.1 cites `PROJECT_DECISION_INDEX.md` + ADR-008 marked deferred.
- **Not conflicting** — §3.1 includes an explicit wording rule: "do not call tenancy 'conflicting.'"
- **Not locked** — same wording rule forbids "locked."

Consequence is correctly carried (blocks Pod C schema/migration/`TenantContext` work and final ORM selection). §3.2 confirms the decision index is referenced as an existing Pod B-owned file and is **not** recreated. ✅

---

## Methodology / Governance Notes

| ID | Note | Impact |
|---|---|---|
| G-1 | **The already-committed Pod B snapshot does not yet meet v0.2's own §10 rules.** `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` (a) has no §10.2 snapshot header, and (b) still embeds full *Locked Technical Decisions*, *Not Yet Locked*, and *Confirmed Phase 1 Product Decisions (D-001…D-011)* tables, plus an "account for schema-per-tenant" presumption in responsibility #3 — all of which §10.3 forbids. This is the live instance of the drift the proposal exists to prevent. | **Medium.** Not blocking Kerem's decision. Schedule a PR-5 cleanup: add the §10.2 header, strip the embedded decision tables, and replace them with pointers to `PROJECT_DECISION_INDEX.md`. v0.2 §8.5 should add one line acknowledging this retrofit is owed. |
| G-2 | **§16.4's merge example pushes directly to `main`** (`git merge --no-ff` + `git push origin main`), which bypasses the PR merge and branch protection — mildly inconsistent with the "all changes through PRs / no direct commits to main" principle the same document upholds. | **Low–Medium.** Recommend changing the example to `gh pr merge --no-ff` (or the GitHub UI merge) so the merge goes through the PR. |
| G-3 | **The git-command rule (§16) must propagate** into `PROJECT_METHODOLOGY.md` and each pod instruction snapshot via the Instruction Update Packet, or only this proposal carries it and the other pods won't follow it. | **Low.** Routing note — fold into PR-5 snapshot updates. |
| G-4 | **Filename casing inconsistency:** `POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` (uppercase `.MD`) vs. the other snapshots' `.md`. On Linux/CI these are different paths. | **Trivial.** Normalize to `.md`. |
| G-5 | **Handoff Q3 answered:** `PROJECT_DECISION_INDEX.md` is correctly referenced as the existing Pod B-owned canonical instance and is not recreated (§3.2, §8.3). | Positive confirmation. |

---

## Risk Notes

| ID | Risk | Severity | Recommendation |
|---|---|---|---|
| R-1 | Embedded decision tables remain in the live Pod B snapshot, so a future decision change could again drift between the snapshot and the index — the exact failure that produced the tenancy conflict. | **Medium** | PR-5 cleanup per G-1. Until then, the snapshot's source-of-truth rule (which already points to the repo/index) contains the risk but does not remove it. |
| R-2 | If §16.4's direct-to-`main` merge example is followed literally, it sidesteps branch protection and the PR control plane. | **Low–Medium** | G-2: use `gh pr merge` / UI merge in the example. |
| R-3 | (Carryover, not a v0.2 defect) Tenancy deferral keeps Pod C schema/migration and ADR-004 (ORM) blocked; Phase 1 persistence cannot start. | **High (schedule)** | Unchanged. The narrow Phase-1 single-`adeks`-schema ADR remains available if Kerem wants to start build without revisiting tenancy. |

---

## Remaining Required Revisions

**None are blocking Kerem's decision.** Optional polish, foldable into the implementation PRs:

| ID | Required Revision | Owner |
|---|---|---|
| OPT-1 | Add a §8.5 line acknowledging the committed Pod B snapshot owes a §10-compliance retrofit (header + de-embed decision tables) in PR-5. (G-1) | Pod A |
| OPT-2 | Replace the §16.4 local-merge-to-`main` example with `gh pr merge --no-ff` / UI merge. (G-2) | Pod A |
| OPT-3 | Normalize pod-instruction filename extension casing to `.md`. (G-4) | Pod A |

---

## Kerem Decisions Ready?

| Decision | Ready? | Notes |
|---|---:|---|
| MD-2 — Approve methodology-consolidation direction | **Yes** | Direction sound; REV-1…REV-7 applied. Pod B recommends Approve. |
| MD-3 — Record as ADR-013 + methodology revision | **Yes** | Both, per OQ-002. |
| MD-4 — Decision-index ownership | **Yes** | Pod B sole owner; Pod A reviewer on product rows. |
| MD-5 — Workflow file disposition | **Yes** | Permanent stub + archive. |
| MD-6 — Pod Impact Matrix scope | **Yes** | Conditional gate only. |

---

## Git Command Requirement Check

**Correctly included and routed.** Kerem's rule appears as a guiding principle (§6) and a dedicated §16 covering branch/commit/push/PR/merge/delete/remove/move/archive/restore/fetch/pull/tag, with quality rules that are notably good — §16.2 includes "review-aware" (no merge commands when approval is missing) and "honest" (state which commands Pod C must confirm). One refinement (G-2): the §16.4 merge *example itself* should model the PR-based merge rather than a direct push to `main`. One routing item (G-3): the rule must land in `PROJECT_METHODOLOGY.md` and each snapshot, not only this proposal.

---

## Final Recommendation to Kerem

**Kerem can decide MD-2…MD-6 now.** v0.2 correctly applies all seven required revisions, represents tenancy as deferred / not locked, references the existing decision index without recreating it, and incorporates the git-command requirement. Pod A does **not** need to revise before the decision.

After Kerem records MD-2…MD-6, three Pod B-owned items queue up — draft **ADR-013** (methodology consolidation), draft **ADR-009** (PR approval policy, absorbing workflow §14), and the **PR-5 Pod B snapshot §10-compliance cleanup** (G-1) — and Pod A produces the repo-ready plan for Pod C PR sequencing. The optional polish items OPT-1…OPT-3 fold into the implementation PRs.
