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
| **K-FB-PRICE-001** (Opt 1-E) | **D-4** — F&B item price source | (No prior OQ existed; D-4 was flagged "not found in reviewed docs") | §8 event **S1** `FB_SETTLEMENT_DEBIT` (settlement amount) | No |
| **K-FB-LOY-001** (Opt 2-B, 10% / round-down) | **D-3** — loyalty earning formula | OQ-LOY-001 (eligibility), OQ-LOY-002 (formula), OQ-LOY-003 (exclusions); BRD-LOY-002 | §9 event **L1** `FB_ACCRUAL` (points amount) | No |
| **K-FB-CORR-001** (Opt 3-C + F) | **D-5** — post-settlement correction policy | BRD-WAL-002 / OQ-WAL-002 (adjacent: top-up correction); BRD-LOY-003 / OQ-LOY-003 (accrual reversal) | §10.2 post-settlement correction = compensating append entries | No |

All three are **business-policy inputs**. They feed ADR-006 (wallet), ADR-007 (loyalty), and the audit/correction design — they do not themselves constitute those ADRs.

---

## 3. Blocking findings

These block the **complete F&B settlement + correction surface** reaching Definition of Ready. They do **not** make the decisions unsafe; they are gaps to close before Pod C.

- **B-1 — "Same-shift" is an undefined, non-auditable boundary.** `[NEEDS KEREM APPROVAL]` There is no "shift" concept anywhere in the repo. The only mentions are a generic illustration and a "shift lead" feedback-routing note. ADR-015 defines a 40-minute cashier **inactivity timeout** and server-side sessions — but a *session* is not a *shift*. "Same-shift correction" must be replaced with a **deterministic, recorded, auditable window** before it can be implemented (see C-3 and KD-1). Without this, the correction-eligibility check is unspecifiable and unauditable.

- **B-2 — Executor-authority divergence from the recorded recommendation.** `[NEEDS KEREM APPROVAL]` `BUSINESS_RULES.md` BRD-WAL-002 already records the recommended posture for mistaken-correction handling: *"Recommend ADMIN-initiated reversal with required reason in Phase 1; cashier raises request,"* and flags *"Initiation authority is security-sensitive."* K-FB-CORR-001 instead has the **cashier execute** the correction (own settlements, same shift), with ADMIN receiving **reporting** rather than executing. This is Kerem's product call and is acceptable **with the constraints in §10** — but because it inverts a recorded security recommendation and creates a self-correction (same-actor) path, Kerem should explicitly confirm the cashier-executed model for F&B settlement, and decide whether BRD-WAL-002 (top-up correction) should align to the same model or stay ADMIN-initiated (consistency — see KD-2).

- **B-3 — Dependent ADRs are stubs; KVKK/security artifacts are open/absent.** ADR-006 and ADR-007 are Proposed stubs; `SECURITY_REVIEW.md` and `DATA_PROCESSING_INVENTORY.md` do not exist; OQ-AUDIT-001 (audit field/schema) and OQ-LEGAL-005 (retention) are open. The reason store created by corrections is personal data (FB-010) and **every feature touching personal data must link to the data-processing inventory** (`PROJECT_METHODOLOGY.md` §20.2) — which must therefore exist first. This blocks Pod C (it does not block accepting the three decisions).

---

## 4. Non-blocking findings

- **N-1 — Money representation is undefined in the repo.** `[ASSUMPTION]` No currency type / minor-unit / decimal convention was found in the eight files. The 10%-round-down rule is deterministic for *points* (integers) but the **base amount** it is computed on has no defined precision. ADR-006 must fix this. **Pod B recommendation:** store monetary amounts as **integer minor units (kuruş)** and apply a **single floor at the end** of the loyalty computation (see §7). Non-blocking for the decision; required for ADR-006.

- **N-2 — Price snapshot at submission.** 1-E says the amount is "fixed for that order once submitted." This implies the order must **capture the catalog price at submission time** (an immutable price snapshot stored with the order), so that later catalog edits do not change an in-flight order's settlement amount, and so settlement and audit are reproducible. This is almost certainly Kerem's intent; confirm at approval (KD-3).

- **N-3 — ADR-006/007 stub approver line understates the gate.** The ADR-006 stub lists *"Approver: Pod B (with KVKK advisory check)"* and ADR-007 lists *"Approver: Pod B."* Both carry **wallet/loyalty ledger logic**, which `PROJECT_METHODOLOGY.md` §11.1 and the §19 ADR-authorship table require to be approved by **Kerem + Pod B**. When the full ADRs are written, the approver line must be corrected to **Kerem + Pod B**. Documentation correction; non-blocking now.

- **N-4 — The three decisions are not yet recorded in the canonical decision log.** `KEREM_DECISIONS.md` ends at K-16 and `PROJECT_DECISION_INDEX.md` (last updated 2026-06-10) does not list K-FB-PRICE/LOY/CORR. The durable record of a decision is its ADR plus Kerem's approval; these decisions should be recorded (Pod A action, Kerem approval) so they are authoritative rather than chat-only. Routed in the Pod A handoff.

- **N-5 — Reason-code enumeration is a small Pod A/UX item.** The correction reason-code set and any customer-facing copy mirror the §6.3 reject/cancel reason-code situation already flagged `[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]`. Pod B's minimum set (§10 C-4) is sufficient to design against.

---

## 5. Answers to the nine review questions

1. **Is K-FB-PRICE-001 sufficient for ADR-006 wallet settlement design?** Sufficient **as the price-source input** for the S1 settlement amount (resolves D-4). It is **not** sufficient on its own to *write* ADR-006, which still needs money representation/precision (N-1), entry taxonomy incl. correction types, balance derivation, idempotency/concurrency, insufficient-balance-at-settlement policy, and the submission-time price-snapshot mechanism (N-2). See §6.

2. **Is K-FB-LOY-001 sufficient for ADR-007 loyalty accrual design?** Sufficient **as the accrual formula + trigger input** (resolves D-3; resolves OQ-LOY-001/002/003). It is **not** sufficient to *write* ADR-007, which still needs the loyalty entry taxonomy (incl. an accrual-reversal type), point precision rule, and reversal-linkage mechanics. OQ-LOY-004 (redemption), OQ-LOY-005 (expiry), BRD-LOY-008 (override) remain open for the *full* loyalty feature but are **not** required for accrual-on-settlement. See §7.

3. **Is the 10% rounded-down formula acceptable from ledger-precision, reversal, and audit perspective?** **Yes, with one precision dependency and one recomputation rule.** Points are non-negative integers (round-down) → store integer points; clean. The dependency is the **base-amount precision** (N-1): compute on the exact settled amount (recommend integer kuruş) with a **single floor at the end** — never pre-round the amount, never double-round. The reversal rule: on any correction, **recompute points from the corrected settled amount** (`floor(0.10 × corrected_amount)`) and post a compensating delta — do **not** subtract a proportion of the originally-rounded points, which can leave a residual. With these pinned, it is audit-clean (each accrual and each reversal is its own immutable entry). See §7–§8.

4. **Is K-FB-CORR-001 acceptable as written?** **Acceptable as product policy, safe with corrections** — it preserves append-only / no-overwrite / cashier-mediated payment and does not reopen a locked decision. Two items need Kerem before it is fully settled: the undefined "same-shift" boundary (B-1 / KD-1) and the executor-authority divergence (B-2 / KD-2). With the §10 constraints attached, the model is sound. See §8, §10, §11.

5. **If CASHIER same-shift correction is acceptable, what minimum constraints are required?** See **§10 (C-1 … C-11)** — the full constraint set. In brief: compensating-entry-only; own-settlements-only; a deterministic/auditable window replacing "shift"; mandatory structured reason (fail-closed); loyalty reversal bound to and recomputed from the corrected amount; single-correction/idempotency discipline; no negative balance via correction; FB_STAFF excluded; ADMIN reporting with masked identifier; full immutable audit with derived (never overwritten) before/after values.

6. **If CASHIER same-shift correction is NOT acceptable, what safer variant?** It **is** acceptable with §10 constraints, so this is a fallback, not a requirement. The safer variant (**V-SAFE**): cashier may *flag/raise* a correction request (read-only marker); **ADMIN executes** the compensating reversal with mandatory reason — i.e., the BRD-WAL-002 recorded recommendation. This removes the "shift"-window problem and adds separation of duties, at the cost of needing an admin present. A middle option is a **very short, system-enforced** self-correction window (e.g., only the cashier's most recent settlement, before any subsequent settlement in the same authenticated session), with everything else ADMIN-initiated. Presented to Kerem in KD-2.

7. **What audit/KVKK issues are created?** See **§9**. Summary: corrections are discretionary financial actions → mandatory **immutable** audit (BR-AUDIT-001/002) needing the audit event schema (OQ-AUDIT-001, open); reason fields are **personal data** (FB-010, §6.5) requiring pseudonymization + retention so a right-to-erasure request can pseudonymize without deleting the immutable ledger/audit (append-only vs erasure tension; resolution = pseudonymization); `DATA_PROCESSING_INVENTORY.md` / `DATA_RETENTION_POLICY.md` / `KVKK_LEGAL_BASIS.md` are absent and must exist (§20.2); customer-visible correction history must be **data-minimized** (no internal reason codes / cashier identity to the customer); ADMIN report uses masked last-4 only.

8. **What exact remaining Kerem decisions are needed before ADR-006/007 can proceed?** ADR-006/007 **drafting can begin now** for the happy path + accrual using these inputs. To finalize them and reach the full settlement+correction surface: **KD-1** (correction-window definition), **KD-2** (executor-model confirmation + BRD-WAL-002 consistency), **KD-3** (price-snapshot-at-submission confirmation), **KD-4** (customer-visible correction-history intent + KVKK granularity). Standing-open, still-blocking (not new): OQ-AUDIT-001, OQ-LEGAL-005, and the KVKK artifacts above. See §11.

9. **Does Pod C remain blocked?** **Yes — unambiguously.** ADR-006/007 are stubs; `SECURITY_REVIEW.md` and `DATA_PROCESSING_INVENTORY.md` are absent (manifest fallback → no Pod C work); OQ-AUDIT-001 and KVKK pseudonymization/retention are open; the correction window is undefined. The Accepted lifecycle model itself states it does not authorize Pod C and lists D-1…D-6 as still-blocking. See §12.

---

## 6. ADR-006 (wallet ledger) implications

K-FB-PRICE-001 fixes the **S1 settlement amount** as the Adeks Platform catalog/order-submission price, fixed at submission, corrected only via compensating entries, never overwritten. For ADR-006, this means:

- **Entry taxonomy must include a correction type.** Beyond `FB_SETTLEMENT_DEBIT` (S1), ADR-006 needs an explicit **`FB_SETTLEMENT_CORRECTION`** entry type (a signed compensating entry, or an explicit reversal-plus-redebit pair — Pod B to choose in ADR-006). The original S1 entry is never edited or deleted.
- **Money representation (N-1).** Recommend integer minor units (kuruş). The settlement amount, the correction delta, and the derived balance are all integers; balance = sum of entries.
- **Price snapshot (N-2).** The order must store the price captured at submission so settlement is reproducible and independent of later catalog edits. ADR-006-adjacent / order-schema concern; confirm via KD-3.
- **Idempotency & concurrency.** Exactly one S1 per order (already in §8). The correction path needs its own single-correction discipline (C-6) and must not create a state where two corrections race. Mechanism deferred to ADR-006/schema; the **invariant** is stated here.
- **Insufficient-balance / negative-balance policy.** A correction that increases a debit, or any path that would drive a derived balance negative, must fail closed or route to ADMIN (C-7). Insufficient-balance-at-settlement policy is an ADR-006 decision.
- **Approval gate (N-3).** ADR-006 is **Wallet ledger logic** → **Kerem + Pod B** (§11.1). The stub's "Approver: Pod B" line must be corrected.

**Synthetic example.** Customer A's delivered order settles at ₺157 → wallet entry `FB_SETTLEMENT_DEBIT −₺157` (stored 15700 kuruş). One item is returned at the till within the correction window; cashier corrects the settled amount to ₺100 → wallet entry `FB_SETTLEMENT_CORRECTION +₺57` (5700 kuruş). Derived wallet effect = −₺100. **No row overwritten.**

---

## 7. ADR-007 (loyalty ledger) implications

K-FB-LOY-001 fixes the **L1 accrual amount** as `floor(0.10 × settled F&B wallet debit)` whole points, accrued only on S1 settlement, with cancelled/rejected/unsettled/reversed amounts retaining no points. For ADR-007:

- **Point precision is integer.** Round-down → points are non-negative integers; no fractional-point storage. The verification table is correct: ₺99 → `floor(9.9)` = **9**; ₺100 → **10**; ₺157 → `floor(15.7)` = **15**.
- **Single-floor rule (N-1).** Define the computation precisely to avoid double-rounding. With integer minor units: `points = floor(settled_kuruş / 1000)` (equivalently `floor(0.10 × settled_TRY)`). Round **once**, at the end. ADR-007 records this; the *base-amount* precision lives in ADR-006.
- **Accrual-reversal entry type.** ADR-007 needs an explicit **`FB_ACCRUAL_REVERSAL`** (signed) entry, structurally **linked to the wallet correction entry** that caused it (C-5). Balance = sum of entries.
- **Recompute-from-corrected-amount rule (Q3).** On correction, post `corrected_points − original_points`; never derive the reversal as a proportion of the originally-rounded points.
- **Out of scope here / still open.** Redemption (OQ-LOY-004), expiry (OQ-LOY-005), cashier override (BRD-LOY-008) — needed for the full loyalty feature, not for accrual-on-settlement.
- **Approval gate (N-3).** ADR-007 is **Loyalty ledger logic** → **Kerem + Pod B**.

**Is the 10% interpretation sufficient for ADR-007?** **Yes, as the business formula.** The remaining items (money representation, single-floor rule, partial-correction recomputation, reversal entry type) are **Pod B ledger-design decisions**, not new business values from Kerem. The only confirmation worth stating: the base is the **settled wallet debit amount** (gross; no F&B-level discounts are in Phase 1 scope, and discounts/campaigns are excluded from earning per K-FB-LOY-001), so gross settled amount = the base.

**Synthetic example (continuing §6).** Original accrual `FB_ACCRUAL +15` (from ₺157). After correction to ₺100: corrected points = `floor(0.10 × 100)` = 10 → reversal entry `FB_ACCRUAL_REVERSAL −5`, linked to the wallet correction. Derived points for the order = 10. Full reversal (corrected to ₺0) → `floor(0)` = 0 → `FB_ACCRUAL_REVERSAL −15`; the order retains **no** points, satisfying "reversed/corrected amounts do not retain earned points."

---

## 8. Correction / reversal design implications

K-FB-CORR-001 is consistent with §10.2 of the Accepted lifecycle (post-settlement correction = compensating append entries, out of the state machine). Design implications:

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
