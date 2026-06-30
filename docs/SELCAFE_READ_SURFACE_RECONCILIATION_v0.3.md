# Selcafe Read-Surface Reconciliation (ADR-005 §4.2) — Pod B Reconciliation Analysis v0.3

<!--
  ARTIFACT TYPE: Pod B reconciliation analysis (architecture/risk). Pre-implementation.
  CANONICAL HOME: TBD by Kerem (candidate: docs/SELCAFE_READ_SURFACE_RECONCILIATION_v0.3.md,
  or fold into the eventual ADR-005 v1.2 revision). NOT YET COMMITTED — command-keyword gated.
  v0.3 supersedes v0.2 (v0.2 retained as historical); change driver is the 2026-06-30 kasaislem
  mechanism elicitation (see §0b).
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

## 0b. Changes from v0.2 — `kasaislem` mechanism elicitation (2026-06-30)

Driver: a Pod B↔Kerem QA session (Rounds 1–3) that closed the `kasaislem` behaviour gap flagged in v0.2 §7. Derived from v0.2 at SHA `48b7378`; v0.2 substance carries forward **except** as below. Schema/behaviour facts only — no row values, no real customer data.

**Mechanism (now complete).** `kasaislem` is a **general cash-register/till journal** — no cash operation, no row; never a settlement record. Settlement truth lives on `adisyon`; authoritative figure = **`adisyon.toplam_tutar`** (full, pre-cash-discount, fixed after settlement). **`adisyon.kasaislem_no` is a stub** (no reliable bill↔till link either way). Member/SP discount → `adisyon.uye_indirim` (retired by K-OS-008). Manual cash discount → a hand-entered `kasaislem` row, amount in **`alacak`**, free-text `aciklama`. A bill may also be transferred to another bill (`adisyon.odeme_adisyon_no` + `diger_adisyon_tutar`) with **no** `kasaislem` row at all.

**FINDING B — superseded then re-resolved.** v0.2 redesigned the green-light to a **totals-only** comparison against `adisyon.toplam_tutar`. That is **wrong**: a cash discount does not reduce `toplam_tutar`, so a totals comparison verifies nothing about the discount. New resolution (Kerem-decided): Adeks reflects the discount as a `kasaislem` row with a **dedicated Adeks `islem_tip`** (admin-panel-defined; cashier-selected from the Kasiyer dropdown) + a **pseudorandom one-time code** in `aciklama` + amount in **`alacak`**; Adeks reads `adisyon.toplam_tutar` by fiş and the discount `alacak` by `islem_tip`+code, joining **inside Adeks**.

**Green-light (pinned).** `adisyon.toplam_tutar` − `kasaislem.alacak` (matched by dedicated `islem_tip` + code) ≟ Adeks's discount-inclusive total, within 2%; **fail-closed**.

**Read-surface effect.** `kasaislem` **stays in** the read surface as a single Adeks-reflected discount row (identity/staff columns grant-denied). The v0.2 "single `adisyon.kasaislem_no`-linked settlement row" sub-projection is replaced by the `islem_tip`+code-matched discount row. `adisyon.kasaislem_no` moves to EXCLUDE (stub).

**Decisions recorded this session.** Discount sign = `alacak` (positive). Reflection key = dedicated Adeks `islem_tip` + **pseudorandom** one-time code (enumerated rejected — leaks discount ordering/volume, weaker minimization, residual collision risk). Both feed `[NEEDS KEREM APPROVAL]` fixed-format spec + advisor sign-off (still pending).

**KVKK posture (honest).** This **re-engages** advisor §8 Q3/Q4 — it does not shrink them. An Adeks token is deliberately placed into Selcafe (write-posture already settled by K-OS-008, human bridge); pseudorandom keeps it from leaking identity/ordering; the dedicated `islem_tip` does make Adeks discount **volume** countable in Selcafe (inherent to reflecting discounts at all). `kasaislem.uye_no`/staff columns remain grant-denied.

**Sections changed vs v0.2:** §1 (FINDING B bullet + recommendation clause), §3 Q5, §4 (`adisyon.kasaislem_no` row + the `kasaislem` sub-projection), §5 (SR-003-9), §7 (kasaislem gap closed; `detay` still open), §8 (Q3/Q4), §9 (reconciliation chain), §G (point 3 note). **Unchanged in substance:** FINDING A, §2, §6 locked-posture checks, §10 fallbacks, §11–§12, the governance/checkpoint layer.

**Still gated (unchanged):** no ADR-005 edit, no Pod C implementation, no Selcafe writes/reads, no real data; legal/KVKK (K-A5), Operating Slice Checkpoint, and ADR-009 §4 all still stand ahead of any ADR-005 v1.2.

---

## 0. Method & freshness

- **Repo HEAD pinned:** `99e0c36c5b54ad6eea3b8ea81f14a43013d435ba` (commit "docs: resolve PG-OQ-002 and reconcile PHASE_GATES internal matrix … (#112)", 2026-06-28). v0.1 was pinned at `fd56f929` (#108); analysis-input files verified byte-unchanged across the move (see §0a).
- **Read at that SHA:** `docs/adr/ADR-005-selcafe-read-only-adapter.md` (§4.1/4.2/4.2a/D-3a/4.3/5/6/9), `docs/SELCAFE_SPIKE_REPORT.md` (§6.2 row counts, §8 cross-table member FKs, §9 `masa`/`_pc`/`adisyon` columns, §10 `kasaislem` columns), `docs/BUSINESS_RULES.md` (BR-OS-015/023/024/025), `docs/KEREM_DECISIONS.md` §21 (K-21, KD-1/KD-2, K-OS-007, K-OS-008), `docs/OPEN_QUESTIONS.md` (OQ-OS-006/007).
- **KVKK artifact state verified at SHA:** `DATA_PROCESSING_INVENTORY.md` present; `KVKK_LEGAL_BASIS.md`, `CROSS_BORDER_TRANSFER_ASSESSMENT.md`, `DATA_RETENTION_POLICY.md` absent (404). Matches the handoff packet.
- **Pre-existing ADR-005 decisions relevant here:** **K-A1 = Option A (direct live SQL; replica deferred)** is already decided. **K-A5 = standing GATING ITEM — legal advisor required before *any* member-linked read** is already on record. Merge gate for any ADR-005 change is **Pod B + Kerem**, with **ADR-009 §4** firing (Pod Impact Matrix + Instruction Update Packet).
- **NEW gate in scope (PR #110):** the **Operating Slice Checkpoint** (`PHASE_GATES.md` Phase 7 entry) now also governs the eventual ADR-005 v1.2 revision for this slice. See §G.

---

## 1. Conclusion & recommendation

**Recommendation: conditional-include — with material conditions — over fallback.** A narrowed, **fiş-keyed** projection of `adisyon` + `detay` (plus a single Adeks-reflected discount `kasaislem` row, matched by a dedicated Adeks `islem_tip` + pseudorandom code — *not* via `adisyon.kasaislem_no`, which is a stub), with member and staff FKs denied at the grant level, **can defensibly move from §4.2 hard-excluded to "conditionally included under controls"** — and it is the **only** path that delivers KD-1's product goal (showing F&B items a cashier typed straight into Selcafe). The §10 Adeks-native fallback structurally **cannot** show staff-entered items.

But the conditional-include is contingent, and the analysis surfaced **two findings the packet's framing did not anticipate**, both decisive:

- **FINDING A (security — the biggest new risk).** `adisyon_no` is a monotonic `int` PK over ~1.8M rows. If the customer-supplied fiş is a raw guessable integer, the bill view is a **cross-customer enumeration surface** — type an adjacent number, read someone else's itemized bill. The fiş-claim path **must** carry an anti-enumeration authorization design before this read can exist. This is the single hardest condition.
- **FINDING B (feasibility — the green-light mechanics; *resolved 2026-06-30*).** `kasaislem` is a **general till journal**, not a settlement record, and carries **no `adisyon_no`** and no native discount-code column; **`adisyon.kasaislem_no` is a stub.** Settlement truth is `adisyon.toplam_tutar` (full, pre-cash-discount). v0.2's totals-only redesign is **superseded** — a cash discount never reduces `toplam_tutar`, so a totals comparison verifies nothing. **Resolution:** Adeks reflects the discount as a `kasaislem` row with a **dedicated Adeks `islem_tip`** (admin-panel-defined; cashier-selected) + a **pseudorandom code** in `aciklama` + amount in **`alacak`**, read back and joined to the bill **inside Adeks** (§3 Q5). This is a **`[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]`** for BR-OS-024/025 + the fixed-format spec. **It remains checkpoint-relevant (§G):** the corrected green-light must be reflected in the Kerem-approved operating-slice model before the checkpoint clears.

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

### Q5 — `kasaislem` schema-mapping feasibility (DECISIVE — FINDING B, resolved 2026-06-30)
`kasaislem` columns (spike §10): `kasaislem_no` (PK), `kasa_no`, `kullanici_no`, `islem_zaman`, `islem_tip` (FK→`islemtip`), `borc`, `alacak`, `aciklama` (varchar 250), `uye_no`, `pos_no`. There is **no `adisyon_no`** and **no native discount-code column.** Mechanism elicitation (§0b) establishes the live behaviour:

- `kasaislem` is a **general cash-register/till journal** — no cash operation, no row. It is **never** the settlement record. Settlement is computed onto `adisyon`; the authoritative settled figure is **`adisyon.toplam_tutar`** (full price, pre-cash-discount, fixed after settlement).
- **`adisyon.kasaislem_no` is a stub** — there is no reliable bill↔till link in either direction. The earlier "single linked settlement row" assumption is withdrawn.
- A member/SP discount lives only in **`adisyon.uye_indirim`** (the surface K-OS-008 retires). A manual **cash discount** — the structural twin of the Adeks discount — is a hand-entered `kasaislem` row: amount in **`alacak`**, free-text `aciklama`, no key back to the bill.

**Consequence for the green-light:** a cash discount does **not** reduce `adisyon.toplam_tutar`, so a totals-only comparison against it verifies nothing about whether a discount was applied. v0.2's totals-only redesign is therefore **superseded.** And "read the discount **by `adisyon_no`**" is doubly dead — no `adisyon_no` on `kasaislem`, and the only navigational FK is a stub.

**Resolution (Kerem-decided this session).** Adeks reflects its discount as a `kasaislem` row carrying a **dedicated Adeks `islem_tip`** (defined once in the Selcafe admin panel; cashier-selects it from the Kasiyer dropdown) + a **pseudorandom one-time code** in `aciklama` + the **amount in `alacak`**. Adeks holds the `code → adisyon_no → expected discount` mapping. The green-light reads two things and joins them **inside Adeks** (never in Selcafe):

> `adisyon.toplam_tutar` (by claimed fiş) **−** `kasaislem.alacak` (the row where `islem_tip` = the dedicated Adeks value AND `aciklama` contains the code) **≟** Adeks's discount-inclusive total, within 2%. **Fail-closed:** no clean match → no green light → manual check. The row is verification-only, never settlement truth.

The dedicated `islem_tip` self-isolates Adeks rows (no collision with native cash-discount rows; no free-text-only fragility), and is a one-time Selcafe admin-panel setup — **not** a per-transaction vendor change. **`[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]`** — BR-OS-024/025 and the fixed-format-record spec need: (a) the wording fix `adisyon_no` → Adeks pseudorandom code + dedicated `islem_tip`; (b) the code-generation + delimiting rule; (c) the `islemtip` definition as a pilot setup prerequisite. **`[NEEDS KEREM APPROVAL]`** on the fixed-format spec; advisor sign-off on §8 Q4 still required.

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
| `kasaislem_no` | FK to a till transaction — **STUB** (often unset; not a reliable bill↔till link) | **EXCLUDE** — not a usable join key (mechanism elicitation 2026-06-30) |
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

### `dbo.kasaislem` — **only** the Adeks-reflected discount row (matched by dedicated `islem_tip` + pseudorandom code)
Selected by `islem_tip = <dedicated Adeks value>` AND `aciklama` containing the Adeks pseudorandom code for the claimed bill. Adeks holds the `code → adisyon_no → expected discount` mapping; the `adisyon` read and this read are joined **inside Adeks**, never in Selcafe. `adisyon.kasaislem_no` is a stub and is not used.
| Column | Purpose | Decision |
|---|---|---|
| `alacak` | Discount amount (positive credit) for the green-light | INCLUDE — read-as-display; `float`→money coerce; float-safe tolerance compare |
| `islem_tip` | Dedicated Adeks transaction type — row selector | INCLUDE as selector (closed match on the Adeks value; fail-safe) |
| `aciklama` | Carries the **pseudorandom one-time code** (non-identifying) — row selector / bill key | INCLUDE — match only; the code carries no customer/coupon/member id (SR-003-9) |
| `islem_zaman` | Reflection timing | INCLUDE if needed for reconciliation |
| `borc` | — | **EXCLUDE** (discount uses `alacak`) |
| `uye_no`, `kullanici_no`, `kasa_no`, `pos_no` | — | **EXCLUDE — column-grant deny / minimization** |

**Never read** (restating §4.2 hard lines that stand): `dbo.uye`, `dbo.basvuru`, `dbo.kullanici`, any `sifre`, `uye.bakiye`, `uyesinif` credit/balance columns, `masa.aktif_adisyon_no` as a propagated FK (server-internal authorization use only, per Q4).

---

## 5. Finalized control set (SR-003 extensions)

- **SR-003-5 — Anti-enumeration / fiş-claim authorization (FINDING A, highest priority).** The fiş selector must **not** be a raw guessable `adisyon_no`. Require server-side authorization that the claim is legitimate — account-bound **and** a verifiable claim factor (e.g. the fiş is currently active at a station, checked server-internally per Q4; or an unguessable claim token tied to the physical receipt). Rate-limit claim attempts, fail closed, never return adjacent bills, and never confirm existence of a non-owned fiş.
- **SR-003-6 — Column-level deny grants** on `adisyon` / `detay` / `kasaislem` for `uye_no`, `kullanici_no`, `iptal_kullanici_no` (extends SR-003-1; the RO login physically cannot select them).
- **SR-003-7 — Fiş-keyed selector only; no member resolution.** No `uye_no` in any query, join, projection, read model, or log (extends D-3a as amended in Q4).
- **SR-003-8 — Read-as-display only** for every financial value; `float`→money coercion with range/sanity checks; tolerance-based, float-safe comparison; never recompute Selcafe pricing (restates SR-003-2.5 / A8 for this surface).
- **SR-003-9 — Reverse-flow record discipline.** The cashier-entered `kasaislem` discount row carries **only**: the **dedicated Adeks `islem_tip`** (row selector), a **pseudorandom one-time code** in `aciklama` (the bill key — Adeks holds `code → adisyon_no`), and the **amount in `alacak`** — **never** an Adeks customer/coupon/member id, and **not** `adisyon_no` itself. Adeks logs **every issued** code so the green-light reconciles *issued* vs *settled* and detects a settlement Adeks never issued. The read is **fail-closed**: no clean `islem_tip`+code match → no green light → manual check; the row is verification-only, never settlement truth.
- **SR-003-10 — Audit/log (minimized).** Log who claimed which fiş, what was displayed, which discount records were issued, and the green-light outcome — pseudonymized customer reference per the ADR-006 §13 / ADR-007 §11 standing rule; **no** Selcafe member identity.

---

## 6. Two locked-posture checks (both pass)

- **`[LOCKED PRINCIPLE CONFLICT]` — none.** **Read-only posture (D-1) is preserved.** The discount reflection is a **human bridge**: the *cashier* enters the record into Selcafe's own UI; the Adeks adapter issues no Selcafe write. Read-only is a system-boundary property of the adapter; the manual reflection is an operational act, already settled by **K-OS-008 / BR-OS-007**. Recorded explicitly so it is not glossed: *if* "read-only" were ever interpreted as "no Adeks-originated value may reach Selcafe by any path," that interpretation was foreclosed by K-OS-008.
- **Append-only ledgers (ADR-006/007) — untouched.** Nothing here writes to or derives the Adeks wallet/loyalty balance from Selcafe; `uye.bakiye` exclusion (§4.2a) stands.

---

## 7. Spike knowledge gap — must close before projection finalization

- **`detay` column detail is absent from the spike** (no §9–§11 column section). Per spike §8, `detay` is **not** among the tables carrying a direct `uye_no` FK (only `adisyon`, `kasaislem`, `kuyruk` are) — so `detay`'s member linkage is **indirect** (via its bill link to `adisyon.uye_no`). But the full `detay` schema, the exact bill-link column, and the presence/absence of any direct identifier on `detay` are **unconfirmed**.
- **Physical discount recording in `kasaislem` — RESOLVED (2026-06-30, §0b).** A member/SP discount lives only in `adisyon.uye_indirim` (no `kasaislem` row). A manual cash discount is a hand-entered `kasaislem` row (`alacak`, free-text `aciklama`); `kasaislem` is a general till journal, never a settlement record, and `adisyon.kasaislem_no` is a stub. The Adeks reflection adopts this manual path with a dedicated `islem_tip` + pseudorandom code. **No remaining gap here.**

**Targeted elicitation item (probe/aggregate-only, no row values, no real customer data):** capture `detay` column detail + its `adisyon` link. *(The `kasaislem` discount-recording question is now closed by §0b; no probe needed for it.)* This is a small Selcafe knowledge-elicitation pass, not a new spike.

---

## 8. Tightened KVKK / legal-question set (for the external advisor)

*Pod B is not a legal authority; these are framed for the advisor's determination, refined against the confirmed schema. They do not assert a legal conclusion.*

1. **Lawful basis (KVKK Art. 5)** for Adeks processing a customer's **own** visit/bill data fetched from Selcafe **by a customer-supplied fiş claim** — explicit consent (the claim), performance of a contract, or legitimate interest? Which applies, and what records it?
2. Is the **itemized bill + settled total personal data of the claiming customer**? And of the **Selcafe member if they differ** from the claimant (the guest/addition case)?
3. **Reading the Adeks-reflected discount `kasaislem` row** — selected by a dedicated Adeks `islem_tip` + pseudorandom code, with `uye_no`/`kullanici_no` **denied at the grant level**. (`kasaislem` is a till journal, not the settlement record; the settled figure comes from `adisyon.toplam_tutar`.) Is column-level exclusion **sufficient minimization**, or does *selecting the row at all* — a row a cashier may or may not have stamped with `uye_no` — constitute processing personal data requiring its own basis?
4. **Reverse flow:** lawful basis + minimization for an Adeks-derived discount record entered into Selcafe `kasaislem` by the cashier — now a **dedicated Adeks `islem_tip`** + a **pseudorandom one-time code** in `aciklama` + amount in `alacak`. Confirm that (a) the pseudorandom code (not `adisyon_no`, not any customer/coupon/member id) is acceptable minimization and does not create a durable Selcafe-side cross-system identifier; and (b) a dedicated Adeks `islem_tip` — which makes Adeks discount **volume/ordering** countable in Selcafe — is acceptable, given it is inherent to reflecting Adeks discounts into settlement at all.
5. **Guest/addition mismatch:** when the Adeks claimant ≠ the Selcafe member on the fiş, whose personal data is shown, and is the claimant authorized to see it?
6. **Retention:** how long may Selcafe-derived bill/line/settlement data persist in Adeks, and in what form (display-only/transient vs stored-minimized)?
7. **Required artifacts:** `KVKK_LEGAL_BASIS.md` (**absent**), a `DATA_PROCESSING_INVENTORY.md` "Selcafe-derived active-bill surfaces" entry (**inventory present** — needs the entry), the **Aydınlatma Metni** update, `DATA_RETENTION_POLICY.md` (**absent**).
8. **Cross-border:** confirmed **not** triggered by this read path (Option A, direct/in-region). Independent of this surface, does any existing Selcafe→GCP replica trigger `CROSS_BORDER_TRANSFER_ASSESSMENT.md` (**absent**) on its own?

---

## 9. Auditability & retention questions (for the implementation gate)

The discount now reconciles as: **[Adeks issues a fixed-format record: pseudorandom code + dedicated `islem_tip` + amount] → [cashier enters a `kasaislem` row: Adeks `islem_tip`, code in `aciklama`, amount in `alacak`] → [Adeks reads `adisyon.toplam_tutar` by fiş and the discount `alacak` by `islem_tip`+code, joins inside Adeks] → [green-light: `toplam_tutar` − `alacak` ≟ Adeks total, within 2%, fail-closed]**. Control points to define before any implementation: wrong amount; omitted/mis-typed discount; a settlement Adeks never issued (reconcile against the SR-003-9 issued-record log); float/tolerance edge cases. Open: exactly which read/display/issue events are logged and for how long; whether Selcafe-derived bill values are display-only/transient or stored-minimized in Adeks; how "no member identity read" is *evidenced* (column-level deny + security-regression tests per SECURITY_REVIEW SR-006).

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
3. **FINDING B blocks checkpoint satisfaction.** "Reconciled" cannot be true while the slice model's green-light step (BR-OS-024/025) is schema-infeasible. The green-light correction must land in the operating-slice model before the checkpoint can be cleared — so FINDING B is now on the **critical path** of the checkpoint, not merely a downstream product flag. **(v0.3 update: FINDING B is now resolved *in principle* — dedicated `islem_tip` + pseudorandom code, §0b/§3 Q5 — but the resolution must still be reflected in the Kerem-approved operating-slice model and in BR-OS-024/025 wording before the checkpoint clears.)**

No `PHASE_GATES.md` edit is needed from Pod B here; the checkpoint is already canonical. This section records the gate's bearing on the reconciliation.

---

## 11. What must not proceed

No ADR-005 edit; no schema/API contracts; no `SelcafeAdapter` implementation; no Pod C; no direct Selcafe writes; no member-identity reads; no real data; no replica provisioning; no building the discount read-back into an issue — until (i) this Pod B analysis is accepted, (ii) the §8 legal/KVKK clearance is obtained, (iii) FINDING A's anti-enumeration design and FINDING B's green-light correction are resolved, (iv) the **Operating Slice Checkpoint** is satisfied for this slice (a committed, Kerem-approved, reconciled end-to-end operating-slice model with FINDING B corrected; §G), and (v) if accepted, ADR-005 v1.2 lands through the ADR-009 §4 gate. The fixed-format-record **product spec** remains a separate Pod A item; only its Selcafe write / Adeks read is gated here.

---

## 12. The single Kerem decision (teed up — not taken this session)

This session delivers the analysis and recommendation. The decision returns **after legal**: *authorize an ADR-005 v1.2 read-surface revision (conditional-include per §1/§4/§5, paired with the FINDING B green-light correction), or adopt a §10 fallback.* That revision must then clear the full Phase 7 stack — legal/KVKK (K-A5), the **Operating Slice Checkpoint** (§G), and ADR-009 §4. **`[NEEDS KEREM APPROVAL]`.** Immediate next action is **routing the §8 legal-question set to the advisor** — the authorize-vs-fallback decision cannot be made until it returns; in parallel, FINDING B's green-light correction (Pod A) is the checkpoint-critical item.
