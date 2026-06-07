# ADR-003: PostgreSQL Database Family

<!--
  STATUS: Proposed (ADR stub — decision direction locked, full ADR to be written)
  AUTHOR: Pod B — Architecture, Logic & Risk
  CREATED: 2026-06-07
  CANONICAL REPO PATH: /docs/adr/ADR-003-postgresql-database-family.md
  RELATED: PROJECT_DECISION_INDEX.md (Locked ADR pending)
-->

## Status

Proposed — decision direction **Locked** (PostgreSQL), ADR full text pending.

This is an ADR stub created 2026-06-07 during BC-3 ADR stub cleanup. The database choice is confirmed; this ADR will be fully written by Pod B.

## Decision Direction (Locked)

Use PostgreSQL as the primary relational database for all persistent state (wallet ledger, loyalty ledger, schema-per-tenant or tenant-ID schemas, reservations, F&B orders).

## Rationale (Summary)

PostgreSQL provides ACID transactions (essential for financial ledgers), jsonb support (flexible schema in Phase 1), and row-level security (future KVKK enforcement). Single database family simplifies operations.

## Approval (Pending Full ADR)

- Author: Pod B
- Approver: Pod B
- Date (full ADR): TBD