# ADR-006: Wallet Append-Only Ledger

<!--
  STATUS: Proposed (ADR stub — decision direction locked, full ADR to be written)
  AUTHOR: Pod B — Architecture, Logic & Risk
  CREATED: 2026-06-07
  CANONICAL REPO PATH: /docs/adr/ADR-006-wallet-append-only-ledger.md
  RELATED:
    - PROJECT_DECISION_INDEX.md (Locked ADR pending)
    - PROJECT_METHODOLOGY.md (§20 KVKK / human approval)
-->

## Status

Proposed — decision direction **Locked** (wallet = append-only ledger), ADR full text pending.

This is an ADR stub created 2026-06-07 during BC-3 ADR stub cleanup. The ledger pattern is confirmed (locked principle per PROJECT_METHODOLOGY.md); this ADR will be fully written by Pod B.

## Decision Direction (Locked)

The wallet system is implemented as an **append-only ledger**, not mutable account balances:

- Each transaction (top-up, spend, refund) creates an immutable ledger entry
- Balance is derived (sum of all entries)
- No in-place updates or deletes
- Full audit trail by design
- Supports KVKK pseudonymization / erasure (future: mark entries as "pseudonymous" without deletion)

## Rationale (Summary)

Financial integrity, auditability, regulatory compliance (KVKK), and concurrency safety. No mutation means no lost updates or race conditions.

## Approval (Pending Full ADR)

- Author: Pod B
- Approver: Pod B (with KVKK advisory check)
- Date (full ADR): TBD