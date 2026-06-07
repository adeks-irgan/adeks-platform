# ADR-001: Modular Monolith Architecture

<!--
  STATUS: Proposed (ADR stub — decision direction locked, full ADR to be written)
  AUTHOR: Pod B — Architecture, Logic & Risk
  REVIEWER: Pod B (when advancing to full ADR)
  APPROVER: Pod B (architecture decision)
  CREATED: 2026-06-07
  CANONICAL REPO PATH: /docs/adr/ADR-001-modular-monolith-architecture.md
  RELATED DOCUMENTS:
    - /docs/PROJECT_DECISION_INDEX.md (status: Locked ADR pending)
    - /docs/PROJECT_METHODOLOGY.md (§19 ADR backlog)
  IMPLEMENTATION: Blocks Pod C schema design and build phase; decision locked per Pod B direction
-->

---

## Status

Proposed — decision direction **Locked** (monolithic architecture, not microservices), ADR full text pending.

This is an ADR stub created 2026-06-07 during BC-3 ADR stub cleanup. The architectural direction is confirmed (per PROJECT_DECISION_INDEX.md); this ADR will be fully written by Pod B before Phase 7 completes.

---

## Decision Direction (Locked)

Adopt a **modular monolith** architecture, not microservices.

---

## Rationale (Summary — full Context/Consequences in final ADR)

A monolithic architecture allows phase-1 delivery without operational complexity; module boundaries (wallet, loyalty, cafe-management, F&B, reservations) enable future decomposition without enforcing it now.

---

## Next Steps

Pod B will expand this stub into a full ADR with:
- Complete Context (problem statement, alternatives)
- Full Decision section with pattern details
- Consequences (operational, scaling, refactoring cost)
- Alternatives Considered (microservices, serverless patterns)

---

## Approval (Pending Full ADR)

- Author: Pod B
- Reviewer: Pod C (as needed)
- Approver: Pod B
- Date (full ADR): TBD