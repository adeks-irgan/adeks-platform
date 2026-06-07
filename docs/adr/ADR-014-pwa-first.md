# ADR-014: PWA-First Customer Application

<!--
  STATUS: Proposed (ADR stub — decision direction locked, full ADR to be written)
  AUTHOR: Pod B — Architecture, Logic & Risk
  CREATED: 2026-06-07
  CANONICAL REPO PATH: /docs/adr/ADR-014-pwa-first.md
  RELATED:
    - /docs/PROJECT_DECISION_INDEX.md (status: Locked)
    - /docs/PROJECT_METHODOLOGY.md (§19 ADR backlog)
    - /docs/PROJECT_BRIEF.md (customer app context)
-->

---

## Status

Proposed — decision direction **Locked** (PWA-first), ADR full text pending.

This is an ADR stub created 2026-06-07 during BC-3 ADR stub cleanup. The PWA-first
direction is confirmed and locked (per PROJECT_DECISION_INDEX.md §1); this ADR will
be fully written by Pod B before Phase 7 completes.

Previously stub-referenced as `adr/ADR-0003-pwa-first.md` (root, pre-BC-3). That file
is deleted; this `docs/adr/ADR-014` is the canonical successor.

---

## Decision Direction (Locked)

The customer-facing application is **PWA-first**: delivered as a Progressive Web App,
not a native mobile application, for Phase 1 and Phase 2.

---

## Rationale (Summary — full Context/Consequences in final ADR)

Cross-platform delivery without app store friction; installable on Android and iOS;
aligns with café on-site QR-code entry pattern; avoids native app maintenance overhead
in Phase 1. Native app may be reconsidered in Phase 3+ based on user research.

---

## Next Steps

Pod B will expand this stub into a full ADR with:
- Complete Context (problem statement, alternatives)
- Full Decision section with PWA pattern details
- Consequences (offline capability, push notification constraints, iOS limitations)
- Alternatives Considered (native iOS/Android, React Native, Flutter)

---

## Approval (Pending Full ADR)

- Author: Pod B
- Reviewer: Pod A (product-impacting architecture)
- Approver: Kerem
- Date (full ADR): TBD
