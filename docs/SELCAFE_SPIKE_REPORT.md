# SELCAFE_SPIKE_REPORT.md

<!--
  CANONICAL REPO PATH : /docs/SELCAFE_SPIKE_REPORT.md
  DOCUMENT TYPE       : Spike report template — awaiting Pod C execution
  STATUS              : TEMPLATE — not yet filled
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
| Status | **TEMPLATE — Pod C to fill Sections 1–13; Pod B to complete Sections 14–17** |
| Script version | `selcafe_schema_discovery_v1.0.sql` |
| Data rule | Schema and catalog metadata only; NO row data; NO real customer data |
| Implementation authority | **Does NOT authorize Pod C to implement any integration** |
| Next action after completion | Route to Kerem + Pod B for review; Pod B uses findings to complete ADR-005 |

---

## Section 1 — Execution Metadata

**To be completed by Pod C.**

| Field | Value |
|---|---|
| Script version executed | selcafe_schema_discovery_v1.0.sql v1.0 |
| Execution date (UTC) | [POD C: YYYY-MM-DD] |
| Execution time (UTC) | [POD C: HH:MM] |
| Pod C operator identifier | [POD C: no personal data — use session ID or role label] |
| SQL tool used | [e.g. SSMS 19, Azure Data Studio, sqlcmd] |
| Connection method | [e.g. VPN + TCP/IP, direct LAN, port forwarding] |
| Time-box start | [POD C: YYYY-MM-DD HH:MM local] |
| Time-box end | [POD C: YYYY-MM-DD HH:MM local] |
| Script run status | [e.g. Completed / Partial — Part A only / Error in section Bx] |
| Any anomalies or interruptions | [POD C: describe or "none"] |

---

## Section 2 — Connectivity Findings

**To be completed by Pod C from Part A output.**

### 2.1 Network Accessibility

| Question (K-10) | Finding |
|---|---|
| Is the SQL Server network-accessible? | [Yes / No / Requires VPN / Requires port forwarding] |
| Host/address used (do not include credentials) | [e.g. 192.168.x.x or hostname — internal only; do not publish] |
| Port used | [e.g. 1433 / custom port] |
| Initial connection successful? | [Yes / No — if No, describe the error without including credentials] |

### 2.2 Authentication

| Question (K-10) | Finding |
|---|---|
| Authentication method required | [SQL Server Authentication / Windows Authentication / Both available] |
| Named instance required? | [Yes — instance name: [redact credentials] / No — default instance] |
| TLS/SSL enforced by server? | [Yes / No / Unknown] |
| Connection string format needed | [e.g. Server=host,port;Database=…;User Id=…;Password=…;] — describe format only; do not include actual credentials |

### 2.3 Connectivity Risk Notes

[POD C: note any timeouts, firewall blocks, intermittent failures, or unusual connection behaviour observed during the spike.]

---

## Section 3 — Server Identity (from Script Part A)

**To be completed by Pod C from Section A1–A3 output.**

| Field | Value |
|---|---|
| SQL Server name (`@@SERVERNAME`) | [POD C] |
| Product version | [e.g. 14.0.3456.2] |
| Product level | [e.g. RTM / SP1 / CU12] |
| Edition | [e.g. Standard Edition (64-bit) / Express Edition] |
| Engine edition code | [1–8; see script comments] |
| Server default collation | [e.g. SQL_Latin1_General_CP1_CI_AS / Turkish_CI_AS] |
| Full text search installed | [Yes / No] |
| Server time vs UTC at run time | [POD C: note offset for timezone context] |

### 3.1 Collation Assessment

[POD C: paste the `server_default_collation` value here and note whether it contains "Turkish" or "Latin1". Pod B will assess Turkish character encoding risk in Section 15.]

---

## Section 4 — Database Inventory (from Script Section A4)

**To be completed by Pod C. List all non-system databases found.**

| database_name | database_id | state | recovery_model | compatibility_level | database_collation | is_read_only | create_date |
|---|---|---|---|---|---|---|---|
| [POD C] | | | | | | | |

### 4.1 Target Database Identification

| Field | Value |
|---|---|
| Identified Selcafe target database name | [POD C: name used as SELCAFE_DB_NAME_PLACEHOLDER in Part B] |
| Basis for identification | [e.g. only non-system DB present / matches expected name / confirmed with Kerem] |
| Additional databases noted (names only) | [POD C: list any other non-system DBs found] |

---

## Section 5 — Credential / Permission Check (from Script Section A5, B12)

**To be completed by Pod C. Confirms read-only posture.**

### 5.1 Server-Level Role Membership (Section A5)

| Role | Value | Expected |
|---|---|---|
| is_sysadmin | [0 / 1] | 0 |
| is_securityadmin | [0 / 1] | 0 |
| is_serveradmin | [0 / 1] | 0 |
| is_diskadmin | [0 / 1] | 0 |
| is_dbcreator | [0 / 1] | 0 |
| is_bulkadmin | [0 / 1] | 0 |
| is_public | [0 / 1] | 1 |

⚠ If any of the first six values above is `1`, STOP — the credential has elevated server privileges. Report to Kerem immediately. Do not proceed with Part B.

### 5.2 Database-Level Role Membership (Section B12)

| Role | is_member |
|---|---|
| db_owner | [0 / 1] — must be 0 |
| db_ddladmin | [0 / 1] — must be 0 |
| db_datawriter | [0 / 1] — must be 0 |
| db_datareader | [0 / 1] — expected 1 or custom read-only role |
| db_denydatawriter | [0 / 1] |

---

## Section 6 — Schema and Table Inventory (from Script Sections B2, B3)

**To be completed by Pod C.**

### 6.1 User-Defined Schemas (Section B2)

| schema_id | schema_name | schema_owner |
|---|---|---|
| [POD C] | | |

### 6.2 Table Inventory with Approximate Row Counts (Section B3)

*Row counts are from `sys.partitions` — SQL Server internal catalog statistics. This is table-size metadata, not business data.*

| schema_name | table_name | create_date | modify_date | approx_row_count_catalog |
|---|---|---|---|---|
| [POD C — paste all rows from B3 output here] | | | | |

---

## Section 7 — Functional Surface Mapping

**To be completed by Pod C initially; Pod B refines after reviewing Section 6.**

Based on the table names discovered in Section 6.2, map each table to the most likely functional category. Use the table names only — do not query the tables.

| Table name (from Section 6.2) | Most likely functional category | Confidence | Notes |
|---|---|---|---|
| [POD C: list each table name from B3] | [select from categories below] | [High/Med/Low/Unknown] | |

**Functional category options:**
- `CUSTOMER / MEMBER` — customer account, identity, or membership data
- `SESSION / PC_USAGE` — PC session, usage time, active sessions
- `PC / WORKSTATION` — PC/workstation inventory and status
- `MENU / CATALOG` — F&B menu items, categories, pricing
- `ORDER / TRANSACTION` — F&B orders or general transaction records
- `PAYMENT / INVOICE` — payment, invoice, or receipt records
- `BALANCE / CREDIT / WALLET` — prepaid balance, credits, wallet data
- `STAFF / EMPLOYEE` — staff or employee accounts
- `OPERATING_HOURS / SCHEDULE` — café open hours, schedule
- `AUDIT / LOG` — activity log, audit records
- `SYSTEM / CONFIG` — system configuration, settings
- `UNKNOWN` — cannot determine from name alone; Pod B to assess

---

## Section 8 — Column Detail: Customer / Member Data Surface

**To be completed by Pod C. COLUMN NAMES AND TYPES ONLY — no row values.**

List columns from tables identified as `CUSTOMER / MEMBER` in Section 7, plus any column in any table with names suggestive of personal data (e.g. containing "phone", "name", "email", "tc", "kimlik", "address", "mobile", "gsm").

| schema_name | table_name | column_name | data_type | max_length | is_nullable | column_collation | is_identity | notes |
|---|---|---|---|---|---|---|---|---|
| [POD C] | | | | | | | | |

**KVKK flag:** For each column that appears to hold personal data (names, phone numbers, national ID numbers, email addresses, birthdates), add `[KVKK SURFACE]` in the notes column. Pod B will assess in Section 16.

---

## Section 9 — Column Detail: Session / PC Data Surface

**To be completed by Pod C. COLUMN NAMES AND TYPES ONLY — no row values.**

List columns from tables identified as `SESSION / PC_USAGE` or `PC / WORKSTATION` in Section 7.

| schema_name | table_name | column_name | data_type | max_length | is_nullable | column_collation | is_identity | notes |
|---|---|---|---|---|---|---|---|---|
| [POD C] | | | | | | | | |

**ADR-005 note:** The SelcafeAdapter Phase 1 intent is to read: open hours, categories, menu items, and active sessions. Identify which session columns map to these read targets.

---

## Section 10 — Column Detail: Value / Balance / Payment Surface

**To be completed by Pod C. COLUMN NAMES AND TYPES ONLY — no row values.**

List columns from tables identified as `BALANCE / CREDIT / WALLET`, `PAYMENT / INVOICE`, or `ORDER / TRANSACTION` in Section 7.

| schema_name | table_name | column_name | data_type | max_length | is_nullable | column_collation | is_identity | notes |
|---|---|---|---|---|---|---|---|---|
| [POD C] | | | | | | | | |

**KVKK flag:** If any column appears to hold customer-linked financial data, add `[KVKK SURFACE]` in the notes column.

---

## Section 11 — Column Detail: Menu / Catalog / Operating Hours Surface

**To be completed by Pod C. COLUMN NAMES AND TYPES ONLY — no row values.**

List columns from tables identified as `MENU / CATALOG` or `OPERATING_HOURS / SCHEDULE` in Section 7.

| schema_name | table_name | column_name | data_type | max_length | is_nullable | column_collation | is_identity | notes |
|---|---|---|---|---|---|---|---|---|
| [POD C] | | | | | | | | |

**ADR-005 note:** These tables are primary Phase 1 read targets for the SelcafeAdapter (categories, menu items, open hours). Completeness of this section directly informs ADR-005 completion.

---

## Section 12 — Referential Integrity and Index Notes

**To be completed by Pod C from Sections B5–B8 output.**

### 12.1 Primary Key Types Observed

| PK type observed | Table count | Notes |
|---|---|---|
| Integer / IDENTITY (auto-increment) | [POD C] | |
| GUID / uniqueidentifier | [POD C] | |
| Composite PK (multi-column) | [POD C] | |
| No PK defined | [POD C] | Tables without PKs are flagged as data quality risk |

### 12.2 Foreign Key Observations

[POD C: summarise the FK map from Section B6. Note:
- How many FK relationships exist?
- Are there circular references?
- Are any FKs marked `is_not_trusted = 1` (constraints not enforced)?
- Are any FKs disabled?]

### 12.3 Index Observations

[POD C: note any unusual patterns from Section B8 — e.g. many non-clustered indexes suggesting heavy query load; no indexes on large tables; indexes on datetime/session columns suggesting time-based queries.]

### 12.4 Stored Procedure / Trigger Inventory Summary (Section B11)

| object_type | count |
|---|---|
| Stored procedures (P) | [POD C] |
| Scalar functions (FN) | [POD C] |
| Table-valued functions (IF/TF) | [POD C] |
| Triggers (TR) | [POD C] |

[POD C: note the names of any stored procedures with names suggestive of customer data, balance operations, or session management. Names only — do not read the procedure body.]

---

## Section 13 — Encoding and Data Quality Observations

**To be completed by Pod C from Section B9 output.**

### 13.1 Collation Summary

| Level | Collation value |
|---|---|
| Server default (from Section 3) | [POD C] |
| Target database collation (from Section B1) | [POD C] |
| Number of columns with collation different from database default | [POD C] |
| Any column-level Turkish collation observed | [Yes / No] |
| Any column-level Latin1 collation observed | [Yes / No] |
| Any `varchar` / `char` columns (non-Unicode) observed | [Yes / No — count: ] |
| Any `nvarchar` / `nchar` columns (Unicode) observed | [Yes / No — count: ] |

### 13.2 Nullability Risk Summary

| Finding | Value |
|---|---|
| Tables with >50% nullable columns | [POD C: list table names from B9] |
| Tables with 0% nullable columns (strict) | [POD C: list table names] |
| Tables with no NOT NULL columns at all | [POD C: list table names — data quality red flag] |

### 13.3 Linked Server Findings (Section A6)

| Finding | Value |
|---|---|
| Linked servers found? | [Yes / No] |
| If yes — linked server names and providers | [POD C: list from A6 output] |
| Implication for adapter scope | [POD C: note if any linked server suggests additional data sources] |

---

## Section 14 — Feasibility Assessment

**To be completed by Pod B after reviewing Sections 1–13.**

### 14.1 K-10 Question Answers

| K-10 Question | Answer |
|---|---|
| Is the SQL Server network-accessible? | [Pod B: based on Section 2] |
| What authentication method is needed? | [Pod B: based on Section 2.2] |
| What tables and columns exist? | [Pod B: see Sections 6–11; full detail in those sections] |
| What data quality is present? | [Pod B: based on Section 13] |
| What customer data exists? | [Pod B: based on Section 8 — field names and types only] |
| What session/PC data exists? | [Pod B: based on Section 9] |
| What value/balance data exists? | [Pod B: based on Section 10] |
| Is Phase 1 read-only sync feasible? | [Pod B: **Feasible / Partially Feasible / Not Feasible** — see 14.2] |

### 14.2 Phase 1 Feasibility Verdict

**[Pod B to complete after reviewing all sections]**

Feasibility verdict: `[ ] Feasible` `[ ] Partially Feasible` `[ ] Not Feasible` `[ ] Requires Further Spike`

Rationale:

[Pod B: provide structured rationale covering:
1. Whether the Phase 1 read targets (open hours, categories, menu items, active sessions) are present as readable table structures.
2. Whether the connection method is operationally viable (latency, reliability, no live-operation disruption).
3. Whether the encoding/collation situation is manageable at the adapter layer.
4. Whether PII/customer data in the read path creates KVKK scope that would require legal-advisor input before the adapter is built.
5. Whether the schema structure is stable enough to build a reliable read adapter against.]

### 14.3 Recommended Phase 1 Read Targets

**[Pod B to complete]**

Based on the spike findings, the following Selcafe tables/views are recommended as Phase 1 read targets for the SelcafeAdapter (subject to ADR-005 full text and Kerem confirmation):

| Read target (table/view name) | Functional purpose | Personal data present? | Recommended adapter read? |
|---|---|---|---|
| [Pod B] | | | |

### 14.4 Surfaces Recommended Out of Phase 1 Scope

**[Pod B to complete]**

The following discovered surfaces are recommended as out of Phase 1 SelcafeAdapter scope, with rationale:

| Table/view name | Reason to exclude from Phase 1 |
|---|---|
| [Pod B] | |

---

## Section 15 — Encoding and Connectivity Risk Assessment

**To be completed by Pod B.**

### 15.1 Turkish Character Encoding Risk

[Pod B: assess whether the observed collation(s) and column types create a risk of Turkish character corruption when data is ingested into the NestJS/TypeScript adapter layer. Note any tables or columns where encoding conversion will be required.]

**Risk level:** `[ ] Low` `[ ] Medium` `[ ] High`

**Mitigation recommendation:** [Pod B]

### 15.2 Operational Risk to Live Selcafe Operation

[Pod B: based on connection method, table sizes (from Section 6.2 row counts), and schema structure, assess whether a periodic read-only polling adapter poses any risk to live Selcafe performance or data integrity.]

**Risk level:** `[ ] Low` `[ ] Medium` `[ ] High`

**Mitigation recommendation:** [Pod B]

### 15.3 Connection Stability and Retry Risk

[Pod B: assess the operational reliability of the read path — VPN dependency, TCP/IP stability, SQL Server instance restarts on updates, etc. Note whether the adapter will require circuit-breaker or fallback behaviour.]

---

## Section 16 — KVKK / Personal Data Scope Notes

**To be completed by Pod B. ASSUMPTION markers used where data evidence is insufficient.**

### 16.1 Personal Data Surfaces Identified

[Pod B: based on the `[KVKK SURFACE]` flags in Sections 8–10, list the discovered personal-data-bearing columns and their KVKK implications for the SelcafeAdapter.]

| Column surface (schema.table.column) | Personal data type | KVKK implication |
|---|---|---|
| [Pod B: derived from Section 8 flags] | | |

### 16.2 Personal Data Scope Position

Based on the spike findings:

| Question | Position |
|---|---|
| Does the Phase 1 SelcafeAdapter read path touch customer personal data? | [Yes / No / Conditional on read target selection] |
| Does Phase 1 read path require legal-advisor KVKK review before implementation? | [Yes / No / Partial] |
| Is `DATA_PROCESSING_INVENTORY.md` update required before adapter implementation? | [Yes — new data surfaces identified / No — existing inventory covers the scope] |
| Is `CROSS_BORDER_TRANSFER_ASSESSMENT.md` affected? | [Note if Selcafe DB hosting introduces any cross-border dimension] |

### 16.3 Legal Gate Position for ADR-005 Implementation

[Pod B: state whether the SelcafeAdapter implementation gate is:
- (a) clear of KVKK dependencies if the Phase 1 read targets are non-PII only (open hours, categories, menu items), OR
- (b) KVKK-gated if the read path will include any customer-identity-linked data (session records with customer references, balance data, etc.)]

---

## Section 17 — Open Questions for ADR-005 Completion

**To be completed by Pod B.**

The following questions must be resolved before the full ADR-005 text can be finalized (ROADMAP Seq 16). This section is an input packet for the ADR-005 Opus session.

| ID | Question | Owner | Priority |
|---|---|---|---|
| OQ-SC-001 | [Pod B: list open question] | | |

**Standing questions from K-10 and SR-003 (pre-spike):**

| ID | Question | Owner | Status |
|---|---|---|---|
| OQ-SC-PRE-001 | What parameterized/least-privilege read access mechanism should the SelcafeAdapter use to prevent injection on the Selcafe read path? (SR-003 control 1) | Pod B | Pending ADR-005 full text |
| OQ-SC-PRE-002 | What validation/sanitization must occur at the CafeManagementAdapter boundary for Selcafe-ingested data before it enters Adeks domain logic? (SR-003 control 2) | Pod B | Pending ADR-005 full text |
| OQ-SC-PRE-003 | How should the Selcafe read-only credential be stored and rotated within the Adeks deployment? (SR-001 / SR-003 control 3) | Pod B | Pending secrets-management approach (SR-001) |
| OQ-SC-PRE-004 | If Selcafe session records link to a customer identifier, what pseudonymization or exclusion approach prevents that PII from entering Adeks domain objects? (SR-003 control 4) | Pod B + Kerem | Pending spike findings |

---

## Section 18 — Review Routing

| Role | Action |
|---|---|
| Pod C | Completes Sections 1–13; routes to Kerem + Pod B |
| Kerem | Reviews execution metadata; confirms no row data captured; gates any further Selcafe access scope beyond this spike |
| Pod B | Completes Sections 14–17; produces ADR-005 full text in a separate Opus/Extra/ON session (ROADMAP Seq 16) |
| Pod A | No action required on this document; consumes ADR-005 completion once available |
| Pod D | No action required at spike stage; will consume adapter monitoring design once ADR-005 is finalized |

**Implementation authority:** This report does **NOT** authorize Pod C to implement any Selcafe integration. Implementation is gated on ADR-005 full text, Pod B + Kerem approval, and separately approved GitHub issues meeting Definition of Ready.

---

## Document History

| Version | Date | Author | Change |
|---|---|---|---|
| Template v1.0 | 2026-06-22 | Pod B | Initial template. Sections 1–13 for Pod C; Sections 14–17 for Pod B. Aligned to K-10 question set, SR-003 controls, ADR-005 stub, ROADMAP Seq 14–16. HEAD SHA at template production: d76eede939514cf1051e1521415c0754a749a05e. |
