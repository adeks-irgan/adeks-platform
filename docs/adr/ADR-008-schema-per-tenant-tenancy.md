# ADR-008: Tenancy Strategy — Shared Schema with tenant_id

<!-- FILENAME NOTE: This file is named ADR-008-schema-per-tenant-tenancy.md and that
filename is retained for link stability; the actual decision recorded herein is
shared schema with mandatory non-null tenant_id, not schema-per-tenant. -->

<!--
  STATUS: Accepted
  AUTHOR: Pod B — Architecture, Logic & Risk
  REVIEWER: Pod A (product-impacting — Phase 3 SaaS implications)
  APPROVER: Kerem
  DATE: 2026-06-08
  CANONICAL REPO PATH: /docs/adr/ADR-008-schema-per-tenant-tenancy.md
  RELATED:
    - /docs/adr/ADR-004-orm-selection.md (ORM — Prisma; co-decided with this ADR)
    - /docs/PROJECT_DECISION_INDEX.md §1 (Locked technical decisions)
    - /docs/PROJECT_BRIEF.md §17 (updated)
  NOTE: Decision was deferred by Kerem 2026-06-04. Revisited and decided 2026-06-08.
  Implementation remains blocked pending separate Pod B + Kerem approved issues.
-->

## Status

Accepted — 2026-06-08 (Kerem approval).

**Decision: Shared schema with mandatory non-null `tenant_id`** on all tenant-scoped
tables. Locked for Phase 1 and as the long-term multi-tenant model. Schema-per-tenant
and database-per-tenant are not planned.

## Context

The Adeks Platform is designed from Phase 1 to eventually support Phase 3 multi-location,
multi-tenant SaaS operation (`PROJECT_BRIEF.md §5.3`). Tenancy strategy therefore has
long-term consequences; the wrong choice either creates a costly Phase 3 migration or adds
unnecessary Phase 1 complexity.

This decision was consciously deferred by Kerem on 2026-06-04 until the product shape and
SaaS direction were sufficiently clear. That deferral was correct. The project now has:
- Confirmed Phase 1 scope (single-tenant Adeks deployment)
- Confirmed Phase 3 SaaS ambition (multi-location, multiple café operator tenants)
- Confirmed ORM direction (Prisma — co-decided as ADR-004)
- No regulatory or contractual requirement for per-tenant schema or database isolation at launch

### Tenancy candidates evaluated

| Model | PostgreSQL isolation | Operational cost | Migration complexity | Phase 3 SaaS fit |
|---|---|---|---|---|
| **Database-per-tenant** | Maximum — separate DB | Very high | Very high | Poor for large-N SaaS |
| **Schema-per-tenant** | High — schema boundary | Medium | High — per-schema migrations | Good for small/medium-N; poor for large-N |
| **Shared schema + `tenant_id`** | Row-level (ORM-enforced) | Low | Low — one migration set | Standard for large-N SaaS |

### Why this needed an explicit decision before Pod C implementation

This decision was the primary blocker for:

- ORM selection (ADR-004): Prisma vs Drizzle depends on the tenancy model.
- All Pod C schema/migration work: `tenant_id` column presence and type depends on this decision.
- Prisma Client Extension design: the extension's behavior is shaped by the tenancy model.
- `TenantContext` module design: how the application resolves the current tenant per request.
- UUID vs integer primary key strategy: UUID is more appropriate for cross-tenant portability.

## Decision

**Shared schema with mandatory non-null `tenant_id`** on all tenant-scoped tables.

This is the **long-term tenancy model** for the Adeks Platform, locked from Phase 1 through
Phase 3. No migration to schema-per-tenant or database-per-tenant is planned.

### What "shared schema + tenant_id" means in practice

| Rule | Requirement |
|---|---|
| Single PostgreSQL database and schema | All tenants share one schema. No per-tenant schema or database. |
| `tenant_id` on all tenant-scoped tables | Every table holding tenant-specific data carries a `tenant_id` column. |
| `tenant_id` is NOT NULL | Enforced at the database level via a NOT NULL constraint — not only application level. |
| `tenant_id` is a foreign key | References the `tenants` table. A `tenants` table must exist. |
| Mandatory filtering on all queries | Every query against a tenant-scoped table must include a `tenant_id` predicate. |

### Binding design requirement: Global tenant scoping enforcement

**Phase 1 database design MUST enforce tenant scoping globally.** The implementation
mechanism is a Prisma Client Extension (see ADR-004) that automatically injects `tenant_id`
filtering on every query against a tenant-scoped table.

This is a binding design requirement — not optional, not deferrable to after schema creation,
and not eligible to be bypassed without a new Pod B architecture review and Kerem approval.

**Why this is binding:** Shared-schema tenancy is only as safe as its enforcement layer.
A query that omits `tenant_id` returns or modifies cross-tenant data — a severe data isolation
failure for a product handling wallet and loyalty financial data. The Prisma Client Extension
creates a centralized enforcement point below application business logic; it is:

- Auditable as a single, reviewable code artifact.
- Applied uniformly to all Pod C-authored queries.
- Impossible to accidentally bypass in normal Prisma query authoring.

Any design change that removes or bypasses the global Prisma Client Extension as the primary
enforcement mechanism requires a new Pod B architecture review and Kerem approval.

### UUID primary keys

All entity tables use **UUID** primary keys. This resolves the earlier UUID-vs-bigint open
question in favour of UUID.

| Reason | Detail |
|---|---|
| Cross-tenant portability | No collision risk between tenant rows; UUIDs are globally unique without coordination |
| Phase 3 SaaS security | UUIDs do not expose sequential row volume to external parties |
| Consistent identity generation | UUID generation is available in any tier without central coordination |

`tenant_id` itself is a UUID foreign key referencing `tenants.id`.

### Phase 1 single-tenant simplification

Phase 1 deploys with a single tenant (Adeks). The `TenantContext` module will resolve to a
static tenant identifier in Phase 1. This means:

- No tenant-routing logic is required at Phase 1 runtime.
- The schema is correctly structured for Phase 3 multi-tenancy from day one.
- The Prisma Client Extension operates trivially (injects one constant `tenant_id`).

This achieves Phase 1 simplicity without requiring a disruptive schema migration before Phase 3.

## Consequences

### What becomes easier

- A single migration set applies to all tenants — no per-tenant migration execution in Phase 3.
- Prisma Client Extensions (ADR-004) provide a clean, central, auditable `tenant_id` hook.
- Phase 1 operates without tenant-routing complexity (single tenant, static context).
- No PostgreSQL schema-management tooling needed for Phase 3 tenant provisioning — onboarding
  a new tenant requires only a new `tenants` row.
- Feature development across Phase 1 and Phase 2 requires no tenancy-aware schema changes;
  the model is set.

### What becomes harder or more constrained

- **Data isolation is ORM/application-enforced, not schema-enforced.** A bug in the Prisma
  Client Extension or a raw query bypassing it can cause cross-tenant data leakage. Mitigated
  by the binding global enforcement requirement, mandatory Pod B review on all tenant-scoped
  schema changes, and required test coverage for the extension behavior.
- **Complex cross-tenant analytics** (Phase 3 operator dashboards) require careful scoping.
  Not a Phase 1 or Phase 2 concern; noted for Phase 3 design.
- **Regulatory isolation.** If a Phase 3 tenant requires physical data separation (e.g. data
  residency or contractual separation), shared schema cannot satisfy it. This risk is accepted
  for Phase 1–2; must be reviewed before Phase 3 onboarding of tenants with heightened
  regulatory requirements.

### What is constrained

- Schema-per-tenant and database-per-tenant approaches are not planned. This decision is Locked.
- All tenant-scoped tables must carry a `tenant_id` NOT NULL column with a FK constraint.
- All queries against tenant-scoped tables must filter by `tenant_id`, enforced via the
  Prisma Client Extension.
- No schema, migration, or `TenantContext` implementation begins until separate Pod B + Kerem
  approved implementation issues exist (ADR-009 §3: database/schema migration → Pod B + Kerem).

### Risks accepted

- **Cross-tenant leakage via application-layer enforcement.** Accepted with the binding Prisma
  Client Extension requirement, mandatory Pod B review on all schema PRs, and required test
  coverage for the extension.
- **Phase 3 regulatory isolation requirements for specific tenants.** Accepted; to be reviewed
  before Phase 3 tenant onboarding for any tenant with contractual or regulatory data
  separation requirements.

## Alternatives Considered

### Schema-per-tenant

**Not selected.** Provides strong PostgreSQL-level isolation and suits small-to-medium tenant
counts. However:

- Per-tenant migration execution is operationally expensive at large-N scale (Phase 3 SaaS target).
- Prisma's migration engine targets a single schema; schema-per-tenant would require significant
  additional migration tooling.
- Drizzle (the alternative ORM candidate) would be needed for this model; co-decision to
  select Prisma (ADR-004) makes schema-per-tenant impractical.
- The Phase 3 large-N café operator SaaS ambition makes shared-schema the more sustainable
  long-term choice.

The original ADR-008 stub was titled "Schema-per-tenant" as the then-leading candidate. The
filename `ADR-008-schema-per-tenant-tenancy.md` is retained for link stability only; the
decision recorded herein is shared schema with tenant_id.

### Database-per-tenant

**Not selected.** Maximum isolation but operational cost scales linearly with tenant count:
per-tenant provisioning, backup, monitoring, and migration management are unsustainable at
scale. Not appropriate for the Phase 3 large-N SaaS ambition.

### No explicit tenancy preparation in Phase 1

**Not selected.** Operating Phase 1 without `tenant_id` columns would require a destructive
migration to add them before Phase 3. The shared-schema model with Phase 1 single-tenant
simplification achieves Phase 1 simplicity without creating a Phase 3 migration hazard.

## Approval

- **Author:** Pod B — Architecture, Logic & Risk
- **Reviewer:** Pod A (product-impacting — Phase 3 SaaS implications)
- **Approver:** Kerem
- **Date proposed:** 2026-06-08
- **Date approved:** 2026-06-08 (Kerem decision; co-decided with ADR-004)