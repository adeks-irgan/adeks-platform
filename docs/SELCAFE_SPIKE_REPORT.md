# SELCAFE_SPIKE_REPORT.md

<!--
  CANONICAL REPO PATH : /docs/SELCAFE_SPIKE_REPORT.md
  DOCUMENT TYPE       : Spike report — Pod C execution complete; awaiting Kerem + Pod B review
  STATUS              : SECTIONS 1–13 FILLED BY POD C — Sections 14–17 reserved for Pod B
  AUTHOR (template)   : Pod B — Architecture, Logic & Risk
  EXECUTOR            : Pod C — Build & DevOps
  REVIEWER            : Pod B — Architecture, Logic & Risk
  APPROVER            : Kerem (for any further Selcafe access or integration scope change)
  TASK REF            : M3 / K-10 (KEREM_DECISIONS.md §10)
  ROADMAP REF         : Seq 14 (spike execution), Seq 15 (this report), Seq 16 (ADR-005 full text)
  SCRIPT REF          : selcafe_schema_discovery_v1.0.sql (Pod B authored)
  DOWNSTREAM          : ADR-005-selcafe-read-only-adapter.md full text (separate Pod B Opus session)

  DATA RULE (NON-NEGOTIABLE)
  --------------------------
  This document MUST contain SCHEMA NAMES, TABLE NAMES, COLUMN NAMES,
  AND DATA TYPES ONLY.
  
  ⚠ DO NOT include any row-level data values from Selcafe business tables.
  ⚠ DO NOT include customer names, phone numbers, IDs, session data, payment
     amounts, or any other row-level content.
  ⚠ DO NOT paste query result rows from business tables — column metadata only.
  
  Approximate row counts from Section B3 of the script (sys.partitions catalog
  metadata) are acceptable as they are system catalog data, not business data.
  
  KVKK NOTE
  ---------
  Any discovered column name that appears to reference personal data (e.g.
  fields named "phone", "name", "email", "tc_no", "address") must be
  flagged in Section 8 of this report — field name and type only.
  Pod B will assess the KVKK scope in Section 16.
-->

---

## Document Status

| Field | Value |
|---|---|
| Document | `SELCAFE_SPIKE_REPORT.md` |
| Project | Adeks Platform |
| Status | **Complete — Sections 1–13 (Pod C), Sections 14–16 (Pod B), and Section 17 (Pod B) all filled** |
| Script version | `selcafe_schema_discovery_v1.0.sql` v1.0 |
| Data rule | Schema and catalog metadata only; NO row data; NO real customer data |
| Implementation authority | **Does NOT authorize Pod C to implement any integration** |
| Next action after completion | Route to Kerem + Pod B for review; Pod B uses findings to complete ADR-005 |

---

## Section 1 — Execution Metadata

| Field | Value |
|---|---|
| Script version executed | selcafe_schema_discovery_v1.0.sql v1.0 |
| Execution date (UTC) | 2026-06-23 |
| Execution time (UTC) | 08:57 (server UTC timestamp from A1) |
| Pod C operator identifier | Pod C — Build & DevOps (Claude Code session) |
| SQL tool used | pymssql 2.3.13 (Python 3.9.6) — sqlcmd unavailable; mssql-tools18 brew install blocked by outdated macOS CLT |
| Connection method | Direct TCP/IP to 192.168.1.249:1433 (LAN/VPN — no port forwarding required) |
| Time-box start | 2026-06-23 (within one working day) |
| Time-box end | 2026-06-23 |
| Script run status | Completed — Part A (A1–A6) and Part B (B1–B12) all succeeded |
| Any anomalies or interruptions | B12 IS_ROLEMEMBER() ran in master DB context, not selcafe — results reflect master-DB role membership only (see Section 5.2 note). All other sections executed cleanly. |

---

## Section 2 — Connectivity Findings

### 2.1 Network Accessibility

| Question (K-10) | Finding |
|---|---|
| Is the SQL Server network-accessible? | Yes — direct TCP/IP connection established |
| Host/address used (do not include credentials) | 192.168.1.249 (internal LAN address — do not publish externally) |
| Port used | 1433 (default SQL Server port) |
| Initial connection successful? | Yes — connection established immediately, no timeout |

### 2.2 Authentication

| Question (K-10) | Finding |
|---|---|
| Authentication method required | SQL Server Authentication (login name + password) |
| Named instance required? | Named instance present: `DESKTOP-B1IP8HO\SELCAFESERVER` — however, connection succeeded on port 1433 directly without specifying instance name, suggesting the named instance listens on a fixed port rather than requiring SQL Server Browser |
| TLS/SSL enforced by server? | Unknown — pymssql connected without explicit TLS config; no connection error, suggesting TLS not strictly enforced or negotiated transparently |
| Connection string format needed | `Server=192.168.1.249,1433;Database=selcafe;User Id=<login>;Password=<password>;` — SQL Server Auth; do not include actual credentials |

### 2.3 Connectivity Risk Notes

Connection was stable throughout the spike. No timeouts or intermittent failures observed. The server is a named instance (`SELCAFESERVER`) on a Windows 10 Pro host — this is a consumer OS, not a server OS. Windows 10 may apply OS-level updates that restart the SQL Server service without notice. This is a connectivity reliability risk for any periodic read-only adapter.

SQL Server Express Edition has a 10 GB database size limit. This is a scalability constraint Pod B should note for long-term adapter planning.

---

## Section 3 — Server Identity (from Script Part A)

| Field | Value |
|---|---|
| SQL Server name (`@@SERVERNAME`) | `DESKTOP-B1IP8HO\SELCAFESERVER` |
| Product version | 16.0.1180.1 |
| Product level | RTM (RTM-GDR via KB5091158) |
| Edition | Express Edition (64-bit) |
| Engine edition code | 4 (Express) |
| Server default collation | `Turkish_CI_AS` |
| Full text search installed | Yes (IsFullTextInstalled = 1) |
| Server time vs UTC at run time | Server local: 2026-06-23 11:57:51 / UTC: 2026-06-23 08:57:51 → UTC+3 offset (Turkey Standard Time / TRT) |

### 3.1 Collation Assessment

Server default collation: `Turkish_CI_AS` — this is Turkish, Case-Insensitive, Accent-Sensitive. The database collation also confirms `Turkish_CI_AS` (Section 4). This is the correct collation for Turkish character support (`ç`, `ş`, `ı`, `ğ`, `ö`, `ü`). However, all user-data columns use `varchar`/`char` (non-Unicode), not `nvarchar`. Turkish characters are supported via the Turkish code page in `varchar` under `Turkish_CI_AS`, but conversion to Unicode at the adapter boundary will require explicit handling. Pod B to assess encoding risk in Section 15.

---

## Section 4 — Database Inventory (from Script Section A4)

| database_name | database_id | state | recovery_model | compatibility_level | database_collation | is_read_only | create_date |
|---|---|---|---|---|---|---|---|
| selcafe | 5 | ONLINE | SIMPLE | 100 | Turkish_CI_AS | False | 2026-03-21 10:17:47 |

### 4.1 Target Database Identification

| Field | Value |
|---|---|
| Identified Selcafe target database name | `selcafe` |
| Basis for identification | Only non-system database present on server |
| Additional databases noted (names only) | None — `selcafe` is the sole non-system database |

**Notable:** Compatibility level 100 = SQL Server 2008 compatibility mode. The server runs SQL Server 2022 (v16) but the database is configured at the 2008 compatibility level. This means some 2022 query optimizer features are disabled. Adapter queries must be compatible with SQL Server 2008 syntax.

**Notable:** `create_date` is 2026-03-21 — the database was recently created (or restored) on this instance. The oldest table creation dates are 2005, confirming this is a restored/migrated copy of a long-running database.

---

## Section 5 — Credential / Permission Check (from Script Section A5, B12)

### 5.1 Server-Level Role Membership (Section A5)

| Role | Value | Expected |
|---|---|---|
| is_sysadmin | 0 | 0 ✓ |
| is_securityadmin | 0 | 0 ✓ |
| is_serveradmin | 0 | 0 ✓ |
| is_diskadmin | 0 | 0 ✓ |
| is_dbcreator | 0 | 0 ✓ |
| is_bulkadmin | 0 | 0 ✓ |
| is_public | 1 | 1 ✓ |

**PRIVILEGE CHECK: PASSED** — No elevated server-level roles. Read-only posture confirmed at the server level. Proceeded with Part B.

### 5.2 Database-Level Role Membership (Section B12)

⚠ **Important caveat:** B12 ran while connected to the `master` database (three-part-name access). `IS_ROLEMEMBER()` reflects the current connection context (`master`), not the `selcafe` database. All role values below show `master` membership, not `selcafe` membership.

| Role | is_member | Note |
|---|---|---|
| db_owner | 0 | In master — not meaningful for selcafe |
| db_ddladmin | 0 | In master |
| db_datawriter | 0 | In master |
| db_datareader | 0 | In master |
| db_denydatawriter | 0 | In master |
| db_accessadmin | 0 | In master |
| db_securityadmin | 0 | In master |
| db_backupoperator | 0 | In master |
| db_denydatareader | 0 | In master |

**Observed behaviour:** Despite db_datareader showing 0, the account successfully read all `[selcafe].INFORMATION_SCHEMA.*` and `[selcafe].sys.*` catalog views (Sections B1–B11 returned full results). This indicates the `masa` account has either (a) individual GRANT permissions on selcafe catalog views, or (b) is a member of a custom role in selcafe not captured by the fixed-role query, or (c) holds db_owner or equivalent in selcafe via a mechanism not visible in master context. **Pod B should verify actual selcafe-level permissions by connecting directly to selcafe and running `SELECT IS_MEMBER('db_owner'), IS_MEMBER('db_datawriter'), IS_MEMBER('db_datareader')` before the adapter is implemented.**

---

## Section 6 — Schema and Table Inventory (from Script Sections B2, B3)

### 6.1 User-Defined Schemas (Section B2)

No user-defined schemas beyond `dbo`. All tables reside in the default `dbo` schema.

| schema_id | schema_name | schema_owner |
|---|---|---|
| 1 | dbo | dbo |

### 6.2 Table Inventory with Approximate Row Counts (Section B3)

*Row counts are from `sys.partitions` — SQL Server internal catalog statistics. This is table-size metadata, not business data.*

| schema_name | table_name | create_date | modify_date | approx_row_count_catalog |
|---|---|---|---|---|
| dbo | _kampanya | 2024-02-25 | 2024-02-25 | 6 |
| dbo | _kontrol | 2014-12-19 | 2014-12-19 | 1,635,929 |
| dbo | _pc | 2023-06-05 | 2023-06-05 | 8 |
| dbo | adisyon | 2005-10-22 | 2024-11-22 | 1,817,097 |
| dbo | ariza | 2008-09-23 | 2008-09-23 | 170,599 |
| dbo | ayar | 2005-10-28 | 2006-02-13 | 26 |
| dbo | basvuru | 2008-09-23 | 2008-09-23 | 116 |
| dbo | detay | 2008-09-23 | 2014-12-19 | 2,112,023 |
| dbo | dtproperties | 2005-10-22 | 2005-10-22 | 0 |
| dbo | id | 2005-10-29 | 2005-10-29 | 2 |
| dbo | islemtip | 2006-02-13 | 2006-02-13 | 29 |
| dbo | kasa | 2005-10-22 | 2006-10-27 | 3 |
| dbo | kasaislem | 2008-09-23 | 2008-09-23 | 2,082,765 |
| dbo | kullanici | 2011-08-29 | 2011-08-29 | 116 |
| dbo | kuyruk | 2006-02-13 | 2006-02-13 | 0 |
| dbo | masa | 2005-11-17 | 2017-12-31 | 250 |
| dbo | menudetay | 2006-05-30 | 2006-05-30 | 12 |
| dbo | siparis | 2005-10-22 | 2008-07-28 | 1,456,901 |
| dbo | stokislem | 2008-09-23 | 2008-09-23 | 2 |
| dbo | sysdiagrams | 2005-11-19 | 2005-11-19 | 0 |
| dbo | urun | 2006-05-30 | 2006-05-30 | 1,075 |
| dbo | uye | 2008-09-23 | 2008-09-23 | 10,659 |
| dbo | uyesinif | 2005-12-20 | 2005-12-20 | 14 |

**High-volume tables (>1M rows):** `detay` (2.1M), `kasaislem` (2.1M), `adisyon` (1.8M), `_kontrol` (1.6M), `siparis` (1.5M). These are long-running operational tables dating to 2005.

---

## Section 7 — Functional Surface Mapping

*Based on table names only — no row data queried.*

| Table name | Most likely functional category | Confidence | Notes |
|---|---|---|---|
| _kampanya | SYSTEM / CONFIG | Med | "kampanya" = campaign/promotion; config-level discount rules |
| _kontrol | AUDIT / LOG | Med | "kontrol" = control/check; 1.6M rows, all-nullable, likely a soft-delete or change-log shadow table |
| _pc | PC / WORKSTATION | High | "pc" = PC; 8 rows with `tip`, `ad`, `fiyat` — PC type/pricing config |
| adisyon | SESSION / PC_USAGE | High | "adisyon" = bill/tab; 1.8M rows with session start/end times, totals, member ref — the core PC session billing table |
| ariza | SYSTEM / CONFIG | High | "ariza" = malfunction/fault; 170K rows — PC fault/downtime log |
| ayar | SYSTEM / CONFIG | High | "ayar" = setting; 26 rows — key-value settings store (likely includes open hours, rates) |
| basvuru | CUSTOMER / MEMBER | High | "basvuru" = application/registration; 116 rows — member sign-up applications |
| detay | ORDER / TRANSACTION | High | "detay" = detail; 2.1M rows — F&B order line items linked to adisyon + siparis |
| dtproperties | SYSTEM / CONFIG | High | SQL Server diagram metadata — internal, not business-relevant |
| id | SYSTEM / CONFIG | High | 2-row counter/sequence table — likely application-managed ID sequences |
| islemtip | SYSTEM / CONFIG | High | "islem tipi" = transaction type; 29 rows — lookup table for cash register transaction types |
| kasa | SYSTEM / CONFIG | High | "kasa" = cash register/till; 3 rows — cash register configuration |
| kasaislem | PAYMENT / INVOICE | High | "kasa islemi" = cash register transaction; 2.1M rows — full financial transaction ledger |
| kullanici | STAFF / EMPLOYEE | High | "kullanici" = user; 116 rows — staff/employee accounts with login credentials |
| kuyruk | SYSTEM / CONFIG | Med | "kuyruk" = queue; 0 rows — likely a client notification/command queue |
| masa | PC / WORKSTATION | High | "masa" = table/desk; 250 rows — PC/station inventory with real-time status (durum, aktif_adisyon_no, baslangic_zaman) |
| menudetay | MENU / CATALOG | High | "menu detay" = menu detail; 12 rows — combo/set-menu item mappings |
| siparis | ORDER / TRANSACTION | High | "siparis" = order; 1.5M rows — F&B order headers |
| stokislem | SYSTEM / CONFIG | Med | "stok islemi" = stock transaction; 2 rows — inventory movement (nearly empty, low usage) |
| sysdiagrams | SYSTEM / CONFIG | High | SQL Server database diagram storage — internal, not business-relevant |
| urun | MENU / CATALOG | High | "urun" = product; 1,075 rows — product/menu item catalog with prices |
| uye | CUSTOMER / MEMBER | High | "uye" = member; 10,659 rows — customer/member master data with PII and balance |
| uyesinif | CUSTOMER / MEMBER | High | "uye sinifi" = member class; 14 rows — membership tier/class lookup |

**Notable gap:** `urun.urungrup_no` references a product group/category by integer ID, but no corresponding `urungrup` or `urun_grup` table exists in the schema. The product category table is either missing, named differently, or was dropped. This is a significant gap for the SelcafeAdapter's menu/category read target.

---

## Section 8 — Column Detail: Customer / Member Data Surface

*COLUMN NAMES AND TYPES ONLY — no row values.*

### Table: dbo.uye (member master)

| schema_name | table_name | column_name | data_type | max_length | is_nullable | column_collation | is_identity | notes |
|---|---|---|---|---|---|---|---|---|
| dbo | uye | uye_no | int | — | NO | — | YES | PK, IDENTITY |
| dbo | uye | ad | varchar | 50 | YES | Turkish_CI_AS | NO | Member name [KVKK SURFACE] |
| dbo | uye | eposta | varchar | 50 | YES | Turkish_CI_AS | NO | Email address [KVKK SURFACE] |
| dbo | uye | uyelik_sinif | char | 1 | YES | Turkish_CI_AS | NO | Membership class code (FK to uyesinif) |
| dbo | uye | baslangic_tarih | datetime | — | YES | — | NO | Membership start date |
| dbo | uye | aktif | bit | — | YES | — | NO | Active flag |
| dbo | uye | telefon | varchar | 20 | YES | Turkish_CI_AS | NO | Phone number [KVKK SURFACE] |
| dbo | uye | cep | varchar | 20 | YES | Turkish_CI_AS | NO | Mobile/cell number [KVKK SURFACE] |
| dbo | uye | adres | varchar | 80 | YES | Turkish_CI_AS | NO | Home address [KVKK SURFACE] |
| dbo | uye | bakiye | float | — | YES | — | NO | Member balance — direct mutable field, NOT append-only [KVKK SURFACE — linked to member identity] |
| dbo | uye | sifre | varchar | 50 | YES | Turkish_CI_AS | NO | Password — varchar suggests plain text or weak hash [KVKK SURFACE — credential storage risk] |
| dbo | uye | semt | varchar | 20 | YES | Turkish_CI_AS | NO | Neighbourhood/district [KVKK SURFACE] |

### Table: dbo.basvuru (member applications / registrations)

| schema_name | table_name | column_name | data_type | max_length | is_nullable | column_collation | is_identity | notes |
|---|---|---|---|---|---|---|---|---|
| dbo | basvuru | basvuru_no | int | — | NO | — | YES | PK, IDENTITY |
| dbo | basvuru | ad | varchar | 50 | YES | Turkish_CI_AS | NO | Applicant name [KVKK SURFACE] |
| dbo | basvuru | eposta | varchar | 50 | YES | Turkish_CI_AS | NO | Email address [KVKK SURFACE] |
| dbo | basvuru | sifre | varchar | 50 | YES | Turkish_CI_AS | NO | Password [KVKK SURFACE — credential storage risk] |
| dbo | basvuru | basvuru_tarih | datetime | — | YES | — | NO | Application date |
| dbo | basvuru | telefon | varchar | 20 | YES | Turkish_CI_AS | NO | Phone number [KVKK SURFACE] |
| dbo | basvuru | cep | varchar | 20 | YES | Turkish_CI_AS | NO | Mobile/cell number [KVKK SURFACE] |
| dbo | basvuru | adres | varchar | 80 | YES | Turkish_CI_AS | NO | Address [KVKK SURFACE] |
| dbo | basvuru | semt | varchar | 20 | YES | Turkish_CI_AS | NO | Neighbourhood/district [KVKK SURFACE] |
| dbo | basvuru | durum | int | — | YES | — | NO | Application status |
| dbo | basvuru | aciklama | varchar | 50 | YES | Turkish_CI_AS | NO | Staff note |
| dbo | basvuru | uye_no | int | — | YES | — | NO | FK to uye (if approved) |

### Table: dbo.kullanici (staff accounts)

| schema_name | table_name | column_name | data_type | max_length | is_nullable | column_collation | is_identity | notes |
|---|---|---|---|---|---|---|---|---|
| dbo | kullanici | kullanici_no | int | — | NO | — | YES | PK, IDENTITY |
| dbo | kullanici | kullanici_kod | varchar | 20 | YES | Turkish_CI_AS | NO | Staff username |
| dbo | kullanici | sifre | varchar | 20 | YES | Turkish_CI_AS | NO | Staff password [KVKK SURFACE — credential storage risk; length 20 char suggests plain text or simple hash] |
| dbo | kullanici | ad | varchar | 20 | YES | Turkish_CI_AS | NO | Staff display name [KVKK SURFACE] |
| dbo | kullanici | yetki | char | 20 | YES | Turkish_CI_AS | NO | Permission/role code |
| dbo | kullanici | aktif | bit | — | YES | — | NO | Active flag |

### Cross-table personal data references (member ID in transactional tables)

| schema_name | table_name | column_name | data_type | notes |
|---|---|---|---|---|
| dbo | adisyon | uye_no | int | Member reference — links billing session to a specific member [KVKK SURFACE] |
| dbo | kasaislem | uye_no | int | Member reference — links financial transaction to a specific member [KVKK SURFACE] |
| dbo | kuyruk | uye_no | int | Member reference in queue table [KVKK SURFACE] |

---

## Section 9 — Column Detail: Session / PC Data Surface

*COLUMN NAMES AND TYPES ONLY — no row values.*

### Table: dbo.masa (PC/workstation table — real-time status)

| schema_name | table_name | column_name | data_type | max_length | is_nullable | column_collation | is_identity | notes |
|---|---|---|---|---|---|---|---|---|
| dbo | masa | masa_no | int | — | NO | — | NO | PK — station/table number |
| dbo | masa | tip | int | — | YES | — | NO | Station type code (maps to _pc.tip) |
| dbo | masa | x_pos | int | — | YES | — | NO | Floor-plan X coordinate |
| dbo | masa | y_pos | int | — | YES | — | NO | Floor-plan Y coordinate |
| dbo | masa | yon | int | — | YES | — | NO | Orientation |
| dbo | masa | boyut | int | — | YES | — | NO | Size |
| dbo | masa | durum | int | — | YES | — | NO | **Current status** — key adapter read target (open/in-use/fault/closed) |
| dbo | masa | aktif_adisyon_no | int | — | YES | — | NO | **Active session bill number** — links to adisyon for in-session billing |
| dbo | masa | mac | varchar | 20 | YES | Turkish_CI_AS | NO | MAC address of PC |
| dbo | masa | sure_limit | float | — | YES | — | NO | Time limit for session |
| dbo | masa | baslangic_zaman | datetime | — | YES | — | NO | **Current session start time** — key adapter read target |
| dbo | masa | ariza_aciklama | varchar | 50 | YES | Turkish_CI_AS | NO | Fault description |
| dbo | masa | ariza_zaman | datetime | — | YES | — | NO | Fault start time |
| dbo | masa | teknik_cagri | int | — | YES | — | NO | Technical call status flag |
| dbo | masa | servis_cagri | int | — | YES | — | NO | Service call status flag |
| dbo | masa | son_kapanis_zaman | datetime | — | YES | — | NO | Last session close time |
| dbo | masa | panel_oyun | bit | — | YES | — | NO | Gaming panel mode flag |
| dbo | masa | panel_media | bit | — | YES | — | NO | Media panel mode flag |
| dbo | masa | idle_exe | varchar | 200 | YES | Turkish_CI_AS | NO | Idle-state executable path (client config) |
| dbo | masa | idle_exe_params | varchar | 200 | YES | Turkish_CI_AS | NO | Idle-state executable params |
| dbo | masa | busy_exe | varchar | 200 | YES | Turkish_CI_AS | NO | In-use executable path |
| dbo | masa | busy_exe_params | varchar | 200 | YES | Turkish_CI_AS | NO | In-use executable params |

### Table: dbo._pc (PC type / pricing configuration)

| schema_name | table_name | column_name | data_type | max_length | is_nullable | column_collation | is_identity | notes |
|---|---|---|---|---|---|---|---|---|
| dbo | _pc | tip | int | — | NO | — | NO | PK — PC type code |
| dbo | _pc | ad | varchar | 20 | NO | Turkish_CI_AS | NO | PC type name (e.g. "Gaming", "Standard") |
| dbo | _pc | fiyat | money | — | NO | — | NO | Hourly rate for this PC type |

### Table: dbo.adisyon (session billing — contains session link to member)

| schema_name | table_name | column_name | data_type | max_length | is_nullable | notes |
|---|---|---|---|---|---|---|
| dbo | adisyon | adisyon_no | int | — | NO | PK — session bill number |
| dbo | adisyon | masa_no | int | — | YES | Station number |
| dbo | adisyon | baslangic_zaman | datetime | — | YES | Session start |
| dbo | adisyon | aciklama | varchar | 50 | YES | Description |
| dbo | adisyon | uye_no | int | — | YES | Member FK — session is linked to member if signed in [KVKK SURFACE] |
| dbo | adisyon | uye_indirim_oran | float | — | YES | Member discount rate applied |
| dbo | adisyon | bitis_zaman | datetime | — | YES | Session end |
| dbo | adisyon | kullanim_sure | float | — | YES | Usage duration (minutes/hours) |
| dbo | adisyon | internet_tutar | float | — | YES | Internet/PC charge amount |
| dbo | adisyon | cafe_tutar | float | — | YES | F&B charge amount |
| dbo | adisyon | toplam_tutar | float | — | YES | Total charge |
| dbo | adisyon | uye_indirim | float | — | YES | Member discount applied |
| dbo | adisyon | ek_indirim | float | — | YES | Additional discount |
| dbo | adisyon | odeme_sekli | int | — | YES | Payment method code |
| dbo | adisyon | kasa_no | int | — | YES | Cash register FK |
| dbo | adisyon | kasaislem_no | int | — | YES | Cash register transaction FK |
| dbo | adisyon | kullanici_no | int | — | YES | Staff (cashier) FK |
| dbo | adisyon | durum | int | — | YES | Status |
| dbo | adisyon | iptal_kullanici_no | int | — | YES | Cancelling staff FK |
| dbo | adisyon | iptal_aciklama | varchar | 50 | YES | Cancellation reason |
| dbo | adisyon | odeme_adisyon_no | int | — | YES | Payment bill reference |
| dbo | adisyon | diger_adisyon_tutar | float | — | YES | Other bill amount |
| dbo | adisyon | cafe_adisyon | bit | — | YES | F&B-only bill flag |

**ADR-005 note:** `masa.durum`, `masa.aktif_adisyon_no`, and `masa.baslangic_zaman` are the three key columns for determining active PC sessions. `adisyon` links sessions to members via `uye_no` — reading `adisyon` pulls PII into the adapter scope if member-linked sessions are included.

---

## Section 10 — Column Detail: Value / Balance / Payment Surface

*COLUMN NAMES AND TYPES ONLY — no row values.*

### Table: dbo.kasaislem (cash register transaction ledger)

| schema_name | table_name | column_name | data_type | max_length | is_nullable | column_collation | is_identity | notes |
|---|---|---|---|---|---|---|---|---|
| dbo | kasaislem | kasaislem_no | int | — | NO | — | YES | PK, IDENTITY |
| dbo | kasaislem | kasa_no | int | — | YES | — | NO | Cash register FK |
| dbo | kasaislem | kullanici_no | int | — | YES | — | NO | Staff FK |
| dbo | kasaislem | islem_zaman | datetime | — | YES | — | NO | Transaction timestamp |
| dbo | kasaislem | islem_tip | int | — | YES | — | NO | Transaction type FK (to islemtip) |
| dbo | kasaislem | borc | float | — | YES | — | NO | Debit amount |
| dbo | kasaislem | alacak | float | — | YES | — | NO | Credit amount |
| dbo | kasaislem | aciklama | varchar | 250 | YES | Turkish_CI_AS | NO | Transaction description |
| dbo | kasaislem | uye_no | int | — | YES | — | NO | Member FK — links transaction to member [KVKK SURFACE] |
| dbo | kasaislem | pos_no | int | — | YES | — | NO | POS terminal reference |

### Table: dbo.uye — balance column (within member table)

| schema_name | table_name | column_name | data_type | max_length | is_nullable | notes |
|---|---|---|---|---|---|---|
| dbo | uye | bakiye | float | — | YES | **Direct mutable balance field** — not an append-only ledger; Selcafe mutates this value directly. This is architecturally incompatible with Adeks's append-only wallet ledger (ADR-006/007). Do NOT read this as the authoritative balance for the Adeks wallet. [KVKK SURFACE — linked to member identity] |

### Table: dbo.kasa (cash register configuration)

| schema_name | table_name | column_name | data_type | max_length | is_nullable | notes |
|---|---|---|---|---|---|---|
| dbo | kasa | kasa_no | int | — | NO | PK |
| dbo | kasa | kasiyer_no | int | — | YES | Current cashier FK |
| dbo | kasa | bakiye | float | — | YES | Cash register current balance (mutable) |
| dbo | kasa | pos_bakiye | float | — | YES | POS balance (mutable) |
| dbo | kasa | kasa_pc | varchar | 50 | YES | Cash register PC identifier |

### Table: dbo.uyesinif (member tier — includes credit/pricing rules)

| schema_name | table_name | column_name | data_type | max_length | is_nullable | notes |
|---|---|---|---|---|---|---|
| dbo | uyesinif | sinif | char | 1 | NO | PK — tier code |
| dbo | uyesinif | interaktif | int | — | YES | Interactive session flag |
| dbo | uyesinif | kredi | float | — | YES | Starting credit for this tier |
| dbo | uyesinif | indirim_oran | float | — | YES | Discount rate for this tier |
| dbo | uyesinif | kullanim_limit | float | — | YES | Usage time/value limit |
| dbo | uyesinif | on_odeme | float | — | YES | Pre-payment requirement |

**Key finding:** `uye.bakiye` is a single mutable `float` field — Selcafe maintains balance by directly updating this value, not via an append-only ledger. **The Adeks wallet ledger (ADR-006) must be entirely separate from and must not use `uye.bakiye` as its authoritative balance.** Any read of `uye.bakiye` through the adapter must be clearly scoped and labelled as "Selcafe legacy balance" — not as the Adeks wallet balance.

---

## Section 11 — Column Detail: Menu / Catalog / Operating Hours Surface

*COLUMN NAMES AND TYPES ONLY — no row values.*

### Table: dbo.urun (product catalog)

| schema_name | table_name | column_name | data_type | max_length | is_nullable | column_collation | is_identity | notes |
|---|---|---|---|---|---|---|---|---|
| dbo | urun | kod | varchar | 20 | NO | Turkish_CI_AS | NO | PK — product code |
| dbo | urun | ad | varchar | 50 | YES | Turkish_CI_AS | NO | Product name |
| dbo | urun | tip | int | — | YES | — | NO | Product type code |
| dbo | urun | urungrup_no | int | — | YES | — | NO | **Product group/category ID — references a table NOT PRESENT in schema** (see note below) |
| dbo | urun | fiyat | float | — | YES | — | NO | Unit price |
| dbo | urun | birim | varchar | 10 | YES | Turkish_CI_AS | NO | Unit of measure |
| dbo | urun | aktif | bit | — | YES | — | NO | Active/available flag |
| dbo | urun | menu | bit | — | YES | — | NO | Included in menu flag |

**Critical gap:** `urun.urungrup_no` is an integer FK referencing a product group/category, but the target table does not appear in the `selcafe` database schema. No `urungrup`, `urun_grup`, `kategori`, or similar table was found. **The product category/grouping structure is missing from the current schema.** Pod B must resolve whether: (a) the category table was intentionally omitted from this database copy, (b) categories are only coded in the application layer, or (c) `islemtip` partially serves this purpose.

### Table: dbo.menudetay (set menu / combo item mappings)

| schema_name | table_name | column_name | data_type | max_length | is_nullable | notes |
|---|---|---|---|---|---|---|
| dbo | menudetay | menu_urun_kod | varchar | 20 | NO | PK col 1 — parent menu item code |
| dbo | menudetay | urun_kod | varchar | 50 | NO | PK col 2 — component product code |
| dbo | menudetay | miktar | float | — | YES | Component quantity in the set menu |

### Table: dbo.ayar (settings / configuration — likely includes open hours)

| schema_name | table_name | column_name | data_type | max_length | is_nullable | notes |
|---|---|---|---|---|---|---|
| dbo | ayar | kod | varchar | 20 | NO | PK — setting code key |
| dbo | ayar | deger | float | — | YES | Numeric setting value |
| dbo | ayar | bindeger | image | — | YES | Binary/blob setting value |
| dbo | ayar | txtdeger | varchar | 2000 | YES | Text setting value |

**Note on open hours:** The `ayar` table is a key-value settings store (26 rows). Operating hours are likely stored here as setting keys (e.g. `acilis_saat`, `kapanis_saat` or similar). The actual key names are not visible without querying row data. Pod B to determine whether `ayar` reading is within Phase 1 scope, given it may include mixed settings — some of which could be sensitive system configuration.

### Table: dbo._pc (PC type pricing)

| schema_name | table_name | column_name | data_type | max_length | is_nullable | notes |
|---|---|---|---|---|---|---|
| dbo | _pc | tip | int | — | NO | PK — PC type code |
| dbo | _pc | ad | varchar | 20 | NO | PC type name |
| dbo | _pc | fiyat | money | — | NO | Hourly rate |

---

## Section 12 — Referential Integrity and Index Notes

### 12.1 Primary Key Types Observed

| PK type observed | Table count | Notes |
|---|---|---|
| Integer / IDENTITY (auto-increment) | 12 | ariza, basvuru, detay, dtproperties, kasaislem, kullanici, stokislem, sysdiagrams, uye — plus id (partial) |
| Integer / NOT identity (manually managed) | 5 | adisyon, islemtip, kasa, masa, siparis — PK is int but is_identity = False |
| varchar PK (natural key) | 3 | ayar (kod), urun (kod), id (ad) |
| char PK (natural key) | 1 | uyesinif (sinif) |
| datetime PK | 1 | kuyruk (zaman) — unusual; high collision risk if multiple queue entries created in same millisecond |
| Composite PK (multi-column) | 2 | dtproperties (id+property), menudetay (menu_urun_kod+urun_kod) |
| No PK defined | 3 | _kampanya, _kontrol, _pc — these tables have no PK constraint |

**Notable:** `adisyon.adisyon_no`, `siparis.siparis_no`, and `masa.masa_no` are integer PKs that are NOT identity columns — they appear to be application-managed sequences. The `id` table (2 rows) likely serves as the application-layer sequence counter for these.

### 12.2 Foreign Key Observations

**Zero formal foreign key constraints exist in the entire `selcafe` database.**

All inter-table relationships are implicit, enforced only at the application layer via column naming convention (e.g. `adisyon.masa_no` → `masa.masa_no`, `adisyon.uye_no` → `uye.uye_no`). This has the following implications for the SelcafeAdapter:

- No referential integrity guarantee from the database — application could have orphaned rows.
- Adapter join logic must be written defensively (LEFT JOINs rather than INNER JOINs in most cases).
- No cascade delete/update behaviour exists at the DB level — Selcafe application handles all consistency.
- `is_not_trusted` and `is_disabled` checks are not applicable (no FKs at all).

### 12.3 Index Observations

Non-primary-key indexes of note:

| Table | Index name | Indexed columns | Notes |
|---|---|---|---|
| adisyon | NonClusteredIndex-20241122-183734 | baslangic_zaman, bitis_zaman | Added 2024-11-22 — recent addition; confirms time-range queries are common and expensive enough to warrant indexing |
| detay | _dta_index_detay_* | siparis_no (key); urun_kod, urun_ad, miktar, birim, fiyat, tutar, durum, iptal_kullanici_no, iptal_aciklama (INCLUDE) | DTA (Database Tuning Advisor) auto-generated — covering index for order-detail lookups by order number |
| siparis | _dta_index_siparis_* | siparis_zaman, siparis_no, adisyon_no, kullanici_no (key); durum (INCLUDE) | DTA auto-generated — time-based order queries; confirms high query frequency on siparis |
| uye | IX_uye_ad | ad | UNIQUE non-clustered — member name must be unique in Selcafe |

DTA indexes indicate the Selcafe application issues frequent queries against `detay` by `siparis_no` and against `siparis` by time and order number. The adapter's read-only queries should follow the same indexed patterns to avoid performance impact on the live system.

### 12.4 Stored Procedure / Trigger Inventory Summary (Section B11 + post-spike correction)

⚠ **Correction (2026-06-23):** The original B11 discovery script results were incomplete. The provisioned read-only account has no permissions on the business-logic objects in `selcafe`, so they were invisible to `sys.objects` and `INFORMATION_SCHEMA.ROUTINES` queries run under that account. Kerem confirmed via SSMS (admin account) that additional objects exist. This section has been updated to reflect the full picture.

#### Objects visible to the provisioned read-only account (original B11 results)

| object_type | count |
|---|---|
| Stored procedures (P) — diagram utilities | 6 |
| Scalar functions (FN) — diagram utility | 1 |
| Table-valued functions (IF/TF) | 0 |
| Triggers (TR) | 4 |

Objects visible to this account are SQL Server diagram-management utilities only: `sp_alterdiagram`, `sp_creatediagram`, `sp_dropdiagram`, `sp_helpdiagramdefinition`, `sp_helpdiagrams`, `sp_renamediagram`, `fn_diagramobjects`.

#### Business-logic objects confirmed via SSMS (admin account) — NOT visible to read-only account

| Object name | Type | Name translation | Likely purpose |
|---|---|---|---|
| `dbo._sp_kampanya_hesapla` | Stored Procedure | campaign-calculate | Calculate promotion/discount for a single transaction |
| `dbo._sp_kampanya_tum_hesapla` | Stored Procedure | campaign-all-calculate | Batch recalculate all active promotions |
| `dbo.sp_get_id` | Stored Procedure | get-id | Application-managed sequence getter (aligns with `id` table, 2 rows) |
| `dbo.sp_ucret_hesapla` | Stored Procedure | charge-calculate | Calculate session/usage fee |
| `dbo.fn_saat_ucret` | Scalar Function | hour-charge | Return hourly rate for a given PC type/time |

**Definition text:** NULL / not retrievable — `sys.sql_modules` returns NULL definition for all objects, including diagram utilities. This is consistent with WITH ENCRYPTION on these objects OR the account lacking VIEW DEFINITION. Business SP source text was not retrieved.

**Permission finding:** The provisioned read-only account has **zero permissions** on the five business-logic objects above — they are completely invisible to that login. This is correct for a read-only data adapter (the adapter should never call business SPs). However, it also means the spike could not confirm their exact logic from this account.

**Revised architectural finding:** Pricing and campaign discount logic **IS present at the database layer** — not only in the Windows application layer as originally reported. `sp_ucret_hesapla` (charge calculation) and `fn_saat_ucret` (hourly rate) implement session pricing logic in T-SQL. `_sp_kampanya_hesapla` and `_sp_kampanya_tum_hesapla` implement promotion/discount logic. `sp_get_id` manages application-layer sequences via the `id` table. The SelcafeAdapter must be aware that computed totals in `adisyon` and `kasaislem` are produced by these SPs — the adapter should read the stored results, not re-implement the pricing logic.

**Triggers relevant to the adapter:**

| Trigger name | Object type | Notes |
|---|---|---|
| masa_on_update | SQL_TRIGGER | Fires on `masa` table updates — read-only adapter unaffected. |
| siparis_on_update | SQL_TRIGGER | Fires on `siparis` table updates — read-only adapter unaffected. |
| trgDurumDelete | SQL_TRIGGER | Fires on status-row deletes — read-only adapter unaffected. |
| trgDurumUpdate | SQL_TRIGGER | Fires on status field updates — read-only adapter unaffected. |

---

## Section 13 — Encoding and Data Quality Observations

### 13.1 Collation Summary

| Level | Collation value |
|---|---|
| Server default | `Turkish_CI_AS` |
| Target database collation | `Turkish_CI_AS` |
| Number of columns with collation different from database default | 0 — all character columns use `Turkish_CI_AS`; only non-character columns (int, float, datetime, bit) have null collation (expected) |
| Any column-level Turkish collation observed | Yes — all varchar/char columns: `Turkish_CI_AS` |
| Any column-level Latin1 collation observed | No |
| Any `varchar` / `char` columns (non-Unicode) observed | Yes — count: 58 varchar/char columns across all user tables |
| Any `nvarchar` / `nchar` columns (Unicode) observed | Yes — count: 2, but both are in SQL Server internal tables (`dtproperties.uvalue`, `sysdiagrams.name`). Zero nvarchar in business tables. |

**Encoding risk:** All business data is stored as `varchar`/`char` under `Turkish_CI_AS`. Turkish characters (`ğ`, `ş`, `ç`, `ö`, `ü`, `ı`) are supported via the Turkish code page in `varchar` under this collation, but when read by the TypeScript/NestJS adapter (which expects UTF-8 / Unicode), pymssql or mssql driver's codec handling will be critical. If the driver returns raw bytes without converting to UTF-8, Turkish characters will be corrupted. Pod B to assess and specify the required connection charset configuration in Section 15.

### 13.2 Nullability Risk Summary

| Finding | Value |
|---|---|
| Tables with >50% nullable columns | `_kontrol` (7/7 = 100%), `adisyon` (22/23 = 96%), `detay` (11/12 = 92%), `uye` (11/12 = 92%), `basvuru` (11/12 = 92%), `siparis` (5/6 = 83%), `kasaislem` (9/10 = 90%), `masa` (21/22 = 95%), `kasa` (4/5 = 80%), `stokislem` (5/6 = 83%), `kuyruk` (3/4 = 75%), `ayar` (3/4 = 75%), `ariza` (3/5 = 60%), `uyesinif` (5/6 = 83%), `urun` (7/8 = 88%) |
| Tables with 0% nullable columns (strict) | `_pc` (0/3 nullable), `islemtip` (0/3 nullable) |
| Tables with no NOT NULL columns at all (beyond PK) | `_kontrol` — all 7 columns are nullable including non-PK columns; this table has no PK and all nulls — it is a shadow/log table, not a reliable data store |

High nullability is pervasive. Most tables have nullable everything beyond the PK. Adapter read logic must not assume non-null values for any business columns.

### 13.3 Linked Server Findings (Section A6)

| Finding | Value |
|---|---|
| Linked servers found? | No |
| If yes — linked server names and providers | N/A |
| Implication for adapter scope | No external data integration paths visible at the SQL Server layer. Selcafe is a self-contained SQL Server instance with no database-level connections to other systems. All Selcafe integrations with external systems (if any) are handled at the Windows application layer. |

---

## Section 14 — Feasibility Assessment

> **Note (Pod B, 2026-06-23):** ADR-005 (`/docs/adr/ADR-005-selcafe-read-only-adapter.md`,
> Accepted 2026-06-23) is the authoritative architectural assessment drawn from this spike.
> Sections 14–16 cross-reference ADR-005 rather than re-derive its findings.
> ADR-005 governs on any conflict.

### 14.1 K-10 Question Answers

| K-10 Question | Answer | Source |
|---|---|---|
| Is the SQL Server network-accessible? | **Yes** — direct TCP/IP to 192.168.1.249:1433 established successfully. Named instance `SELCAFESERVER` listens on a fixed port; SQL Server Browser not required. | Section 2; ADR-005 §1.2 |
| What authentication method is needed? | SQL Server Authentication (login + password). Dedicated least-privilege read-only login required; spike's `masa` account has unconfirmed effective grants and must not be reused. | Section 5.2; ADR-005 SR-003-1 |
| What tables and columns exist? | 23 user tables in `dbo`; full schema and column detail in Sections 6–11. Phase 1 read surface narrowed to 6 candidate non-PII tables — see Section 14.3. | Sections 6–11; ADR-005 §4 |
| What data quality is present? | Pervasive nullability (>80% nullable beyond PK in most business tables), zero FK constraints database-wide, all 58 business character columns `varchar`/`char` non-Unicode under `Turkish_CI_AS`, compat level 100 (SQL Server 2008 mode). | Section 13; ADR-005 §1.2, SR-003-2 |
| What customer data exists? | Heavy PII in `uye` (name, email, phone, mobile, address, district, password, balance), `basvuru` (registration PII + password), `kullanici` (staff name + password); member linkage FK in `adisyon.uye_no`, `kasaislem.uye_no`, `kuyruk.uye_no`. | Section 8; ADR-005 §4.2 |
| What session/PC data exists? | `masa` holds station status (`durum`), session start time (`baslangic_zaman`), and active-session link (`aktif_adisyon_no` — excluded from adapter propagation per D-3a). `adisyon` holds full session billing including member FK. | Section 9; ADR-005 D-3a |
| What value/balance data exists? | `uye.bakiye` is a single mutable `float` — not a ledger, architecturally incompatible with ADR-006 (hard-excluded). `kasaislem` holds SP-computed financial transactions linked to member IDs (hard-excluded). | Section 10; ADR-005 §4.2, §4.2a |
| Is Phase 1 read-only sync feasible? | **Yes — Feasible (bounded, PII-free surface).** See Section 14.2. | ADR-005 §2, §6.1 |

### 14.2 Phase 1 Feasibility Verdict

**Feasibility verdict: ✅ Feasible — bounded, PII-free read surface**

Rationale (full reasoning in ADR-005 §§2–6; summarized here):

1. **Phase 1 read targets exist and are structurally readable.** The non-PII candidate tables (`masa`, `_pc`, `urun`, `menudetay`, `uyesinif`, `ayar`) are present and accessible to a scoped read-only account. Whether each is *built* in Phase 1 is a product-scope question (PI-1/PI-2, Section 17.4), not a feasibility question.

2. **Connection method is operationally viable with managed risk.** Direct TCP/IP on port 1433, SQL Server authentication, non-blocking reads — viable. The Win10/Express host introduces an availability risk (OS-update restarts); addressed by mandatory circuit-breaker / graceful degradation in the adapter (ADR-005 §6.2).

3. **Encoding is manageable at the adapter boundary.** The `Turkish_CI_AS` / `varchar` situation requires explicit driver-charset configuration and UTF-8 conversion at the adapter boundary (ADR-005 SR-003-2.3). Not a feasibility blocker; a mandatory implementation requirement.

4. **PII does not block the non-PII read surface.** The §4.2 hard-exclusion list and D-3a no-member-resolution rule keep the Phase 1 read path PII-free. The absent KVKK legal artifacts gate the PII/cross-border tracks only, not the non-PII catalog/status read from Source A (ADR-005 §8.4).

5. **Schema stability is adequate.** Tables dated 2005–2024 with no structural volatility visible in spike metadata. Zero-FK structure requires defensive LEFT JOINs (mandatory, not a blocker) (ADR-005 SR-003-2).

### 14.3 Recommended Phase 1 Read Targets

Per ADR-005 §4.1 (authoritative). Column-level projections and neutral read-model shapes are stated in ADR-005 §4.1; this table gives the summary.

| Selcafe table | Functional purpose | PII? | Recommended for Phase 1? |
|---|---|---|---|
| `dbo.masa` | Station occupancy status and session start time → neutral `StationStatus` | No — `aktif_adisyon_no` not propagated; no member resolution (D-3a) | **Yes** — subject to PI-1 (is station status a Phase-1 consumer?) |
| `dbo._pc` | PC type name and hourly rate → neutral `StationType` | No | **Yes** |
| `dbo.urun` | Product/menu catalog → neutral `CatalogItem` | No | **Yes** — subject to PI-2 (Selcafe-sourced vs Adeks-native menu?) |
| `dbo.menudetay` | Combo/set-menu component mappings → neutral `CatalogComboComponent` | No | **Yes** — subject to PI-2 |
| `dbo.uyesinif` | Membership tier rules (tier definitions only, no member rows) → neutral `MembershipTierDefinition` | No | **Yes** |
| `dbo.ayar` | Operating hours (key-value store) → neutral `OperatingHours` | No — if scoped to confirmed non-sensitive open-hours keys | **Conditional** — requires K-A3 authorization (controlled `ayar.kod` key-name read; currently open, ADR-005 §9). Until authorized, `ayar` / open-hours stays out of Phase 1. |

### 14.4 Surfaces Recommended Out of Phase 1 Scope

Per ADR-005 §4.2 (hard-EXCLUDED surfaces — authoritative) and D-3a.

| Selcafe table / column | Reason to exclude from Phase 1 |
|---|---|
| `dbo.uye` (entire table) | Heavy PII — name, email, phone, mobile, address, district, password, balance. Hard-excluded ADR-005 §4.2. |
| `dbo.basvuru` (entire table) | Heavy PII (same field set) + password. Hard-excluded ADR-005 §4.2. |
| `dbo.kullanici` (entire table) | Staff PII + `sifre` credential column. Hard-excluded ADR-005 §4.2. |
| Any `sifre` column | Credential-storage risk (varchar, likely weak hash or plaintext). Never read under any circumstance. ADR-005 §4.2, OQ-SC-NEW-004. |
| `uye.bakiye` | Mutable `float` — architecturally incompatible with ADR-006 append-only wallet. Hard-excluded + isolation rule. ADR-005 §4.2a. |
| `adisyon.uye_no`, `kasaislem.uye_no`, `kuyruk.uye_no` | Member-linkage FKs — PII by linkage. Hard-excluded ADR-005 §4.2. |
| `dbo.adisyon` (as a member-linked table) | Member FK + SP-computed financials; not required for Phase 1 non-PII surface. Hard-excluded ADR-005 §4.2. |
| `dbo.kasaislem` (as a member-linked table) | Member FK + SP-computed financials. Hard-excluded ADR-005 §4.2. |
| `masa.aktif_adisyon_no` (as a usable FK) | D-3a rule: must not be propagated into Adeks as a usable foreign key; occupancy boolean + session-start time derived instead. ADR-005 D-3a. |
| `masa.mac`, `masa.idle_exe*`, `masa.busy_exe*` | Device/client-config data; unnecessary; data minimization. ADR-005 §4.1. |
| `dbo.adisyon`, `dbo.siparis`, `dbo.detay`, `dbo.kasaislem` (high-volume tables) | SP-computed, member-linked financials; no Phase 1 consumer identified; >1M-row scale. All hard-excluded. |
| `dbo._kontrol` | All-nullable shadow/log table; no PK; structurally unreliable. No Phase 1 consumer. |
| `dbo.ariza` | PC fault log; no Phase 1 consumer identified. |
| `dbo.kuyruk` | Client notification queue (0 rows); contains `uye_no` PII reference; no Phase 1 consumer. |

---

## Section 15 — Encoding and Connectivity Risk Assessment

> **Note (Pod B, 2026-06-23):** Risks identified in this section are formally mitigated in
> ADR-005 SR-003-1 and SR-003-2. No new findings are raised here; this section translates
> the spike's raw observations (Section 13) into risk-level verdicts and pointers to the
> controlling ADR-005 controls.

### 15.1 Turkish Character Encoding Risk

**Risk level: ⚠ Medium** (present and mandatory to address; not a feasibility blocker)

All 58 business character columns are `varchar`/`char` under `Turkish_CI_AS` (Section 13.1). Turkish characters (`ç`, `ş`, `ı`, `ğ`, `ö`, `ü`) are stored via the Turkish code page (Windows-1254). If the SQL Server driver returns raw bytes without Unicode conversion, these characters will be corrupted at the adapter boundary.

**Mitigation — ADR-005 SR-003-2, item 3:** The `SelcafeAdapter` must explicitly configure the driver connection charset to the Turkish code page and convert output to UTF-8 at the adapter boundary. This is a mandatory implementation requirement; it must be validated with Turkish-character round-trip test cases before any Phase 1 data surfaces to consumers. The specific driver parameter is a Pod C implementation-issue decision.

### 15.2 Operational Risk to Live Selcafe Operation

**Risk level: ✓ Low** (read-only, indexed-access, small included tables)

The Phase 1 included tables are operationally small: `masa` (~250 rows), `_pc` (8 rows), `urun` (1,075 rows), `menudetay` (12 rows), `uyesinif` (14 rows), `ayar` (26 rows). None of the high-volume operational tables (`detay`, `kasaislem`, `adisyon`, `siparis` — each >1M rows) appear in the Phase 1 included set; all are hard-excluded (Section 14.4).

**Mitigation — ADR-005 SR-003-1:** Parameterized, SQL Server 2008-compatible (compat level 100), indexed-access, non-blocking reads. The specific isolation level is an implementation-phase decision (OQ-SC-NEW-009); dirty-read modes must not be used for any value-bearing read — and none of the Phase 1 included targets are value-bearing. Polling frequency should match the rate of change of the target data: catalog and open hours are slow-changing; station status is faster but still polled, not event-driven.

### 15.3 Connection Stability and Retry Risk

**Risk level: ⚠ Medium** (inherent to Win10/Express host; must be handled in adapter design)

The Selcafe SQL Server runs as named instance `SELCAFESERVER` on a Windows 10 Pro consumer-OS host under a hypervisor (Section 2.3). OS-level updates may restart the SQL Server service without notice, breaking open connections and suspending polling until reconnect. The 10 GB Express Edition size ceiling is a longer-term capacity constraint but does not affect Phase 1 (Section 3).

**Mitigation — ADR-005 §6.2:** The `SelcafeAdapter` **must** implement circuit-breaker, retry-with-backoff, and graceful degradation. A failed Selcafe read must not block, crash, or degrade Adeks features — the system must surface a neutral "status unavailable" or cached-last-known value rather than propagating errors downstream. This is a mandatory implementation requirement to be specified in the Pod C issue.

---

## Section 16 — KVKK / Personal Data Scope Notes

> **Note (Pod B, 2026-06-23):** The KVKK scope position is formalized in ADR-005 §§4–5,
> D-5. This section summarizes that position for the report reader; it is not an independent
> assessment. ADR-005 governs on any conflict.

### 16.1 Personal Data Surfaces Identified

The following surfaces were flagged `[KVKK SURFACE]` in Sections 8–10. All are formally assessed and hard-excluded in ADR-005 §4.2. The `SelcafeAdapter` must not read any of them in Phase 1.

| Column surface (schema.table.column) | Personal data type | ADR-005 disposition |
|---|---|---|
| `dbo.uye.ad` | Member name | Hard-excluded — ADR-005 §4.2 |
| `dbo.uye.eposta` | Email address | Hard-excluded — ADR-005 §4.2 |
| `dbo.uye.telefon` | Phone number | Hard-excluded — ADR-005 §4.2 |
| `dbo.uye.cep` | Mobile number | Hard-excluded — ADR-005 §4.2 |
| `dbo.uye.adres` | Home address | Hard-excluded — ADR-005 §4.2 |
| `dbo.uye.semt` | District / neighbourhood | Hard-excluded — ADR-005 §4.2 |
| `dbo.uye.sifre` | Password (varchar — likely weak hash or plaintext) | Hard-excluded — ADR-005 §4.2, OQ-SC-NEW-004 |
| `dbo.uye.bakiye` | Member balance (mutable float) | Hard-excluded + isolation rule — ADR-005 §4.2a |
| `dbo.basvuru.ad` / `.eposta` / `.telefon` / `.cep` / `.adres` / `.semt` | Registration PII (name, email, phone, mobile, address, district) | Hard-excluded — ADR-005 §4.2 |
| `dbo.basvuru.sifre` | Password | Hard-excluded — ADR-005 §4.2 |
| `dbo.kullanici.ad` | Staff name | Hard-excluded — ADR-005 §4.2 |
| `dbo.kullanici.sifre` | Staff password | Hard-excluded — ADR-005 §4.2 |
| `dbo.adisyon.uye_no` | Member linkage FK — PII by linkage | Hard-excluded; D-3a no-member-resolution rule — ADR-005 §4.2, D-3a |
| `dbo.kasaislem.uye_no` | Member linkage FK — PII by linkage | Hard-excluded — ADR-005 §4.2 |
| `dbo.kuyruk.uye_no` | Member linkage FK — PII by linkage | Hard-excluded — ADR-005 §4.2 |

### 16.2 Personal Data Scope Position

Per ADR-005 D-5 (KVKK scope position — authoritative).

| Question | Position | ADR-005 reference |
|---|---|---|
| Does the Phase 1 `SelcafeAdapter` read path touch customer personal data? | **No** — provided the §4.2 hard exclusions and D-3a no-member-resolution rule hold throughout implementation. | ADR-005 D-5, §4.2, D-3a |
| Does the Phase 1 non-PII read path require the legal-advisor KVKK gate before implementation? | **No** — for the bounded non-PII surface (Source A, direct live SQL). Three explicit carve-outs apply (see below). | ADR-005 D-5, §8.4 |
| Is `DATA_PROCESSING_INVENTORY.md` update required? | **Yes — recommended** before or alongside Phase 1 implementation: add a Selcafe-derived surfaces section documenting the Phase 1 non-PII read surface and the explicitly excluded PII surfaces with exclusion rationale. Pod A owns; Pod B reviews; Kerem approves. | ADR-005 D-5; OQ-SC-NEW-010 |
| Is `CROSS_BORDER_TRANSFER_ASSESSMENT.md` affected? | **Open** — if the Selcafe→GCP replication is confirmed to exist, it creates a cross-border obligation independently of the adapter read surface. ADR-005 K-A1 selects Source A (direct live SQL) for Phase 1; however, the replication's existence must be declared in `CROSS_BORDER_TRANSFER_ASSESSMENT.md` regardless. | ADR-005 D-6, K-A4 |

**Carve-outs that flip the KVKK gate ON (per ADR-005 D-5):**

1. **`ayar` open-hours read** — requires K-A3 authorization (controlled `ayar.kod` key-name read; currently open, ADR-005 §9). Until authorized, `ayar` / open-hours stays out of Phase 1.
2. **Any member-linked read** — requires `[NEEDS KEREM APPROVAL]` + legal-advisor gate + `DATA_PROCESSING_INVENTORY.md` update. Not authorized by ADR-005.
3. **Cross-border processing** — if the Selcafe→GCP replication is confirmed, `CROSS_BORDER_TRANSFER_ASSESSMENT.md` is required before any cross-border source is used (K-A4 gating item).

### 16.3 Legal Gate Position for ADR-005 Implementation

Per ADR-005 §8.4 (implementation gating — authoritative).

**The non-PII direct-read surface is not gated by the three absent legal artifacts.** For the strictly non-PII Source-A read surface (catalog + station status, per K-A1), the binding pre-implementation items are:

- Dedicated least-privilege read-only login provisioned — SR-003-1 (K-A2 authorized by Kerem 2026-06-23).
- SR-001 secrets-management approach in place for the Selcafe credential — SR-003-3 (SR-001 is a Pod B design item; a dependency, not yet designed).
- Kerem confirmation on PI-1 and PI-2 (which targets are built in Phase 1) — Section 17.4.
- K-A3 authorized if `ayar` / open-hours is included — ADR-005 §9.

The three absent legal artifacts (`KVKK_LEGAL_BASIS.md`, `DATA_RETENTION_POLICY.md`, `CROSS_BORDER_TRANSFER_ASSESSMENT.md`) gate the **PII and cross-border tracks specifically**:

- Any read of a §4.2 excluded PII surface → legal-artifact gate + Kerem + legal advisor.
- Any use of Source B (replica / BigQuery) → `CROSS_BORDER_TRANSFER_ASSESSMENT.md` + legal advisor (K-A4).
- Proceeding with Phase 1 non-PII catalog/status reads from Source A does **not** require these artifacts first.

**Implementation is not authorized by this spike report.** The `SelcafeAdapter` becomes Pod C work only via a separately Pod B + Kerem-approved issue meeting the Definition of Ready. See ADR-005 §8.4 and Section 18.

---

## Section 17 — Open Questions for ADR-005 Completion

**Completed by Pod B during the ADR-005 full-text session (2026-06-23, HEAD 5102859e).**

ADR-005 full text is now drafted and Kerem-approved (`/docs/adr/ADR-005-selcafe-read-only-adapter.md`,
Accepted 2026-06-23). This section records the question set as resolved/raised by that drafting.

### 17.1 ADR-005 completion status

| Item | Status |
|---|---|
| ADR-005 full text | Accepted 2026-06-23 (Kerem); merge gate Pod B + Kerem; does NOT authorize Pod C |
| Pre-spike SR-003 controls (PRE-001…004) | Resolved by ADR-005 SR-003-1…4 (see 17.2) |
| New questions from ADR-005 drafting | OQ-SC-NEW-008…010 + product-implication PI-1/PI-2 (see 17.3–17.4) |
| `[NEEDS KEREM APPROVAL]` raised | ADR-005 §9 K-A1…K-A5 (K-A1 decided = Option A; K-A2 authorized; K-A3 open; K-A4/K-A5 gating) |

### 17.2 Standing questions from K-10 and SR-003 (pre-spike) — RESOLVED

| ID | Question | Resolution in ADR-005 |
|---|---|---|
| OQ-SC-PRE-001 | Parameterized/least-privilege read mechanism (SR-003 control 1) | **Resolved** — SR-003-1: dedicated `SELECT`-only least-privilege login, parameterized, SQL-2008-compatible, indexed, non-blocking reads. |
| OQ-SC-PRE-002 | Boundary validation/sanitization of ingested data (SR-003 control 2) | **Resolved** — SR-003-2: null-tolerance, defensive LEFT JOINs, UTF-8 conversion, closed fail-safe status enums, no trust of SP-computed totals, vendor-neutral read models. |
| OQ-SC-PRE-003 | Read-only credential storage/rotation (SR-001 / SR-003 control 3) | **Resolved at requirement level** — SR-003-3: credential via the SR-001 secrets approach, never in repo/source/plaintext, rotatable. Mechanism owned by SR-001 (dependency). |
| OQ-SC-PRE-004 | Pseudonymization/exclusion for member-linked session records (SR-003 control 4) | **Resolved** — SR-003-4 + ADR-005 §4.2 hard exclusion + D-3a no-member-resolution. Phase 1 ingests no Selcafe PII. (Spike confirmed `adisyon.uye_no` / `kasaislem.uye_no` linkage; both hard-excluded.) |

### 17.3 New questions raised by ADR-005 drafting

| ID | Question | Owner | Priority |
|---|---|---|---|
| OQ-SC-NEW-008 | **Physical read source**: direct live SQL read (spiked, decided = Option A) vs. a downstream replica (BigQuery/Airbyte, ~10-min, assumed). Includes the **active-session staleness-tolerance** question and the **cross-border** implication (replication moves full Selcafe PII to GCP → `CROSS_BORDER_TRANSFER_ASSESSMENT.md` required regardless of adapter read surface). Resolved for Phase 1 by K-A1 = Option A; replica path deferred and gated by K-A4. | Kerem + Pod B (+ legal) | High |
| OQ-SC-NEW-009 | **Read isolation-level / non-blocking strategy** for the live-read path so the adapter never blocks Selcafe writers; eventual consistency acceptable for status/catalog; dirty-read modes must not be used for any value-bearing read (none in Phase 1). | Pod B | Med |
| OQ-SC-NEW-010 | **`DATA_PROCESSING_INVENTORY.md` Selcafe-surface update**: add a Selcafe-derived data surfaces section documenting the non-PII read surface and the explicitly-excluded PII surfaces with rationale. Pod A owns; Pod B reviews; Kerem approves. | Pod A + Pod B + Kerem | High |

### 17.4 Product-implication questions (route to Pod A)

| ID | Question | Owner | Priority |
|---|---|---|---|
| PI-1 | Is real-time station/session status consumed by any Phase-1 feature, or is the `masa` read a Phase-2 prerequisite being validated early? Determines whether `masa` is a Phase-1 read target. | Pod A + Kerem | High |
| PI-2 | Is the Phase-1 customer menu sourced from Selcafe `urun`, or Adeks-native? Determines whether `urun`/`menudetay` are Phase-1 read targets and whether the missing-category gap (OQ-SC-NEW-001) blocks Phase-1 menu categorization. | Pod A + Kerem | High |

### 17.5 Carry-forward (unchanged) — high-priority spike questions still open

OQ-SC-NEW-001 (missing `urungrup` category table), OQ-SC-NEW-002 (provision a dedicated scoped read-only login; ADR-005 K-A2 authorized), OQ-SC-NEW-003 (`uye.bakiye` isolation; encoded as ADR-005 §4.2a), OQ-SC-NEW-004 (`sifre` columns hard-excluded; ADR-005 §4.2), OQ-SC-NEW-005 (`ayar.kod` key-name read authorization; ADR-005 K-A3, still open), OQ-SC-NEW-006 (join/null strategy; folded into SR-003-2), OQ-SC-NEW-007 (Win10/Express availability/capacity; ADR-005 §6.2).

---

## Section 18 — Review Routing

| Role | Action |
|---|---|
| Pod C | Sections 1–13 completed 2026-06-23. Routes to Kerem + Pod B. |
| Kerem | Reviews execution metadata; confirms no row data captured; gates any further Selcafe access scope beyond this spike (including OQ-SC-NEW-005 if `ayar` key-name read is desired) |
| Pod B | Completes Sections 14–17; produces ADR-005 full text in a separate Opus/Extra/ON session (ROADMAP Seq 16) |
| Pod A | No action required on this document; consumes ADR-005 completion once available |
| Pod D | No action required at spike stage; will consume adapter monitoring design once ADR-005 is finalized |

**Implementation authority:** This report does **NOT** authorize Pod C to implement any Selcafe integration. Implementation is gated on ADR-005 full text, Pod B + Kerem approval, and separately approved GitHub issues meeting Definition of Ready.

---

## Document History

| Version | Date | Author | Change |
|---|---|---|---|
| Template v1.0 | 2026-06-22 | Pod B | Initial template. Sections 1–13 for Pod C; Sections 14–17 for Pod B. Aligned to K-10 question set, SR-003 controls, ADR-005 stub, ROADMAP Seq 14–16. HEAD SHA at template production: d76eede939514cf1051e1521415c0754a749a05e. |
| v1.1 (Sections 1–13) | 2026-06-23 | Pod C | Sections 1–13 filled from live spike execution against `selcafe` on 192.168.1.249:1433. Script selcafe_schema_discovery_v1.0.sql executed in full (Parts A + B). No row data captured. 23 tables, 180 columns documented. 7 new open questions raised (OQ-SC-NEW-001 through 007). |
| v1.2 (Section 17) | 2026-06-23 | Pod B | Section 17 completed during the ADR-005 full-text session. Resolved OQ-SC-PRE-001…004 (mapped to ADR-005 SR-003-1…4); raised OQ-SC-NEW-008…010 and product-implication PI-1/PI-2. Status line updated. Sections 14–16 remain pending Pod B (lightweight follow-on referencing ADR-005). No row data; schema/metadata only. |
| v1.3 (Sections 14–16) | 2026-06-23 | Pod B | Sections 14–16 completed as ADR-005 cross-references (no new findings). Feasibility verdict ✅ Feasible (bounded, PII-free surface). Recommended/excluded read targets per ADR-005 §4.1/§4.2. Encoding risk Medium, operational-disruption risk Low, connection-stability risk Medium — all mitigated by ADR-005 SR-003-1/SR-003-2/§6.2. KVKK scope position per ADR-005 D-5: non-PII Phase-1 surface not gated by absent legal artifacts. Document complete. |
