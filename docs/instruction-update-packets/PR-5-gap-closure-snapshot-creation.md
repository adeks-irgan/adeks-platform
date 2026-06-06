# Instruction Update Packet — PR-5 Gap Closure: Pod A & Pod D Snapshot Creation

## Trigger

PR-5 (`PR-5-pod-instruction-normalization.md`) explicitly deferred two snapshot files as a tracked gap:

- `POD_A_CHATGPT_INSTRUCTIONS.md` — logged as "Pod-A-owned follow-up"
- `POD_D_GEMINI_GEM_INSTRUCTIONS.md` — logged as "Kerem-assigned owner"

Both files were created and merged in PR #23 (`docs/pod-instruction-snapshots-pr5`, merged 2026-06-06). This packet closes that tracked gap, records the Pod Impact Matrix, and notes the governance sign-off for the authorship question raised by PR-5.

## Source PR / Issue

- Snapshot files: PR #23 (`docs/pod-instruction-snapshots-pr5`, merged 2026-06-06)
- Gap originally raised: `PR-5-pod-instruction-normalization.md` § Tracked Gap
- Gap-closure governance PR: this document (merged in `docs/pr5-gap-closure-snapshot-governance`)

## Canonical Files Changed

| File | Change |
|---|---|
| `/docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md` | **New** — Reference-only bootloader for Pod A (ChatGPT Project). Conforms to ADR-013 §5: role, role boundaries, source-of-truth, context-loading, output style, stop conditions, Snapshot Maintenance, Pointer Map. No volatile state. |
| `/docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md` | **New** — Reference-only bootloader for Pod D (Gemini Gem). Same structural compliance. `SYNC BASIS` header confirms text was normalized from the live Gem instruction text supplied by Kerem 2026-06-06. |
| `/docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md` | **Amended (this PR)** — `SYNC BASIS:` line added to header comment for parity with Pod D file. |
| `/docs/instruction-update-packets/PR-5-pod-instruction-normalization.md` | **Amended (this PR)** — Tracked Gap section marked resolved. |
| `/docs/AGENT_CONTEXT_MANIFEST.md` | **Amended (this PR)** — Methodology-change row: pod-instruction snapshot status updated from `planned`/`missing` to `exists` for Pod A and Pod D files. |

## Behavior Impact

| Question | Answer |
|---|---|
| Does this change pod responsibilities? | No |
| Does this change required context loading? | No — snapshots were already referenced as required; only their existence status changed |
| Does this change review or approval triggers? | No |
| Does this change locked, deferred, or not-yet-locked decisions? | No |
| Does this change output format? | No |
| Does this change handoff routing? | No |

## Authorship Governance Note

PR-5 noted that the Pod D snapshot was authored by Pod A, whereas PR-5 had designated the Pod D owner as "Kerem-assigned." The content is a pure reference-only bootloader normalized from the live Gem text supplied by Kerem on 2026-06-06 (no fabricated state). This packet records that **Kerem signed off on Pod A acting as Pod D snapshot author for this one-time normalization**, consistent with the methodology-change sign-off requirement (ADR-013 §7). Future Pod D snapshot updates follow the standard PR + Instruction Update Packet path with Pod B + Kerem sign-off.

## Affected Pods

| Pod | Affected? | Required Update |
|---|---:|---|
| Pod A | Yes | Re-paste `POD_A_CHATGPT_INSTRUCTIONS.md` into ChatGPT Project (Kerem action). Update `LAST SYNCED TO PLATFORM` after paste. |
| Pod B | No | No snapshot or behavior change for Pod B in this PR. |
| Pod C | No | `CLAUDE.md` is repo-committed; no external paste. |
| Pod D | Yes | Re-paste `POD_D_GEMINI_GEM_INSTRUCTIONS.md` into Gemini Gem (Kerem action). Update `LAST SYNCED TO PLATFORM` after paste. |

## External Platform Updates Required

| Platform | Instruction File | Action |
|---|---|---|
| ChatGPT Project | `/docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md` | **Replace in full** — paste from repo snapshot. Then update `LAST SYNCED TO PLATFORM`. |
| Claude Project | `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` | No change in this PR. |
| Claude Code | `/CLAUDE.md` | No change in this PR. |
| Gemini Gem | `/docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md` | **Replace in full** — paste from repo snapshot. Then update `LAST SYNCED TO PLATFORM`. |

## Verification Checklist

- [x] `PROJECT_METHODOLOGY.md` updated if methodology changed — **N/A** (no methodology change)
- [x] `AGENT_CONTEXT_MANIFEST.md` updated — **YES** (pod-instruction snapshot status `planned`/`missing` → `exists` for Pod A and Pod D)
- [x] `PROJECT_DECISION_INDEX.md` updated if decision state changed — **N/A** (no decision state change)
- [x] Relevant templates updated if output format changed — **N/A**
- [x] Pod instruction snapshots updated — **done** (Pod A + Pod D created in PR #23)
- [x] External platform text re-pasted from repo snapshot — **Pod A + Pod D = pending Kerem paste (steps 1 & 2 from original recommendation)**
- [x] `LAST SYNCED TO PLATFORM` header — **to be updated by Kerem after live paste**
- [x] Manifest validated against repo tree — **done in this PR**
- [x] PR-5 tracked gap resolved — **done in this PR**
- [x] Authorship governance note recorded — **done above**
- [x] Pod B + Kerem sign-off on methodology/process aspect — **Kerem sign-off via this PR approval**

## PR-5 Tracked Gap — Status

| Item | Status |
|---|---|
| `POD_A_CHATGPT_INSTRUCTIONS.md` creation | **Resolved** — merged PR #23, 2026-06-06 |
| `POD_D_GEMINI_GEM_INSTRUCTIONS.md` creation | **Resolved** — merged PR #23, 2026-06-06 |
| Pod D authorship governance sign-off | **Resolved** — Kerem sign-off recorded in this packet |
| Manifest status update | **Resolved** — done in this PR |
| PR-5 packet tracked-gap annotation | **Resolved** — done in this PR |
