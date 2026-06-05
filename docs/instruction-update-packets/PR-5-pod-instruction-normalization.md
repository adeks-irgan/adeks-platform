# Instruction Update Packet — PR-5: Normalize Pod Instruction Snapshots

## Trigger

ADR-013 §5 (Accepted) requires pod instruction snapshots to be reference-only bootloaders that do not embed volatile state (locked-decision tables, open-question lists, ADR status/counts, sprint/blocker status, duplicated methodology). PR-5 enforces this on the existing snapshots.

## Source PR / Issue

- PR: PR-5 (ADR-013 implementation sequence, final step)
- Issue: _(link the tracking issue if one exists)_

## Canonical Files Changed

| File | Change |
|---|---|
| `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` | Stripped LOCKED TECHNICAL DECISIONS, NOT YET LOCKED, and CONFIRMED PHASE 1 PRODUCT DECISIONS tables → pointers to `PROJECT_DECISION_INDEX.md`. Reduced duplicated methodology (PROJECT PHASES, LOCKED PRINCIPLES, AI POD STRUCTURE, HANDOFF PROMPTS) → pointers to `PROJECT_METHODOLOGY.md`. Reduced PROJECT CONTEXT/Selcafe detail → pointer to `PROJECT_BRIEF.md`. Added snapshot header with `LAST SYNCED TO PLATFORM`, explicit Context-Loading rule (→ `AGENT_CONTEXT_MANIFEST.md`), Stop Conditions, Snapshot Maintenance, and a Pointer Map. Retained: role, role boundaries, source-of-truth, output rules. |
| `/CLAUDE.md` | §7 Locked Technical Decisions table stripped → pointer to `PROJECT_DECISION_INDEX.md` §1 + `AGENT_CONTEXT_MANIFEST.md`; retained the two unique guardrails (no microservices; Selcafe not core domain). §8 Not Yet Decided list stripped → pointer to `PROJECT_DECISION_INDEX.md` §2 + retained stop-and-flag behavior. §1–6 and §9–18 unchanged; section numbering preserved. |

## Behavior Impact

| Question | Answer |
|---|---|
| Does this change pod responsibilities? | No (responsibilities unchanged; only their source location) |
| Does this change required context loading? | Yes (snapshots now route to the manifest/index instead of carrying inline state) |
| Does this change review or approval triggers? | No |
| Does this change locked, deferred, or not-yet-locked decisions? | No (decision *state* unchanged; only where it is recorded) |
| Does this change output format? | No |
| Does this change handoff routing? | No |

## Affected Pods

| Pod | Affected? | Required Update |
|---|---:|---|
| Pod A | Yes | Custodian follow-up: author/normalize the **missing** `POD_A_CHATGPT_INSTRUCTIONS.md` (and resolve ownership of `POD_D_GEMINI_GEM_INSTRUCTIONS.md`); confirm manifest/template references resolve. Not done in PR-5. |
| Pod B | Yes | After merge, re-paste the normalized Pod B snapshot into the Claude Project; update `LAST SYNCED TO PLATFORM`. |
| Pod C | Yes | `CLAUDE.md` is committed/loaded from repo — no external paste; the merged file is the source. |
| Pod D | Yes | Gemini Gem snapshot is missing; needs creation under a Kerem-assigned owner. Not done in PR-5. |

## External Platform Updates Required

| Platform | Instruction File | Action |
|---|---|---|
| ChatGPT Project | `/docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md` | **N/A in PR-5 — file absent.** Deferred to Pod-A-owned follow-up. |
| Claude Project | `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` | **Replace** — re-paste from merged snapshot (re-paste = YES) |
| Claude Code | `/CLAUDE.md` | Commit update (no external paste) |
| Gemini Gem | `/docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md` | **N/A in PR-5 — file absent.** Deferred to follow-up. |

## Ready-to-Paste Update Text

### Pod A

No change in PR-5. Pod A snapshot does not yet exist in the repo; creation is a separate Pod-A-owned action (see Affected Pods).

### Pod B

Re-paste the full contents of `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` (as merged) into the Claude Project instructions, replacing the current text in full. Then set `LAST SYNCED TO PLATFORM` to the paste date.

### Pod D

No change in PR-5. Pod D snapshot does not yet exist in the repo; creation requires a Kerem-assigned owner (see Affected Pods).

## Verification Checklist

- [ ] `PROJECT_METHODOLOGY.md` updated if methodology changed — **N/A** (no methodology change; only pointers)
- [ ] `AGENT_CONTEXT_MANIFEST.md` updated if required context changed — **review**: confirm it lists pod-instruction snapshots correctly
- [ ] `PROJECT_DECISION_INDEX.md` updated if decision state changed — **N/A** (state unchanged)
- [ ] Relevant templates updated if output format changed — **N/A**
- [ ] Pod instruction snapshots updated if pod behavior changed — **done** (Pod B + CLAUDE.md)
- [ ] Updated repo snapshot merged
- [ ] External platform text re-pasted from repo snapshot — **Pod B = YES; Pod A/D = pending file creation**
- [ ] `LAST SYNCED TO PLATFORM` header updated (Pod B)
- [ ] Manifest validated against repo tree
- [ ] External platform paste text included if needed — **yes (Pod B above)**
- [ ] Pod B reviewed architecture/risk/process impact — **done (this PR is Pod B work)**
- [ ] Kerem approved behavior-changing process update — **YES (Kerem, this session)**

## Tracked Gap (raised by PR-5)

`/docs/pod-instructions/` contains only the Pod B snapshot. `POD_A_CHATGPT_INSTRUCTIONS.md` and `POD_D_GEMINI_GEM_INSTRUCTIONS.md` — referenced by ADR-013 §5, the ADR-013 Implementation table, and this template's External Platform table — do not exist. PR-5 deliberately does not fabricate them. Follow-up: Pod A authors the Pod A snapshot (custodian per ADR-013); Kerem assigns the Pod D snapshot owner.
