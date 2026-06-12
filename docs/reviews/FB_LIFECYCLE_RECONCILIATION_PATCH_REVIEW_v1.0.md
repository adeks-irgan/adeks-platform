# Pod B Review Note — F&B Order Lifecycle Reconciliation Patch

## Status

| Field | Value |
|---|---|
| Document | FB_LIFECYCLE_RECONCILIATION_PATCH_REVIEW_v1.0.md |
| Version | v1.0 |
| Type | Pod B review note |
| Reviewer | Pod B — Architecture, Logic & Risk |
| Review date | 2026-06-12 |
| Patch reviewed | Pod A F&B lifecycle reconciliation patch to `BUSINESS_RULES.md`, `OPEN_QUESTIONS.md`, `MVP_SCOPE.md` |
| Target branch | `docs/fb-lifecycle-reconciliation-rec-fixes` |
| PR | #54 |

## Freshness Baseline

All files read from live `main` at session start on 2026-06-12.

| File | SHA at time of review |
|---|---|
| `docs/BUSINESS_RULES.md` | f7b58883 |
| `docs/OPEN_QUESTIONS.md` | 3c4de451 |
| `docs/MVP_SCOPE.md` | a9a7b35a |
| `docs/reviews/FB_ORDER_LIFECYCLE_REVIEW_v1.0.md` | e2a85905 |
| `docs/PROJECT_METHODOLOGY.md` | d3355d0 (via raw fetch) |
| `docs/AGENT_CONTEXT_MANIFEST.md` | 47ba17e (via raw fetch) |

## Review Type

Narrow documentation-class reconciliation patch review. Does not constitute state machine design. Does not authorize Pod C.

## Review Verdict

**Approved — non-blocking findings only, with one advisory (REC-001) requiring a Pod A correction before commit.**

The Pod A reconciliation patch correctly folds Kerem's F&B lifecycle decisions from the 2026-06-12 decision packet into `BUSINESS_RULES.md`, `OPEN_QUESTIONS.md`, and `MVP_SCOPE.md`. Stale "Kerem decision needed" language for resolved items has been removed. Remaining F&B work is correctly routed to Pod B formalization. Pod C remains blocked. The patch does not accidentally resolve any design-class item.

Two findings are raised. Neither is blocking for commit. REC-001 requires a Pod A wording correction before merge.

## Findings

### REC-001 — Advisory (Pod A correction required before commit)

**Document:** `BUSINESS_RULES.md` (BR-FB-004)

**Finding:** The BR-FB-004 entry stated `"Until Preparing" means cancellation is allowed before the order enters Preparing, not after Preparing has started` without an explicit source attribution. In `FB_ORDER_LIFECYCLE_REVIEW_v1.0.md` §3, Finding FB-003 classifies this as a Pod B assumption requiring validation, not a confirmed fact. The patch promoted the assumption to a confirmed business rule without recording the confirmation source.

**Required action:** Add `[CONFIRMED by Kerem, 2026-06-12 F&B lifecycle decision packet]` as the explicit attribution, or mark it as an assumption if only implied. Do not assert it as a plain confirmed rule without attribution.

**Resolution:** Applied in commit `94e5521` on branch `docs/fb-lifecycle-reconciliation-rec-fixes`. BR-FB-004 now reads `[CONFIRMED by Kerem, 2026-06-12 F&B lifecycle decision packet]`.

### REC-002 — Non-blocking (housekeeping required before commit)

**Document:** `OPEN_QUESTIONS.md`

**Finding:** OQ-ORDER-001 through OQ-ORDER-004 remained in the active open-questions table after Kerem's 2026-06-12 decisions resolved them. The "Kerem decisions needed next" list still included items 10–13 referencing those same resolved questions.

**Required action:** Move OQ-ORDER-001–004 to the "Resolved / No Longer Open" section with resolution notes and "Do not reopen" guardrails. Remove items 10–13 from the "Kerem decisions needed next" list and renumber.

**Resolution:** Applied in commit `94e5521` on branch `docs/fb-lifecycle-reconciliation-rec-fixes`.

## Scope Verification

| Check | Result |
|---|---|
| Stale "Kerem decision needed" language removed for resolved F&B lifecycle items | ✓ Confirmed |
| Remaining F&B work correctly routed to Pod B formalization/review | ✓ Confirmed — every resolved rule carries `[REQUIRES POD B REVIEW]` |
| Pod C remains blocked | ✓ Confirmed — all three documents carry explicit "Ready for Pod C? No" statements |
| Patch does not resolve state machine, actor, audit-field, wallet-ledger, loyalty-ledger, reversal, API, schema, or security/KVKK design | ✓ Confirmed — all design items left open with `[REQUIRES POD B REVIEW]` |
| Patch does not implement code or draft Pod C implementation issues | ✓ Confirmed |

## Additional Observations

**Corrections from `FB_ORDER_LIFECYCLE_REVIEW_v1.0.md` §6 applied correctly:**
- Finding FB-011 (`Rejected` status wording): corrected in `BUSINESS_RULES.md`.
- Finding FB-008/§5 (payment-boundary guardrail): added to combined-status row.

**`FB_ORDER_LIFECYCLE_REVIEW_v1.0.md` §6 blocked-items table is now partially superseded.** Findings FB-001, FB-002, FB-006, and FB-007 are resolved by Kerem's 2026-06-12 decisions and recorded in `BUSINESS_RULES.md`. The §6 "Not yet" readiness verdict must not be taken as current in a future Pod B state machine session without cross-checking live `BUSINESS_RULES.md`.

**`MVP_SCOPE.md` trailing stale line (advisory, non-blocking for PR #54):** The "F&B ordering — Status updates" row still read "exact customer-visible statuses unresolved" at time of this review. Flagged for Pod A follow-on pass. Resolved separately in PR #55.

## Readiness Statement

**Ready for Kerem review and commit (PR #54)?** Yes, after REC-001 and REC-002 corrections are applied.

**Ready for Pod B state machine formalization session?** Closer than before. Pre-conditions from `FB_ORDER_LIFECYCLE_REVIEW_v1.0.md` §6 are substantially reduced: FB-001, FB-002, FB-006, and FB-007 are resolved. Remaining Pod B-internal design items (actor assignments, concurrency, combined-status model, audit-field design) have no outstanding Kerem product decisions blocking them.

**Ready for Pod C issue drafting?** No. Pod B formal state machine design must be completed, reviewed, and approved first.
