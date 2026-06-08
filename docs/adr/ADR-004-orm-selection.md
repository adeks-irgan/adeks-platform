# ADR-004: ORM Selection

<!--
  STATUS: Accepted
  AUTHOR: Pod B — Architecture, Logic & Risk
  REVIEWER: Pod C
  APPROVER: Kerem
  DATE: 2026-06-08
  CANONICAL REPO PATH: /docs/adr/ADR-004-orm-selection.md
  RELATED:
    - /docs/adr/ADR-008-schema-per-tenant-tenancy.md (tenancy strategy — co-decided)
    - /docs/PROJECT_DECISION_INDEX.md §1 (Locked technical decisions)
    - /docs/PROJECT_BRIEF.md §17 (updated)
  NOTE: Previously blocked on ADR-008. Both ADRs accepted together 2026-06-08.
  Implementation remains blocked pending separate Pod B + Kerem approved issues.
-->

## Status

Accepted — 2026-06-08 (Kerem approval).

**Decision: Prisma** is selected as the ORM for the Adeks Platform.

## Context

The Adeks Platform requires an ORM to manage PostgreSQL interaction for:

- Domain entities (customers, orders, reservations, audit logs)
- Append-only financial ledger tables (wallet — ADR-006; loyalty — ADR-007)
- All tenant-scoped tables under the shared-schema multi-tenancy model (ADR-008)

This ADR was previously blocked on ADR-008 (tenancy strategy), because the two leading
candidates have different fits depending on the tenancy model chosen:

| ORM candidate | Tenancy fit |
|---|---|
| **Prisma** (schema-first, generated client) | Better fit for shared-schema + `tenant_id`: Prisma Client Extensions provide a first-class mechanism for global per-query `tenant_id` injection |
| **Drizzle** (schema-as-code, raw migration control) | Better fit for schema-per-tenant: fine-grained schema-file control and proximity to raw SQL simplify per-schema migration management |

ADR-008 has been co-decided: **shared schema with mandatory non-null `tenant_id`**, locked as
the long-term model. This resolves the coupling dependency and enables ORM selection.

### Candidates evaluated

| Criterion | Prisma | Drizzle |
|---|---|---|
| Tenancy enforcement mechanism | Prisma Client Extensions — first-class, centralized, auditable | None equivalent — application-layer patterns only |
| Migration management | `prisma migrate` generates reviewable SQL migration files committed to the repo | Schema push or raw SQL — less structured migration audit trail |
| TypeScript integration | Strong generated client, good IDE support | Very strong — type inference directly from schema definitions |
| Schema representation | Schema-first (`.prisma` file) | Code-first (TypeScript) |
| Raw SQL support | `$queryRaw`, `$executeRaw` for edge cases | Close to raw SQL by default |
| Ecosystem maturity | Large community, broad docs, active releases | Growing community, newer ecosystem |

## Decision

**Prisma** is selected as the ORM for the Adeks Platform.

### Rationale

**1. Tenancy strategy alignment (primary reason).**
ADR-008 selects shared-schema + `tenant_id` as the long-term tenancy model. Prisma Client
Extensions are the implementation mechanism for the binding global tenant-scoping requirement
(see ADR-008 and below): they allow a single, central, auditable extension to inject mandatory
`tenant_id` filtering at the ORM layer on every query against a tenant-scoped table. Drizzle
has no equivalent centralized hook. Without this mechanism, tenant isolation in a shared-schema
model relies entirely on application-layer discipline — a significantly higher risk posture
for a product handling financial (wallet/loyalty) data across tenants.

**2. Reviewed, auditable SQL migrations.**
`prisma migrate` generates SQL migration files that are committed to the repository, reviewed
by Pod B, and approved by Kerem before execution (ADR-009 §3: database/schema migration →
Pod B + Kerem). This satisfies the control-plane audit requirement for schema changes without
additional tooling.

**3. Developer experience and type safety.**
The Prisma generated client provides strong type coverage across all domain modules with minimal
boilerplate, appropriate for an AI-assisted development workflow (Pod C) where type errors should
fail early.

**4. Phase 3 long-term fit.**
ADR-008 is locked as the long-term model. The shared-schema + `tenant_id` + Prisma Client
Extension approach scales through Phase 3 multi-tenancy without requiring an ORM migration.
Locking Prisma now avoids a future migration cost.

### Binding design requirement: Global tenant scoping enforcement

**Phase 1 database design MUST enforce tenant scoping globally.** The required implementation
pattern is a Prisma Client Extension that automatically injects `tenant_id` filtering on every
query against a tenant-scoped table. This is a binding design requirement — not optional and
not deferrable to after initial schema creation.

This requirement:
- Applies before any tenant-scoped schema or migration is created.
- Must be reviewed by Pod B and approved by Kerem before Pod C implementation begins.
- Is classified as a security-sensitive and database/schema migration item under ADR-009 §3
  (Pod B + Kerem required before merge).
- Cannot be bypassed by `$queryRaw` calls on tenant-scoped tables without a new Pod B
  architecture review.

**Implementation remains blocked.** No Prisma installation, schema authoring, migration, or
TenantContext implementation begins until separate Pod B + Kerem approved implementation
issues exist.

### Primary key convention

All entity tables use **UUID** primary keys. This resolves the earlier UUID-vs-bigint open
question in favour of UUID. UUIDs are required for:

- Cross-tenant identity portability (no collision risk between tenants sharing a schema)
- Phase 3 SaaS compatibility (UUIDs do not expose sequential row volume to external parties)
- Consistent identity generation across all domain modules without a coordination dependency

## Consequences

### What becomes easier

- Centralized, ORM-layer tenant isolation via Prisma Client Extensions.
- Reviewed, auditable SQL migration history via `prisma migrate` — each migration is a
  committed file, reviewable before execution.
- Strong typed client across all domain modules with minimal boilerplate.
- Deterministic UUID primary key strategy eliminates ambiguity in foreign key design.

### What becomes harder or more constrained

- Prisma is an external dependency with version lifecycle management overhead. Major version
  upgrades may introduce breaking changes; ADR-009 §3 gate on schema migration PRs mitigates
  unreviewed upgrades.
- Complex ledger aggregation queries (e.g. balance derivation from append-only events) may
  require `$queryRaw` for performance. All `$queryRaw` usage on financial tables requires
  Pod B review.
- Any future ORM change is a large-scope migration. Prisma is the long-term commitment.
- All schema changes must go through `prisma migrate` — not ad hoc SQL. This is a
  governance requirement, not a risk.

### What is constrained

- Drizzle is not the ORM for this repository. This decision is Locked.
- Schema changes without a `prisma migrate` migration are not permitted.
- A Prisma Client Extension for global `tenant_id` filtering is required before any
  tenant-scoped entity implementation begins.
- `$queryRaw` on financial or customer-data tables requires Pod B review.

### Risks accepted

- **Prisma version upgrade risk.** Major versions may break the Client Extension or generated
  client API. Mitigated by version pinning, CHANGELOG review before upgrades, and ADR-009 §3
  gate on all schema migration PRs.
- **Client Extension immaturity risk.** Prisma Client Extensions are a relatively recent
  feature. Any discovered limitation during implementation must be escalated to Pod B before
  workarounds are introduced; workarounds that weaken tenant isolation are not acceptable.

## Alternatives Considered

### Drizzle ORM

**Not selected.** Drizzle is an excellent choice for schema-per-tenant tenancy due to its raw
SQL proximity and schema-as-code migration control. However, ADR-008 selects shared-schema +
`tenant_id` as the long-term model. Drizzle provides no equivalent to Prisma Client Extensions
for centralizing global `tenant_id` injection. Under shared-schema tenancy, tenant isolation in
Drizzle depends on application-layer query patterns — a significantly weaker enforcement posture
for financial data. If the tenancy model were schema-per-tenant, Drizzle would have been
the preferred choice.

### Raw query builder (Knex, Slonik)

**Not selected.** Maximum SQL control but removes the type-safety and migration-management
benefits that support the AI-assisted development workflow. The traceability of `prisma migrate`
migration files committed to the repository satisfies the control-plane audit requirement; a raw
builder would require a separate migration framework.

### Sequelize / TypeORM

**Not selected.** Both are mature but have weaker TypeScript integration and less deterministic
migration tooling than Prisma for a greenfield project. Neither provides a Client
Extension-equivalent mechanism for global query filtering.

## Approval

- **Author:** Pod B — Architecture, Logic & Risk
- **Reviewer:** Pod C
- **Approver:** Kerem
- **Date proposed:** 2026-06-08
- **Date approved:** 2026-06-08 (Kerem decision recorded; co-decided with ADR-008)