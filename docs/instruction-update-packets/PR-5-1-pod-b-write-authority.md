# Instruction Update Packet — PR-5.1: Pod B Snapshot Write-Authority Reconciliation

## Trigger

Post-merge reconciliation of PR-5. Diffing the live Claude Project instructions against the merged Pod B snapshot surfaced a contradiction in the git-access wording ("read-only unless authorized" vs. an absolute "do not push, branch, or commit"). PR-5.1 replaces both with one coherent rule and makes the never-self-merge boundary explicit. Behavior-clarifying only.

## Source PR / Issue

- PR: PR-5.1 (follow-up to PR-5; ADR-013 sequence)
- Issue: _(link if one exists)_

## Files Changed

| File | Change |
|---|---|
| `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` | New **GitHub Access & Write Authority** section: read-only by default; writes only on explicit per-session authorization; branches/commits/PRs allowed when authorized; **never self-merge** (Kerem sole merge authority, ADR-013); PowerShell fallback when unauthorized; no settings/branch-protection/force-push changes. One-line Source-of-Truth tweak allowing repo reads when access is available. No other content changed from the PR-5 version. |

## Behavior Impact

| Question | Answer |
|---|---|
| Pod responsibilities? | No |
| Required context loading? | No |
| Review / approval triggers? | No |
| Locked / deferred / not-yet-locked decisions? | No |
| Output format? | No |
| Handoff routing? | No |
| Git/write behavior? | **Clarified** — aligns the snapshot with the control plane (ADR-013) and with actual PR-5 session behavior |

## Affected Pods

| Pod | Affected? | Required Update |
|---|---:|---|
| Pod A | No | — |
| Pod B | Yes | Re-paste the v2 snapshot into the Claude Project; `LAST SYNCED TO PLATFORM` = paste date |
| Pod C | No | — |
| Pod D | No | — |

## External Platform Updates Required

| Platform | Instruction File | Action |
|---|---|---|
| Claude Project | `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` | **Replace** — re-paste from merged snapshot (re-paste = YES) |

## Verification Checklist

- [ ] Updated repo snapshot merged
- [ ] Pod B snapshot re-pasted into the Claude Project from the merged file
- [ ] `LAST SYNCED TO PLATFORM` set to paste date
- [ ] Kerem approved (this session)

## Notes

No decision-state or methodology change → `PROJECT_DECISION_INDEX.md` and `PROJECT_METHODOLOGY.md` untouched. Scoped as a lightweight self-correction; carried as a short packet for a clean audit trail at Kerem's request.
