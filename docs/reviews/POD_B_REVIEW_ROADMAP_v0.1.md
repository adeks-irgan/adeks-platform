# Pod B Review — `ROADMAP.md` v0.1

| Field | Value |
|---|---|
| Document | `POD_B_REVIEW_ROADMAP_v0.1.md` |
| Project | Adeks Platform |
| Reviewer | Pod B — Architecture, Logic & Risk |
| Subject | `/docs/ROADMAP.md` v0.1 draft (Pod A) |
| For | Kerem (approval); Pod A (corrections) |
| Target repo path | `/docs/reviews/POD_B_REVIEW_ROADMAP_v0.1.md` |
| Implementation status | **Does NOT authorize Pod C.** Review/design only. |
| Data | Synthetic examples only. No real Adeks data appears. |

---

## Freshness Baseline

All repository files were read from `main` at **HEAD `7dd2f6a57768a67a3efaaebe7b9bd4745f5416c1`** (commit "docs: reconcile remaining manifest status drift (#72)", 2026-06-15T20:36:13Z), on 2026-06-16.

Files read: `ROADMAP.md` v0.1 (from handoff), `PROJECT_METHODOLOGY.md`, `AGENT_CONTEXT_MANIFEST.md`, `PROJECT_DECISION_INDEX.md`, `KEREM_DECISIONS.md`, `PROJECT_BRIEF.md`, `MVP_SCOPE.md`, `OPEN_QUESTIONS.md`, `DATA_PROCESSING_INVENTORY.md`, `SECURITY_REVIEW.md`, `BUSINESS_RULES.md`, `USER_ROLES_AND_PERMISSIONS.md`, `CORE_USER_FLOWS.md`, `architecture/FB_ORDER_LIFECYCLE_STATE_MODEL_v1.0.md`, `adr/ADR-005`, `adr/ADR-006`, `adr/ADR-007`, `adr/ADR-009`, `adr/ADR-015`. (`AUDIT_EVENT_SCHEMA.md`, `AUTH_THREAT_MODEL.md`, `SMS_PROVIDER_REPORT.md` referenced indirectly via the above and the decision index.)

Repository is the source of truth. Where this review and a repo file disagree, the repo file wins and this review is stale until corrected.

---

## Verdict

**The roadmap is sound in substance and safe in posture — it does not over-authorize Pod C, it correctly treats legal/KVKK closure as a hard implementation and launch gate, and its milestone sequence is coherent.** The main Pod B review risk the handoff named — "is any *can proceed while legal pending* classification too permissive?" — is **largely clear**: the "can proceed" calls are defensible. The one item that needs explicit guardrails before action is the **read-only Selcafe spike**.

The blocking issues are **not** in the sequence logic; they are in **freshness and repo reconciliation**:

1. The roadmap's declared "current repository context" predates the 2026-06-14/15 landings (ADR-006/007 Accepted; K-17/18/19 locked; `AUDIT_EVENT_SCHEMA.md` accepted; `DATA_PROCESSING_INVENTORY.md` approved). Committing it as written would re-assert a stale baseline.
2. The repo itself contains a live contradiction: two artifacts the roadmap depends on (`DATA_PROCESSING_INVENTORY.md`, `SECURITY_REVIEW.md`) now exist, but `SECURITY_REVIEW.md`'s own gating language and the decision index's K-18/K-19 rows still call them absent. The roadmap correctly anticipates this as its **item 2** — this review confirms it and pins the exact locations.

**Recommendation: approve `ROADMAP.md` as the Phase 1 planning sequence *after* the B-1 freshness pass; prioritise the B-2 reconciliation (= roadmap item 2) through a Pod B + Kerem documentation PR; do not execute the Selcafe spike (items 14/15) until K-D-1 (environment) is decided and N-1 (read-path controls) are in the spike script.** No locked principle is violated; no `[LOCKED PRINCIPLE CONFLICT]` is raised.

---

## Findings Summary

| ID | Finding | Class | Affected roadmap area | Kerem approval needed? |
|---|---|---|---|---|
| **B-1** | Roadmap freshness baseline is stale vs `main` HEAD `7dd2f6a` | **Blocking (before commit)** | Source Context; Locked Planning Principles; items 21–23; M4/M5; Audit Points (wallet/loyalty/F&B/audit); Blocked-Until-Legal audit row | Yes (approver) |
| **B-2** | Live repo contradiction: inventory & security-review present but documented as absent | **Blocking (repo reconciliation)** | Item 2 / M-series reconciliation | Yes (security-artifact gate language → ADR-009 §3 / K-11) |
| **K-D-1** | Selcafe spike target environment (production vs restored copy) unspecified | **Requires Kerem decision** | Items 14, 15; M3; "Can Proceed Now" Selcafe row | Yes (operational + access) |
| **N-1** | Selcafe read-path controls stated as policy, not enforced as control | Non-blocking | Items 14, 15; M3 | No (except K-D-1) |
| **N-2** | "Pod C executes the spike" could be misread as Pod C authorization | Non-blocking | Items 14, 15; M3 | No |
| **A-1** | Legal-deliverable scaffolding could optionally be pre-structured now | Advisory | Items 9, 10 | No |
| **A-2** | 99.9% SLO is achievable only under hosting prerequisites not yet locked | Advisory | Item 27; M7 | No (awareness) |
| **A-3** | F&B audit triggers are now an envelope-mapping task, not an open design gap | Advisory | Item 23; M5 | No |
| **A-4** | Reinforce: do not lock status-based reservation approval before the Selcafe spike | Advisory | Items 24, 25; M6 | No |

---

## Direct Answers to the 13 Review Questions

1. **Architecture sequencing risks** — Sequence is coherent. Legal → SMS/Auth → Selcafe discovery → Ledger reconciliation → F&B → Reservation → Monitoring → Audit → Pilot is correctly ordered, with implementation strictly downstream of all gates. No ordering inversion found. (See B-1 for the freshness caveat that affects *which* items are still genuinely open.)
2. **Security/KVKK blockers** — Correctly treated as hard gates. The three genuinely-absent KVKK artifacts (`DATA_RETENTION_POLICY.md`, `KVKK_LEGAL_BASIS.md`, `CROSS_BORDER_TRANSFER_ASSESSMENT.md`) remain valid launch/implementation blockers and the roadmap keeps them so.
3. **Any item too permissive ("can proceed while legal pending")?** — No item is wrongly green-lit. The most permissive items — Selcafe spike (14/15), admin bootstrap (13), SMS outage/ceiling decision (12) — are each correctly scoped to non-personal-data, non-implementation work. The Selcafe spike needs guardrails (K-D-1, N-1) but its "Yes, schema-only" class is defensible: schema/column *metadata* is not personal data, so it does not require KVKK closure.
4. **Any item incorrectly marked as blocked?** — No item is blocked in a way that creates risk. Two legal-deliverable docs (items 9, 10) could *optionally* have their non-legal scaffolding prepared now to shorten turnaround (A-1), but keeping them "No / blocked for completion" is the correct, safe call.
5. **Any item accidentally authorizes Pod C?** — No. The roadmap is exhaustively explicit. The only Pod C *touchpoint* is executing the read-only Selcafe spike under K-10 (investigation, not implementation); N-2 recommends a one-line carve-out so this is unambiguous.
6. **Selcafe read-only boundary correctness** — Correct. ADR-005 (stub; direction locked read-only) is respected; item 17 reconfirms read-only and routes any write-posture change to Kerem + Pod B. Read-path *controls* are under-specified (N-1).
7. **Wallet/loyalty ledger readiness** — ADR-006 and ADR-007 are **Accepted** (2026-06-14); K-17 (price source), K-18 (loyalty formula), K-19 (correction policy) are **locked**. Design direction is settled. Remaining gates are legal/KVKK (retention, legal basis), the still-open business rules (wallet top-up methods OQ-WAL-001/002/003; loyalty redemption/expiry OQ-LOY-001/004/005), and separately approved Pod C issues. The roadmap's M4 entry criteria acknowledge the locked items; B-1 asks it to reflect the *Accepted* ADR status consistently.
8. **Auth/SMS/provider/cross-border readiness** — Correct. ADR-015 makes SMS provider a hard dependency for customer login; the auth threat model (`AUTH_THREAT_MODEL.md`, **Accepted**, BL-2 closed) and the provider report (`SMS_PROVIDER_REPORT.md`, exists) are satisfied inputs. Remaining: provider *selection* (OQ-SMS-001, gated by cross-border/processor assessment), legal text (OQ-LEGAL-001), K-15/K-16 sufficiency (OQ-LEGAL-002/003), retention (OQ-LEGAL-005). IR-24 (admin bootstrap) and IR-25 (SMS ceiling) are correctly decidable now (OQ-AUTH-001/002).
9. **Hosting/deployment/monitoring & 99.9% SLO** — Monitoring spec can be drafted now; final vendor/hosting is partly cross-border-gated (OQ-LEGAL-006). The SLO target (K-05) is achievable only under hosting prerequisites not yet locked — surface those in the spec (A-2). Not reopening K-05.
10. **F&B lifecycle, audit trigger, settlement/correction** — F&B state model (v1.0) is **Accepted** (2026-06-13). Its stated cross-domain blockers D-1…D-4 (ADR-006, ADR-007, loyalty formula, price source) are **now all resolved/locked**. The per-transition audit points already exist in its §4 table; with `AUDIT_EVENT_SCHEMA.md` now accepted, the remaining work is **mapping** those points onto the envelope (SR-004) — a bounded Pod B reconciliation, not an open design gap (A-3). Settlement/correction logic is settled (ADR-006 §8, ADR-007 §6; K-19). Remaining: legal/KVKK + approved issues.
11. **Reservation state-machine dependencies** — Correct. Item 25 (Pod B state machine) depends on Kerem's reservation rules (OQ-RES-001…004) and, where status-based criteria are considered, the Selcafe spike (OQ-RES-005, OQ-SEL-002). Phase 1 stays manual-approval by design; reinforce that this must not be locked away pre-spike (A-4).
12. **DoR / DoD alignment** — Accurate. The roadmap's Audit-Points DoR row matches Methodology §14 (business context, scope, non-goals, testable acceptance criteria, linked docs/ADRs/schemas/API, risk class, Pod B + Kerem review status, synthetic data). The DoD row matches §15 (acceptance criteria, unit/integration tests, CI, security/financial review if triggered, docs, schema-migration review Pod B + Kerem, rollback notes, no real data). No correction needed.
13. **Stale repo-context reconciliation** — **Confirmed and material (B-2).** See below for exact locations. This is precisely the risk the handoff flagged ("`SECURITY_REVIEW.md` references to absent files if newer files now exist").

---

## Detailed Findings

### B-1 — Roadmap freshness baseline is stale vs `main` HEAD `7dd2f6a` — **Blocking (before commit)**

- **Affected:** "Source Context" table; "Locked Planning Principles"; items 21, 22, 23; milestones M4, M5; "General Project Audit Points" (wallet ledger / loyalty ledger / F&B / audit rows); "Blocked Until Legal Advisor Answers" (audit reason-notes row).
- **Issue:** The roadmap declares it is "based on the current repository context," but its baseline predates the 2026-06-14/15 landings. Specifically it omits or understates:
  - **ADR-006 Accepted** and **ADR-007 Accepted** (2026-06-14) — the roadmap's Source Context describes them as "accepted design; implementation blocked," which is directionally right, but the audit/ledger reconciliation rows read as if more design is open than is.
  - **K-17, K-18, K-19 locked** (2026-06-14) — M5 entry criteria reference these (good), but they are not surfaced consistently across the F&B/ledger rows.
  - **`AUDIT_EVENT_SCHEMA.md` Kerem-accepted (2026-06-15, PR #66)** resolving **OQ-AUDIT-001** — not listed in Source Context at all; the audit-trigger dependency is treated as fully open when it is design-resolved.
  - **`DATA_PROCESSING_INVENTORY.md` Kerem-approved (2026-06-15)** — listed as "exists, inventory level," which is correct, but see B-2 for the contradiction this collides with.
  - **`AUTH_THREAT_MODEL.md` (Accepted)** and **`SMS_PROVIDER_REPORT.md` (exists)** — neither appears in Source Context, though both are satisfied auth/SMS inputs the roadmap relies on.
- **Risk:** Committing a planning document that asserts a stale "current context" re-introduces drift and violates the repository-is-source-of-truth principle. A downstream pod could treat OQ-AUDIT-001 or the inventory's existence as still open.
- **Recommended correction:**
  1. Re-pin the roadmap's freshness baseline to `main` HEAD `7dd2f6a`.
  2. Add to Source Context: `architecture/AUDIT_EVENT_SCHEMA.md` (Kerem-accepted, resolves OQ-AUDIT-001), `architecture/AUTH_THREAT_MODEL.md` (Accepted), `decision-support/SMS_PROVIDER_REPORT.md` (exists).
  3. Update the audit-trigger language in item 23 / M5 / the audit Audit-Point to: *"audit envelope design resolved (`AUDIT_EVENT_SCHEMA.md`, OQ-AUDIT-001); remaining F&B/reservation per-event mapping (SR-004) + retention (OQ-LEGAL-005, KD-D) + inventory entries (KD-E) + approved issues."*
  4. State ADR-006/ADR-007 consistently as **Accepted** (design settled; implementation blocked) across the ledger/F&B rows.
- **Kerem approval:** Yes (he is the roadmap approver). The corrections are documentation-only; Pod B reviews the corrected rows.

---

### B-2 — Live repo contradiction: inventory & security-review present but documented as absent — **Blocking (repo reconciliation)**

- **Affected (roadmap):** Item 2 ("Reconcile current repo status after new `DATA_PROCESSING_INVENTORY.md` and `SECURITY_REVIEW.md` context") and the M-series reconciliation. **The roadmap correctly anticipates this** — this review confirms it and supplies the exact locations.
- **Affected (repo files to correct):**
  - `SECURITY_REVIEW.md` — header `REPO RECONCILIATION` block (~lines 16–17); Status table "Repo reconciliation" row (~line 36); freshness-baseline rows (~lines 62–67); §6 wallet/customer/audit "Open / blocking items" (~lines 160, 167, 174); §8 dependency table (~lines 239, 291); and the privacy-posture summary (~line 248). Throughout, `DATA_PROCESSING_INVENTORY.md` is asserted **ABSENT** and the file is marked **NEEDS REPO RECONCILIATION**.
  - `PROJECT_DECISION_INDEX.md` — **K-18 row** and **K-19 row** both end with "`SECURITY_REVIEW.md` and `DATA_PROCESSING_INVENTORY.md` absent." The **ADR-007 row** lists `SECURITY_REVIEW.md` as a pending gate.
  - `OPEN_QUESTIONS.md` — OQ-AUDIT-001 resolution note (~line 80) reads "KD-E `DATA_PROCESSING_INVENTORY.md` remains open," which is ambiguous against a file that now exists.
- **Ground truth (main HEAD `7dd2f6a`):**
  - `DATA_PROCESSING_INVENTORY.md` — **PRESENT**, v0.1, **Kerem-approved 2026-06-15**, build-gate effect "satisfies the data-processing-inventory artifact prerequisite only."
  - `SECURITY_REVIEW.md` — **PRESENT**, v0.1 (2026-06-15), satisfies the manifest dependency at the review level.
  - Still genuinely **ABSENT**: `DATA_RETENTION_POLICY.md`, `KVKK_LEGAL_BASIS.md`, `CROSS_BORDER_TRANSFER_ASSESSMENT.md` (+ `SECURITY_VIEW.md` / SR-008, `SECURE_SDLC.md` / SR-009, `QA_STRATEGY.md`/`UAT_PLAN.md` / SR-006).
- **Risk:** A security artifact and the canonical decision index assert a false repository state. A future reader either (a) believes the inventory gate is unsatisfiable, or (b) discounts `SECURITY_REVIEW.md` as wholesale stale. Both erode the gate's authority at exactly the layer (financial ledgers, customer data, audit) where authority matters most.
- **Recommended correction (precise, and deliberately narrow):**
  - In `SECURITY_REVIEW.md`: change every "`DATA_PROCESSING_INVENTORY.md` absent / NEEDS REPO RECONCILIATION" to *"present (Kerem-approved 2026-06-15); inventory-artifact gate satisfied at inventory level."* Replace the blanket "no personal-data feature may be built until the inventory exists" with *"the inventory-artifact prerequisite is satisfied; personal-data implementation remains blocked pending retention (OQ-LEGAL-005, KD-D), legal basis (`KVKK_LEGAL_BASIS.md`, absent), cross-border (OQ-LEGAL-006), and separately approved Pod C issues."*
  - In `PROJECT_DECISION_INDEX.md`: amend the **K-18** and **K-19** trailing clauses to drop "`SECURITY_REVIEW.md` and `DATA_PROCESSING_INVENTORY.md` absent" (both now exist); amend the **ADR-007** row so `SECURITY_REVIEW.md` reads as satisfied (review level).
  - In `OPEN_QUESTIONS.md`: reword the OQ-AUDIT-001 note so "KD-E" reads as *"the KD-E inventory entries are recorded in the now-present `DATA_PROCESSING_INVENTORY.md`; retention (KD-D) remains open under OQ-LEGAL-005."*
  - **Do NOT** flip the three genuinely-absent legal files. The reconciliation corrects **status only** and **does not open the Pod C gate** — every other gate (retention, legal basis, cross-border, SMS provider, approved issues) stands.
- **Kerem approval:** **Yes.** Editing a security artifact's gate-statement language is a security-sensitive documentation change requiring **Pod B + Kerem** (ADR-009 §3 / K-11). The roadmap's item-2 classification ("Pod B review; Kerem if status/gates change") is therefore correct; this finding confirms Kerem sign-off *is* triggered because gate statements change. Routing: Pod B drafts the reconciliation, Kerem approves and merges (Pod B does not self-merge). Pod A co-owns where the manifest/inventory ownership applies.

---

### K-D-1 — Selcafe spike target environment (production vs restored copy) — **Requires Kerem decision**

- **Affected:** Items 14 ("Execute read-only Selcafe feasibility spike"), 15 ("Produce `SELCAFE_SPIKE_REPORT.md`"); milestone M3; "Can Proceed Now" Selcafe row.
- **Issue:** The roadmap authorizes a read-only, schema-only spike (K-10) but does not specify whether it runs against the **live production** Selcafe SQL Server (serving ~130 PCs) or a **restored backup / read-replica**.
- **Risk:** Schema introspection against production during operating hours risks locks/load on a business-critical system. An unexpected query (or a heavy `INFORMATION_SCHEMA`/catalog crawl on a large DB) could degrade café operations — itself an operational incident, independent of any data exposure.
- **Recommendation:** Kerem decides the target. Pod B recommends, in order of preference: (1) a **restored backup copy** or read-replica; (2) failing that, the **live DB via a read-only, metadata-scoped login** in a **low-traffic / maintenance window**, with a query timeout. Pod B will encode schema-only introspection into the spike script regardless of target (see N-1).
- **Kerem approval:** **Yes** — operational + access decision. K-10 authorized the spike; it did not fix the environment, which is the material safety choice.

---

### N-1 — Selcafe read-path controls stated as policy, not enforced as control — **Non-blocking**

- **Affected:** Items 14, 15; M3.
- **Issue:** "No writes" and "no row data copied" are written as policy. They should be enforced structurally. Separately, Selcafe **column names** can themselves reveal sensitive personal-data fields (e.g., a national-ID/`TCKN` column or a `Telefon` column).
- **Risk:** Without enforcement, a spike could inadvertently `SELECT` row data, or sample values could be transcribed into the report — breaching the locked synthetic-only / no-real-data rule. The schema is itself sensitive.
- **Recommended correction (fold into ADR-005 full-text scope + the Pod B spike script):**
  - Spike script is **schema-introspection-only by construction** — query catalog / `INFORMATION_SCHEMA` views only; **never** `SELECT ... FROM <data table>`.
  - Execution login is **read-only / metadata-scoped** (no write grants).
  - `SELCAFE_SPIKE_REPORT.md` captures **column names + types only**, treats the schema as **internal/confidential**, and contains **zero sample rows**. (A discovered personal-data column is a valuable *input* to the inventory/legal-basis work — record the column's existence, never its values.)
  - **Credentials never enter any AI chat, document, PR, or the spike report** — they go directly into Pod C's local execution environment / a secret store.
- **Kerem approval:** No (Pod B design discipline), other than K-D-1.

---

### N-2 — "Pod C executes the spike" could be misread as Pod C authorization — **Non-blocking**

- **Affected:** Items 14, 15; M3; "Can Proceed Now" Selcafe row.
- **Issue:** The roadmap's only Pod C activity is executing the spike. The document is otherwise emphatic that Pod C is not authorized.
- **Risk:** Low, but the clean "Pod C not authorized" stance benefits from an explicit carve-out.
- **Recommended correction:** Add one line to items 14/15: *"The Selcafe spike is investigation-only under K-10 — no product code, no migrations, no issues — and does not constitute Pod C implementation authorization for any other roadmap item."*
- **Kerem approval:** No (clarification).

---

### A-1 — Optional acceleration of legal-deliverable scaffolding — **Advisory**

- **Affected:** Items 9 (`DATA_RETENTION_POLICY.md`), 10 (`CROSS_BORDER_TRANSFER_ASSESSMENT.md`).
- **Note:** Both are correctly "No / blocked for completion" on legal-advisor input. However, their *non-legal* scaffolding could be pre-structured now without making any determination: the **data-class list** for retention is now available from the approved `DATA_PROCESSING_INVENTORY.md`; the **vendor / transfer-surface enumeration** for cross-border can be drafted from the (pending) hosting/SMS/monitoring candidate set. Keep both blocked for completion; allow skeleton prep only. Optional — pursue only if Kerem wants to shorten turnaround once advisor input lands.

---

### A-2 — 99.9% SLO achievable only under hosting prerequisites not yet locked — **Advisory**

- **Affected:** Item 27 ("monitoring specification for 99.9% SLO readiness"); M7.
- **Note:** The locked 99.9% SLO (K-05 ≈ 8.8h downtime/yr) is a function of the hosting model — HA / multi-AZ-or-equivalent, DB backup RTO/RPO, single-vs-redundant instance — and hosting is **Not locked** and partly **cross-border-gated** (OQ-LEGAL-006). The monitoring spec should (a) define the SLI/SLO/alerting/error-budget framework now, and (b) **explicitly state the hosting prerequisites** required to *meet* 99.9%, flagging that committing to the target requires a hosting decision carrying an availability budget. **Pod B does not reopen K-05** — this surfaces a dependency. If Kerem wishes to revisit whether 99.9% is the right Phase-1 single-café target, that is his call to initiate.

---

### A-3 — F&B audit triggers are now an envelope-mapping task — **Advisory**

- **Affected:** Item 23; M5 ("audit trigger dependencies defined").
- **Note:** The F&B state model §4 transition table already defines the logical audit points (transition-logged; reason-required-fail-closed for rejection/correction). With `AUDIT_EVENT_SCHEMA.md` now Kerem-accepted, the remaining F&B audit work is **mapping** those points onto the §5 envelope (this is SR-004 in `SECURITY_REVIEW.md`), not designing them from scratch. M5's "audit trigger dependencies defined" should reference SR-004 as a bounded Pod B reconciliation rather than implying an open design gap. (Same applies to reservation audit triggers, which land with the reservation state machine, item 25.)

---

### A-4 — Do not lock status-based reservation approval before the Selcafe spike — **Advisory**

- **Affected:** Items 24, 25; M6.
- **Note:** The roadmap mostly respects OQ-RES-005 ("Phase 1 reservation approval stays manual; do not lock status-based criteria before the spike"). Reinforce explicitly in item 24: any automated PC/session-status-based approval rule is **contingent on the spike result** (OQ-SEL-002) and must not be written into the reservation product rules pre-spike. The manual-judgment Phase-1 default is correct.

---

## Recommended `OPEN_QUESTIONS.md` Additions / Tracking

| Proposed ID | Question | Owner | Source finding |
|---|---|---|---|
| **OQ-SEL-003** | Does the read-only Selcafe spike run against production or a restored backup/read-replica? | Kerem + Pod B | K-D-1 |
| **OQ-SEL-004** | What are the Selcafe read-path controls (read-only/metadata-scoped login; schema-only script; confidential schema handling; no credentials/rows in docs/AI)? *(May instead be captured directly in the ADR-005 full text.)* | Pod B | N-1 |
| **OQ-OPS-001** | What hosting redundancy / RTO / RPO is required to meet the locked 99.9% SLO, and is it compatible with the cross-border position (OQ-LEGAL-006)? | Kerem + Pod B | A-2 |
| *(track, no new OQ)* | **SR-004** — map F&B and reservation per-event audit triggers onto `AUDIT_EVENT_SCHEMA.md`. | Pod B | A-3 |
| *(track, no new OQ)* | **B-2 reconciliation** — correct the inventory/security-review "absent" references (exact locations above). | Pod B + Pod A; Kerem approves | B-2 |

The handoff also asked about: legal/KVKK closure gates (covered by existing OQ-LEGAL-001…006 — no gap); SMS provider outage response (OQ-SMS-002/OQ-AUTH-001 — no gap); F&B audit triggers (SR-004 above); Selcafe read-path controls (OQ-SEL-004 above); Definition of Ready before Pod C (Methodology §14 — no gap). No additional gaps found beyond the table above.

---

## Routing

- **Ready for Kerem approval:** Yes — approve `ROADMAP.md` as the Phase 1 planning sequence **after** the B-1 freshness pass.
- **Requires Kerem decision:** K-D-1 (Selcafe spike environment); authorisation of the B-2 reconciliation gate-language change (Pod B + Kerem).
- **Requires Pod A action:** Apply B-1 corrections to `ROADMAP.md`; add the recommended OQs; co-own the B-2 reconciliation (Pod A owns `DATA_PROCESSING_INVENTORY.md` / the manifest; Pod B drafts the `SECURITY_REVIEW.md` / decision-index edits and reviews).
- **Requires Pod B follow-on:** ADR-005 full text (incl. N-1 read-path controls); SR-004 audit-trigger mapping; B-2 reconciliation draft. These are subsequent one-deliverable-per-session items.
- **Pod C:** Not authorized. The Selcafe spike, when run, is investigation-only under K-10.
- **Pod D:** Not triggered by this review (monitoring/UX/audit-plan items remain as the roadmap sequences them).

---

## Appendix A — Handoff-Kerem (decision request)

```text
DECISION REQUEST — Pod B review of ROADMAP.md v0.1

Summary: Pod B reviewed ROADMAP.md v0.1 against main HEAD 7dd2f6a. The roadmap is sound
and does NOT over-authorize Pod C. Two blocking issues are reconciliation/freshness, not
sequence logic. Three decisions are yours.

1. APPROVE ROADMAP (after a freshness pass)
   - Impact: ROADMAP.md v0.1 declares a "current repository context" that predates the
     2026-06-14/15 landings (ADR-006/007 Accepted; K-17/18/19 locked; AUDIT_EVENT_SCHEMA.md
     accepted, resolving OQ-AUDIT-001; DATA_PROCESSING_INVENTORY.md approved; AUTH_THREAT_MODEL.md
     accepted; SMS_PROVIDER_REPORT.md exists). Committing as-is re-asserts a stale baseline.
   - Options: (a) Pod A applies the B-1 freshness pass, then you approve/commit [recommended];
     (b) commit now with an explicit freshness-baseline pin + a note that item 2 will reconcile.
   - Default if no action: roadmap stays in draft; downstream planning waits.
   - Pod B recommendation: (a).

2. AUTHORISE THE B-2 REPO RECONCILIATION (security-artifact gate language → Pod B + Kerem)
   - Impact: DATA_PROCESSING_INVENTORY.md and SECURITY_REVIEW.md both EXIST and are
     Kerem-approved/at-review-level, but SECURITY_REVIEW.md's gating language and the
     PROJECT_DECISION_INDEX.md K-18/K-19 rows still call them ABSENT. This is roadmap item 2.
     The fix corrects STATUS only and does NOT open the Pod C gate (retention, legal basis,
     cross-border, SMS provider, approved issues all stand). The three genuinely-absent legal
     files are NOT touched.
   - Options: (a) authorise Pod B to draft the reconciliation PR for your approval/merge
     [recommended]; (b) defer.
   - Default if no action: a security artifact + the decision index keep asserting a false
     repo state.
   - Pod B recommendation: (a). Because gate STATEMENTS change, this is a Pod B + Kerem
     documentation PR (ADR-009 §3 / K-11). Pod B drafts; you approve and merge.

3. DECIDE THE SELCAFE SPIKE ENVIRONMENT (K-D-1)
   - Impact: items 14/15 authorise a read-only schema spike (K-10) but don't say whether it
     runs against LIVE production Selcafe (serving ~130 PCs) or a restored backup/replica.
     Production introspection risks load/locks on a business-critical system.
   - Options: (a) restored backup / read-replica [recommended]; (b) live DB via a read-only,
     metadata-scoped login in a low-traffic/maintenance window with a query timeout.
   - Default if no action: spike (items 14/15, M3) does not start.
   - Pod B recommendation: (a). Pod B will encode schema-only introspection + read-path
     controls (N-1) into the spike script regardless of target. Credentials must never enter
     any AI chat/doc/PR.

Also note (no decision needed now):
 - 99.9% SLO (K-05) is achievable only under hosting prerequisites not yet locked; the
   monitoring spec (item 27) must surface them. Pod B is not reopening K-05.
 - Write authority for this session is read-only; Pod B will not push anything until you
   authorise writes per-session.
```

---

## Appendix B — Handoff-Pod A (corrections + reconciliation)

```text
You are Pod A — Product & Planning for the Adeks Platform project.

Context: Pod B reviewed ROADMAP.md v0.1 (review file: /docs/reviews/POD_B_REVIEW_ROADMAP_v0.1.md).
The roadmap is sound and does NOT over-authorize Pod C. Two corrections are needed before
Kerem commits, plus open-question additions. Repository is the source of truth; read live
files from main (current HEAD 7dd2f6a) before editing.

Attach / read from main:
 - /docs/ROADMAP.md (v0.1)
 - /docs/reviews/POD_B_REVIEW_ROADMAP_v0.1.md (this review)
 - /docs/PROJECT_DECISION_INDEX.md
 - /docs/SECURITY_REVIEW.md
 - /docs/DATA_PROCESSING_INVENTORY.md
 - /docs/OPEN_QUESTIONS.md
 - /docs/AGENT_CONTEXT_MANIFEST.md

Tasks:
 1. (B-1) Apply the freshness pass to ROADMAP.md: re-pin the baseline to HEAD 7dd2f6a; add
    AUDIT_EVENT_SCHEMA.md (resolves OQ-AUDIT-001), AUTH_THREAT_MODEL.md (Accepted), and
    SMS_PROVIDER_REPORT.md (exists) to Source Context; update items 21/22/23, M4/M5, and the
    wallet/loyalty/F&B/audit Audit-Point rows to state ADR-006/007 Accepted and K-17/18/19
    locked consistently, and to reflect the audit envelope as design-resolved (remaining work
    = SR-004 mapping + retention + inventory entries + approved issues).
 2. (OQ additions) Add OQ-SEL-003, OQ-SEL-004, OQ-OPS-001 to OPEN_QUESTIONS.md (text in the
    review's "Recommended OPEN_QUESTIONS Additions" table).
 3. (B-2, co-owned) The inventory/security-review "absent" references are stale. Pod A owns
    DATA_PROCESSING_INVENTORY.md and the manifest; Pod B will draft the SECURITY_REVIEW.md and
    PROJECT_DECISION_INDEX.md (K-18/K-19/ADR-007) edits and the OPEN_QUESTIONS.md OQ-AUDIT-001
    note, for Pod B + Kerem review. Confirm with Pod B which file each of you edits before any PR.

Constraints:
 - These are documentation/planning changes. Do NOT change any gate or unblock Pod C.
 - The three genuinely-absent legal files (DATA_RETENTION_POLICY.md, KVKK_LEGAL_BASIS.md,
   CROSS_BORDER_TRANSFER_ASSESSMENT.md) remain absent and remain blockers — do NOT flip them.
 - Synthetic data only.

Review routing: Pod B reviews the corrected ROADMAP.md and the B-2 reconciliation; Kerem
approves and merges (no self-merge). The B-2 edits change a security artifact's gate language,
so the merge gate is Pod B + Kerem (ADR-009 §3 / K-11).

Expected output: corrected ROADMAP.md (B-1), updated OPEN_QUESTIONS.md (OQ additions), and a
reconciliation plan naming which pod edits which file for B-2.
```
