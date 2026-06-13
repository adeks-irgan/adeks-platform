# F&B Settlement Dependencies — Pod B Review Note (K-FB-PRICE-001 / K-FB-LOY-001 / K-FB-CORR-001)

## Status

| Field | Value |
|---|---|
| Document | `FB_SETTLEMENT_DEPENDENCIES_REVIEW_v1.0.md` |
| Project | Adeks Platform |
| Owner | Pod B — Architecture, Logic & Risk |
| Reviewer / Approver | Kerem |
| Current status | **Ready for Kerem review.** Review of three F&B settlement-dependency business decisions. |
| Target repo path | `/docs/reviews/FB_SETTLEMENT_DEPENDENCIES_REVIEW_v1.0.md` |
| Scope class | Review note only — architecture / ledger / audit / security / KVKK implications. **Not** an ADR, schema, API contract, or Pod C issue. |
| Repo reconciliation | **Needs repo reconciliation** (see §0) — `SECURITY_REVIEW.md` and `DATA_PROCESSING_INVENTORY.md` are absent from `main`. Per `AGENT_CONTEXT_MANIFEST.md` Wallet/Loyalty fallback, output is a review note only and **must not** issue Pod C work. |
| Implementation status | **Does NOT authorize Pod C** (see §12). |

### Freshness baseline

All sources read **live from `main` on 2026-06-13** (raw fetch). Independent git blob/commit SHAs were **not** retrievable this session (unauthenticated GitHub API returned `403`); content was hash-pinned instead. **Per the repo-is-source-of-truth principle, `main` wins on any conflict** — re-verify before any commit.

| Source read (`/docs/…`) | sha256 (first 12) |
|---|---|
| `architecture/FB_ORDER_LIFECYCLE_STATE_MODEL_v1.0.md` | `6d792c6d295b` |
| `MVP_SCOPE.md` | `929cdd370d54` |
| `BUSINESS_RULES.md` | `211cbec203cf` |
| `OPEN_QUESTIONS.md` | `8c346af4c4a1` |
| `KEREM_DECISIONS.md` | `34164aa4207c` |
| `PROJECT_DECISION_INDEX.md` | `f64759759499` |
| `AGENT_CONTEXT_MANIFEST.md` | `4a2be5e89356` |
| `PROJECT_METHODOLOGY.md` | `593e55dc3ffa` |
| `adr/ADR-006-wallet-append-only-ledger.md` | *(read; Proposed stub)* |
| `adr/ADR-007-loyalty-append-only-ledger.md` | *(read; Proposed stub)* |

Existence checks on `main`: `ADR-006` **exists (stub)**; `ADR-007` **exists (stub)**; `SECURITY_REVIEW.md` **absent**; `DATA_PROCESSING_INVENTORY.md` **absent**; `DOMAIN_MODEL.md`, `USER_ROLES_AND_PERMISSIONS.md`, `ROLLBACK_POLICY.md`, `templates/HANDOFF_PACKET.md` present.

---

## 0. Repo reconciliation flag

Two files the Wallet/Loyalty rows of `AGENT_CONTEXT_MANIFEST.md` list as required are **absent** from `main`: `SECURITY_REVIEW.md` and `DATA_PROCESSING_INVENTORY.md`. The manifest's stated fallback is explicit:

> *"If ledger ADR, security review, or KVKK files are absent, produce product draft or review note only; mark output `Needs repo reconciliation`; do not issue Pod C implementation work."*

This note is therefore a **review note only**, marked **Needs repo reconciliation**, and issues no Pod C work. ADR-006 and ADR-007 also exist only as **Proposed stubs** (direction locked, full text pending) — confirmed by reading both files and by `PROJECT_DECISION_INDEX.md §3` ("Backlog — principle locked, ADR to write").

---

## 1. Verdict

**SAFE WITH CORRECTIONS.**

The three decisions are internally sound, consistent with the locked append-only / no-overwrite / cashier-mediated-payment principles, and consistent with the **Accepted** `FB_ORDER_LIFECYCLE_STATE_MODEL_v1.0.md`. They correctly supply the previously-tracked business inputs **D-3** (loyalty formula), **D-4** (F&B price source), and the policy for **D-5** (post-settlement correction). **None of them reopens a Locked decision**, and I found **no repository contradiction** with the Accepted lifecycle, so the lifecycle states are not reopened.

"With corrections" means two distinct things, kept separate below:

- **(a) Decision-level corrections** — a small set of Pod B ledger-precision/correction-design rules to pin when ADR-006/007 are written (§6–§8), plus a short list of Kerem follow-up confirmations (§11). These do not require the decisions to change; they refine them.
- **(b) Readiness is a separate axis.** Independent of safety, **Pod C remains blocked** (§12) — the dependent ADRs are stubs, the audit schema and KVKK artifacts are open/absent, and the "same-shift" correction boundary is undefined.

> **Pod C is NOT authorized by this note.** These decisions reduce the blocker set; they do not clear it.

The one item that prevents a plain "safe" rather than "safe with corrections" is **K-FB-CORR-001's reliance on an undefined "shift" boundary** (§3 B-1) combined with its divergence from the previously-recorded correction-authority recommendation (§3 B-2). Both are resolvable by Kerem follow-up; neither is a locked-principle conflict.

---

## 2. What these decisions map to

| Decision | Resolves dependency | Resolves / relates to open items | Lifecycle hook (already Accepted) | Reopens a locked decision? |
|---|---|---|---|---|
| K-FB-PRICE-001 — price source | D-4 (price source) | OQ-FB-002 (price at submission vs delivery) | `SUBMITTED → CONFIRMED` price snapshot | No |
| K-FB-LOY-001 — loyalty formula | D-3 (loyalty formula) | OQ-LOY-001 (accrual base), OQ-LOY-002 (formula), OQ-LOY-003 (trigger) | `PAYMENT_RECORDED → SETTLED` accrual trigger | No |
| K-FB-CORR-001 — correction policy | D-5 (correction policy) | OQ-FB-003 (post-settlement correction), OQ-AUDIT-001 (audit fields) | No new lifecycle state added | No |

All three decisions are **additive** to the Accepted lifecycle — they supply business parameters the lifecycle was explicitly waiting for (D-3, D-4, D-5). None introduces a new lifecycle state or removes an existing one.

---

## 3. Flags and issues

### A. K-FB-PRICE-001 — No flags

Price captured at submission (immutable snapshot) is the correct append-only-compatible choice. It is consistent with:
- The lifecycle's `SUBMITTED` state (price is locked at submission time per `FB_ORDER_LIFECYCLE_STATE_MODEL_v1.0.md` §1-E)
- BR-WALLET-004 / BR-LOYALTY-005 (no overwrite of ledger entries)
- The correction mechanism in K-FB-CORR-001 (corrections are compensating entries, not price edits)

No architectural flags on this decision.

### B. K-FB-CORR-001 — Two flags (resolvable; not blockers)

**B-1 — "Same shift" is undefined.** The decision says cashier self-correction is permitted "within the same shift," but "shift" is not defined in the repo. There is no `SHIFT` entity in the domain model, no shift table in any existing schema, and no shift-open/shift-close event in the lifecycle. This creates a runtime ambiguity: what does the system check to determine if a correction is in-window?

Pod B recommendation for the eligibility gate: **same operating day, before the daily end-of-day / till-close event that produces the daily settlement/top-up report** (which already exists as a compensating control — KD-F / BR-WALLET-005). This is deterministic, recorded, and does not require a new `SHIFT` entity. Alternative: a defined till-session (open→close) if Kerem wants finer-grained control. Both options are covered in §10 (C-3) and §11 (KD-1).

**B-2 — Divergence from BRD-WAL-002 recommendation.** The BRD recorded a "V-SAFE" recommendation (cashier raises correction request; ADMIN executes) for top-up corrections (BRD-WAL-002). K-FB-CORR-001 Option 3-C (cashier-executed) is a different model. Pod B is comfortable with cashier-executed F&B correction with the §10 constraint set, but Kerem should explicitly confirm: (a) whether Option 3-C is deliberate (not an oversight relative to BRD-WAL-002), and (b) whether top-up correction should align to the same model or remain V-SAFE. Recorded as KD-2 (§11).

---

## 4. K-FB-PRICE-001 — Architectural implications

- **Price snapshot field required.** The F&B order entity must store `unit_price_at_submission` (or equivalent) per line item alongside the catalog FK. This is a schema implication for Pod B's order entity design — noted for ADR-006 and the F&B order schema work.
- **Settlement uses the snapshot, not the catalog.** When a cashier records payment, the wallet debit (`FB_SETTLEMENT` entry) is computed from `unit_price_at_submission × quantity`, not from the current catalog price. No runtime price lookup at settlement time.
- **Immutable after submission.** Once the order record is created with the snapshot price, that field is never updated. Corrections go through the K-FB-CORR-001 mechanism, not through editing the order record.
- **Audit.** The `FB_SETTLEMENT` wallet entry references the order ID, which in turn carries the snapshot price — so the audit trail is complete without storing the price redundantly in the ledger entry itself. (Ledger entry references → order → snapshot price.)

---

## 5. K-FB-LOY-001 — Architectural implications

- **Formula.** `floor(settled_amount_TRY)` → 1 loyalty point per whole Turkish Lira settled. Fractional TRY does not accrue.
- **Accrual base.** The settled amount is derived from the price snapshot (K-FB-PRICE-001), not the catalog price at accrual time.
- **Trigger.** Cashier recording of payment settlement (the `PAYMENT_RECORDED → SETTLED` transition in the lifecycle). The loyalty `FB_ACCRUAL` entry (L1) is posted atomically with or immediately after the wallet `FB_SETTLEMENT` entry (S1).
- **Loyalty entry links to wallet entry.** L1 references S1 for traceability — so a correction to S1 (wallet) can be matched to the corresponding loyalty reversal. This is the structural link required by C-5 (§10).
- **Single accrual floor.** One point per whole TRY, no tiers or multipliers in Phase 1. Full loyalty scope (redemption, expiry, tiers) is outside this decision.

---

## 6. K-FB-LOY-001 — Precision notes for ADR-007

These are precision requirements that must land in ADR-007 (not decisions for Kerem — Pod B ledger design discipline):

- **P-1 — Entry type name.** Loyalty entry type for F&B accrual: `FB_ACCRUAL`. Reversal entry type for correction: `FB_ACCRUAL_REVERSAL`. These must be defined in the loyalty ledger entry-type enum alongside the existing `TOP_UP_BONUS` type.
- **P-2 — Structural link is mandatory.** The `FB_ACCRUAL` entry must carry a foreign-key reference to the originating `FB_SETTLEMENT` wallet entry. Not advisory — required for correction integrity and audit traceability.
- **P-3 — Floor is applied to the settled amount, not the order total.** If a partial settlement is ever possible (not currently modelled — flagging for completeness), the floor applies to the partial settled amount. For Phase 1, full settlement is the only modelled path.
- **P-4 — No loyalty on correction entries by default.** Loyalty accrual applies to original settlement (`FB_SETTLEMENT`). Corrections (`FB_SETTLEMENT_CORRECTION`) result in a `FB_ACCRUAL_REVERSAL` — not a new accrual on the corrected amount. The net effect is: original accrual reversed; re-accrual on the corrected amount. This is implemented as two entries: a reversal of the original L1 and a new `FB_ACCRUAL` on the corrected settled amount. ADR-007 to confirm this is the intended double-entry model.

---

## 7. K-FB-LOY-001 — Customer-facing loyalty display

The loyalty decision has a customer-facing implication that touches Pod A scope:

- The customer wallet/loyalty history view must show `FB_ACCRUAL` entries (earned points from F&B orders). The customer should be able to see: date, amount earned, and a neutral description (e.g. "Sipariş — 3 puan" / "Order — 3 points"). No internal reason codes or cashier identity should be visible.
- Correction reversals (`FB_ACCRUAL_REVERSAL`) should also appear in the history with a neutral label (e.g. "Düzeltme" / "Correction") and the net point change. Consistent with §9 (customer-visible correction history).
- **This is a Pod A alignment item** (N-5 in §13): the customer loyalty history display spec and the correction description copy need to be reflected in `CORE_USER_FLOWS.md` and `BUSINESS_RULES.md`.

---

## 8. K-FB-CORR-001 — Architectural implications (correction mechanism)

The correction mechanism design, stated at the principle level (detail in §10):

- **Two coupled compensating entries per correction.** A wallet `FB_SETTLEMENT_CORRECTION` and a linked loyalty `FB_ACCRUAL_REVERSAL`, posted atomically so the wallet and loyalty effects of a correction cannot diverge. The loyalty reversal **references** the wallet correction (C-5).
- **Bidirectional.** Corrections can be downward (over-charge) or upward (under-charge). Loyalty must follow in both directions (recompute from corrected amount). Upward corrections are subject to the negative-balance guard (C-7).
- **Full and partial both expressed the same way.** Full correction is the special case where the corrected amount is ₺0 (order effectively unwound post-settlement). No separate "void" mechanism is needed; it is one compensating entry.
- **Append-only invariant holds (P-3, BR-WALLET-004, BR-LOYALTY-005).** No balance and no prior entry is ever mutated. This also preserves the rollback-policy guarantee (`ROLLBACK_POLICY.md`: wallet/loyalty integrity failure → non-discretionary rollback) because balance remains a pure sum of immutable entries.
- **Lifecycle is not touched.** Per §10.2 / P-4, there is no un-deliver or un-settle transition; the order's fulfillment state remains `DELIVERED` and settlement remains `SETTLED`; the correction lives entirely in the ledger domain.

---

## 9. Audit / KVKK implications

- **Audit (BR-AUDIT-001/002/003).** A correction is a discretionary financial action and must emit an **immutable** audit record (no role may edit/delete audit logs). The audit captures: actor UUID, original settlement entry ref, correction entry ref, corrected amount (a **derived** value, never an overwrite — per the audit-detail prep), reason code/note, timestamp, and workflow source. The audit **event schema** (storage, tamper, retention, before/after-derived, workflow source) is **OQ-AUDIT-001 / D-6 — open** and Pod B-then-Kerem owned.
- **KVKK — reason fields are personal data (FB-010, §6.5).** Reason codes/notes linked to a customer and order are personal data. They must be covered by the project's **pseudonymization + retention** strategy so a right-to-erasure request (Art. 11) can pseudonymize the customer linkage **without** deleting the immutable ledger/audit — this is the append-only-vs-erasure tension, and the resolution is pseudonymization (consistent with the ADR-006 stub's KVKK note). `DATA_PROCESSING_INVENTORY.md`, `DATA_RETENTION_POLICY.md`, and `KVKK_LEGAL_BASIS.md` are **absent**; §20.2 requires every personal-data feature to link to the inventory, so the inventory must exist before Pod C builds this.
- **Customer-visible correction history (data minimization).** K-FB-CORR-001 says customer-visible history "should reflect correction entries, subject to Pod B/KVKK review." Pod B position: corrections appear in the **customer wallet/loyalty history** (consistent with §7 — the customer learns of charges via the wallet view, not via order status), showing a **neutral customer-facing description and the value delta only**. Do **not** expose internal reason codes, free-text operational notes, or the cashier's identity to the customer. Retention/legal basis pending OQ-LEGAL-005.
- **ADMIN reporting.** The cashier-correction report is a compensating control (parallel to the daily top-up report, BR-WALLET-005 / KD-F). Use **masked last-4 identifier only**, never full phone (BR-WALLET-006 / BRD-WAL-004 guardrail); include reason for accountability; retention pending legal; cross-border/logging only relevant if the reporting/logging infrastructure implicates OQ-LEGAL-006.
- **Security classification.** Cashier-executed financial correction is a **security-sensitive** action → **Pod B + Kerem** gate (§11.1) and **Pod B security review** (§20.3: wallet/loyalty ledger writes + audit log logic). Abuse cases that ADR-006/threat work must cover (§20.1): cashier corrects to skim value; repeated correction "churn" to mask errors; correction to inflate/deflate loyalty; correcting after the window closes; attempting to correct another cashier's settlement.

---

## 10. Required constraints for CASHIER same-shift correction

If Kerem retains the cashier-executed model (K-FB-CORR-001 Option 3-C), these are Pod B's **minimum** constraints. They must be reflected in ADR-006/007 and the audit/KVKK design before Pod C.

- **C-1 — Compensating-entry-only.** Correction = new wallet `FB_SETTLEMENT_CORRECTION` + linked loyalty `FB_ACCRUAL_REVERSAL`. Original S1/L1 entries are never edited or deleted (P-3; BR-WALLET-004; BR-LOYALTY-005; BR-AUDIT-002).
- **C-2 — Own settlements only.** A cashier may correct only settlements whose recording actor UUID matches their own. Correcting another cashier's settlement is **ADMIN-only**.
- **C-3 — Deterministic, recorded, auditable correction window (replaces "shift").** `[NEEDS KEREM APPROVAL]` Self-correction permitted only within a window bounded by a **recorded event/timestamp**, not the undefined word "shift." Pod B recommendation: **same operating day, before the end-of-day / till-close that finalizes the daily settlement/top-up report**, or a defined **till-session open→close**. Outside the window → **ADMIN-only**. (See KD-1.)
- **C-4 — Mandatory structured reason (fail-closed).** Reason code from a defined enum (minimum: `OVER_CHARGE`, `UNDER_CHARGE`, `ITEM_RETURNED`, `OPERATIONAL_OTHER`; free-text required when `OPERATIONAL_OTHER`) + actor UUID + original settlement entry ref + corrected amount (derived) + timestamp. Mirrors the §6.3 reject/cancel reason discipline and §20.2 "reason for every discretionary financial action."
- **C-5 — Loyalty reversal bound to the corrected wallet amount.** The loyalty reversal is recomputed from the corrected settled amount (single floor, §7) and is **structurally linked** to the wallet correction entry — never a free-standing point edit.
- **C-6 — Single-correction / idempotency discipline.** Prevent double-correction of the same settlement; a correction supersedes, and any further change routes to ADMIN. Mechanism deferred to ADR-006/schema; invariant stated here.
- **C-7 — No negative balance via correction.** A correction that would drive a derived wallet balance negative must fail closed or route to ADMIN.
- **C-8 — FB_STAFF fully excluded.** Only CASHIER (own, in-window) and ADMIN may execute corrections; FB_STAFF never touches payment, wallet, or loyalty (P-5; BR-ROLE-002; BR-FB-002).
- **C-9 — ADMIN reporting/visibility (compensating control).** Every cashier correction surfaces in an ADMIN report with masked last-4 identifier and reason; retention pending legal.
- **C-10 — Full immutable audit.** Each correction emits an immutable audit record (BR-AUDIT-001/002); before/after expressed as **derived** values only, never as balance overwrites.
- **C-11 — Bounded by open dependencies.** Even with C-1…C-10, Pod C cannot implement until ADR-006/007 (incl. correction entry types), the audit event schema (OQ-AUDIT-001), and KVKK pseudonymization/retention for the reason store (D-6) land.

---

## 11. Required Kerem follow-up decisions

New, specific to this review:

- **KD-1 — Correction-eligibility window.** `[NEEDS KEREM APPROVAL]` Replace "same-shift" with a deterministic, recorded boundary. Options: (a) same operating day, before end-of-day/till close; (b) a defined till-session open→close; (c) ADMIN-only (no cashier self-correction window — this is V-SAFE). Pod B default recommendation: **(a)**.
- **KD-2 — Executor model + consistency.** `[NEEDS KEREM APPROVAL]` Confirm cashier-executed correction for F&B settlement (Option 3-C) vs the safer **V-SAFE** (cashier raises, ADMIN executes — the BRD-WAL-002 recommendation). Also decide whether BRD-WAL-002 **top-up** correction should align to the same model. Pod B is comfortable with either, with §10 constraints.
- **KD-3 — Price snapshot at submission.** `[NEEDS KEREM APPROVAL]` Confirm settlement uses the price captured at submission (immutable snapshot), unaffected by later catalog edits (likely already implied by 1-E; just confirm).
- **KD-4 — Customer-visible correction history + KVKK granularity.** `[NEEDS KEREM APPROVAL]` `[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]` Confirm corrections appear in customer wallet/loyalty history at the **minimized** granularity in §9 (neutral description + value delta; no internal reason codes / cashier identity). Subject to legal/KVKK.

Standing-open and still Pod-C-blocking (not new; surfaced for sequencing): **OQ-AUDIT-001** (audit fields/schema — Pod B, then Kerem); **OQ-LEGAL-005** (retention periods — Kerem + legal + Pod B); KVKK artifacts **`DATA_PROCESSING_INVENTORY.md`**, **`DATA_RETENTION_POLICY.md`**, **`KVKK_LEGAL_BASIS.md`** (§20.2 owners); and, for the *full* loyalty feature only (not accrual-on-settlement): **OQ-LOY-004**, **OQ-LOY-005**, **BRD-LOY-008**.

Also documentation, not a decision: the three decisions should be **recorded** in `KEREM_DECISIONS.md` and mirrored in `PROJECT_DECISION_INDEX.md` (N-4) — routed to Pod A.

---

## 12. Pod C authorization statement

**Pod C is NOT authorized by this note.** This review resolves the business inputs for D-3 (loyalty formula) and D-4 (price source) and the policy for D-5 (correction), but Pod C remains blocked by: ADR-006 and ADR-007 still being **Proposed stubs** (full Pod B designs + Kerem + Pod B approval required); the **absence** of `SECURITY_REVIEW.md` and `DATA_PROCESSING_INVENTORY.md` (triggering the manifest's "review note only / do not issue Pod C work" fallback); the **open** audit event schema (OQ-AUDIT-001) and KVKK pseudonymization/retention (D-6, OQ-LEGAL-005); and the **undefined** correction-eligibility window (KD-1). The Accepted `FB_ORDER_LIFECYCLE_STATE_MODEL_v1.0.md` independently states it does not authorize Pod C and lists D-1…D-6 as still-blocking. This note must not be used to draft or start Pod C implementation work.

---

## 13. Routing & approval

- **Ready for commit?** Yes — as a Pod B review note under `/docs/reviews/`, after Kerem review. Documentation/review class. (GitHub writes are not authorized this session; commit commands provided to Kerem separately.)
- **Requires Kerem approval / decisions?** Yes — KD-1…KD-4 (§11), plus acknowledgement of the §10 constraint set. The downstream ADR-006/007 are **Wallet/Loyalty ledger logic → Kerem + Pod B** (§11.1).
- **Requires further Pod B work?** Yes, as separate deliverables: full ADR-006, full ADR-007, audit event schema (OQ-AUDIT-001), and KVKK pseudonymization/retention design for the reason/audit store — none of which is this note.
- **Requires Pod A?** Yes — record the three decisions in `KEREM_DECISIONS.md` / `PROJECT_DECISION_INDEX.md` (N-4) and align the correction reason-code enum / customer copy (N-5).
- **Requires Pod C?** **No** (§12).

---

*Produced by Pod B — Architecture, Logic & Risk. Review note only. It does not author ADR-006/007, does not design schema or API, does not resolve KVKK/audit-storage questions, and does not authorize Pod C. The repository is the source of truth; re-verify `main` SHAs of the cited sources before commit.*
