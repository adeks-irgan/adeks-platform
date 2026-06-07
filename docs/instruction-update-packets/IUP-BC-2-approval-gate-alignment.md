# INSTRUCTION_UPDATE_PACKET — BC-2 Option A

<!--
  PACKET TYPE: Instruction Update Packet (ADR-009 §4 / ADR-013 §7)
  PR: bc-2/approval-gate-alignment → main
  ISSUE: #26
  DATE: 2026-06-07
  AUTHOR: Pod B — Architecture, Logic & Risk
  APPROVED BY: Kerem (BC-2 Option A, 2026-06-07)
-->

---

## 1. Summary of Changes

This PR corrects two methodology sections whose approval gates are weaker than
ADR-009 §3 (authoritative, Accepted 2026-06-05). It is behavior-changing under
ADR-009 §4 because it alters mandatory human approval triggers.

| File | Change |
|---|---|
| `docs/PROJECT_METHODOLOGY.md` §11.1 | Selcafe adapter row → `Pod B + Kerem`; DB/schema migration row → `Pod B + Kerem`; security-sensitive PR row added (`Pod B + Kerem`); authority annotation added |
| `docs/PROJECT_METHODOLOGY.md` §15 | Stale embedded PR template block removed; replaced with pointer to live `.github/PULL_REQUEST_TEMPLATE.md` and ADR-009 |
| `docs/PROJECT_METHODOLOGY.md` §28.3 | Revision log v0.6 entry added |
| `docs/PROJECT_METHODOLOGY.md` §28.5 | BC-2 Kerem decisions section added |
| `docs/KEREM_DECISIONS.md` | K-11 entry added recording BC-2 Option A approval |
| `docs/instruction-update-packets/IUP-BC-2-approval-gate-alignment.md` | This file |

---

## 2. Pod Impact Matrix

| Pod | Impacted? | Reason | Required Follow-Up |
|---|---|---|---|
| Pod A | Yes | §15 change — must not re-embed PR template copies in methodology documents in future drafts | Pod A to note in working practice; re-paste snapshot if platform instruction exists |
| Pod B | Yes | §11.1 now explicitly locks security-sensitive, Selcafe, and migration to Pod B + Kerem; Pod B snapshot `LAST SYNCED` date must be updated | Re-paste `POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` into Claude Project after merge; update `LAST SYNCED TO PLATFORM` to merge date |
| Pod C | Yes | §11.1 Selcafe adapter and DB/schema migration rows now require `Pod B + Kerem` (not `Pod B` only); Pod C must not merge these categories without Kerem approval | Pod C instruction snapshot must be updated before next Selcafe adapter or migration PR |
| Pod D | No | Audit/monitoring scope unaffected | None |

---

## 3. Instruction Snapshot Updates Required

| Snapshot | Repo Location | Update Required | Platform Re-paste Required? |
|---|---|---|---|
| `POD_B_CLAUDE_PROJECT_INSTRUCTIONS.MD` | `/docs/pod-instructions/` | Update `LAST SYNCED TO PLATFORM` date to merge date | **Yes** — re-paste into Claude Project after merge |
| Pod C instruction snapshot | `/docs/pod-instructions/` (if exists) | Add explicit note: Selcafe adapter and DB/schema migration PRs require `Pod B + Kerem` before merge | Yes if Pod C uses a live platform instruction |
| Pod A instruction snapshot | `/docs/pod-instructions/` (if exists) | Add note: do not embed PR template copies in methodology documents | Yes if Pod A uses a live platform instruction |

---

## 4. Decision Index Update

After merge, add or update the following row in `docs/PROJECT_DECISION_INDEX.md`:

- **Decision:** BC-2 approval gate alignment (ADR-009 §3 vs §11.1/§15)
- **Status:** Locked (Kerem-approved 2026-06-07)
- **Authority:** `KEREM_DECISIONS.md` K-11; `ADR-009` §3

---

## 5. Post-Merge Verification Checklist

- [ ] §11.1 Selcafe adapter or Selcafe integration changes row reads `Pod B + Kerem`
- [ ] §11.1 Database / schema migration row reads `Pod B + Kerem`
- [ ] §11.1 Security-sensitive PR row present with `Pod B + Kerem`
- [ ] §11.1 authority annotation present (references ADR-009 §3)
- [ ] §15 contains no fenced PR template block
- [ ] §15 contains pointer to live `.github/PULL_REQUEST_TEMPLATE.md` and ADR-009
- [ ] §28.3 revision log shows v0.6
- [ ] §28.5 BC-2 Kerem Decisions section present
- [ ] K-11 recorded in `KEREM_DECISIONS.md`
- [ ] Pod B snapshot `LAST SYNCED TO PLATFORM` date updated after merge
- [ ] `PROJECT_DECISION_INDEX.md` BC-2/K-11 row updated after merge
