# Selcafe Read-Surface Reconciliation (ADR-005 §4.2) — Pod B Reconciliation Analysis v0.2

<!--
  ARTIFACT TYPE: Pod B reconciliation analysis (architecture/risk). Pre-implementation.
  CANONICAL HOME: TBD by Kerem (candidate: docs/SELCAFE_READ_SURFACE_RECONCILIATION_v0.2.md,
  or fold into the eventual ADR-005 v1.2 revision). NOT YET COMMITTED — command-keyword gated.
  STATUS: Does NOT authorize Pod C, schema/API work, ADR-005 edits, SelcafeAdapter implementation,
  direct Selcafe writes, the kasaislem reflection write, member-identity reads, real data, or
  replica provisioning. It is the §9 reconciliation analysis the ADR-005 / KVKK gate requires.
  Synthetic data only (Customer A, fiş 100045, +90 555 000 00 01, Station 12, code DSC-CMB).
-->

## 0a. Changes from v0.1 — PR sweep #109–#112 (re-execution)

Re-run after PRs #109, #110, #111, #112 merged. **Result: the substantive analysis is unchanged; one governance gate is added.**

| PR | What it did | Effect on this reconciliation |
|---|---|---|
| #109 | Adds `PROJECT_SEQUENCE_STATUS.md` mirror surface + one additive manifest routing row | **None** — mirror-only; explicitly does not touch ADR-005, schema/API, or planning. |
| **#110** | Adds the **Operating Slice Checkpoint** as a `PHASE_GATES.md` Phase 7 entry criterion (behavior-changing; Pod Impact Matrix + IUP in PR body) | **Material — governance only.** A new named Phase 7 gate now sits upstream of the ADR-005 v1.2 revision this analysis feeds. See §G below; integrated into Q8, §11, §12. |
| #111 | Mirror-only refresh of `PROJECT_SEQUENCE_STATUS.md` marking the checkpoint live | **None to substance** — confirms framing ("ADR-005 read-surface reconciliation + KVKK/legal review are the steps to satisfy it"). |
| #112 | `PHASE_GATES.md` housekeeping — PG-OQ-002 [RESOLVED] + internal matrix note | **None** — no gate text/criterion change. |

**Verified at HEAD `99e0c36`:** `ADR-005`, `SELCAFE_SPIKE_REPORT.md`, `KEREM_DECISIONS.md`, `BUSINESS_RULES.md`, `OPEN_QUESTIONS.md` are **byte-identical** to the v0.1 read; KVKK artifact state unchanged (only `DATA_PROCESSING_INVENTORY.md` present). Therefore **§1–§10 below carry forward from v0.1 unchanged** (FINDING A, FINDING B, the §9 answers, the projection, SR-003-5…10, and the legal-question set all stand). The edits in v0.2 are confined to §0, the FINDING B status line in §1, the new §G, and Q8/§11/§12.

> Minor maintainer note (not actioned here): `PROJECT_SEQUENCE_STATUS.md`'s source pin was set to `4766a8a` in #111 but HEAD is now `99e0c36` after #112 — the mirror's pin is one housekeeping step behind. Separate from this reconciliation; flagged for the sequence-status maintainer (Pod B).

---

## 0. Method & freshness

- **Repo HEAD pinned:** `99e0c36c5b54ad6eea3b8ea81f14a43013d435ba` (commit "docs: resolve PG-OQ-002 and reconcile PHASE_GATES internal matrix … (#112)", 2026-06-28). v0.1 was pinned at `fd56f929` (#108); analysis-input files verified byte-unchanged across the move (see §0a).
- **Read at that SHA:** `docs/adr/ADR-005-selcafe-read-only-adapter.md` (§4.1/4.2/4.2a/D-3a/4.3/5/6/9), `docs/SELCAFE_SPIKE_REPORT.md` (§6.2 row counts, §8 cross-table member FKs, §9 `masa`/`_pc`/`adisyon` columns, §10 `kasaislem` columns), `docs/BUSINESS_RULES.md` (BR-OS-015/023/024/025), `docs/KEREM_DECISIONS.md` §21 (K-21, KD-1/KD-2, K-OS-007, K-OS-008), `docs/OPEN_QUESTIONS.md` (OQ-OS-006/007).
- **KVKK artifact state verified at SHA:** `DATA_PROCESSING_INVENTORY.md` present; `KVKK_LEGAL_BASIS.md`, `CROSS_BORDER_TRANSFER_ASSESSMENT.md`, `DATA_RETENTION_POLICY.md` absent (404). Matches the handoff packet.
- **Pre-existing ADR-005 decisions relevant here:** **K-A1 = Option A (direct live SQL; replica deferred)** is already decided. **K-A5 = standing GATING ITEM — legal advisor required before *any* member-linked read** is already on record. Merge gate for any ADR-005 change is **Pod B + Kerem**, with **ADR-009 §4** firing (Pod Impact Matrix + Instruction Update Packet).
- **NEW gate in scope (PR #110):** the **Operating Slice Checkpoint** (`PHASE_GATES.md` Phase 7 entry) now also governs the eventual ADR-005 v1.2 revision for this slice. See §G.

---

## 1. Conclusion & recommendation

**Recommendation: conditional-include — with material conditions — over fallback.** A narrowed, **fiş-keyed** projection of `adisyon` + `detay` (plus the single `adisyon.kasaislem_no`-linked settlement `kasaislem` row), with member and staff FKs denied at the grant level, **can defensibly move from §4.2 hard-excluded to "conditionally included under controls"** — and it is the **only** path that delivers KD-1's product goal (showing F&B items a cashier typed straight into Selcafe). The §10 Adeks-native fallback structurally **cannot** show staff-entered items.

But the conditional-include is contingent, and the analysis surfaced **two findings the packet's framing did not anticipate**, both decisive:

- **FINDING A (security — the biggest new risk).** `adisyon_no` is a monotonic `int` PK over ~1.8M rows. If the customer-supplied fiş is a raw guessable integer, the bill view is a **cross-customer enumeration surface** — type an adjacent number, read someone else's itemized bill. The fiş-claim path **must** carry an anti-enumeration authorization design before this read can exist. This is the single hardest condition.
- **FINDING B (feasibility — the green-light mechanics).** `kasaislem` physically carries **no `adisyon_no` column and no discount-code column**. BR-OS-024/025 / K-OS-008 specify reading "the `kasaislem` discount **by `adisyon_no`**" — that read is **not supported by the schema as written.** The green-light must be redesigned to a **totals-based** comparison (`adisyon.toplam_tutar` and/or the single linked settlement row), not an explicit discount-line read. This is a **`[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]`** that feeds back into BR-OS-024/025. **As of PR #110 this is also checkpoint-blocking:** the Operating Slice Checkpoint requires a *reconciled* end-to-end operating-slice model, and a model whose green-light step is schema-infeasible is not reconciled — so the checkpoint cannot be cleared for this slice until the green-light correction lands (§G).

Plus a **spike gap**: `detay`'s columns were never captured (no column-detail section in the spike). The `detay` projection cannot be finalized until they are elicited.

**Net:** Recommend authorizing an ADR-005 read-surface revision **paired with** (i) legal/KVKK clearance, (ii) a solved anti-enumeration design, (iii) a green-light-mechanics correction (Pod A), and (iv) a targeted `detay`/discount-recording elicitation. If legal rejects the member-linked read, or the anti-enumeration design can't be made safe, fall back to §10 Option A (Adeks-native) or Option C (defer to Phase 2). **`[NEEDS KEREM APPROVAL]` — gated on legal first; not decidable this session.**

---

## 2. The §4.2 exclusion has two separable bases — only one is a real gate

ADR-005 §4.2 excludes `dbo.adisyon` and `dbo.kasaislem` for two stated reasons. Assessed separately:

- **Basis 1 — "SP-computed financial values."** This is **not a structural blocker** for the new ask. ADR-005's own trust model (SR-003-2.5; alternative A8; D-2) already says: *read SP-produced results, never re-implement pricing.* The product requirement reads `toplam_tutar` as settled truth **for display** and never recomputes Selcafe pricing. So Basis 1 was a "not required at the time" rationale, not a prohibition on reading a computed result. Reading-as-display is already inside the trust model.
- **Basis 2 — "member linkage → PII by linkage."** This **is** the real gate, and it is what K-A5 guards. Every `adisyon`/`kasaislem` row carries `uye_no`; even unprojected, the row *is* a specific member's session. This is genuine personal-data processing and cannot be waved away by column exclusion alone — it requires the legal/KVKK basis (§8) and the ADR-005 revision.

The reconciliation therefore turns entirely on Basis 2 plus the two new findings — not on the SP-computed-value concern.

---

## 3. §9 reconciliation answers

### Q1 — Hard-excluded → conditionally-included-under-controls, or stay excluded?
**Conditionally include**, for a **fiş-keyed projection of `adisyon` + `detay` + the single linked settlement `kasaislem` row**, member/staff FKs excluded — subject to §4–§6 conditions below. The key architectural distinction that makes this clean:

| Path | Disposition |
|---|---|
| `masa.aktif_adisyon_no` → `adisyon` → `uye_no` (resolve *who* is in a session) — the A6 / D-3a-forbidden move | **Stays forbidden.** Not reintroduced. |
| Customer-supplied **fiş** → `adisyon_no` selector → read non-identity columns of *that one bill* + its `detay` lines + its linked settlement `kasaislem`. **No `uye_no` read, no member resolution.** | **New conditional-include class.** The customer self-identifies their own bill; Adeks never derives the member's identity. |

This is not "read member-linked data to find the member"; it is "read one bill the customer pointed us to, with identity columns denied." That is a defensible, narrow class.

### Q2 — Exact minimized projection
See **§4** (authoritative table).

### Q3 — SR-003-x control extension
See **§5** (SR-003-5…10).

### Q4 — Does D-3a need amendment?
**Yes — a narrow amendment.** D-3a currently forbids `masa.aktif_adisyon_no → adisyon` resolution and forbids propagating `aktif_adisyon_no` as a usable FK. The new path needs a **server-internal** `masa.aktif_adisyon_no ↔ fiş` check as an *authorization gate* for the anti-enumeration control (FINDING A) — verifying a claimed fiş is genuinely active at a station — **without** resolving `uye_no` and **without** returning/propagating `aktif_adisyon_no` to the client or Adeks domain. Proposed amendment: *permit a server-side-only fiş-claim authorization match against `masa.aktif_adisyon_no`, identity-free and non-propagating; member resolution and client-side exposure of the FK remain forbidden.* Bounded, not a reversal of D-3a's intent.

### Q5 — `kasaislem` schema-mapping feasibility (DECISIVE — FINDING B)
`kasaislem` columns (spike §10): `kasaislem_no` (PK), `kasa_no`, `kullanici_no`, `islem_zaman`, `islem_tip` (FK→`islemtip`), `borc`, `alacak`, `aciklama` (varchar 250), `uye_no`, `pos_no`. There is **no `adisyon_no`** and **no discount-code column.** Consequences:

- The bill→payment link is **one-directional**: `adisyon.kasaislem_no → kasaislem` points to a **single** transaction (the settlement). It does **not** let one bill reference multiple `kasaislem` lines.
- A **separate** discount `kasaislem` line would have **no structural key back to the fiş** other than `uye_no` (excluded) or `kasa_no` + `islem_zaman` + amount (fragile, non-authoritative).
- A discount "code" can only land in `islem_tip` (an FK requiring a Selcafe-side `islemtip` config entry — a vendor/admin change, possibly out of scope) or in `aciklama` (free text — tamper-prone, no clean enum, and a minimization hazard).

**Therefore BR-OS-024/025's "read the `kasaislem` discount by `adisyon_no`" is infeasible as written.** Redesign the green-light to a **totals-based** comparison: Adeks compares its own discount-inclusive figure against **`adisyon.toplam_tutar`** (keyed by `adisyon_no`) and/or the single `adisyon.kasaislem_no`-linked settlement amount, within the 2% tolerance — the discount having been folded into settlement by the cashier. This removes the dependency on a non-existent discount-line read and on `islemtip` configuration. **`[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]`** — BR-OS-024/025 and the fixed-format-record spec need this correction.

### Q6 — Read source (direct vs replica)
**No change — Option A (direct) already decided (K-A1) and reinforced here.** The green-light needs `adisyon`/settlement freshness within seconds; a ~10-min replica is unusable for it. So this read path runs on the already-chosen direct read. **No new cross-border obligation arises from this surface** (Option A is in-region/LAN). The pre-existing "does a Selcafe→GCP replica exist at all" question (D-6 / K-A4) remains a **separate** `CROSS_BORDER_TRANSFER_ASSESSMENT.md` obligation, independent of this read.

### Q7 — SP-computed-value trust model
**Confirmed:** read `internet_tutar` / `cafe_tutar` / `toplam_tutar` and the settlement amount as **display/settled truth**, never recompute (SR-003-2.5, A8, D-2). **Caveat:** these `adisyon` financial columns are `float` — lossy for money. Coerce to the Adeks money type with range/sanity checks; the green-light comparison must be **tolerance-based and float-safe** (never float equality). The 2% band absorbs this, but the implementation must not assume exact `float` matches.

### Q8 — New ADR-005 revision via ADR-009 §4?
**Yes (flag only — not drafted here).** Moving `adisyon`/`detay`/(linked)`kasaislem` from §4.2 hard-excluded to a conditional-include class, amending D-3a (Q4), and adding SR-003-5…10 (§5) is a behaviour-change to an Accepted ADR. It requires an **ADR-005 v1.2 revision** through the **ADR-009 §4** gate (Pod Impact Matrix + `INSTRUCTION_UPDATE_PACKET.md`), merge gate **Pod B + Kerem**, Kerem sole merge authority. Do **not** draft that revision until legal clears and Kerem authorizes.

---

## 4. Finalized minimized projection (authoritative)

Selected **only** by customer-supplied fiş → `adisyon_no`; identity/staff columns **denied at the SQL grant level** so they cannot be queried, projected, or logged.

### `dbo.adisyon` (the claimed bill)
| Column | Purpose | Decision |
|---|---|---|
| `adisyon_no` | Bill key — selector + join key for `detay`/settlement `kasaislem` | INCLUDE as selector/join; **never expose raw id to client** |
| `masa_no` | Station confirmation | INCLUDE → neutral label (e.g. "Station 12") |
| `baslangic_zaman` / `bitis_zaman` / `kullanim_sure` | PC start / end / duration | INCLUDE (prefer `masa`-derived for live estimate; `adisyon` for settled) |
| `internet_tutar` / `cafe_tutar` | PC charge / F&B subtotal | INCLUDE — read-as-display; `float`→money coerce |
| `toplam_tutar` | Settled total | INCLUDE — settled truth; read-as-display |
| `durum` | Bill status (e.g. "settled") | INCLUDE — closed enum, fail-safe on unknown |
| `kasaislem_no` | FK to settlement transaction | INCLUDE as **join key only**; never expose |
| `uye_no` | — | **EXCLUDE — column-grant deny** (PII by linkage) |
| `uye_indirim`, `uye_indirim_oran`, `ek_indirim` | — | **EXCLUDE** (unused/STUB; BR-OS-023 retires member discount) |
| `kullanici_no`, `iptal_kullanici_no` | Staff FKs | **EXCLUDE — column-grant deny** (staff are data subjects) |
| `aciklama`, `iptal_aciklama` | Free text | **EXCLUDE** (may carry incidental PII) |
| `kasa_no`, `odeme_sekli`, `odeme_adisyon_no`, `diger_adisyon_tutar`, `cafe_adisyon` | Operational metadata | **EXCLUDE** (minimization) |

### `dbo.detay` (F&B line items) — **PENDING column elicitation (§7)**
| Column (expected) | Purpose | Decision |
|---|---|---|
| `adisyon_no` *(assumed link)* | Join to the claimed bill | INCLUDE as join key *[ASSUMPTION — confirm]* |
| item code / name | F&B line label (incl. cashier-entered) | INCLUDE — label only |
| quantity | Line qty | INCLUDE |
| line price | Line price | INCLUDE — read-as-display |
| any `uye_no` / `kullanici_no` on `detay` | — | **EXCLUDE if present — confirm in elicitation** |

### `dbo.kasaislem` — **only** the `adisyon.kasaislem_no`-linked settlement row
| Column | Purpose | Decision |
|---|---|---|
| `borc` / `alacak` | Settlement amount for the **totals-based** green-light (Q5) | INCLUDE — read-as-display; float-safe tolerance compare |
| `islem_zaman` | Settlement timing | INCLUDE if needed |
| `aciklama` | Free text (may carry a discount tag under the redesign) | **EXCLUDE by default**; INCLUDE a designated, non-identifying token **only** if the green-light redesign + fixed-format spec require it — flag |
| `islem_tip` | Transaction type | INCLUDE only if the redesign uses it to type a discount; closed-enum, fail-safe |
| `uye_no`, `kullanici_no`, `kasa_no`, `pos_no` | — | **EXCLUDE — column-grant deny / minimization** |

**Never read** (restating §4.2 hard lines that stand): `dbo.uye`, `dbo.basvuru`, `dbo.kullanici`, any `sifre`, `uye.bakiye`, `uyesinif` credit/balance columns, `masa.aktif_adisyon_no` as a propagated FK (server-internal authorization use only, per Q4).

---

## 5. Finalized control set (SR-003 extensions)

- **SR-003-5 — Anti-enumeration / fiş-claim authorization (FINDING A, highest priority).** The fiş selector must **not** be a raw guessable `adisyon_no`. Require server-side authorization that the claim is legitimate — account-bound **and** a verifiable claim factor (e.g. the fiş is currently active at a station, checked server-internally per Q4; or an unguessable claim token tied to the physical receipt). Rate-limit claim attempts, fail closed, never return adjacent bills, and never confirm existence of a non-owned fiş.
- **SR-003-6 — Column-level deny grants** on `adisyon` / `detay` / `kasaislem` for `uye_no`, `kullanici_no`, `iptal_kullanici_no` (extends SR-003-1; the RO login physically cannot select them).
- **SR-003-7 — Fiş-keyed selector only; no member resolution.** No `uye_no` in any query, join, projection, read model, or log (extends D-3a as amended in Q4).
- **SR-003-8 — Read-as-display only** for every financial value; `float`→money coercion with range/sanity checks; tolerance-based, float-safe comparison; never recompute Selcafe pricing (restates SR-003-2.5 / A8 for this surface).
- **SR-003-9 — Reverse-flow record discipline.** The cashier-entered `kasaislem` record carries a **non-identifying discount-type code + amount + bill key only** — never an Adeks customer/coupon/member id. Adeks logs **every issued** fixed-format record so the green-light can reconcile *issued* vs *settled* (and detect a settlement Adeks never issued).
- **SR-003-10 — Audit/log (minimized).** Log who claimed which fiş, what was displayed, which discount records were issued, and the green-light outcome — pseudonymized customer reference per the ADR-006 §13 / ADR-007 §11 standing rule; **no** Selcafe member identity.

---

## 6. Two locked-posture checks (both pass)

- **`[LOCKED PRINCIPLE CONFLICT]` — none.** **Read-only posture (D-1) is preserved.** The discount reflection is a **human bridge**: the *cashier* enters the record into Selcafe's own UI; the Adeks adapter issues no Selcafe write. Read-only is a system-boundary property of the adapter; the manual reflection is an operational act, already settled by **K-OS-008 / BR-OS-007**. Recorded explicitly so it is not glossed: *if* "read-only" were ever interpreted as "no Adeks-originated value may reach Selcafe by any path," that interpretation was foreclosed by K-OS-008.
- **Append-only ledgers (ADR-006/007) — untouched.** Nothing here writes to or derives the Adeks wallet/loyalty balance from Selcafe; `uye.bakiye` exclusion (§4.2a) stands.

---

## 7. Spike knowledge gap — must close before projection finalization

- **`detay` column detail is absent from the spike** (no §9–§11 column section). Per spike §8, `detay` is **not** among the tables carrying a direct `uye_no` FK (only `adisyon`, `kasaislem`, `kuyruk` are) — so `detay`'s member linkage is **indirect** (via its bill link to `adisyon.uye_no`). But the full `detay` schema, the exact bill-link column, and the presence/absence of any direct identifier on `detay` are **unconfirmed**.
- **Physical discount recording in `kasaislem`** at live settlement is unconfirmed — i.e. whether a member discount today is folded into the single settlement row or appears as a separate line (FINDING B turns on this).

**Targeted elicitation item (probe/aggregate-only, no row values, no real customer data):** capture `detay` column detail + its `adisyon` link; confirm how a settlement-time discount is physically represented in `kasaislem` (single net settlement row vs separate line; which field, if any, types it). This is a small Selcafe knowledge-elicitation pass, not a new spike.

---

## 8. Tightened KVKK / legal-question set (for the external advisor)

*Pod B is not a legal authority; these are framed for the advisor's determination, refined against the confirmed schema. They do not assert a legal conclusion.*

1. **Lawful basis (KVKK Art. 5)** for Adeks processing a customer's **own** visit/bill data fetched from Selcafe **by a customer-supplied fiş claim** — explicit consent (the claim), performance of a contract, or legitimate interest? Which applies, and what records it?
2. Is the **itemized bill + settled total personal data of the claiming customer**? And of the **Selcafe member if they differ** from the claimant (the guest/addition case)?
3. **Reading the linked settlement `kasaislem` row** (a financial-ledger row that carries `uye_no`/`kullanici_no`) with those identity columns **denied at the grant level** — is column-level exclusion **sufficient minimization**, or does *selecting the row at all* constitute processing the member's personal data requiring its own basis?
4. **Reverse flow:** lawful basis + minimization for an Adeks-derived discount record entered into Selcafe `kasaislem` by the cashier. Given `kasaislem` has **no dedicated code field** (only `islem_tip` / `aciklama` / `borc`/`alacak`), confirm that a **non-identifying discount-type token** in a designated field does not push Adeks-linked personal data into Selcafe and does not create a new Selcafe-side cross-system identifier tying a `kasaislem` row to an Adeks coupon/customer.
5. **Guest/addition mismatch:** when the Adeks claimant ≠ the Selcafe member on the fiş, whose personal data is shown, and is the claimant authorized to see it?
6. **Retention:** how long may Selcafe-derived bill/line/settlement data persist in Adeks, and in what form (display-only/transient vs stored-minimized)?
7. **Required artifacts:** `KVKK_LEGAL_BASIS.md` (**absent**), a `DATA_PROCESSING_INVENTORY.md` "Selcafe-derived active-bill surfaces" entry (**inventory present** — needs the entry), the **Aydınlatma Metni** update, `DATA_RETENTION_POLICY.md` (**absent**).
8. **Cross-border:** confirmed **not** triggered by this read path (Option A, direct/in-region). Independent of this surface, does any existing Selcafe→GCP replica trigger `CROSS_BORDER_TRANSFER_ASSESSMENT.md` (**absent**) on its own?

---

## 9. Auditability & retention questions (for the implementation gate)

The discount now reconciles as: **[Adeks-issued fixed-format record] → [cashier folds it into settlement `kasaislem`] → [`adisyon.toplam_tutar` + linked settlement amount] → [Adeks totals-based 2% check → green light]**. Control points to define before any implementation: wrong amount; omitted/mis-typed discount; a settlement Adeks never issued (reconcile against the SR-003-9 issued-record log); float/tolerance edge cases. Open: exactly which read/display/issue events are logged and for how long; whether Selcafe-derived bill values are display-only/transient or stored-minimized in Adeks; how "no member identity read" is *evidenced* (column-level deny + security-regression tests per SECURITY_REVIEW SR-006).

---

## 10. Recommendation vs fallbacks (restated with the new conditions)

- **Conditional-include (recommended)** — deliverable *if* all hold: (a) legal/KVKK clearance (K-A5 fires; absent artifacts produced); (b) a solved **anti-enumeration** fiş-claim design (SR-003-5); (c) the **green-light-mechanics correction** (Q5/FINDING B, Pod A); (d) `detay`/discount-recording **elicitation** (§7); then (e) ADR-005 v1.2 via the ADR-009 §4 gate. **Only path that delivers KD-1.**
- **Fallback A — Adeks-native** (PWA items + Adeks PC estimate; no `adisyon`/`detay`/`kasaislem` read). Keeps ADR-005 intact; **cannot** show staff-entered items or auto-verify the settled total → the 2% green light becomes manual/trust-based.
- **Fallback B — reflect discount, don't read back.** Green light from Adeks's own calculation only; no Selcafe-side verification.
- **Fallback C — defer** the live bill/order-line view + settled-amount read to Phase 2; Phase 1 keeps PWA-order visibility + Adeks estimate.

---

## G. Operating Slice Checkpoint (PR #110) — added Phase 7 gate for this slice

PR #110 added the **Operating Slice Checkpoint** to `PHASE_GATES.md` as a Phase 7 (Architecture & Design) entry criterion. Verbatim intent: *before component-level ADRs, schema/API design, or implementation-ready issue drafting for an operating slice, a Kerem-approved end-to-end operating-slice model for that slice must be committed and reconciled against locked ADRs and decisions, with no open `[LOCKED PRINCIPLE CONFLICT]` for the slice.* It was created specifically because "the live-bill direction collided with ADR-005's read-only posture" — i.e. this exact slice.

**Boundary-test classification.** Foundational, slice-independent decisions (ledgers, tenancy, auth, **the read-only Selcafe posture D-1**) are *out of scope* of the checkpoint. But the **ADR-005 v1.2 read-surface expansion is slice-tied** — it depends on this slice's café workflow (fiş-claim, live bill view, discount reflection) and would not be reused unchanged across arbitrary future slices. **→ In scope of the checkpoint.**

**Effect on this reconciliation (governance only — no substance change):**

1. The eventual **ADR-005 v1.2 revision is now gated by three things, not two**: (a) legal/KVKK clearance (K-A5), (b) the ADR-009 §4 behaviour-change gate, and now (c) the Operating Slice Checkpoint (Phase 7 entry).
2. **This analysis is checkpoint *evidence*, not a checkpoint *pass*.** It supplies the "reconciled against locked ADRs" work and the `[LOCKED PRINCIPLE CONFLICT]` determination for this slice (§6 — none found; D-1 preserved via human bridge). It does **not** itself satisfy the checkpoint: the checkpoint requires a **Kerem-approved, committed, reconciled end-to-end operating-slice model** (a Pod A artifact), which this Pod B risk analysis informs but does not replace.
3. **FINDING B blocks checkpoint satisfaction.** "Reconciled" cannot be true while the slice model's green-light step (BR-OS-024/025) is schema-infeasible. The green-light correction must land in the operating-slice model before the checkpoint can be cleared — so FINDING B is now on the **critical path** of the checkpoint, not merely a downstream product flag.

No `PHASE_GATES.md` edit is needed from Pod B here; the checkpoint is already canonical. This section records the gate's bearing on the reconciliation.

---

## 11. What must not proceed

No ADR-005 edit; no schema/API contracts; no `SelcafeAdapter` implementation; no Pod C; no direct Selcafe writes; no member-identity reads; no real data; no replica provisioning; no building the discount read-back into an issue — until (i) this Pod B analysis is accepted, (ii) the §8 legal/KVKK clearance is obtained, (iii) FINDING A's anti-enumeration design and FINDING B's green-light correction are resolved, (iv) the **Operating Slice Checkpoint** is satisfied for this slice (a committed, Kerem-approved, reconciled end-to-end operating-slice model with FINDING B corrected; §G), and (v) if accepted, ADR-005 v1.2 lands through the ADR-009 §4 gate. The fixed-format-record **product spec** remains a separate Pod A item; only its Selcafe write / Adeks read is gated here.

---

## 12. The single Kerem decision (teed up — not taken this session)

This session delivers the analysis and recommendation. The decision returns **after legal**: *authorize an ADR-005 v1.2 read-surface revision (conditional-include per §1/§4/§5, paired with the FINDING B green-light correction), or adopt a §10 fallback.* That revision must then clear the full Phase 7 stack — legal/KVKK (K-A5), the **Operating Slice Checkpoint** (§G), and ADR-009 §4. **`[NEEDS KEREM APPROVAL]`.** Immediate next action is **routing the §8 legal-question set to the advisor** — the authorize-vs-fallback decision cannot be made until it returns; in parallel, FINDING B's green-light correction (Pod A) is the checkpoint-critical item.
