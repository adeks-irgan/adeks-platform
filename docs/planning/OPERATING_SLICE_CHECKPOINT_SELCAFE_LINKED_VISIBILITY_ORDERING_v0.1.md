# Operating Slice Checkpoint — Selcafe-Linked Customer Visibility and Ordering v0.1

## Status

| Field | Value |
|---|---|
| Document | `OPERATING_SLICE_CHECKPOINT_SELCAFE_LINKED_VISIBILITY_ORDERING_v0.1.md` |
| Proposed path | `/docs/planning/OPERATING_SLICE_CHECKPOINT_SELCAFE_LINKED_VISIBILITY_ORDERING_v0.1.md` |
| Owner | Pod A — Product & Planning |
| Reviewer | Pod B — Architecture, Logic & Risk |
| Approver | Kerem |
| Artifact type | Planning-only Operating Slice Checkpoint status record |
| Slice | Product Phase 1 — Selcafe-linked customer visibility and ordering |
| Current checkpoint result | **Not satisfied** |
| Product-side cleanup status | BR-FB account-boundary contradiction corrected in the same docs-only pass; checkpoint can be treated as product-clean only after this PR lands |
| Implementation status | Does **not** authorize Pod C |
| Data rule | Synthetic examples only; no real customer, staff, transaction, Selcafe row, credential, screenshot, wallet, loyalty, reservation, or secret data |
| Selcafe posture | Phase 1 remains read-only toward Selcafe |
| ADR status | Does not edit, supersede, or expand ADR-005 |
| Command keyword used for package | `gitpkm` — Pod-authored edits, Kerem-applied macOS shell |

---

## 1. Purpose

This artifact records the Product Phase 1 Operating Slice Checkpoint status for:

> **Selcafe-linked customer visibility and ordering**

The checkpoint exists before slice-level Lifecycle Phase 7 work can begin for this operating slice.

This artifact consolidates product/planning alignment only. It does not authorize:

- Pod C implementation;
- component-level ADR drafting;
- schema design;
- API contracts;
- SelcafeAdapter implementation;
- direct Selcafe writes;
- wallet/payment implementation;
- real data use;
- ADR-005 edits.

---

## 2. Source Basis

| Source | Use in this checkpoint |
|---|---|
| `/docs/PHASE_GATES.md` | Defines the Operating Slice Checkpoint as a Phase 7 entry criterion. |
| `/docs/PROJECT_SEQUENCE_STATUS.md` | Mirrors current gate status and records that this operating slice has not entered Phase 7. |
| `/docs/KEREM_DECISIONS.md` §21 | Records K-21, K-OS-008, and K-OS-009. |
| `/docs/PROJECT_DECISION_INDEX.md` | Mirrors locked decision state for K-21, K-OS-008, and K-OS-009. |
| `/docs/CORE_USER_FLOWS.md` §4 | Defines the QR-reconciled Selcafe-linked customer visibility and ordering flow. |
| `/docs/MVP_SCOPE.md` | Defines Phase 1 scope and operating-spine alignment. |
| `/docs/BUSINESS_RULES.md` | Defines operating-spine business rules; BR-FB account-boundary wording was corrected in the same docs-only pass as this checkpoint artifact. |
| `/docs/PROJECT_BRIEF.md` | Provides Phase 1 Selcafe/read-only and operating-spine framing. |
| `/docs/adr/ADR-005-selcafe-read-only-adapter.md` | Governs the current accepted Selcafe read-only adapter boundary. |
| `/docs/planning/SESSION_LINKING_QR_HANDSHAKE_DESIGN_v0.1.md` | Provides QR-handshake design evidence and SL-1…SL-7. |
| `/docs/OPEN_QUESTIONS.md` | Tracks OQ-OS blockers for active bill/order-line visibility and KVKK/legal review. |

---

## 3. Scope Decision

Kerem selected the whole-slice path:

> Keep the Phase 1 operating slice whole: **QR-link + live bill visibility + F&B ordering**.

Do **not** carve a thinner order-only sub-slice.

This means product-side cleanup may make the slice product-clean, but the checkpoint still remains **not satisfied** until the legal/KVKK and ADR-005 gates for live bill / active order-line visibility are closed.

---

## 4. Operating Slice Definition

### 4.1 Slice Name

**Selcafe-linked customer visibility and ordering**

### 4.2 Slice Intent

The slice gives customers a useful first Phase 1 PWA experience without replacing Selcafe.

The customer should be able to:

1. start a normal café visit through the cashier/Selcafe workflow;
2. link the PWA/app session to the active PC/session through a desk-side one-time QR handshake;
3. see the linked PC/session context;
4. see the full live bill, including itemized lines, only after the active bill read gate is cleared;
5. order F&B from seat;
6. use account features only where required for discounts, coupons, and points;
7. pay final settlement at cashier;
8. see settled amount, coupon/discount status, and loyalty/points status where later approved.

The slice preserves Selcafe as the Phase 1 operational and settlement source of truth.

---

## 5. Reconciled Product Direction

| Area | Checkpoint position |
|---|---|
| Operating-spine direction | K-21 sets the Product Phase 1 spine as Selcafe-linked customer visibility and ordering. |
| Session linking | K-OS-009 replaces typed/scanned `fiş` entry with a desk-side one-time QR handshake. |
| Guest behavior | Guest may link, see the full live bill, and order F&B without an Adeks account. |
| Account boundary | Account is required only for discounts, coupons, points, and account-linked history. |
| BR-FB correction | BR-FB account-boundary wording must align with BR-OS-003. The stale BR-FB scan found only BR-FB-001 carrying the stale `Logged-in CUSTOMER` F&B-submission wording. |
| Manual PC/session association | Manual cashier PC/session association is the Phase 1 path. |
| Auto-detect PC | Fast-follow only, behind ADR-005 read-surface expansion and legal/KVKK clearance. |
| F&B order bridge | Cashier manually enters accepted PWA orders into Selcafe. |
| Cashier visibility of pending PWA order | CORE_USER_FLOWS.md §4 covers cashier receipt of a PWA order queue before manual Selcafe entry at product-flow level. Detailed implementation remains out of scope. |
| Kitchen/service | Kitchen/service continue from Selcafe printed receipts in the first slice. |
| Final settlement | Selcafe remains the final settlement source of truth. |
| Discount ownership | K-OS-008 records Adeks-owned discount calculation and cashier-entered Selcafe reflection as product direction only. |
| Direct Selcafe writes | Not authorized. Human cashier bridge only. |
| Selcafe member identity/profile | Excluded. No read, derive, resolve, or display of Selcafe member identity/profile, including `adisyon.uye_no`. |
| Live-bill read | Desired product direction only; blocked until ADR-005 expansion, legal/KVKK, auditability, retention, and data minimization are resolved. |

---

## 6. K-OS-009 QR Handshake Incorporation

The Phase 1 customer-facing app session-linking path is:

> **Desk-side, one-time QR handshake.**

| ID | Incorporated checkpoint rule |
|---|---|
| SL-1 | Linking is exclusively through a desk-side one-time QR handshake. No typed/scanned `fiş` entry exists in the Customer PWA. |
| SL-2 | Two scan directions are supported: desk/customer-facing screen QR scanned by customer, or customer app QR scanned by cashier. |
| SL-3 | QR token is random, single-use, bound to exactly one `(PC, Adeks session-link)`, seconds-scale, and burned on first successful scan. |
| SL-4 | PC/session association is manual first. Auto-detect PC is fast-follow behind ADR-005 read-surface expansion and legal/KVKK clearance. |
| SL-5 | No in-seat late-joiner fallback. Customer revisits cashier for a fresh QR. |
| SL-6 | Guest may order F&B and see the full live bill, including itemized lines, without an account. Account required only for discounts, coupons, and points. |
| SL-7 | First-timer lands as guest; signup/login is offered alongside ordering, not before ordering. |

---

## 7. K-OS-008 Discount Direction Incorporation

K-OS-008 is incorporated as product direction only.

At PWA pilot:

- Selcafe member-discount mechanism is retired for Adeks discounts.
- Adeks owns and calculates coupon/loyalty discounts.
- `adisyon.uye_indirim` is unused for Adeks discount handling.
- Cashier reflects an Adeks discount into Selcafe using a fixed-format `kasaislem` record:
  - dedicated Adeks `islem_tip`;
  - pseudorandom one-time code in `kasaislem.aciklama`;
  - positive discount amount in `kasaislem.alacak`;
  - no `adisyon_no`;
  - no Adeks customer id;
  - no coupon id;
  - no member id;
  - no other Adeks identity.
- Adeks holds the internal `code → linked Selcafe bill/addition → expected discount` mapping.
- Adeks later reads the linked bill and matching `kasaislem` discount row where feasible, compares net settlement against Adeks calculation, and green-lights cashier only within the approved 2% threshold.
- No clean match fails closed to manual check.
- Selcafe remains the settlement source of truth.

### Gate status

This direction does not authorize:

- direct Selcafe writes;
- `kasaislem` write automation;
- `adisyon` / `kasaislem` implementation reads;
- schema/API work;
- Pod C implementation.

The read/reflection path remains blocked on ADR-005 read-surface reconciliation, KVKK/legal review, auditability, retention, and data-minimization review.

---

## 8. Live-Bill Read Gate

The product target includes full live-bill visibility for the QR-linked active visit/session, including itemized lines and cashier/staff-entered F&B items not submitted through Adeks PWA.

However, this remains gated.

| Gate | Status |
|---|---|
| ADR-005 read-surface expansion | Open / required |
| Legal/KVKK review | Open / required |
| Auditability review | Open / required |
| Retention policy | Open / required |
| Data-minimization review | Open / required |
| Pod B review | Required |
| Kerem approval | Required |

QR opt-in improves the product/security posture, but it is not legal clearance and does not close the live-bill read gate.

---

## 9. Selcafe Member Identity/Profile Exclusion

The operating slice must not read, derive, resolve, display, log, or persist Selcafe member identity/profile data.

This includes:

- no `dbo.uye` read;
- no Selcafe member profile read;
- no Selcafe member phone/name/address/email read;
- no `adisyon.uye_no` read;
- no `kasaislem.uye_no` read;
- no `kuyruk.uye_no` read;
- no attempt to resolve a QR-linked app session to a Selcafe member;
- no display of Selcafe member identity/profile in Customer PWA, cashier/admin UI, logs, tests, or examples.

The QR handshake binds:

> app session → Adeks-native session-link → PC/session

It does not bind:

> app session → Selcafe member

---

## 10. Product-Side Cleanup Findings

| Finding | Status in this checkpoint |
|---|---|
| Slice should not be split into an order-only sub-slice | Resolved by Kerem: keep the whole slice. |
| BR-FB vs BR-OS ordering/account-boundary contradiction | Must be fixed in the same docs-only pass before this artifact is product-clean. |
| Stale BR-FB row enumeration | Scan found only BR-FB-001 carrying stale `Logged-in CUSTOMER` F&B-submission wording. |
| CORE_USER_FLOWS.md §4 cashier order visibility | Verified at product-flow level: cashier receives PWA order queue, checks order, then manually enters accepted order into Selcafe. No implementation detail is authorized. |
| PROJECT_BRIEF.md / MVP_SCOPE.md stale account-boundary prose | Narrow cleanup is permitted only where directly tied to QR/K-21 account-boundary shift. |

---

## 11. Checkpoint Evaluation

| Checkpoint condition | Current status | Result |
|---|---|---|
| End-to-end product slice named | Selcafe-linked customer visibility and ordering is named and recorded. | Met |
| Slice scope fork closed | Whole slice retained; no order-only sub-slice. | Met |
| Customer/staff flow reconciled | CORE_USER_FLOWS.md §4 reflects QR-handshake flow and cashier queue/manual Selcafe entry at product-flow level. | Met at product-flow level |
| K-21 incorporated | K-21 direction is recorded. | Met |
| K-OS-008 incorporated | Discount direction incorporated as product direction only. | Met |
| K-OS-009 incorporated | QR handshake SL-1…SL-7 incorporated. | Met |
| Guest behavior incorporated | Guest may link, see full live bill, and order F&B; account only for discounts/coupons/points. | Met at product-rule level |
| BR-FB / BR-OS account-boundary contradiction | Must be corrected in this PR. | Met only after this PR lands |
| Manual PC/session association identified as Phase 1 path | Manual first; auto-detect fast-follow only. | Met |
| Phase 1 read-only Selcafe posture preserved | No direct Selcafe writes authorized. | Met |
| Selcafe member identity/profile exclusion preserved | No read/derive/resolve/display of `adisyon.uye_no` or member profile. | Met as product constraint |
| ADR-005 conflict/reconciliation closed | Not closed. Active bill/order-line visibility still requires ADR-005 read-surface expansion. | **Not met** |
| Human KVKK/legal gate closed | Not closed. | **Not met** |
| Auditability reviewed | Not closed for live-bill / active order-line read path. | **Not met** |
| Retention reviewed | Not closed. | **Not met** |
| Data minimization reviewed | Not closed for active bill/order-line path. | **Not met** |
| Kerem approval for checkpoint pass | Not recorded for this checkpoint artifact. | **Not met** |

---

## 12. Checkpoint Result

**Result: Operating Slice Checkpoint is not satisfied.**

After the BR-FB account-boundary contradiction is corrected in the same PR, the slice can be treated as **product-clean but still not checkpoint-satisfied**.

The remaining blockers are legal/KVKK and ADR-005 stack blockers, not product-side slice-scope blockers.

The following may proceed:

- planning documentation;
- checkpoint-status documentation;
- legal/KVKK preparation;
- Pod B read-surface reconciliation analysis;
- Pod A/Kerem decision-prep.

The following must not proceed:

- component-level ADR drafting for this slice;
- schema/API contracts for this slice;
- implementation-ready issue drafting for this slice;
- Pod C implementation;
- Selcafe live-bill reads;
- direct Selcafe writes;
- real data use.

---

## 13. Remaining Blockers

| Blocker | Owner / route | Required before checkpoint can pass |
|---|---|---|
| Human KVKK/legal gate | Kerem + legal advisor + Pod B | Legal basis and sufficiency for QR-linked live-bill / active order-line visibility, including guest-not-member case. |
| ADR-005 read-surface reconciliation | Pod B + Kerem | Determine whether and how ADR-005 can expand to support active bill/order-line reads while preserving hard exclusions. |
| Auditability | Pod B + Kerem | Define audit evidence for QR linking, live-bill reads, cashier manual bridge, discount reflection, mismatch checks, and correction paths. |
| Retention | Kerem + legal advisor + Pod B | Define retention periods for session-link, live-bill view evidence, order-line visibility, discount code mapping, audit logs, and related records. |
| Data minimization | Pod B + legal/KVKK + Kerem | Confirm minimal projection, no member identity/profile, no `adisyon.uye_no`, no unnecessary Selcafe fields. |
| Kerem checkpoint approval | Kerem | Approve this checkpoint status and later approve checkpoint pass only after all conditions are explicitly met. |

---

## 14. Review Routing

| Route | Status |
|---|---|
| Ready for commit | Yes, as a planning-only checkpoint-status artifact in the same PR as the BR-FB account-boundary correction. |
| Requires Kerem approval | Yes. Required to accept checkpoint status; later required again to mark checkpoint satisfied. |
| Requires Pod B review | Yes. Required for ADR-005 reconciliation, read-surface, auditability, security, KVKK, and Selcafe integration implications. |
| Requires Pod C implementation | No. Not authorized. |
| Requires Pod D prototype/audit/monitoring review | Later, after Pod B defines risk/audit boundaries for desk QR UX, mismatch warnings, pilot pause visibility, and first-week admin checks. |

---

## 15. Final Notice

This artifact is a checkpoint-status artifact, not a checkpoint pass.

It records that the Product Phase 1 operating slice is product-clean after the same-PR BR-FB account-boundary correction, but not legally, architecturally, or operationally cleared enough to begin slice-level component architecture/design work.
