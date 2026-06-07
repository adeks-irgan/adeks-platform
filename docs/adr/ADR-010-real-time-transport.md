# ADR-010: Real-Time Transport Selection

<!--
  STATUS: Proposed (ADR stub — Phase 2, decision pending)
  AUTHOR: Pod B — Architecture, Logic & Risk
  CREATED: 2026-06-07
  CANONICAL REPO PATH: /docs/adr/ADR-010-real-time-transport.md
  RELATED:
    - PROJECT_DECISION_INDEX.md (Phase 2, not locked)
    - PROJECT_METHODOLOGY.md (Phase 2–3 roadmap)
-->

## Status

Proposed — Phase 2 decision. Not required for Phase 1. ADR full text pending before Phase 2 begins.

This is an ADR stub created 2026-06-07 during BC-3 ADR stub cleanup.

## Decision Direction (Phase 2 Candidate)

Real-time features (live order status, balance updates, reservation confirmations) will require a real-time transport layer in Phase 2+.

Current candidate: **WebSocket**, because:
- Widely supported in browsers and Node.js
- Low latency
- Bidirectional
- Well-understood operational constraints

Alternative: Server-Sent Events (SSE) for simpler unidirectional case.

Pod B will finalize choice before Phase 2 planning.

## Approval (Pending Phase 2)

- Author: Pod B
- Approver: Pod B
- Date (full ADR): Before Phase 2 begins