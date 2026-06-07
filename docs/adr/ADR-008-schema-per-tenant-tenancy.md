# ADR-008: Schema-Per-Tenant Tenancy Strategy

<!--
  STATUS: Proposed (ADR stub — decision DEFERRED)
  AUTHOR: Pod B — Architecture, Logic & Risk
  CREATED: 2026-06-07
  CANONICAL REPO PATH: /docs/adr/ADR-008-schema-per-tenant-tenancy.md
  RELATED:
    - PROJECT_DECISION_INDEX.md (Deferred — Kerem 2026-06-04)
    - ADR-004 (ORM — coupled)
  BLOCKING: Pod C multi-tenancy schema design, TenantContext, ORM selection
-->

## Status

Proposed — decision **Deferred** by Kerem (2026-06-04). ADR full text pending when Kerem revisits.

This is an ADR stub created 2026-06-07 during BC-3 ADR stub cleanup. Per Kerem's deferral, this ADR will not be advanced until Kerem signals that tenancy strategy is ready to be decided.

## Decision Direction (Deferred)

This is a Phase 3 (SaaS) decision pending Kerem's strategic revisit. Candidates:

- **Schema-per-tenant:** Separate PostgreSQL schema per café; highest isolation, complex migrations, good for small-N multi-tenancy (Adeks + future partners)
- **Shared schema + tenant_id:** Single schema; lowest operational overhead; harder to fully isolate; standard for large-N SaaS
- **Database-per-tenant:** Maximum isolation; operational cost scales with tenant count

Pod B is ready to compare and recommend once Kerem signals it's time.

## Approval (Deferred)

- Author: Pod B
- Decision: Deferred to Kerem
- Pod B recommendation: Pending Kerem signal to proceed