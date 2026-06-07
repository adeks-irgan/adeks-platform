# ADR-012: Feature Flag Tool Selection

<!--
  STATUS: Proposed (ADR stub — decision pending before Phase 1 go-live)
  AUTHOR: Pod B — Architecture, Logic & Risk
  CREATED: 2026-06-07
  CANONICAL REPO PATH: /docs/adr/ADR-012-feature-flag-tool.md
  RELATED:
    - PROJECT_DECISION_INDEX.md (Before Phase 1 go-live)
    - KEREM_DECISIONS.md (K-04: feature flags assigned to Pod B)
    - PROJECT_METHODOLOGY.md (§19 ADR backlog)
-->

## Status

Proposed — Pod B decision, must be finalized before Phase 1 go-live. ADR full text pending.

This is an ADR stub created 2026-06-07 during BC-3 ADR stub cleanup.

## Decision Direction (Pod B to Finalize)

Phase 1 and on-site operations require feature flags to safely roll out features, kill switches for incidents, and A/B testing.

**Phase 1 approach (Pod B recommendation):** Database-driven flags (simple, no external dependency, good for single-site / early multi-tenancy)

**Phase 3 approach (future):** Managed service (Unleash, LaunchDarkly) for SaaS-scale management

Pod B will write full ADR before Phase 1 launch.

## Approval (Pending Full ADR)

- Author: Pod B
- Approver: Pod B
- Date (full ADR): Before Phase 1 go-live