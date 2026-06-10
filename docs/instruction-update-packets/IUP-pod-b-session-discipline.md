# Instruction Update Packet — Pod B Session & Model Discipline

## Trigger

Integration of the agreed Pod B Session & Model Discipline methodology into the canonical Pod B instruction snapshot (ADR-013 §5 bootloader file).

## Source PR / Issue

- PR: (this PR)
- Issue: —

## Canonical Files Changed

| File | Change |
|---|---|
| `docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.md` | `## Handoff Prompts` replaced by `## Session & Model Discipline` (§1–4); write failure bullet added to `## GitHub Access & Write Authority` |

## Behavior Impact

| Question | Answer |
|---|---|
| Does this change pod responsibilities? | No |
| Does this change required context loading? | No |
| Does this change review or approval triggers? | No |
| Does this change locked, deferred, or not-yet-locked decisions? | No |
| Does this change output format? | No — handoff format was already required; taxonomy is now explicit |
| Does this change handoff routing? | Yes — four typed handoffs (Git / Cont / Kerem / Pod) replace generic "produce handoff prompts" instruction; model/effort/thinking selection table added |

## Affected Pods

| Pod | Affected? | Required Update |
|---|---:|---|
| Pod A | No | — |
| Pod B | Yes | Re-paste `POD_B_CLAUDE_PROJECT_INSTRUCTIONS.md` to Claude Project after merge |
| Pod C | No | — |
| Pod D | No | — |

## External Platform Updates Required

| Platform | Instruction File | Action |
|---|---|---|
| ChatGPT Project | `/docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md` | No change |
| Claude Project | `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.md` | **Replace** — re-paste after merge |
| Claude Code | `/CLAUDE.md` | No change |
| Gemini Gem | `/docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md` | No change |

## Ready-to-Paste Update Text

### Pod A

No update required.

### Pod B

Replace the full Claude Project instruction text with the content of
`docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.md` at the merged commit,
then update `LAST SYNCED TO PLATFORM` in the file header to today's date.

### Pod D

No update required.

## Verification Checklist

- [ ] `PROJECT_METHODOLOGY.md` updated if methodology changed — N/A (Pod B internal instruction; PROJECT_METHODOLOGY.md unchanged)
- [ ] `AGENT_CONTEXT_MANIFEST.md` updated if required context changed — N/A
- [ ] `PROJECT_DECISION_INDEX.md` updated if decision state changed — N/A
- [ ] Relevant templates updated if output format changed — N/A
- [ ] Pod instruction snapshots updated if pod behavior changed — this PR is the update
- [ ] Updated repo snapshot merged — pending this merge
- [ ] External platform text re-pasted from repo snapshot — pending Kerem re-paste
- [ ] `LAST SYNCED TO PLATFORM` header updated — Kerem updates on re-paste
- [ ] Manifest validated against repo tree — N/A (no manifest change)
- [ ] External platform paste text included if needed — see Ready-to-Paste section above
- [ ] Pod B reviewed architecture/risk/process impact — Pod B authored this change
- [ ] Kerem approved behavior-changing process update — [KEREM APPROVED 2026-06-10]
