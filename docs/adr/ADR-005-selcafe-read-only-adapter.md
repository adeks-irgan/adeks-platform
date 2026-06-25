# ADR-005: Selcafe Read-Only Phase 1 Adapter

<!--
  STATUS: Accepted — Kerem-approved 2026-06-23 (full ADR text). v1.1 Spike v2 reconciliation 2026-06-24 (HEAD 33a55a9); §4.1 narrowed, §4.2 classification notes added, K-A3 closed, OQ-SC-NEW-001 resolved.
  AUTHOR: Pod B — Architecture, Logic & Risk
  CREATED: 2026-06-07 (stub) — FULL TEXT: 2026-06-23
  CANONICAL REPO PATH: /docs/adr/ADR-005-selcafe-read-only-adapter.md
  SUPERSEDES: the 2026-06-07 ADR-005 stub (decision direction unchanged; this adds full text)
  TASK REF: ROADMAP Seq 16 (unblocks M3 completion and M6 Reservation Readiness)
  HEAD SHA AT AUTHORING: 5102859e6ba9bc0bf6a56963369cf69ef99c984d
  SOURCES READ LIVE AT THIS SHA:
    - docs/adr/ADR-005-selcafe-read-only-adapter.md (stub)
    - docs/SECURITY_REVIEW.md (SR-001, SR-003, §4.6)
    - docs/PROJECT_BRIEF.md (§3, §5, §11, §14, §16)
    - docs/PROJECT_DECISION_INDEX.md (ADR-005 backlog row; K-10; K-11)
    - docs/AGENT_CONTEXT_MANIFEST.md (Selcafe integration row; legal-artifact row)
    - docs/DATA_PROCESSING_INVENTORY.md (v0.1, Kerem-approved 2026-06-15)
  SOURCE ATTACHED (NOT read from repo, per handoff):
    - SELCAFE_SPIKE_REPORT.md (Pod C execution v1.1, Sections 1–13; PR #91)
  MERGE GATE: Pod B + Kerem (ADR-009 §3 Selcafe-adapter trigger; K-11). Kerem sole merge authority.
  IMPLEMENTATION AUTHORITY: This ADR does NOT authorize Pod C. It designs no migrations,
    writes no code, creates no issues, and provisions no infrastructure.
  DATA: Synthetic data only. No real Adeks customer/member/staff/transaction data appears.
    Selcafe identifiers below are SCHEMA OBJECT NAMES (table/column names) only — no row values.
-->

## Status

**Accepted — Kerem-approved 2026-06-23 (full ADR text).**

The **decision direction** (read-only Selcafe integration in Phase 1 via the `CafeManagementAdapter` pattern) was **Locked on 2026-06-07**. This document supplies the full ADR that the stub deferred and is now **Accepted**; the `PROJECT_DECISION_INDEX.md` ADR-005 row transitions from *Backlog — decision locked, ADR to write* → **Accepted** in the same PR.

**Decisions recorded with this acceptance (Kerem, 2026-06-23):** **K-A1 = Option A** (direct, scoped, read-only live SQL read for freshness-sensitive targets; replica/BigQuery source **deferred**). **K-A2 = authorized** (provision a dedicated least-privilege read-only login). **K-A4 / K-A5 = gating items** for any *future* PII or cross-border expansion (no such expansion is approved by this ADR).

- **Merge gate:** Pod B + Kerem (strictest ADR-009 §3 trigger — *Selcafe adapter or Selcafe integration changes → Pod B + Kerem required before merge*; K-11). **Kerem is sole merge authority.**
- **Behavior-change classification (ADR-009 §4):** the merging PR **fires the §4 gate** — it resolves previously-open `[NEEDS KEREM APPROVAL]` items and transitions a decision state (stub → Accepted). It therefore requires a **Pod Impact Matrix** and a filled **`INSTRUCTION_UPDATE_PACKET.md`** (ADR-013 §7). See §8.
- **This ADR does NOT authorize Pod C.** Adapter implementation is gated (see §8).

---

## 1. Context

### 1.1 Selcafe as a legacy dependency

Per `PROJECT_BRIEF.md` §3/§14, Selcafe is the incumbent proprietary café-management system: a local SQL Server database with a Windows cashier app and PC client, **no API**, and no POS-device integration. Phase 1 policy is **read-only discovery/sync if feasible**, with **no direct writes** to Selcafe unless Kerem later approves. Selcafe must be treated as a **legacy adapter, not the Adeks core domain model**; integration is isolated behind the `CafeManagementAdapter` port, with the current implementation named `SelcafeAdapter` and the future Adeks-native implementation named `AdeksNativeCafeEngine`.

### 1.2 The spike that informs this ADR

`SELCAFE_SPIKE_REPORT.md` (Pod C execution v1.1, Sections 1–13, PR #91) is a **schema-and-metadata-only** discovery of the live Selcafe database (`selcafe` on `192.168.1.249:1433`). Findings material to this decision:

| Area | Finding (spike §) | Architectural consequence |
|---|---|---|
| Engine / edition | SQL Server 2022 **Express**, compatibility level **100** (2008 mode) (§3, §4) | Adapter queries must be **SQL Server 2008-compatible**; 10 GB Express size ceiling is a long-term capacity constraint. |
| Host | **Windows 10 Pro** (consumer OS) on a hypervisor; named instance `SELCAFESERVER` (§2.3, §3) | OS updates may restart the SQL service without notice → **availability/reliability risk** for any polling adapter. |
| Collation / types | Server + DB `Turkish_CI_AS`; **all 58 business character columns are `varchar`/`char`** (non-Unicode); zero `nvarchar` in business tables (§3.1, §13.1) | **Turkish-character encoding conversion** is required at the adapter boundary; misconfigured driver charset corrupts `ç/ş/ı/ğ/ö/ü`. |
| Referential integrity | **Zero foreign-key constraints** in the entire database (§12.2) | Adapter joins must be **defensive (LEFT JOIN, null-tolerant)**; orphaned rows are possible. |
| Nullability | Pervasive — most tables are >80% nullable beyond the PK (§13.2) | Adapter must treat **all business columns as nullable**; no non-null assumptions. |
| Business logic location | Pricing/discount logic lives in **T-SQL stored procedures** (`sp_ucret_hesapla`, `fn_saat_ucret`, `_sp_kampanya_hesapla`), invisible to the read-only account (§12.4) | Adapter **reads computed results, never re-implements pricing**; computed totals in `adisyon`/`kasaislem` are SP-produced. |
| Permission model | The spike's `masa` account read all catalogs despite `db_datareader = 0` in `master` context; actual `selcafe`-level grants unconfirmed (§5.2) | A **dedicated, scoped, least-privilege read-only login** should be provisioned rather than reusing an account of unknown breadth (OQ-SC-NEW-002). |
| Personal data | Heavy PII in `uye` (member master: name/email/phone/mobile/address/district/**password**/**mutable balance**), `basvuru` (applications), and `kullanici` (staff incl. **password**); member linkage via `adisyon.uye_no`, `kasaislem.uye_no`, `kuyruk.uye_no` (§8, §10) | The PII boundary is the **central KVKK design question** of this ADR (§4, §5). |
| Legacy balance | `uye.bakiye` is a **single mutable `float`** field — not a ledger (§10) | **Architecturally incompatible** with the Adeks append-only wallet (ADR-006). Must never be exposed as the Adeks wallet balance. |
| Catalog gap | `urun.urungrup_no` references a product-category table **that does not exist** in the schema (§7, §11) | Menu **categorization** has no DB-layer source (OQ-SC-NEW-001). |
| Open-hours source | `ayar` is a 26-row key-value settings store; the open-hours **key names are not visible** from metadata alone (§11) | Confirming open-hours availability needs a **controlled key-name read** (OQ-SC-NEW-005). |
| External integration | **No linked servers**; Selcafe is self-contained at the SQL layer (§13.3) | Any external replication (if it exists) runs **outside** the SQL Server, at the application/pipeline layer, and was **not visible to this spike**. |

### 1.3 What Phase 1 actually requires from Selcafe

The locked direction (ADR-005 stub) names four candidate read targets: **open hours, categories, menu items, active sessions**. However, `PROJECT_BRIEF.md` §6 (Phase-1 customer PWA capabilities) does **not** list a customer-facing "which PCs are free" feature, and §11/D-008/D-009 make Phase-1 reservations **staff-approved requests** with automatic, PC-status-dependent confirmation deferred to **Phase 2**. Two product-implication questions therefore gate *which* candidate targets are actually built in Phase 1 — see §4.3 and the `[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]` flags.

### 1.4 Security and KVKK baselines already on record

- `SECURITY_REVIEW.md` §4.6 assesses Selcafe ingestion and raises **SR-003** (read-path controls: injection on read, trust of ingested data, credential handling, PII in session records) and **SR-001** (secrets management not yet consolidated). This ADR is the named home where SR-003 is **formalized**.
- `DATA_PROCESSING_INVENTORY.md` is present and Kerem-approved (2026-06-15) but does **not yet** inventory Selcafe-derived surfaces.
- `KVKK_LEGAL_BASIS.md`, `DATA_RETENTION_POLICY.md`, and `CROSS_BORDER_TRANSFER_ASSESSMENT.md` remain **absent** (registered `planned` in `AGENT_CONTEXT_MANIFEST.md`) and are binding blockers on any **personal-data** implementation track.

---

## 2. Decision (summary)

In Phase 1, Adeks integrates Selcafe as a **read-only data source** through the `CafeManagementAdapter` port, implemented as **`SelcafeAdapter`**, restricted to a **bounded, PII-free read surface**, governed by four read-path security controls (SR-003-1…4), and producing **vendor-neutral read models** that never leak Selcafe internals into the Adeks domain. No writes to Selcafe. Adeks native ledgers remain authoritative. The **physical read source** (direct live SQL vs. a downstream replica) and any **member-linked (PII) read** are **not** authorized by this ADR and are flagged for Kerem decision and, where applicable, a legal-advisor gate.

The decision is stated in seven parts (D-1…D-7) in §3–§5.

---

## 3. Decision (detail) — integration architecture

### D-1 — Read-only posture (locked principle, restated)

The `SelcafeAdapter` performs **`SELECT`-only** access. It issues **no** `INSERT`/`UPDATE`/`DELETE`/`MERGE`/DDL and calls **no** Selcafe stored procedures. Any operational adjustment on the Selcafe side is performed **manually by an operator outside Adeks** and is **not** an Adeks runtime write and **not** part of any Adeks correction flow (consistent with ADR-006 §8.1). This restates a Locked principle; it is not re-opened here.

### D-2 — `CafeManagementAdapter` port / `SelcafeAdapter` implementation

The Adeks domain depends only on a **vendor-neutral `CafeManagement` port interface** (ports-and-adapters). `SelcafeAdapter` is the Phase-1 implementation of that port; `AdeksNativeCafeEngine` (Phase 2+) is a future implementation of the **same** port. Binding rules:

1. **No Selcafe leakage.** Selcafe table names, column names, Turkish field names, type quirks, status codes, and the `uye.bakiye` concept **must not** cross the adapter boundary into Adeks domain models, DTOs, API contracts, or persisted Adeks rows. The adapter **maps** Selcafe rows into vendor-neutral Adeks read models (e.g. a neutral `StationStatus`, `CatalogItem`, `OperatingHours` shape).
2. **Read models are non-authoritative external state.** Adapter outputs are treated as **untrusted, eventually-consistent external reference data**, never as a source of financial truth. The Adeks wallet/loyalty ledgers (ADR-006/007) remain the sole authority for value.
3. **Adapter is a temporary bridge.** Its presence must not create coupling that complicates the Phase 2 migration to `AdeksNativeCafeEngine` (PROJECT_BRIEF §14 vendor-neutrality principle).

### D-7 — Phase 2 migration pointer (stated here for architectural continuity)

The `SelcafeAdapter` is explicitly **transitional**. Phase 2 introduces an Adeks-controlled PC client (Electron + TypeScript candidate) and **progressive Selcafe replacement** toward `AdeksNativeCafeEngine` (PROJECT_BRIEF §5.2). The session-pricing logic discovered in Selcafe SPs (`sp_ucret_hesapla`, `fn_saat_ucret`) is the kind of behavior that migrates **into** `AdeksNativeCafeEngine` when Adeks assumes session control; until then the adapter **reads SP-computed results and never re-implements them**. Phase 2 design is **out of scope** for this ADR and is named only as a forward pointer.

---

## 4. Decision (detail) — Phase 1 read surface and PII boundary

### D-3 — Bounded Phase 1 read surface

The Phase-1 `SelcafeAdapter` read surface is **bounded to non-PII operational and catalog data**, with the member-identity layer **hard-excluded**.

#### 4.1 Candidate INCLUDED surfaces (non-PII), subject to §4.3 product confirmation

| Selcafe object (schema.table) | Minimal column projection the adapter may read | Neutral Adeks read model | PII? |
|---|---|---|---|
| `dbo.masa` | `masa_no`, `tip`, `durum`, `baslangic_zaman`, `sure_limit` (status/occupancy/session-start **only**) | `StationStatus` (available / in-use / fault; occupied-since) | **No** — `masa` carries no `uye_no`; see D-3a |
| `dbo._pc` | `tip`, `ad`, `fiyat` | `StationType` (type label + hourly rate) | No |
| `dbo.urun` | `kod`, `ad`, `tip`, `fiyat`, `birim`, `aktif` | `CatalogItem` | No — F&B customer filter: `tip=1 AND aktif=1`; service items (`tip=2`) and staff-only items (e.g. `kod` prefix `PP`) excluded. `menu` column is live-valued but NOT operationally used by the Selcafe cashier workflow — do not read or filter on it. Category is not DB-derivable (only a `kod`-prefix naming convention exists at the application layer); category label must not cross the adapter boundary (D-2 rule 1). |
| `dbo.menudetay` | `menu_urun_kod`, `urun_kod`, `miktar` | `CatalogComboComponent` | No |

#### 4.2 Hard-EXCLUDED surfaces (architectural constraint, independent of product confirmation)

The following are **excluded from the Phase-1 read surface** and **must not** appear in any adapter query, projection, read model, log, or persisted Adeks row:

| Excluded object / column | Reason |
|---|---|
| `dbo.uye` (entire member master) | Heavy PII: `ad`, `eposta`, `telefon`, `cep`, `adres`, `semt`. |
| `dbo.basvuru` (entire applications table) | Heavy PII (same field set) plus `sifre`. |
| `dbo.kullanici` (entire staff table) | Staff PII + `sifre` (likely plaintext/weak hash). |
| **Any `sifre` column** (`uye.sifre`, `basvuru.sifre`, `kullanici.sifre`) | Credential-storage risk; never read under any circumstance (OQ-SC-NEW-004). |
| `uye.bakiye` | **Mutable `float` legacy balance** — incompatible with the Adeks append-only wallet (ADR-006). Must never be exposed as the Adeks wallet balance (OQ-SC-NEW-003). |
| `adisyon.uye_no`, `kasaislem.uye_no`, `kuyruk.uye_no` | Member-linkage columns → **PII by linkage** (OQ-SC-PRE-004, confirmed by spike §8). |
| `dbo.adisyon`, `dbo.kasaislem` (as member-linked transaction tables) | Contain member linkage and SP-computed financial values; not required for the Phase-1 non-PII surface. |

**Spike v2 — stub and deprecated column classification:** The following columns belong to already-excluded tables. They are classification records only; the hard-exclusion status of their parent tables is unchanged.

| Column | Classification | Detail |
|---|---|---|
| `adisyon.uye_indirim_oran` | **STUB** | Stores the member-discount rate at session start but is overridden by `sp_ucret_hesapla` before the row is finalised. `adisyon.uye_indirim` holds the SP-computed live discount amount. Never treat `uye_indirim_oran` as the authoritative rate. |
| `adisyon.ek_indirim` | **STUB** | Additional-discount field; overridden by `_sp_kampanya_hesapla` at settlement. Not a reliable discount value. |
| `uyesinif.indirim_oran` | **DEPRECATED** | Superseded by `dbo._kampanya` campaign-discount logic. `uyesinif.sinif` is retained for backward-compatibility joins only; `indirim_oran` is no longer the live tier-discount source. |

#### 4.2a — `uye.bakiye` isolation rule

Even though `uye.bakiye` is hard-excluded above, the ADR records an explicit isolation rule because the spike flagged a future-drift risk (OQ-SC-NEW-003): **no Adeks code path may read `uye.bakiye` as a wallet balance.** If a *future* phase ever needs to display a Selcafe legacy balance, it must be (a) separately approved, (b) labelled "Selcafe legacy balance — not the Adeks wallet," and (c) structurally prevented from being treated as authoritative. This is **out of Phase-1 scope**.

**Spike v2 classification reinforcement:** `uye.bakiye` together with `uyesinif.kredi`, `uyesinif.on_odeme`, and `uyesinif.kullanim_limit` constitute a dormant "usable-but-unused" credit/balance mechanism — structurally present in Selcafe but not actively used in the live cashier workflow. This is the data-minimization basis for removing `uyesinif` from the §4.1 Phase-1 read surface (no live Phase-1-consumed column; same data-minimization pattern applied as PI-1 for `masa`/`_pc` deferral). Hard-exclusion of `uye.bakiye` is unchanged; this classification extends and reinforces it to the `uyesinif` credit/balance columns.

#### D-3a — "Active sessions" read = station status WITHOUT member resolution

"Active sessions" in the locked direction is satisfied **PII-free** by reading **`masa` status only** (`durum`, `baslangic_zaman`): i.e. *whether a station is occupied and since when*, **not who occupies it**. The adapter **must not** resolve `masa.aktif_adisyon_no` → `adisyon` → `uye_no`. To prevent linkage drift, the adapter **derives an occupancy boolean and session-start time** and **does not propagate `aktif_adisyon_no`** as a usable foreign key into Adeks. `masa.mac`, `masa.idle_exe*`, and `masa.busy_exe*` are **not read** (device/client-config data, unnecessary; data minimization).

> **If a Phase-1 feature genuinely requires identifying *which member* is in a live session, that is a NEW PII surface** → it flips the KVKK gate (§5) and is **`[NEEDS KEREM APPROVAL]`** plus a legal-advisor gate plus a `DATA_PROCESSING_INVENTORY.md` update. It is **not** authorized by this ADR.

### 4.3 Product-implication gates on the INCLUDED set

`[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]` The *non-PII* set above is architecturally clean, but two scoping questions determine which targets are actually built in Phase 1:

- **PI-1 — Is real-time station/session status consumed by any Phase-1 feature?** `PROJECT_BRIEF.md` §6 lists no customer-facing PC-availability feature, and auto-confirm reservations are Phase 2. If station status is **not** a Phase-1 consumer, the `masa` read can be **deferred to Phase 2** (where it is a prerequisite for reliable PC status), further shrinking Phase-1 scope. If it **is** needed (e.g. to inform staff reservation approval), the D-3a `masa`-only read covers it PII-free.
- **PI-2 — Is the Phase-1 customer menu sourced from Selcafe `urun`, or is it Adeks-native?** If Adeks-native, `urun`/`menudetay` are **not** Phase-1 read targets and the missing-category gap (OQ-SC-NEW-001) is moot for Phase 1. If Selcafe-sourced, category filtering is blocked until OQ-SC-NEW-001 is resolved.

Neither PI-1 nor PI-2 changes the **hard-exclusion** list (§4.2); they only narrow the **included** list.

---

## 5. Decision (detail) — read-path security and KVKK

### D-4 — Read-path security controls (SR-003 formalized)

#### SR-003-1 — Parameterized, least-privilege read access (resolves OQ-SC-PRE-001)

- A **dedicated Selcafe read-only SQL login** (e.g. `adeks_selcafe_ro`) is provisioned with **`SELECT` only**, scoped to **only** the enumerated Phase-1 read tables (ideally with **column-level grants** that exclude PII columns on any table read). The login holds **no** `db_owner`/`db_datawriter`/`db_datareader`-wide membership and **no** server roles. This **replaces** reuse of the spike's `masa` account, whose effective grants are unconfirmed (OQ-SC-NEW-002).
- **All queries are parameterized**; **no** string-built SQL. Although the read-only inputs are limited, the discipline is mandatory and enforced in review.
- Queries are **SQL Server 2008-compatible** (compat level 100) and follow the **indexed access patterns** observed in the spike (§12.3) to minimize load.
- The adapter uses a **non-blocking read strategy** so it cannot block live Selcafe writers; eventual consistency is acceptable for status/catalog display. The specific isolation level is an implementation-detail decision (see Section 17 / OQ-SC-NEW-009) — dirty-read modes trade consistency for non-blocking and must not be used for anything value-bearing (none is, in Phase 1).

#### SR-003-2 — Adapter-boundary validation / sanitization (resolves OQ-SC-PRE-002)

Selcafe data is **untrusted input**. At the `CafeManagementAdapter` boundary the adapter must:

1. **Treat every business column as nullable** (spike §13.2); apply an explicit null-handling policy; never assume non-null.
2. **Join defensively** (LEFT JOIN, orphan-tolerant) given the total absence of FKs (spike §12.2); skip/flag rows that fail to resolve rather than propagating partial state.
3. **Convert encoding to UTF-8** explicitly (configure the driver charset for `Turkish_CI_AS`/Turkish code page); validate that Turkish characters survive the boundary (spike §13.1).
4. **Map status codes through a closed allow-list enum** (e.g. `masa.durum` → neutral `available|in_use|fault|closed`), **failing safe** on any unknown code (do not pass unknown codes downstream as if valid).
5. **Never trust Selcafe-computed totals as authoritative** (they are SP-produced, spike §12.4); coerce numeric/`money`/`datetime` types into safe Adeks domain types with range/sanity checks.
6. **Emit vendor-neutral read models only** (D-2 rule 1).

#### SR-003-3 — Credential handling (resolves OQ-SC-PRE-003 at the requirement level; mechanism owned by SR-001)

The Selcafe read-only credential is one of several high-value secrets identified in `SECURITY_REVIEW.md` SR-001. ADR-005 states the **requirement**: the credential **must** be stored via the project's secrets-management approach (SR-001) — **never** in source, **never** committed to the repo, **never** in plaintext application config — must be **rotatable**, and must be the **least-privilege** login from SR-003-1. ADR-005 **does not invent** the secrets-management mechanism; that is a separate Pod B design item (**SR-001**), and this control is **dependent** on it (see §8 dependency).

#### SR-003-4 — PII-in-session-records handling (resolves OQ-SC-PRE-004)

The Phase-1 control for PII is **hard exclusion at the read surface** (§4.2) plus **no member resolution** (D-3a). With these in place, **no Selcafe personal data enters Adeks domain objects in Phase 1**. Pseudonymize-without-delete (ADR-006 §13 / ADR-007 §11) remains the standing rule for any Selcafe-derived personal data that might enter Adeks in a *later* phase; in Phase 1 the design goal is that **none does**.

### D-5 — KVKK scope position

| Question | Position |
|---|---|
| Does the Phase-1 `SelcafeAdapter` **read path** (as bounded in §4) touch customer personal data? | **No** — provided the §4.2 hard exclusions and the D-3a no-member-resolution rule hold. |
| Does the Phase-1 read path require the **legal-advisor PII gate** to clear before the adapter reads the non-PII targets? | **No for the bounded non-PII surface** — subject to the three carve-outs below. |
| Is a `DATA_PROCESSING_INVENTORY.md` update required? | **Yes — recommended.** Even though Phase 1 ingests no PII, the spike **discovered** significant Selcafe PII surfaces. The inventory should gain a **Selcafe-derived data surfaces** section documenting (a) the non-PII surfaces read in Phase 1 and (b) the PII surfaces explicitly excluded, with exclusion rationale. Pod A owns; Pod B reviews; Kerem approves. (Routed in handoffs.) |

**Carve-outs that flip the gate ON:**

1. **`ayar` open-hours read.** Reading `ayar` requires confirming which keys hold open-hours data (OQ-SC-NEW-005). Until the key-name read is authorized and the scope confirmed non-sensitive, **open-hours sourcing from Selcafe is unconfirmed** and the `ayar` read is **`[NEEDS KEREM APPROVAL]`** (a limited, controlled `ayar.kod` key-name read, no sensitive setting values).
2. **Any member-linked read** (session→member, `uye`, `basvuru`, balance) → **`[NEEDS KEREM APPROVAL]` + legal-advisor gate + inventory update.** Not authorized here.
3. **Cross-border processing of the *source*** (see D-6) is a **separate** KVKK gate, independent of what the adapter ingests.

### D-6 — Physical read source (FLAGGED — not locked by this ADR)

The spike characterized a **direct connection to the live Selcafe SQL Server**. A second candidate source has been raised in prior project context:

`[ASSUMPTION — from prior project context; to be confirmed against the repo and by Kerem. The spike found NO linked servers (§13.3), so any replication runs outside the SQL layer and was not visible to this spike.]` Selcafe data may already be replicated to **Google BigQuery via Airbyte on a ~10-minute interval**.

| Candidate source | Pros | Cons / gating concerns |
|---|---|---|
| **A — Direct live SQL read** (spiked) | Freshest data; suits real-time station status; no dependence on a replication pipeline. | Operational coupling to a Win10/Express host (restart/availability risk); a connection into the café LAN; adapter must degrade gracefully on read failure (§6). |
| **B — Downstream replica (e.g. BigQuery/Airbyte)** | Zero load on live Selcafe; no LAN connection from Adeks; decouples adapter availability from the Win10/Express host; managed queryable store. | **~10-min staleness** — unsuitable for real-time station status, acceptable for slow-changing catalog/open-hours/tier data; **cross-border transfer** — the replication moves the **full Selcafe tables (including `uye`/`adisyon` PII)** to a non-Turkey region **regardless of what the adapter reads**, which requires `CROSS_BORDER_TRANSFER_ASSESSMENT.md` and legal-advisor input. |

**Recommendation (not a decision):** use **Source A (direct, scoped, read-only)** for any freshness-sensitive target (station status, if PI-1 confirms it is needed); slow-changing targets (catalog/open-hours/tiers) could use either source. Because the source choice carries **product** (staleness tolerance) and **legal** (cross-border) implications, it is **`[NEEDS KEREM APPROVAL]`**. The two gating inputs are:

- **the active-session staleness-tolerance question** (carried forward — whether a ~10-min lag on PC session status is acceptable for any Phase-1 consumer), and
- **the cross-border assessment** (`CROSS_BORDER_TRANSFER_ASSESSMENT.md`) **if** a replica/pipeline source is in use **or** if the Selcafe→GCP replication exists at all.

> **Important:** if the BigQuery/Airbyte replication is confirmed to exist, the **cross-border transfer obligation already applies today** — it is created by the replication pipeline, not by the Adeks adapter — and must be declared in `CROSS_BORDER_TRANSFER_ASSESSMENT.md` independently of this adapter's read surface.

---

## 6. Consequences

### 6.1 Positive

- **Minimal Phase-1 coupling** to the legacy system; Adeks native ledgers stay authoritative; vendor-neutral evolution toward `AdeksNativeCafeEngine` is preserved.
- **PII-free Phase-1 ingest** (under §4 bounds) keeps the adapter **out of the personal-data implementation gate**, so the non-PII targets are not held hostage to the absent legal artifacts — *except* for the explicit carve-outs (§5).
- The read-only posture **removes the entire write-side attack surface** against Selcafe.

### 6.2 Negative / costs

- **Operational reliability risk** (Win10/Express, named instance, possible service restarts) → the adapter **must** implement **circuit-breaker / retry / graceful degradation**: a failed Selcafe read must **not** block or crash Adeks features; Adeks shows neutral "status unavailable" rather than erroring.
- **Encoding fragility** (varchar/Turkish) → a misconfigured driver corrupts Turkish text; boundary validation (SR-003-2.3) is mandatory.
- **No FK integrity + high nullability** → defensive, null-tolerant adapter logic is mandatory; more code and tests than a clean schema would need.
- **Capacity ceiling** (10 GB Express) and **compat-100 syntax** constrain long-term use and reinforce the Phase-2 migration rationale.
- **Staleness** (if Source B) is unacceptable for real-time status; **cross-border** (if Source B / if replication exists) adds a legal obligation.

### 6.3 Residual risks (cross-referenced to `SECURITY_REVIEW.md`)

| Residual | Status | Reference |
|---|---|---|
| Injection / unsafe query construction on the read path | **Mitigated** by SR-003-1 (parameterized, least-privilege) | SR-003-1 |
| Trust of ingested (untrusted) Selcafe data | **Mitigated** by SR-003-2 boundary validation | SR-003-2 |
| Credential exposure for the Selcafe login | **Dependent** on SR-001 secrets-management (requirement stated here) | SR-003-3 / SR-001 |
| PII entering Adeks via session/member linkage | **Mitigated** by §4.2 hard exclusion + D-3a no-resolution | SR-003-4 |
| `uye.bakiye` mistaken for the Adeks wallet balance | **Mitigated** by §4.2a isolation rule | OQ-SC-NEW-003 |
| Live-operation disruption from polling | **Low** — read-only + indexed + non-blocking + low-frequency | SR-003-1 |
| Cross-border transfer (if replica/pipeline source) | **Open** — requires `CROSS_BORDER_TRANSFER_ASSESSMENT.md` + legal advisor | D-6 |

**`[LOCKED PRINCIPLE CONFLICT]`: none identified.** This ADR is consistent with all Locked principles (Selcafe read-only Phase 1; append-only wallet/loyalty ledgers; KVKK required; human approval for customer-data/security; synthetic data only; vendor-neutral domain) and with ADR-004/006/007/008/009/013/015.

---

## 7. Alternatives Considered

| # | Alternative | Disposition |
|---|---|---|
| A1 | **Direct live SQL read** (scoped, read-only) | **Recommended** for freshness-sensitive targets (D-6, Source A). |
| A2 | **Downstream replica read** (BigQuery/Airbyte) | **Flagged / deferred** — viable for slow-changing data but introduces staleness + cross-border (D-6, Source B). Pending Kerem + legal. |
| A3 | **Selcafe-side API / official export** | **Rejected** — no API exists (PROJECT_BRIEF §3; spike confirms no linked servers). |
| A4 | **Write-back / two-way integration** | **Excluded** by the Locked read-only posture (D-1). Not reconsidered. |
| A5 | **Reuse the spike's `masa` login** | **Rejected** — effective grants unconfirmed and possibly over-broad (spike §5.2). Provision a dedicated scoped login (SR-003-1). |
| A6 | **Read member-linked session/financial data for richer Phase-1 features** | **Rejected for Phase 1** — flips the KVKK gate; not a confirmed Phase-1 need (D-3a, §4.3 PI-1). |
| A7 | **Source the Phase-1 menu from an Adeks-native catalog** (not Selcafe `urun`) | **Open** — a product decision (§4.3 PI-2). If chosen, `urun`/`menudetay`/the missing-category gap drop out of Phase-1 scope. |
| A8 | **Read computed pricing by re-implementing Selcafe's pricing logic in Adeks** | **Rejected** — pricing lives in Selcafe SPs; the adapter reads results only (D-2 rule, spike §12.4). |

---

## 8. Acceptance Criteria, Merge Gate & Implementation Gating

### 8.1 ADR acceptance criteria (for this document to move to Accepted)

1. Kerem approves the bounded read surface (§4) and the hard-exclusion list.
2. Kerem records decisions (or explicit deferrals) on the `[NEEDS KEREM APPROVAL]` items in §9.
3. Pod B + Kerem merge gate satisfied; Pod Impact Matrix + `INSTRUCTION_UPDATE_PACKET.md` attached to the merging PR (ADR-009 §4 fires — §0/Status).

### 8.2 Implementation acceptance criteria (for a FUTURE adapter build — NOT authorized here)

A future `SelcafeAdapter` implementation issue is acceptable only if it: provisions the dedicated least-privilege read-only login (SR-003-1); uses parameterized, SQL-2008-compatible, indexed, non-blocking reads; implements boundary validation + UTF-8 conversion + closed status enums + defensive joins (SR-003-2); sources the credential from the SR-001 secrets approach (SR-003-3); reads **none** of the §4.2 excluded surfaces and performs **no** member resolution (SR-003-4); emits vendor-neutral read models only; degrades gracefully on read failure; and ships with the security-regression tests named in `SECURITY_REVIEW.md` SR-006 (§21 minimums).

### 8.3 Merge gate

**Pod B + Kerem** (ADR-009 §3 *Selcafe adapter/integration* trigger; K-11). The §4 PII-boundary decision also engages *customer personal-data handling* (Pod B + Kerem). Strictest trigger governs → **Pod B + Kerem**. **Kerem is sole merge authority.**

### 8.4 Implementation gating (preserved)

**This ADR does NOT authorize Pod C.** It creates no issues, writes no migrations/code, and provisions no infrastructure (the read-only login is specified as a *requirement*, not provisioned here). The `SelcafeAdapter` becomes Pod C work **only** via a separately Pod B + Kerem-approved issue that meets the Definition of Ready and clears: the §9 `[NEEDS KEREM APPROVAL]` items; the legal-artifact gate (`KVKK_LEGAL_BASIS.md` / `DATA_RETENTION_POLICY.md` / `CROSS_BORDER_TRANSFER_ASSESSMENT.md`) **where PII or cross-border is in scope**; and SR-001 secrets-management for the credential. For the **strictly non-PII direct-read surface**, the binding pre-implementation items are the dedicated login (SR-003-1), SR-001 credential handling, and Kerem's PI-1/PI-2 + source decision — the three absent legal artifacts gate the **PII/cross-border** tracks specifically, not the non-PII catalog/status read in isolation.

---

## 9. `[NEEDS KEREM APPROVAL]` items raised by this ADR

**Status (Kerem, 2026-06-23):** K-A1 **decided → Option A** (direct live SQL; replica deferred); K-A2 **authorized**; K-A3 **open** (controlled `ayar.kod` key-name read still to be authorized when open-hours sourcing is taken up); K-A4 / K-A5 **carried as gating items** for any future PII/cross-border expansion (none approved here).

| # | Item | Type | Decision / default |
|---|---|---|---|
| K-A1 | **Physical read source** (Source A direct vs Source B replica), with the **active-session staleness-tolerance** question | Architecture + legal | **DECIDED — Option A** (direct, scoped, read-only); replica/BigQuery deferred. |
| K-A2 | **Provision a dedicated least-privilege read-only login** scoped to the §4.1 tables (resolving OQ-SC-NEW-002) | Security / ops | **AUTHORIZED.** Adapter implementation still gated on separately approved Pod C issue. |
| K-A3 | Authorize a controlled `ayar.kod` key-name read to confirm open-hours keys (OQ-SC-NEW-005) | Data access | **CLOSED — not needed.** Spike v2 confirmed that open hours are NOT stored in `ayar`; no open-hours setting keys are present. Operating-hours configuration is Adeks-native (routed to Pod A as a K-20 product item). `ayar` removed from §4.1 read surface; OQ-SC-NEW-005 closed. Ratified by Kerem's merge of the Spike v2 reconciliation PR. |
| K-A4 | **Commission `CROSS_BORDER_TRANSFER_ASSESSMENT.md`** for the Selcafe→GCP replication **if it exists / if Source B is used** | Legal | **GATING ITEM** for any future cross-border/replica use. Source B not usable until cleared. |
| K-A5 | **Engage legal advisor** before any member-linked (PII) read is ever added | Legal | **GATING ITEM.** PII surfaces remain hard-excluded (Phase-1 default). |

`[PRODUCT IMPLICATION — POD A ALIGNMENT NEEDED]`: **PI-1** (is station status a Phase-1 consumer?) and **PI-2** (is the menu Selcafe-sourced or Adeks-native?) — see §4.3. These narrow the included read set; route to Pod A.

---

## 10. Open Questions feeding `SELCAFE_SPIKE_REPORT.md` Section 17

New questions surfaced while drafting this ADR (delivered as the Section 17 update in the same Pod B session): **OQ-SC-NEW-008** (physical source + staleness + cross-border), **OQ-SC-NEW-009** (read isolation-level / non-blocking strategy), **OQ-SC-NEW-010** (`DATA_PROCESSING_INVENTORY.md` Selcafe-surface update), plus the product-implication questions **PI-1**/**PI-2**. The pre-spike controls **OQ-SC-PRE-001…004** are **resolved** by SR-003-1…4 (PRE-003 at requirement level, mechanism via SR-001). See Section 17.

**Spike v2 reconciliation (2026-06-24): OQ-SC-NEW-001 → RESOLVED.** Category source confirmed as the `urun.kod` prefix naming convention (SP-defined at the Selcafe application layer, not a relational table); `urun.tip` discriminates F&B items (`1`) from service/session items (`2`). No missing DB category table — the `urungrup` FK reference is legacy/unused; the gap is by Selcafe design. Category must not be DB-derived across the adapter boundary (D-2 rule 1). See updated §4.1 and SELCAFE_SPIKE_REPORT.md §17.6.

---

## 11. Approval

- **Author:** Pod B — Architecture, Logic & Risk
- **Reviewer / Approver:** Kerem (merge gate Pod B + Kerem; Kerem sole merge authority)
- **Status:** **Accepted** — Kerem-approved 2026-06-23
- **Date (Accepted):** 2026-06-23 (Kerem approval)

---

## 12. Document History

| Version | Date | Author | Change |
|---|---|---|---|
| stub | 2026-06-07 | Pod B | ADR-005 stub created during BC-3 ADR-stub cleanup; decision direction Locked (read-only Selcafe Phase 1 via `CafeManagementAdapter`); full text deferred. |
| v1.0 (full text) | 2026-06-23 | Pod B | Full ADR authored from `SELCAFE_SPIKE_REPORT.md` v1.1 (PR #91). Adds: integration architecture (D-1/D-2/D-7); bounded PII-free Phase-1 read surface + hard-exclusion list + no-member-resolution rule (D-3/D-3a); SR-003-1…4 read-path controls; KVKK scope position (D-5); flagged physical-source sub-decision incl. cross-border (D-6); consequences + residual risks; alternatives A1–A8; acceptance criteria + Pod B+Kerem merge gate + preserved Pod C gating. Raises `[NEEDS KEREM APPROVAL]` K-A1…K-A5 and `[PRODUCT IMPLICATION]` PI-1/PI-2. Resolves OQ-SC-PRE-001…004. Synthetic/schema-name-only data. |
| v1.0 — Accepted | 2026-06-23 | Pod B / Kerem | **Kerem approval recorded.** Status → Accepted. Decisions: K-A1 = Option A (direct live SQL; replica deferred); K-A2 authorized (dedicated least-privilege read-only login); K-A4/K-A5 carried as gating items for any future PII/cross-border expansion. `PROJECT_DECISION_INDEX.md` ADR-005 row Backlog → Accepted and `AGENT_CONTEXT_MANIFEST.md` Selcafe row updated in the same PR. Does NOT authorize Pod C. |
| v1.1 — Spike v2 reconciliation | 2026-06-24 | Pod B | §4.1 narrowed: `ayar` row removed (open hours Adeks-native; OQ-SC-NEW-005 closed; K-A3 closed); `uyesinif` row removed (data minimization — no live Phase-1-consumed column; dormant credit/balance mechanism); `urun` projection tightened (`tip` added, `menu` removed; `tip=1 AND aktif=1` F&B filter; category = `kod`-prefix convention only; D-2 rule 1 reaffirmed). §4.2 stub/deprecated classification notes added (`adisyon.uye_indirim_oran` STUB; `adisyon.ek_indirim` STUB; `uyesinif.indirim_oran` DEPRECATED). §4.2a reinforced (`uyesinif` credit/balance cols = dormant, same hard-exclusion basis). §9 K-A3 OPEN → CLOSED. §10 OQ-SC-NEW-001 → RESOLVED. Governance: Pod Impact Matrix + INSTRUCTION_UPDATE_PACKET attached to PR. |
