# ADR-007: Loyalty Append-Only Ledger

<!--
  STATUS: Proposed (ADR stub — decision direction locked, full ADR to be written)
  AUTHOR: Pod B — Architecture, Logic & Risk
  CREATED: 2026-06-07
  CANONICAL REPO PATH: /docs/adr/ADR-007-loyalty-append-only-ledger.md
  RELATED:
    - PROJECT_DECISION_INDEX.md (Locked ADR pending)
    - ADR-006 (wallet ledger pattern; loyalty follows same pattern)
-->

## Status

Proposed — decision direction **Locked** (loyalty = append-only ledger), ADR full text pending.

This is an ADR stub created 2026-06-07 during BC-3 ADR stub cleanup. The ledger pattern is confirmed; this ADR will be fully written by Pod B.

## Decision Direction (Locked)

The loyalty system is implemented as an **append-only ledger**, identical pattern to wallet (ADR-006):

- Each point transaction (earn, redeem) creates an immutable ledger entry
- Balance is derived (sum of entries)
- No mutations in-place
- Full audit trail by design

## Rationale (Summary)

Consistency with wallet pattern, financial integrity, auditability. Loyalty points are a form of monetary value and must be treated as such.

## Approval (Pending Full ADR)

- Author: Pod B
- Approver: Pod B
- Date (full ADR): TBD