# ADR-005: Selcafe Read-Only Phase 1 Adapter

<!--
  STATUS: Proposed (ADR stub — decision direction locked, full ADR to be written)
  AUTHOR: Pod B — Architecture, Logic & Risk
  CREATED: 2026-06-07
  CANONICAL REPO PATH: /docs/adr/ADR-005-selcafe-read-only-adapter.md
  RELATED:
    - PROJECT_DECISION_INDEX.md (Locked ADR pending)
    - PROJECT_BRIEF.md (Selcafe legacy system)
  PATTERN: CafeManagementAdapter / SelcafeAdapter
-->

## Status

Proposed — decision direction **Locked** (read-only Selcafe integration Phase 1), ADR full text pending.

This is an ADR stub created 2026-06-07 during BC-3 ADR stub cleanup. The integration pattern is confirmed; this ADR will be fully written by Pod B.

## Decision Direction (Locked)

In Phase 1, Adeks integrates Selcafe as a **read-only data source** via the **CafeManagementAdapter** pattern:
- SelcafeAdapter reads current café state (open hours, categories, menu items, active sessions)
- No writes to Selcafe in Phase 1
- Adeks native ledgers (wallet, loyalty, reservations, F&B) are authoritative
- Phase 2–3: Plan migration to AdeksNativeCafeEngine (full replacement)

## Rationale (Summary)

Minimize Phase 1 coupling to legacy system; preserve Selcafe operations; enable parallel Adeks-native data model evolution.

## Approval (Pending Full ADR)

- Author: Pod B
- Approver: Pod B
- Date (full ADR): TBD