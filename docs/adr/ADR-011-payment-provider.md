# ADR-011: Payment Provider

<!--
  STATUS: Proposed (ADR stub — Phase 2, decision pending)
  AUTHOR: Pod B — Architecture, Logic & Risk
  CREATED: 2026-06-07
  CANONICAL REPO PATH: /docs/adr/ADR-011-payment-provider.md
  RELATED:
    - PROJECT_DECISION_INDEX.md (Phase 2, not locked)
    - PROJECT_METHODOLOGY.md (Phase 2 roadmap; Phase 1 = cashier-only payment)
    - KEREM_DECISIONS.md (D-010, D-011: Phase 1 payment is cashier-only)
-->

## Status

Proposed — Phase 2 decision. Phase 1 uses cashier-initiated top-ups only (no end-user payment processing). ADR pending before Phase 2 payment features begin.

This is an ADR stub created 2026-06-07 during BC-3 ADR stub cleanup.

## Decision Direction (Phase 2)

Phase 2 will enable customers to top up their wallet via card/bank transfer. This requires selecting a payment processor (Stripe, PayU, local Turkish provider, etc.).

Decision pending Phase 2 scoping and Turkish market assessment.

## Approval (Pending Phase 2)

- Author: Pod B
- Approver: Pod B (with Kerem on provider constraints)
- Date (full ADR): Before Phase 2 payment features begin