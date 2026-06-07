# ADR-004: ORM Selection (Prisma vs Drizzle)

<!--
  STATUS: Proposed (ADR stub — NOT LOCKED, decision pending)
  AUTHOR: Pod B — Architecture, Logic & Risk
  CREATED: 2026-06-07
  CANONICAL REPO PATH: /docs/adr/ADR-004-orm-selection.md
  RELATED: 
    - PROJECT_DECISION_INDEX.md (Not locked, blocks Pod C)
    - ADR-008 (tenancy strategy — coupled)
  BLOCKING: Pod C schema/migration design; Pod C build phase
-->

## Status

Proposed — **NOT LOCKED**. ADR full text pending.

This is the critical-path blocking ADR. Choice depends on tenancy complexity (ADR-008). Pod B will recommend ORM **with or after** ADR-008 tenancy is locked.

## Decision Direction (Pending Lock)

Candidates:
- **Prisma:** schema-first, good DevX, best for shared-schema tenancy
- **Drizzle:** schema-as-code, stronger TypeScript, better for schema-per-tenant with raw migration control

Pod B recommendation: Will depend on ADR-008 outcome.

## Approval (Pending Full ADR & Lock)

- Author: Pod B
- Reviewer: Pod C
- Approver: Pod B (technical); Kerem (if product-impacting)
- Date (full ADR): TBD (after ADR-008 locked)