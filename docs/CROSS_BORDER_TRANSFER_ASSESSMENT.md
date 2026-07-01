# CROSS_BORDER_TRANSFER_ASSESSMENT.md

<!--
  CANONICAL REPO PATH: /docs/CROSS_BORDER_TRANSFER_ASSESSMENT.md
  DOCUMENT TYPE: Cross-border transfer assessment status shell
  OWNER / AUTHOR: Pod A — Product & Planning
  REVIEWER: Pod B — Architecture, Logic & Risk
  LEGAL REVIEW: Legal advisor required
  APPROVER: Kerem
  STATUS: v0.1 status shell — P16 cross-border determination blocked on infrastructure/vendor/logging/support/replication facts
  AUTHORITY: This document records assessment status and fact-finding requirements. It does not conclude that no transfer exists, does not authorize implementation, and does not authorize pilot operation.
  IMPLEMENTATION AUTHORITY: This document does NOT authorize Pod C.
  DATA: Synthetic examples only. No real customer/staff/Selcafe row data.
-->

## Status

| Field | Value |
|---|---|
| Document | `CROSS_BORDER_TRANSFER_ASSESSMENT.md` |
| Scope | P16 QR-linked live-bill / guest-flow cross-border transfer status shell |
| Current status | v0.1 status shell — full determination blocked on infrastructure facts |
| Implementation status | Does **not** authorize Pod C, live Selcafe reads, direct Selcafe writes, or pilot operation |
| Source issue | GitHub issue #133 |
| Legal sign-off | Required if transfer exists or determination is finalized |
| Kerem approval | Required |

## Purpose

This document records whether P16 creates a cross-border transfer and what facts are required to make that determination.

It is a status shell because current infrastructure, vendor, logging, monitoring, backup, support, AI-tooling, and Selcafe-replication facts are not fully confirmed.

## Scope

### In scope

| Area | Included |
|---|---|
| Direct local Selcafe read | Determine whether it creates a transfer by itself |
| Backend/database/logs/monitoring/analytics/backups/CDN/WAF/support/debugging/AI tooling | Determine if P16 data is processed outside Türkiye |
| Selcafe replication | Determine whether any Selcafe-to-GCP or similar pipeline exists and what data it carries |
| Required legal mechanism | Identify later requirement if transfer exists |

### Out of scope

| Out of scope | Owner / route |
|---|---|
| Hosting/deployment selection | Pod B + Kerem |
| Vendor selection | Pod B + Kerem + legal advisor |
| Final legal conclusion | Legal advisor + Kerem |
| Implementation | Not authorized |

## Current P16 Position

[REQUIRES POD B REVIEW] [REQUIRES LEGAL ADVISOR SIGN-OFF]

The direct local Selcafe read is not treated as a cross-border transfer by itself if the read and immediate processing occur inside Türkiye and P16 data is not sent abroad.

However, cross-border transfer may arise downstream if any P16 data is processed outside Türkiye by infrastructure, logs, monitoring, backups, support, analytics, CDN/WAF, debugging, AI/support tooling, or an existing Selcafe-to-GCP or similar replication pipeline.

This document does not conclude that no cross-border transfer exists. It records the fact-finding required to make that determination.

## Infrastructure Fact-Finding Matrix

| Area | Required fact | Status |
|---|---|---|
| Backend hosting | Provider, region, data categories processed | [BLOCKED — INFRA FOOTPRINT] |
| Application database | Provider, region, whether P16 data persists | [BLOCKED — INFRA FOOTPRINT] |
| Logs | Provider, region, fields captured, whether P16 identifiers/order lines are logged | [BLOCKED — INFRA FOOTPRINT] |
| Monitoring / error tracking | Provider, region, payload minimization, P16 fields captured | [BLOCKED — INFRA FOOTPRINT] |
| Analytics | Whether P16 data or session identifiers enter analytics | [BLOCKED — INFRA FOOTPRINT] |
| Crash reporting | Whether P16 payloads can appear in crash/error reports | [BLOCKED — INFRA FOOTPRINT] |
| Backups | Region, retention, encryption, data categories included | [BLOCKED — INFRA FOOTPRINT] |
| CDN/WAF | Whether request logs include P16 identifiers or session-link metadata | [BLOCKED — INFRA FOOTPRINT] |
| Remote support | Who can access P16 data and from where | [BLOCKED — INFRA FOOTPRINT] |
| Developer debugging tools | Whether P16 logs/payloads are exported or inspected outside Türkiye | [BLOCKED — INFRA FOOTPRINT] |
| AI/support tooling | Whether logs/tickets/support data containing P16 fields are processed by AI tooling | [BLOCKED — INFRA FOOTPRINT] |
| Selcafe-to-GCP or similar replication | Whether the pipeline exists, region, tables, fields, and whether it includes P16-relevant data | [BLOCKED — FACTUAL CHECK] |

## Selcafe Replication Check

[OPEN QUESTION]

If any Selcafe-to-GCP, Airbyte, BigQuery, or similar replication pipeline exists, it creates a separate cross-border-transfer assessment issue independent of the P16 adapter read.

The following must be confirmed:

| Question | Status |
|---|---|
| Does any Selcafe replication pipeline exist? | [BLOCKED — FACTUAL CHECK] |
| Which provider and region host the replicated data? | [BLOCKED — FACTUAL CHECK] |
| Which tables/fields are replicated? | [BLOCKED — FACTUAL CHECK] |
| Are member/profile/session/bill/order-line fields included? | [BLOCKED — FACTUAL CHECK] |
| Who can access the replicated data and from where? | [BLOCKED — FACTUAL CHECK] |
| What legal transfer mechanism, if any, is in place? | [BLOCKED — LEGAL REVIEW] |

## Cross-Border Transfer Determination

| Determination | Status |
|---|---|
| Direct local Selcafe read only | Not a transfer by itself, subject to fact confirmation |
| P16 backend/database/logs/monitoring/backups/support/AI tooling | [BLOCKED — INFRA FOOTPRINT] |
| Selcafe-to-GCP or similar replication | [BLOCKED — FACTUAL CHECK] |
| Final cross-border conclusion | [BLOCKED — LEGAL ADVISOR + KEREM] |

## Required Legal Mechanism if Transfer Exists

[REQUIRES LEGAL ADVISOR SIGN-OFF]

If P16 data is processed outside Türkiye, the applicable KVKK transfer mechanism must be documented before rollout. This document does not select that mechanism.

Possible work items, depending on legal advisor determination:

| Area | Possible requirement |
|---|---|
| Vendor assessment | Data processor / sub-processor review |
| Transfer mechanism | Standard contract, adequacy/appropriate safeguard, explicit consent where legally required, or other advisor-approved route |
| Notice wording | Privacy notice cross-border transfer section |
| Retention/log minimization | Additional payload minimization or regionalization |
| Kerem approval | Required before checkpoint pass / launch |

## Open Questions

| ID | Question | Owner / route |
|---|---|---|
| CB-P16-001 | Where will the P16 backend run? | Pod B + Kerem |
| CB-P16-002 | Where will P16 database/cache/log/audit data reside? | Pod B + Kerem |
| CB-P16-003 | What monitoring/error/logging vendors will process P16 data? | Pod B + Kerem |
| CB-P16-004 | Are backups stored outside Türkiye? | Pod B + Kerem |
| CB-P16-005 | Does CDN/WAF logging include P16 identifiers? | Pod B |
| CB-P16-006 | Does any remote support/debugging process expose P16 data outside Türkiye? | Pod B + Kerem |
| CB-P16-007 | Does any AI/support tooling process P16 logs, tickets, or payloads? | Pod B + legal advisor + Kerem |
| CB-P16-008 | Does any Selcafe-to-GCP or similar replication pipeline exist? | Kerem + Pod B |
| CB-P16-009 | If transfer exists, what legal transfer mechanism applies? | Legal advisor + Kerem |

## Build-Gating Rules

| Gate | Rule |
|---|---|
| CB-GATE-001 | This shell does not conclude that no cross-border transfer exists. |
| CB-GATE-002 | P16 checkpoint pass remains blocked until infrastructure facts are known and legal advisor/Kerem approve the determination. |
| CB-GATE-003 | No P16 implementation or pilot operation is authorized by this document. |
| CB-GATE-004 | If P16 data leaves Türkiye, legal mechanism and notice updates are required before rollout. |

## Review Routing

| Review item | Required |
|---|---|
| Ready for commit | Yes — as v0.1 status shell |
| Ready for final determination | No |
| Requires Pod B review | Yes |
| Requires legal advisor sign-off | Yes, before final determination |
| Requires Kerem approval | Yes |
| Requires Pod C implementation | No |

## Document History

| Version | Date | Author | Change |
|---|---|---|---|
| v0.1 status shell | 2026-07-01 | Pod A | Initial P16 cross-border transfer assessment shell. Final determination blocked on infrastructure and replication facts. |
