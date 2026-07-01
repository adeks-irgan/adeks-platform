# P16_PILOT_RISK_REGISTER.md

<!--
  CANONICAL REPO PATH: /docs/P16_PILOT_RISK_REGISTER.md
  DOCUMENT TYPE: Pilot risk register
  OWNER / AUTHOR: Pod B — Architecture, Logic & Risk
  PRODUCT REVIEW: Pod A — Product & Planning
  APPROVER: Kerem
  LEGAL REVIEW: Legal advisor where personal-data/legal acceptance is implicated
  STATUS: v0.1 draft — P16 QR-linked live-bill controlled-pilot risk register; required before Operating Slice Checkpoint pass
  AUTHORITY: This risk register records accepted/residual pilot risks and mitigations for review. It does not authorize pilot operation, implementation, or live Selcafe reads.
  IMPLEMENTATION AUTHORITY: This document does NOT authorize Pod C.
  DATA: Synthetic examples only. No real customer/staff/Selcafe row data.
-->

## Status

| Field | Value |
|---|---|
| Document | `P16_PILOT_RISK_REGISTER.md` |
| Scope | P16 QR-linked live-bill / guest-flow controlled pilot risk register |
| Current status | v0.1 draft — requires Pod B review, Pod A product review where needed, legal advisor sign-off where legal acceptance is implicated, and Kerem approval |
| Implementation status | Does **not** authorize Pod C, live Selcafe reads, direct Selcafe writes, or pilot operation |
| Source issue | GitHub issue #133 |
| Kerem approval | Required |

## Purpose

This document records the residual risks accepted or requiring mitigation for the P16 QR-linked live-bill controlled pilot.

It exists because the P16 legal position accepts certain residual risks only under strict conditions: current-bill-only, session-bound, non-identity projection, no transferred/historical bill access, short retention, staff revocation, no in-app guest payment, and minimized logging.

## Scope

### In scope

| Area | Included |
|---|---|
| QR mis-link / wrong scan risk | Wrong station/session QR use, customer confusion, staff correction |
| Shared-tab/session-participant risk | QR holder may see current order lines entered under another person’s Selcafe member session |
| Transfer/merge exposure risk | Risk from following transferred/merged bills; pilot default is not to follow |
| Member identity leakage | Risk from accidental joins/logs/columns; controlled by hard exclusions and DB/query-layer denies |
| Over-retention | Risk from retaining live bills/order lines too long |
| Discount-code linkage | Risk that one-time code becomes durable cross-system identifier |
| Age-restricted items | Guest mode item-control risk |
| Operational incidents | Mis-link complaints, revoke failures, abnormal QR attempts |

### Out of scope

| Out of scope | Owner / route |
|---|---|
| Implementation design | Pod B design later; Pod C only after approved issue |
| Schema/API contracts | Not in this register |
| Production incident process | Separate incident/rollback documentation |
| Legal conclusion | Legal advisor + Kerem |
| Pilot go/no-go | Kerem |

## Pilot Preconditions

| ID | Precondition | Status |
|---|---|---|
| P16-PC-001 | ADR-005 v1.2 read surface accepted and not widened | Met at ADR level; implementation still blocked |
| P16-PC-002 | `KVKK_LEGAL_BASIS.md` P16 rows drafted, signed off, and approved | Open |
| P16-PC-003 | `DATA_PROCESSING_INVENTORY.md` v0.3 drafted and approved | Open |
| P16-PC-004 | `PRIVACY_NOTICE_TR.md` P16 wording signed off and approved | Open |
| P16-PC-005 | `DATA_RETENTION_POLICY.md` P16 schedule signed off and approved | Open |
| P16-PC-006 | `CROSS_BORDER_TRANSFER_ASSESSMENT.md` status resolved or explicitly accepted as blocked/non-transfer based on facts | Open |
| P16-PC-007 | `SECURITY_REVIEW.md` P16 SR-003-5…13 / SR-006 reconciliation complete | Open |
| P16-PC-008 | Staff revoke/manual handling flow reviewed | Open |
| P16-PC-009 | Guest payment remains staff-mediated only; no in-app guest payment | Required |
| P16-PC-010 | Age-restricted item handling resolved | Open |
| P16-PC-011 | Current active bill under transfers/merges defined | Open |

## Risk Register

| ID | Risk | Level | Accepted for pilot? | Required controls / mitigations | Owner / route | Status |
|---|---|---:|---|---|---|---|
| P16-R-001 | QR holder may view current order lines entered under another person’s Selcafe member session on the shared active bill | Medium | Conditionally yes | Current-bill-only; session-bound QR; no member identity/profile/history; short-lived link; staff revocation; minimized logging | Pod B + Pod A + legal advisor + Kerem | Open |
| P16-R-002 | Wrong QR scan links customer to wrong station/session | Medium | Conditionally yes | One-time short TTL token; staff revoke; manual handling; complaint log; abnormal attempt monitoring | Pod B + Pod D later for monitoring UX | Open |
| P16-R-003 | Transfer/merge following exposes unrelated bill lines | Medium/High | No for pilot | Do not follow transfer/merge targets; define current active bill; guest path directly linked bill only | Pod A + Pod B + Kerem | Open |
| P16-R-004 | Member identity leaks through accidental join, query, or log | High | No | ADR-005 §5A.3 hard exclusions; DB/query-layer column-deny grants; no member/staff/free-text columns; regression tests | Pod B | Open |
| P16-R-005 | Raw bill-number enumeration is reintroduced | High | No | No raw `adisyon_no` to client; no customer-supplied raw bill lookup; QR token is auth factor | Pod B | Open |
| P16-R-006 | Full order-line persistence creates over-retention | Medium | No | Display/cache only; metadata-only evidence; session-only + hard TTL; no full order-line logs | Pod A + Pod B + legal advisor | Open |
| P16-R-007 | Discount code becomes durable cross-system identifier | Medium | Conditionally yes | Pseudorandom one-time code; fixed format; mapping in Adeks only; 90–180 day retention; no account/member identity in Selcafe | Pod B + legal advisor | Open |
| P16-R-008 | Guest minor orders age-restricted item | Medium/High if such items exist | Not until resolved | Block age-restricted items in guest mode or require staff confirmation; PI-3 remains open | Pod A + Pod B + legal advisor + Kerem | Open |
| P16-R-009 | Guest attempts in-app payment | Medium/High | No | Guest payment staff-mediated only; no in-app guest payment in pilot | Pod A + Kerem | Required |
| P16-R-010 | P16 data leaves Türkiye through logs, backups, monitoring, support, or AI tooling | Medium/High depending on footprint | Unknown | Complete cross-border fact-finding and legal mechanism if transfer exists | Pod B + legal advisor + Kerem | Open |
| P16-R-011 | Bill-close deletion fails because bill-close signal is unavailable or delayed | Medium | Conditionally yes | 15–60 min hard TTL fail-safe; later implementation spec must define eviction mechanics | Pod B | Open |
| P16-R-012 | Staff fails to revoke a disputed/wrong link promptly | Medium | Conditionally yes | Staff training; revoke action; complaint log; manual escalation | Kerem + Pod A + Pod B | Open |

## Incident / Complaint Log Template

Use synthetic entries only in repository examples. Real incidents must be stored only through the approved production/pilot incident process.

| Field | Description |
|---|---|
| Synthetic incident ID | Example: `P16-INC-SYN-001` |
| Date/time | Synthetic or production-approved incident timestamp only |
| Category | Wrong QR scan / mis-link complaint / transfer exposure / discount mismatch / age-restricted item / other |
| Reported by | Customer / cashier / F&B staff / admin / system |
| Personal data included? | Yes/No; avoid free text |
| Immediate action | Revoked / manual handled / escalated / no action |
| Customer impact | None / low / medium / high |
| Mitigation applied | Structured note |
| Follow-up owner | Role, not real name in docs |
| Status | Open / monitoring / resolved / escalated |

## Pilot Pause / Reassessment Triggers

| Trigger | Required response |
|---|---|
| Any member identity/profile/history exposure | Pause P16 guest live-bill pilot; route to Pod B + legal advisor + Kerem |
| Any historical/transferred bill exposure in guest mode | Pause affected path; route to Pod B + Kerem |
| Repeated wrong QR/mis-link complaints | Review QR issuance/revoke/staff workflow before continuing |
| Full order-line persistence discovered in logs | Stop logging path; review retention/security; legal advisor if personal-data exposure occurred |
| P16 data confirmed in foreign-hosted tooling without approved mechanism | Pause rollout until cross-border assessment is resolved |
| Age-restricted guest item issue | Disable affected items or require staff confirmation before resuming |

## Open Questions

| ID | Question | Owner / route |
|---|---|---|
| P16-RQ-001 | What is the staff operating procedure for wrong QR scans or disputed links? | Kerem + Pod A + Pod B |
| P16-RQ-002 | What pilot monitoring/report should summarize P16 complaints and mis-links for Kerem? | Pod A + Pod D later + Kerem |
| P16-RQ-003 | What exact threshold pauses the pilot for repeated human mis-links? | Kerem |
| P16-RQ-004 | How are age-restricted `urun` items identified or blocked? | Pod A + Pod B + Kerem |
| P16-RQ-005 | What exact current-active-bill rule applies under transfers/merges? | Pod A + Pod B + Kerem |

## Build-Gating Rules

| Gate | Rule |
|---|---|
| P16-RG-001 | This risk register does not authorize pilot operation. |
| P16-RG-002 | Kerem must approve residual-risk acceptance before checkpoint pass. |
| P16-RG-003 | Legal advisor sign-off is required where residual-risk acceptance affects personal-data/legal posture. |
| P16-RG-004 | No implementation issue may be drafted from this register alone. |
| P16-RG-005 | Any weakening of current-bill-only, non-identity, no-transfer/no-history, no-guest-payment, or minimized-retention controls requires reassessment. |

## Review Routing

| Review item | Required |
|---|---|
| Ready for commit | Yes — as v0.1 draft |
| Ready for pilot operation | No |
| Requires Pod B review | Yes |
| Requires Pod A product review | Yes, for customer/staff workflow and pilot policy |
| Requires legal advisor sign-off | Yes where legal residual-risk acceptance is implicated |
| Requires Kerem approval | Yes |
| Requires Pod C implementation | No |
| Requires Pod D review | Later for monitoring/UX audit if pilot proceeds |

## Document History

| Version | Date | Author | Change |
|---|---|---|---|
| v0.1 draft | 2026-07-01 | Pod B / Pod A package | Initial P16 controlled-pilot risk register. No implementation authorization. |
