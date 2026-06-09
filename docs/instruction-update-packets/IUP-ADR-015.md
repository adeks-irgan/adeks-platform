# Instruction Update Packet — ADR-015 Authentication Strategy (Phase 1)

## Trigger

ADR-015 records the Phase 1 authentication strategy as a durable, Accepted ADR. The
underlying decisions (KD-A through KD-H) were locked by Kerem on 2026-06-09 as K-13
(PR #37); this packet accompanies the ADR that gives those decisions their authoritative
ADR home and adds an `Authentication strategy` row to the decision index §1.

## Source PR / Issue

- PR: ADR-015 PR (this PR)
- Issue: OQ-001 resolution lineage (PR #37 / K-13)

## Canonical Files Changed

| File | Change |
|---|---|
| `docs/adr/ADR-015-authentication-strategy.md` | New ADR — `Accepted` 2026-06-09 |
| `docs/PROJECT_DECISION_INDEX.md` | §1 Authentication strategy row added (Locked → ADR-015); §3 ADR-015 backlog row Backlog → Accepted; Last-updated line |
| `docs/instruction-update-packets/IUP-ADR-015.md` | This packet (new) |

## Behavior Impact

| Question | Answer |
|---|---|
| Does this change pod responsibilities? | No |
| Does this change required context loading? | No |
| Does this change review or approval triggers? | No |
| Does this change locked, deferred, or not-yet-locked decisions? | Yes — authentication strategy moves to a Locked ADR (ADR-015 Accepted). Decision content already locked via K-13. |
| Does this change output format? | No |
| Does this change handoff routing? | No |

## Affected Pods

| Pod | Affected? | Required Update |
|---|---:|---|
| Pod A | Yes | `CORE_USER_FLOWS.md` must reflect: Aydınlatma Metni acknowledged before OTP is sent; cashier sees masked phone (last 4 digits) in top-up flow. Action RR-001/RR-002 reconciliation. No role-doc change (v0.2 aligned). |
| Pod B | Yes | Produce authentication threat model (security view) before any Pod C auth unblock; draft auth implementation issues post-approval. |
| Pod C | Yes (primary) | Implementation target. Remains blocked until ADR Accepted (done) + threat model reviewed + separate Pod B + Kerem approved issues exist. Must honor all §Consequences security/KVKK requirements. |
| Pod D | Yes (later) | Audit/monitor login, OTP rate-limiting, and admin MFA flows once implemented; verify no phone number appears in logs. |

## External Platform Updates Required

| Platform | Instruction File | Action |
|---|---|---|
| ChatGPT Project | `/docs/pod-instructions/POD_A_CHATGPT_INSTRUCTIONS.md` | No change |
| Claude Project | `/docs/pod-instructions/POD_B_CLAUDE_PROJECT_INSTRUCTIONS.md` | No change |
| Claude Code | `/CLAUDE.md` | No change |
| Gemini Gem | `/docs/pod-instructions/POD_D_GEMINI_GEM_INSTRUCTIONS.md` | No change |

Pod instruction snapshots are reference-only bootloaders (ADR-013 §5) and carry no decision
state. The ADR plus the decision index are authoritative. No external re-paste is required
for this change.

## Ready-to-Paste Update Text

### Pod A
No instruction-text change. Follow-up is a `CORE_USER_FLOWS.md` content task (see Affected Pods).

### Pod B
No instruction-text change. Next deliverable: authentication threat model for ADR-015.

### Pod D
No instruction-text change. Monitoring/audit follow-up once auth is implemented.

## Verification Checklist

- [x] `PROJECT_DECISION_INDEX.md` updated (§1 row added; §3 ADR-015 → Accepted)
- [ ] `PROJECT_METHODOLOGY.md` updated if methodology changed (n/a — no methodology change)
- [ ] `AGENT_CONTEXT_MANIFEST.md` updated if required context changed (n/a)
- [ ] Relevant templates updated if output format changed (n/a)
- [ ] Pod instruction snapshots updated if pod behavior changed (n/a — reference-only)
- [ ] External platform text re-pasted from repo snapshot (n/a)
- [x] Pod B reviewed architecture/risk/process impact
- [ ] Kerem approved behavior-changing process update (recorded on PR merge)
