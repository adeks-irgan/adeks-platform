# Instruction Update Packet — ROLLBACK_POLICY.md (K-03)

## Trigger

Creation of `/docs/ROLLBACK_POLICY.md` formalises rollback authority, incident
severity classification, decision flow, pod operational responsibilities, and
post-rollback record requirements. Previously, rollback policy was only implied
by `PROJECT_METHODOLOGY.md` §12.4 and the K-03 Kerem decision record; no
standalone authoritative policy file existed.

## Source PR / Issue

- PR: `docs/rollback-policy` → `main`
- Issue: N/A — directed by K-03 (`KEREM_DECISIONS.md` §3) and
  `PROJECT_METHODOLOGY.md` §12.4

## Canonical Files Changed

| File | Change |
|---|---|
| `/docs/ROLLBACK_POLICY.md` | New file — rollback policy (K-03 authoritative home) |
| `/docs/instruction-update-packets/IUP-rollback-policy.md` | New file — this document |

## Behavior Impact

| Question | Answer | Notes |
|---|---|---|
| Does this change pod responsibilities? | **Yes** | Pod B: T-1/T-2 call authority formally recorded. Pod C: rollback execution authority formally assigned. Pod D: monitoring-and-recommend role in rollback scenarios formally documented. |
| Does this change required context loading? | **Potentially** | `ROLLBACK_POLICY.md` may need to be added to `AGENT_CONTEXT_MANIFEST.md` for incident task types. Deferred — see FU-7. |
| Does this change review or approval gates? | No | Compensating transaction approval requirement is consistent with existing §11.1 (Kerem + Pod B for wallet/loyalty ledger class); no new gates introduced. |
| Does this change locked, deferred, or not-yet-locked decisions? | No | K-03 status is unchanged; no ADR status changes. |
| Does this change output format? | No | — |
| Does this change handoff routing? | No | — |

## Affected Pods

| Pod | Affected? | Required Update |
|---|---|---|
| Pod A | No | No instruction update required. Pod A has no role in the rollback flow. |
| Pod B | **Yes** — T-1/T-2 call authority formalised | No snapshot update now. `POD_B_CLAUDE_PROJECT_INSTRUCTIONS.md` is a reference-only bootloader (ADR-013 §5); it deliberately does not embed operational policy. The repo file is authoritative. |
| Pod C | **Yes** — rollback execution authority formalised | No `CLAUDE.md` update now. The execution method is [NEEDS KEREM APPROVAL] (FU-4, below). Review `CLAUDE.md` after FU-4 is resolved to add the specific execution procedure. |
| Pod D | **Yes** — recommend role formalised | No snapshot update needed. Pod D's existing monitoring mandate already encompasses this responsibility; no new instruction text is required. |

## External Platform Updates Required

| Platform | Instruction File | Action |
|---|---|---|
| ChatGPT Project | `/docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md` | No change |
| Claude Project | `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.md` | No change |
| Claude Code | `/CLAUDE.md` | No change now — review after FU-4 resolved |
| Gemini Gem | `/docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md` | No change |

## Ready-to-Paste Update Text

No immediate platform instruction updates required. All pods reference
`ROLLBACK_POLICY.md` from the repo via task-type context loading
(per `AGENT_CONTEXT_MANIFEST.md`) once FU-7 is addressed.

## Open Follow-Up Items from [NEEDS KEREM APPROVAL] Markers

| ID | Item | Priority |
|---|---|---|
| FU-1 | **T-2 KVKK response chain** — confirm Kerem directly contacts the legal advisor on T-2 confirmation, or designate an alternative responsible party if Kerem is unreachable at the moment of confirmation | Go-live blocker |
| FU-2 | **SEV-1/SEV-2 notification channel** — does K-06 WhatsApp cover rollback-class incidents, or is direct phone contact required for SEV-1? | High |
| FU-3 | **Out-of-hours escalation path** — who handles incident detection and Kerem notification outside café operating hours; what is the escalation path if Kerem is unreachable for an extended period during a SEV-1 event? | High |
| FU-4 | **Rollback execution method** — how is a Phase 1 application rollback executed in practice? (Naturally resolves when the hosting/deployment model is decided and locked.) | Deferred — follow deployment model decision |
| FU-5 | **Post-rollback record format** — confirm GitHub Issue as the required format, or specify an alternative | High |
| FU-6 | **Maximum discretionary downtime threshold** — define the cumulative downtime figure that informs a SEV-2/SEV-3 rollback deliberation (currently open in `PROJECT_METHODOLOGY.md` §12.4) | Medium |
| FU-7 | **`AGENT_CONTEXT_MANIFEST.md` review** — assess whether `ROLLBACK_POLICY.md` should be added for incident task types; Pod B to action in next manifest review PR | Pod B follow-up |

When Kerem resolves FU-1 through FU-6, each resolved item must be recorded
as a K-level decision in `KEREM_DECISIONS.md` and the corresponding
[NEEDS KEREM APPROVAL] marker in `ROLLBACK_POLICY.md` replaced with the
decided value via a follow-up PR.

## Verification Checklist

- [x] `PROJECT_METHODOLOGY.md` updated if methodology changed →
      N/A — §12.4 already directed this file; no methodology change required
- [ ] `AGENT_CONTEXT_MANIFEST.md` updated if required context changed →
      **Deferred** — FU-7; out of scope for this PR
- [x] `PROJECT_DECISION_INDEX.md` updated if decision state changed →
      N/A — no decision state changes in this PR
- [x] Relevant templates updated if output format changed → N/A
- [x] Pod instruction snapshots updated if pod behavior changed →
      No updates required now (see Affected Pods above)
- [x] Updated repo snapshot merged → N/A (no snapshot updates)
- [x] External platform text re-pasted from repo snapshot → N/A
- [x] `LAST SYNCED TO PLATFORM` header updated → N/A
- [ ] Manifest validated against repo tree → Deferred — FU-7
- [x] External platform paste text included if needed → N/A
- [x] Pod B reviewed architecture/risk/process impact →
      ✅ Pod B authored and reviewed this packet
- [ ] Kerem approved behavior-changing process update →
      **Pending — required before merge (ADR-009 §4 + §5)**
