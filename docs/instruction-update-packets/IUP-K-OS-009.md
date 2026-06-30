# Instruction Update Packet — K-OS-009 Customer Session-Linking via QR Handshake

## Trigger

K-OS-009 records the Phase 1 customer-facing app session-linking path as a desk-side, one-time
QR handshake (SL-1…SL-7). The decision was locked by Kerem on 2026-06-30 in `KEREM_DECISIONS.md`
§21 (PR #122). This packet accompanies the decision-index mirror update (PR #123) that adds the
K-OS-009 row, corrects the stale K-OS-008 mechanism wording, and annotates K-21 — satisfying the
ADR-009 §4 behavior-change gate for the K-OS-009 decision-state change.

## Source PR / Issue

- PR: #123 (decision-index + v0.3 reconciliation). Lineage: design #119; product reconciliation #120; decision locked #122.
- Issue: K-OS-009 / `SESSION_LINKING_QR_HANDSHAKE_DESIGN_v0.1.md`

## Canonical Files Changed

| File | Change |
|---|---|
| `docs/KEREM_DECISIONS.md` | K-OS-009 added; K-21/K-OS-008 reconciled (PR #122, merged) |
| `docs/PROJECT_DECISION_INDEX.md` | K-OS-009 row added; K-OS-008 mechanism corrected; K-21 annotated; Last-updated line (PR #123) |
| `docs/SELCAFE_READ_SURFACE_RECONCILIATION_v0.3.md` | FINDING A / SR-003-5 forward-status notes (PR #123) |
| `docs/CORE_USER_FLOWS.md`, `docs/BUSINESS_RULES.md`, `docs/MVP_SCOPE.md` | Product flow reconciled to the QR handshake (PR #120, merged) |
| `docs/instruction-update-packets/IUP-K-OS-009.md` | This packet (new) |

## Behavior Impact

| Question | Answer |
|---|---|
| Does this change pod responsibilities? | No |
| Does this change required context loading? | No |
| Does this change review or approval triggers? | No |
| Does this change locked, deferred, or not-yet-locked decisions? | Yes — K-OS-009 locks the customer session-linking path (desk-side QR handshake); supersedes the `fiş`-as-visit-link framing of K-21 and amends the addition-only framing of K-OS-001. Decision content locked via PR #122. |
| Does this change output format? | No |
| Does this change handoff routing? | No |

## Affected Pods

| Pod | Affected? | Required Update |
|---|---:|---|
| Pod A | Yes | Reconcile product/context docs to K-OS-009: `PROJECT_BRIEF.md`, `USER_ROLES_AND_PERMISSIONS.md`, `ADEKS_DISCOUNT_REFLECTION_RECORD_SPEC_v0.1.md` (incl. the agreed `ADEKS INDIRIM` ASCII label + "read by the QR-linked session" wording), superseded-pointers on `SCOPE_RECONCILIATION_OPERATING_SPINE_ALIGNMENT_v0.1.md` and `OPERATING_SLICE_DISCOVERY_v0.1.md`, `OPEN_QUESTIONS.md` note, `AGENT_CONTEXT_MANIFEST.md` entry. Separate Pod A handoff. |
| Pod B | Yes | Design doc (#119), decision-log (#122), decision-index mirror + v0.3 notes (#123) — done / in this PR. |
| Pod C | No | No implementation authorized; the live-bill read and any session-linking build remain gated on KVKK/legal, ADR-005 read-surface expansion, and the Operating Slice Checkpoint. |
| Pod D | Yes (later) | Audit/monitor desk QR-issuance and scan flow (token single-use, seconds TTL, burn-on-first-scan) once implemented and behind read/legal clearance. |

## External Platform Updates Required

| Platform | Instruction File | Action |
|---|---|---|
| ChatGPT Project | `/docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md` | No change |
| Claude Project | `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.md` | No change |
| Claude Code | `/CLAUDE.md` | No change |
| Gemini Gem | `/docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md` | No change |

Pod instruction snapshots are reference-only bootloaders (ADR-013 §5) and carry no decision
state. `KEREM_DECISIONS.md` K-OS-009 plus the decision index are authoritative. No external
re-paste is required for this change.

## Ready-to-Paste Update Text

### Pod A
No instruction-text change. Follow-up is a product/context-doc reconciliation task (see Affected Pods).

### Pod B
No instruction-text change.

### Pod D
No instruction-text change. Follow-up is a later audit/monitoring task once session-linking is implemented.

## Verification Checklist

- [ ] `PROJECT_METHODOLOGY.md` updated if methodology changed — N/A
- [ ] `AGENT_CONTEXT_MANIFEST.md` updated if required context changed — Pod A follow-up (register the QR design doc)
- [x] `PROJECT_DECISION_INDEX.md` updated if decision state changed — K-OS-009 row added (this PR)
- [ ] Relevant templates updated if output format changed — N/A
- [ ] Pod instruction snapshots updated if pod behavior changed — N/A (reference-only, ADR-013 §5)
- [ ] Updated repo snapshot merged — pending Kerem merge of #123
- [ ] External platform text re-pasted from repo snapshot — N/A
- [ ] `LAST SYNCED TO PLATFORM` header updated — N/A
- [ ] Manifest validated against repo tree — Pod A follow-up
- [ ] External platform paste text included if needed — N/A
- [x] Pod B reviewed architecture/risk/process impact — Pod B authored
- [ ] Kerem approved behavior-changing process update — pending Kerem merge of #123
