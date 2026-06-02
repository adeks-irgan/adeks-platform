---
name: Feature
about: Implementation-ready feature or product requirement — must meet Definition of Ready before Pod C begins work
title: "[Feature]: "
labels: ["feature", "needs-triage"]
assignees: ""
---

## Business Context

<!-- Why does this feature exist? What user or business problem does it address? -->

## Scope — What Is Included

<!-- List specifically what will be built. -->

## Non-Goals — What Is Explicitly Excluded

<!-- List what is out of scope for this issue. -->

## User Story

As a [user type], I want [capability], so that [benefit].

## Acceptance Criteria

<!-- Specific, testable criteria. Use Given/When/Then format. -->

- [ ] Given [context], when [action], then [expected result].
- [ ] Given [context], when [action], then [expected result].

## Required Tests

<!-- Check all that apply and describe what must be covered. -->

- [ ] Unit tests — domain logic, ledger calculations, state transitions
- [ ] Integration tests — API behaviour and database interactions
- [ ] E2E / flow-level tests — critical user flows
- [ ] Contract tests — API boundaries (PWA ↔ backend, backend ↔ SelcafeAdapter)
- [ ] Auth / authorisation tests — positive and negative permission cases
- [ ] Manual UAT — Kerem or staff validation in staging
- [ ] Migration verification — if schema changes are included

## Linked Documents

<!-- Link relevant ADRs, schemas, API contracts, or planning docs. -->

- Product / planning document:
- Business rules:
- User flow:
- ADR:
- API contract:
- Database schema:
- Security / KVKK review:

## Risk Category

<!-- Select one — this determines required reviews below -->

- [ ] Standard
- [ ] Security-sensitive (auth, session, RBAC, customer data, KVKK)
- [ ] Financially-sensitive (wallet, loyalty, payments, refunds)
- [ ] Customer-data-sensitive (personal data access, display, or mutation)
- [ ] Selcafe-integration-sensitive (adapter changes, SQL Server access, sync logic)
- [ ] Operationally critical (cashier workflow, F&B queue, reservation flow, audit log)

## Pod B Review Status

<!-- Required if risk category is security-sensitive, financially-sensitive, customer-data-sensitive, or Selcafe-integration-sensitive -->

- [ ] Pod B review approved — link:
- [ ] Pod B review not required — reason:

## Kerem Approval Status

<!-- Required if risk category is financially-sensitive or operationally critical -->

- [ ] Kerem approved — link or reference:
- [ ] Kerem approval not required — reason:

## Synthetic Data Examples

<!-- Where test data is needed, provide synthetic examples only. No real customer names, phone numbers, or transaction data. -->

Example:
- Customer A
- +90 555 000 00 01
- PC-001
- Order #SYN-001

## Open Questions

<!-- List any unresolved questions that must be answered before Pod C starts. -->

- [ ] None
- [ ] Listed below:

## Definition of Ready Checklist

<!-- Pod C confirms all items before starting work. Reject the issue if any item is missing. -->

- [ ] Business context included
- [ ] Scope included
- [ ] Non-goals included
- [ ] User story included
- [ ] Acceptance criteria are specific and testable
- [ ] Required tests listed
- [ ] Linked documents included
- [ ] Risk category selected
- [ ] Pod B review status recorded
- [ ] Kerem approval status recorded
- [ ] Synthetic data examples included where relevant
- [ ] No open questions remaining
