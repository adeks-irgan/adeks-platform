# DATA_RETENTION_POLICY.md

<!--
  CANONICAL REPO PATH: /docs/DATA_RETENTION_POLICY.md
  DOCUMENT TYPE: Pod A / Pod B / legal-KVKK retention planning artifact
  OWNER / AUTHOR: Pod A — Product & Planning
  REVIEWER: Pod B — Architecture, Logic & Risk
  LEGAL REVIEW: Legal advisor required
  APPROVER: Kerem
  STATUS: v0.1 draft — P16 QR-linked live-bill / guest-flow retention schedule; requires legal advisor sign-off, Pod B review, and Kerem approval before merge/checkpoint pass
  AUTHORITY: This document records proposed retention policy. It does not authorize implementation, pilot operation, live Selcafe reads, or Pod C.
  DATA: Synthetic examples only. No real customer/staff/Selcafe row data.
-->

## Status

| Field | Value |
|---|---|
| Document | `DATA_RETENTION_POLICY.md` |
| Scope | Phase 1 retention policy draft, with P16 QR-linked live-bill / guest-flow schedule |
| Current status | v0.1 draft — requires legal advisor sign-off, Pod B review, and Kerem approval |
| Implementation status | Does **not** authorize Pod C, schema/API work, live Selcafe reads, direct Selcafe writes, or pilot operation |
| Source issue | GitHub issue #133 |
| Legal sign-off | Required |
| Kerem approval | Required |

## Purpose

This document records draft retention periods and retention principles for Adeks Platform Phase 1 data classes.

For P16, it distinguishes live display data, short technical cache, session-link metadata, discount-code mapping, audit/security logs, incident/dispute records, and fiscal/commercial Selcafe-side records.

## Scope

### In scope for v0.1

| Area | Included |
|---|---|
| P16 live bill projection | No persistence |
| P16 order-line visibility cache | Session-only + hard TTL |
| QR token/session-link records | Active-state and metadata retention |
| Discount reflection verification | Adeks mapping retention and Selcafe fiscal/commercial pointer |
| Security/audit logs | Draft retention range |
| Incident/dispute records | Retain until dispute/investigation closes |
| Cross-border dependency | Retention must be reassessed if foreign-hosted logs/backups/support process P16 data |

### Out of scope for v0.1

| Out of scope | Owner / route |
|---|---|
| Final legal approval | Legal advisor + Kerem |
| Physical deletion jobs / scheduler implementation | Pod B design → Pod C only after approved issue |
| Database schema/API contracts | Pod B only after checkpoint pass |
| Full fiscal/legal retention classification for Selcafe-side records | Legal/accounting advisor + Kerem |
| Pod C implementation | Not authorized |

## Retention Principles

| ID | Principle |
|---|---|
| RET-P16-001 | Do not apply one long fiscal/accounting retention period to every P16 technical record. |
| RET-P16-002 | Live projection is display-only and must not be persisted. |
| RET-P16-003 | Full order-line persistence should be avoided; metadata-only evidence is preferred. |
| RET-P16-004 | Retention must be tiered by purpose: display, cache, access-control, reconciliation, security/audit, dispute, fiscal/commercial record. |
| RET-P16-005 | P16 logs should be pseudonymized where feasible and must avoid member identity. |
| RET-P16-006 | Guest mode remains current-bill-only and no historical bills are retained/displayed for guest access. |
| RET-P16-007 | Legal advisor sign-off and Kerem approval are required before the schedule becomes policy. |

## P16 Retention Schedule

[REQUIRES LEGAL ADVISOR SIGN-OFF] [REQUIRES POD B REVIEW] [NEEDS KEREM APPROVAL]

| Data category | Draft retention | Policy note |
|---|---:|---|
| Live bill projection rendered in UI | No persistence | Read/display from live source only |
| Order-line visibility cache | Session-only; delete at bill close where detectable; hard TTL 15–60 minutes | Avoid duplicating Selcafe order lines |
| QR token | Until used/expired; normally seconds/minutes | One-time token |
| Active session-link state | Until bill/session closes; hard TTL same business day | Needed only for continuity of active service session |
| Session-link metadata | 30 days for pilot | Security and complaint handling |
| Live-bill view evidence | 30 days; metadata only | Avoid storing full order lines |
| Discount-code mapping | 90–180 days | Reconciliation/dispute window |
| Security/audit logs | 6–12 months | Pseudonymized where feasible |
| Incident/dispute records | Until dispute/investigation closes | Rights protection |
| Selcafe fiscal/accounting discount record | Per applicable accounting/tax/commercial rule | Exact classification requires legal/accounting confirmation |

## Bill-Close Deletion Dependency

[REQUIRES POD B REVIEW]

Order-line cache deletion at bill close depends on a reliable bill-close detection signal. Because P16 remains a read-only/polling path toward Selcafe, bill-close detection is a later implementation-spec dependency.

The 15–60 minute hard TTL is the fail-safe. The policy target is:

1. Delete at bill close where detectable.
2. Otherwise expire the cache through the hard TTL.
3. Never retain full order-line cache merely for convenience.
4. Use metadata-only evidence for view/security/dispute records where possible.

This policy does not define eviction implementation, scheduler design, schema, API, or runtime cache mechanics.

## Fiscal / Accounting / Commercial Records

[OPEN QUESTION — accountant/legal confirmation required]

Selcafe-side fiscal/accounting/commercial records may have longer statutory or commercial retention requirements than Adeks-side P16 technical records.

This policy does **not** assign fiscal retention to all P16 records. The exact treatment of the Selcafe-side discount reflection record must be confirmed by accounting/tax/legal review before checkpoint pass.

## Deletion / Expiry Behavior

| Data category | Draft behavior |
|---|---|
| Live bill projection | Do not persist |
| Order-line cache | Delete at bill close where detectable; hard TTL 15–60 min |
| QR token | Burn on first use or expiry |
| Active session-link | Expire at bill/session close or same-day hard TTL |
| View evidence | Retain metadata-only for 30 days, then expire/delete per approved process |
| Discount mapping | Retain 90–180 days, then expire/delete unless legal/dispute hold applies |
| Security/audit logs | Retain 6–12 months, then expire/delete or archive per approved security policy |
| Incident/dispute records | Retain until investigation/dispute closes; legal hold may override |

## Open Questions

| ID | Question | Owner / route |
|---|---|---|
| RET-P16-001 | What exact fiscal/accounting/commercial retention rule applies to Selcafe-side discount reflection records? | Legal/accounting advisor + Kerem |
| RET-P16-002 | What infrastructure facts affect retention or cross-border handling of logs/backups/monitoring/support/AI tooling? | Pod B + legal advisor + Kerem |
| RET-P16-003 | What implementation design provides reliable bill-close detection, if any, on a read-only polling path? | Pod B later; not in this policy |
| RET-P16-004 | What deletion/expiry mechanism will implement TTLs? | Pod B design → Pod C only after approved DoR issue |
| RET-P16-005 | How are legal holds applied for disputes or investigations? | Legal advisor + Kerem + Pod B |

## Build-Gating Rules

| Gate | Rule |
|---|---|
| RET-GATE-001 | This document does not authorize implementation. |
| RET-GATE-002 | Legal advisor sign-off and Kerem approval are required before these retention entries become policy. |
| RET-GATE-003 | P16 Operating Slice Checkpoint remains blocked until retention is reviewed and approved. |
| RET-GATE-004 | Physical deletion/expiry mechanics are later implementation-spec work and require a separate approved DoR issue. |
| RET-GATE-005 | Full order-line persistence must not be introduced without renewed legal/KVKK/security review and Kerem approval. |

## Review Routing

| Review item | Required |
|---|---|
| Ready for commit | Yes — as v0.1 draft only |
| Ready for merge | No — requires legal advisor sign-off, Pod B review, and Kerem approval |
| Requires Pod B review | Yes |
| Requires legal advisor sign-off | Yes |
| Requires Kerem approval | Yes |
| Requires Pod C implementation | No |
| Requires Pod D review | Later only if retention affects UX/notice/monitoring displays |

## Document History

| Version | Date | Author | Change |
|---|---|---|---|
| v0.1 draft | 2026-07-01 | Pod A | Initial P16 retention schedule for QR-linked live-bill / guest flow. Requires legal advisor sign-off, Pod B review, and Kerem approval. |
