# KVKK_LEGAL_BASIS.md

<!--
  CANONICAL REPO PATH: /docs/KVKK_LEGAL_BASIS.md
  DOCUMENT TYPE: Pod A / legal-KVKK planning artifact
  OWNER / AUTHOR: Pod A — Product & Planning
  REVIEWER: Pod B — Architecture, Logic & Risk
  LEGAL REVIEW: Legal advisor required
  APPROVER: Kerem
  STATUS: v0.1 draft — P16 QR-linked live-bill / guest-flow legal-basis matrix; requires legal advisor sign-off, Pod B review, and Kerem approval before merge/checkpoint pass
  AUTHORITY: This document records proposed legal-basis mapping for project review. It does not itself establish final legal policy, authorize implementation, authorize live Selcafe reads, or satisfy the Operating Slice Checkpoint until reviewed, signed off, and approved.
  IMPLEMENTATION AUTHORITY: This document does NOT authorize Pod C.
  DATA: Synthetic examples only. No real customer, staff, transaction, Selcafe row, credential, or secret data.
-->

## Status

| Field | Value |
|---|---|
| Document | `KVKK_LEGAL_BASIS.md` |
| Scope | Phase 1 legal-basis matrix, with P16 QR-linked live-bill / guest-flow entries |
| Current status | v0.1 draft — requires legal advisor sign-off, Pod B review, and Kerem approval |
| Implementation status | Does **not** authorize Pod C, schema/API work, live Selcafe reads, direct Selcafe writes, or pilot operation |
| Source issue | GitHub issue #133 |
| Legal sign-off | Required before Operating Slice Checkpoint pass |
| Kerem approval | Required before merge/checkpoint pass |

## Purpose

This document records the proposed KVKK legal-basis mapping for Adeks Platform Phase 1 processing activities.

For P16, it converts the recorded legal-advisor position into repository-visible draft rows for review. It does not replace legal-advisor sign-off and does not authorize implementation.

## Scope

### In scope for v0.1

| Area | Included |
|---|---|
| P16 QR-linked live-bill / guest flow | Legal-basis rows for QR-linked active bill display, QR session-link management, order-line visibility, discount reflection verification, security/audit metadata, and account-linked benefits |
| Controller position | Current pilot controller position recorded as Adeks Bilişim Hizmetleri Ltd. Şti. |
| Review routing | Legal advisor sign-off, Pod B review, Kerem approval |

### Out of scope for v0.1

| Out of scope | Owner / route |
|---|---|
| Final legal approval | Legal advisor + Kerem |
| Data retention periods as final policy | `DATA_RETENTION_POLICY.md` + legal advisor + Kerem |
| Cross-border transfer determination | `CROSS_BORDER_TRANSFER_ASSESSMENT.md` + Pod B + legal advisor + Kerem |
| Security/access-control design | `SECURITY_REVIEW.md` + Pod B |
| Schema/API contracts | Pod B only after checkpoint pass |
| Pod C implementation | Not authorized |

## Source Context

| Source | Use |
|---|---|
| `docs/adr/ADR-005-selcafe-read-only-adapter.md` | P16 QR-linked live-bill conditional read surface; read-only Selcafe posture; hard exclusions; SR-003-5…13 |
| `docs/legal/P16_Final_KVKK_Position.md` | Final legal residual position for P16 |
| `docs/legal/P16_Selcafe_QR_Live_Bill_KVKK_Consolidated_Advisor_Comment.md` | Prior consolidated legal-advisor comment |
| `docs/DATA_PROCESSING_INVENTORY.md` | Data-surface inventory; to be updated to v0.3 |
| GitHub issue #133 | Planning/review thread and Pod B review findings |

If any source conflicts with an accepted ADR, the accepted ADR governs and this document must be corrected.

## Legal Basis Principles

| ID | Principle |
|---|---|
| LBP-001 | P16 live bill and itemized order-line data are treated as personal data, not anonymous data. |
| LBP-002 | Core QR-linked live-bill viewing is not based on explicit consent. |
| LBP-003 | The primary proposed basis for core live-bill display is KVKK Art. 5/2(c), processing necessary for contract performance. |
| LBP-004 | QR security, abuse prevention, and short technical logs may rely on legitimate interest where legally confirmed. |
| LBP-005 | Dispute, complaint, fraud, or chargeback evidence may rely on rights protection where legally confirmed. |
| LBP-006 | Fiscal/accounting records may rely on legal obligation and/or rights protection depending on exact record type. |
| LBP-007 | Optional marketing remains outside P16 core processing and requires a separate lawful basis/consent model. |
| LBP-008 | Legal advisor sign-off and Kerem approval are required before these rows become project policy. |

## Controller Position

[REQUIRES LEGAL ADVISOR SIGN-OFF] [NEEDS KEREM APPROVAL]

For the current P16 controlled pilot, the draft controller position is:

> Adeks Bilişim Hizmetleri Ltd. Şti. is the data controller for the P16 pilot.

This is recorded as same-controller internal processing for the current single-entity café/Selcafe/Adeks Platform pilot. If Adeks Platform is later offered to other café operators, operated by a separate entity, or expanded as SaaS/multi-tenant service, controller/processor allocation must be reassessed.

## Phase 1 Legal Basis Matrix

### P16 — QR-Linked Live-Bill / Guest Flow

All rows below are draft rows and require legal advisor sign-off and Kerem approval.

| Processing activity | Data categories | Purpose | Proposed lawful basis | Retention pointer | Notes / constraints |
|---|---|---|---|---|---|
| QR-linked active bill display | Station/session context; current active bill total/status; current itemized F&B order lines | Let the QR-linked physical session participant view the current active bill during service | KVKK Art. 5/2(c) — contract performance | Live projection: no persistence; order-line cache session-only + 15–60 min TTL | Guest account not required. Do not frame as anonymous. Do not use explicit consent for core bill viewing. |
| QR session-link management | QR token metadata; session-link reference; station/session reference; timestamps; used/expired/revoked status | Bind the PWA session to the physical station/session and authorize current-bill access | Contract performance + legitimate interest for access-control/security | Active session state until bill/session closes; metadata 30 days | Token must be one-time/short-lived, non-guessable, session-bound, and staff-revocable. |
| Order-line visibility | Current active F&B item references, quantities, and line amounts | Display the current active order lines on the linked live bill | KVKK Art. 5/2(c) — contract performance | Session-only cache; delete at bill close where detectable; hard TTL 15–60 min | No full order-line persistence in logs/audit. No historical bills in guest mode. |
| Discount reflection verification | Dedicated Adeks transaction type; pseudorandom one-time code; discount amount; timestamp; reconciliation status | Verify that a cashier-entered Adeks discount was reflected in Selcafe | Contract performance + rights protection; legal obligation where fiscal record applies | Adeks mapping 90–180 days; fiscal Selcafe-side record per accounting/tax/commercial rule | Mapping remains in Adeks. Selcafe record must not contain Adeks account ID, Selcafe member ID, phone, name, email, profile, or avoidable coupon ID. |
| Security/audit metadata | Pseudonymized session/account reference where applicable; event timestamps; outcome metadata; revoke/mis-link evidence | Security, abuse prevention, complaint handling, and audit | Legitimate interest + rights protection | Security/audit logs 6–12 months; view evidence 30 days metadata-only | Metadata-only where possible. No member identity or full order-line persistence in logs. |
| Account-linked discounts, coupons, points, and account history | Adeks account reference; coupon/points activity; account-linked history | Provide account benefits outside guest-only flow | Contract performance; explicit consent only for optional marketing | Per account/loyalty/account-history retention policy | Adeks account required. Guest mode cannot use discounts/coupons/points or account-linked history. |

## Items Requiring Legal Advisor Sign-Off

| Item | Required sign-off |
|---|---|
| P16 basis mapping for contract performance / legitimate interest / rights protection / legal obligation | Required |
| Decision not to use explicit consent for core live-bill viewing | Required |
| Controller position for current pilot | Required |
| Guest-mode legal wording and expectation management | Required |
| Retention basis for 30-day evidence and 90–180-day discount mapping | Required |
| Fiscal/accounting classification for Selcafe-side discount record | Required |
| Cross-border transfer status once infrastructure facts are known | Required |
| Age-restricted item handling in guest mode | Required |
| Staff-mediated-only guest payment gate | Required |

## Open Questions

| ID | Question | Owner / route | Status |
|---|---|---|---|
| KLB-P16-001 | Does the legal advisor approve the P16 legal-basis matrix rows as drafted? | Legal advisor + Kerem | Open |
| KLB-P16-002 | What exact fiscal/commercial retention rule applies to Selcafe-side discount records? | Legal advisor/accounting + Kerem | Open |
| KLB-P16-003 | Does P16 data leave Türkiye through hosting, logs, monitoring, backups, support, AI tooling, or a Selcafe replication pipeline? | Pod B + legal advisor + Kerem | Open |
| KLB-P16-004 | How should age-restricted F&B items be blocked or staff-confirmed in guest mode? | Pod A + Pod B + legal advisor + Kerem | Open |
| KLB-P16-005 | What is the precise product definition of “current active bill” when Selcafe transfers/merges exist? | Pod A + Pod B + Kerem | Open |

## Build-Gating Rules

| Gate | Rule |
|---|---|
| KLB-GATE-001 | This document does not authorize Pod C. |
| KLB-GATE-002 | Legal advisor sign-off and Kerem approval are required before these rows become project policy. |
| KLB-GATE-003 | P16 cannot pass the Operating Slice Checkpoint from this document alone. |
| KLB-GATE-004 | P16 implementation remains blocked by all required compliance artifacts, `SECURITY_REVIEW.md` reconciliation, pilot risk register, cross-border status, and a later separately approved DoR issue. |
| KLB-GATE-005 | Consent must not be introduced as the basis for core live-bill viewing without renewed legal advisor review and Kerem approval. |

## Review Routing

| Review item | Required |
|---|---|
| Ready for commit | Yes — as v0.1 draft only |
| Ready for merge | No — requires legal advisor sign-off, Pod B review, and Kerem approval |
| Requires Kerem approval | Yes |
| Requires Pod B review | Yes |
| Requires legal advisor sign-off | Yes |
| Requires Pod C implementation | No |
| Requires Pod D review | Later only if UI notice / guest flow / monitoring UX is changed |

## Document History

| Version | Date | Author | Change |
|---|---|---|---|
| v0.1 draft | 2026-07-01 | Pod A | Initial P16 legal-basis matrix for QR-linked live-bill / guest flow. Does not authorize implementation. |
