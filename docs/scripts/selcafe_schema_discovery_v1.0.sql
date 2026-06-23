/*
================================================================================
  SELCAFE SCHEMA DISCOVERY SCRIPT
  Version     : 1.0
  Date        : 2026-06-22
  Author      : Pod B — Architecture, Logic & Risk (Adeks Platform)
  Task ref    : M3 / K-10 (KEREM_DECISIONS.md §10)
  ADR ref     : ADR-005-selcafe-read-only-adapter (stub)
  Roadmap ref : Seq 14 (execute) — Seq 15 (report) — Seq 16 (ADR-005 full text)
================================================================================

  ╔══════════════════════════════════════════════════════════════════════════╗
  ║  ⚠  READ-ONLY / SCHEMA AND METADATA ONLY                               ║
  ║  ⚠  DO NOT MODIFY — NO INSERT, UPDATE, DELETE, DROP, ALTER, CREATE     ║
  ║  ⚠  NO ROW DATA — queries sys.* catalogs and INFORMATION_SCHEMA only   ║
  ║  ⚠  NO REAL CUSTOMER DATA — this script must never output business rows ║
  ║  ⚠  DO NOT SAVE CREDENTIALS IN THIS FILE OR IN SOURCE CONTROL          ║
  ╚══════════════════════════════════════════════════════════════════════════╝

  PURPOSE
  -------
  Provides a schema-and-metadata-only read of the live Selcafe SQL Server
  database to support the ADR-005 / SelcafeAdapter integration design.
  Answers the K-10 feasibility questions (network access, auth method,
  table/column catalog, encoding posture, data-surface categorisation)
  without touching any business or customer data rows.

  WHAT THIS SCRIPT DOES
  ----------------------
  Part A — Server identity, database listing, credential/permission check.
            Requires no specific database context; run connected to any DB
            (e.g. master or the connection default).

  Part B — Schema, table, column, index, and constraint metadata for the
            Selcafe target database identified in Part A.
            Uses three-part names ([SELCAFE_DB].sys.*, [SELCAFE_DB].INFORMATION_SCHEMA.*)
            so it does NOT require a USE statement or context switch.
            Pod C substitutes the placeholder (see Step 3 below) before running.

  WHAT THIS SCRIPT DOES NOT DO
  ----------------------------
  • SELECT from any business, customer, session, order, or payment table.
  • Read any row-level data (customer records, balances, transaction history).
  • Write, update, insert, delete, or modify any object or row.
  • Export or transmit row data to any external system.
  • Request, store, display, or log credentials.

  COMPATIBILITY
  -------------
  • Tested syntax: SQL Server 2012 and later (avoids STRING_AGG, JSON functions,
    and other SQL Server 2017+ features for maximum compatibility).
  • Minimum permissions required on the read-only SQL account:
      - CONNECT to the target database
      - VIEW DEFINITION  (to read sys.columns, sys.indexes, etc.)
      - VIEW DATABASE STATE  (to read sys.partitions for row-count estimates)
    If the account lacks VIEW DEFINITION or VIEW DATABASE STATE, some sections
    will return zero rows.  Report this to Kerem — do NOT escalate privileges.

  INSTRUCTIONS FOR POD C
  -----------------------
  Step 1  Connect to the Selcafe SQL Server using the read-only SQL credential
          supplied by Kerem through the secure channel (K-10).
          ⚠ Do NOT use Windows admin, 'sa', or any elevated account.
          ⚠ Do NOT save the password in this file, in SSMS, or in source control.

  Step 2  Run PART A in full.  Record the output in the spike report template.
          Note the database name(s) listed under Section A4 (Non-System Databases).

  Step 3  Identify the Selcafe application database from the A4 output.
          In PART B, find every occurrence of the following placeholder text:
              SELCAFE_DB_NAME_PLACEHOLDER
          and replace it with the actual database name.  Example:
              [SELCAFE_DB_NAME_PLACEHOLDER]  →  [SelCafe]
          Use your editor's Find & Replace (Ctrl+H in SSMS).

  Step 4  Run PART B.  Copy column headers and values into the spike report.
          ⚠ COPY COLUMN NAMES AND TYPES ONLY.
          ⚠ DO NOT copy any row-level data values from business tables into
            the report, into any AI chat, or into any shared document.

  Step 5  Hand the completed report template (/docs/SELCAFE_SPIKE_REPORT.md)
          to Kerem and Pod B for review.  Do not interpret the findings
          independently; Pod B performs the feasibility assessment.

  SECURITY NOTES  (see also SECURITY_REVIEW.md SR-003)
  -----------------------------------------------------
  • If the account returns zero rows from system catalogs, it likely lacks
    VIEW DEFINITION.  Report to Kerem immediately; do not attempt to grant
    yourself permissions or switch to a higher-privilege account.
  • If any query output unexpectedly contains recognisable customer names,
    phone numbers, or financial amounts, STOP — do not copy that output to
    the report.  Inform Kerem at once.
  • The approximate row counts in Section B3 come from sys.partitions
    (SQL Server internal statistics metadata) — they are not a SELECT
    against the business tables.  This is the only numeric data the script
    reads and it represents table-size metadata only.

================================================================================
*/


PRINT '================================================================================';
PRINT 'SELCAFE SCHEMA DISCOVERY SCRIPT v1.0';
PRINT 'READ-ONLY / SCHEMA AND METADATA ONLY';
PRINT 'Adeks Platform — M3 / K-10 Feasibility Spike';
PRINT '';
PRINT 'Run by   : [POD C: enter your pod identifier — no personal data]';
PRINT 'Run date : [POD C: enter date in YYYY-MM-DD format]';
PRINT '================================================================================';
PRINT '';


/* ==============================================================================
   PART A — SERVER IDENTITY AND DATABASE DISCOVERY
   Run while connected to any database (master or connection default).
   ============================================================================== */

PRINT '--------------------------------------------------------------------------------';
PRINT 'PART A — SERVER IDENTITY AND DATABASE DISCOVERY';
PRINT '--------------------------------------------------------------------------------';
PRINT '';


/* ---- A1. CONNECTIVITY AND SESSION IDENTITY --------------------------------- */
PRINT '>>> A1. CONNECTIVITY AND SESSION IDENTITY';
PRINT '    Purpose: confirms the connection is live and records the login context.';

SELECT
    @@SERVERNAME                       AS server_name,
    SYSTEM_USER                        AS login_name,
    USER_NAME()                        AS db_user_name,
    DB_NAME()                          AS current_database,
    GETDATE()                          AS run_timestamp_server_local,
    GETUTCDATE()                       AS run_timestamp_utc;

PRINT '';


/* ---- A2. SQL SERVER VERSION AND EDITION ----------------------------------- */
PRINT '>>> A2. SQL SERVER VERSION AND EDITION';
PRINT '    Purpose: determines compatibility constraints for Phase 1 adapter.';

SELECT
    CAST(SERVERPROPERTY('ProductVersion')  AS NVARCHAR(128)) AS product_version,
    CAST(SERVERPROPERTY('ProductLevel')    AS NVARCHAR(128)) AS product_level,
    CAST(SERVERPROPERTY('ProductUpdateLevel') AS NVARCHAR(128)) AS product_update_level,
    CAST(SERVERPROPERTY('Edition')         AS NVARCHAR(128)) AS edition,
    CAST(SERVERPROPERTY('EngineEdition')   AS NVARCHAR(128)) AS engine_edition;
    -- EngineEdition: 1=Desktop,2=Standard,3=Enterprise,4=Express,5=Azure SQL DB,8=Managed Instance

SELECT @@VERSION AS full_version_string;

PRINT '';


/* ---- A3. SERVER COLLATION (critical for Turkish character encoding) -------- */
PRINT '>>> A3. SERVER DEFAULT COLLATION';
PRINT '    Purpose: Turkish character support requires a Turkish_CI or Turkish_CS';
PRINT '    collation, or Unicode (nvarchar) columns.  Flags encoding risk for SelcafeAdapter.';

SELECT
    CAST(SERVERPROPERTY('Collation')           AS NVARCHAR(128)) AS server_default_collation,
    CAST(SERVERPROPERTY('IsFullTextInstalled') AS NVARCHAR(10))  AS fulltext_installed,
    CAST(SERVERPROPERTY('LCID')                AS NVARCHAR(20))  AS lcid;

PRINT '';


/* ---- A4. NON-SYSTEM DATABASES ON THIS SERVER ------------------------------ */
PRINT '>>> A4. NON-SYSTEM DATABASES';
PRINT '    Purpose: identifies the Selcafe application database.';
PRINT '    NOTE: Record the name of the Selcafe DB from this output,';
PRINT '    then substitute it for SELCAFE_DB_NAME_PLACEHOLDER throughout Part B.';

SELECT
    name                                       AS database_name,
    database_id,
    state_desc                                 AS state,
    recovery_model_desc                        AS recovery_model,
    compatibility_level,
    collation_name                             AS database_collation,
    is_read_only,
    create_date,
    CAST(DATABASEPROPERTYEX(name, 'Status')
         AS NVARCHAR(64))                      AS status_property
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb', 'distribution')
  AND name NOT LIKE 'ReportServer%'
ORDER BY database_id;

PRINT '';


/* ---- A5. CURRENT ACCOUNT SERVER-LEVEL PRIVILEGE CHECK -------------------- */
PRINT '>>> A5. CURRENT ACCOUNT SERVER-LEVEL ROLE MEMBERSHIP';
PRINT '    Purpose: verifies the read-only posture.';
PRINT '    Expected result: is_sysadmin = 0, is_securityadmin = 0, is_serveradmin = 0.';
PRINT '    If any of these = 1, STOP and report to Kerem — wrong credential in use.';

SELECT
    IS_SRVROLEMEMBER('sysadmin')          AS is_sysadmin,         -- must be 0
    IS_SRVROLEMEMBER('securityadmin')     AS is_securityadmin,    -- must be 0
    IS_SRVROLEMEMBER('serveradmin')       AS is_serveradmin,      -- must be 0
    IS_SRVROLEMEMBER('diskadmin')         AS is_diskadmin,        -- must be 0
    IS_SRVROLEMEMBER('dbcreator')         AS is_dbcreator,        -- must be 0
    IS_SRVROLEMEMBER('bulkadmin')         AS is_bulkadmin,        -- must be 0
    IS_SRVROLEMEMBER('processadmin')      AS is_processadmin,     -- must be 0
    IS_SRVROLEMEMBER('public')            AS is_public;            -- expected 1

PRINT '';


/* ---- A6. LINKED SERVERS (identifies additional data integrations) ---------- */
PRINT '>>> A6. LINKED SERVERS AND REMOTE CONNECTIONS';
PRINT '    Purpose: reveals whether Selcafe connects to any other data sources.';
PRINT '    Relevant to SelcafeAdapter integration scope.';

SELECT
    name                                AS linked_server_name,
    product,
    provider,
    data_source,
    catalog,
    is_remote_login_enabled,
    is_rpc_out_enabled,
    is_linked
FROM sys.servers
WHERE is_linked = 1
ORDER BY name;

IF @@ROWCOUNT = 0
    PRINT '    (No linked servers found.)';

PRINT '';
PRINT '--------------------------------------------------------------------------------';
PRINT 'PART A COMPLETE.';
PRINT '';
PRINT 'Next step:';
PRINT '  1. Identify the Selcafe database name from A4 above.';
PRINT '  2. In Part B below, find-and-replace every occurrence of:';
PRINT '         SELCAFE_DB_NAME_PLACEHOLDER';
PRINT '     with the actual database name.';
PRINT '  3. Run Part B.';
PRINT '--------------------------------------------------------------------------------';
PRINT '';


/* ==============================================================================
   PART B — SCHEMA AND METADATA DISCOVERY
   ⚠ PREREQUISITE: replace SELCAFE_DB_NAME_PLACEHOLDER with the actual
     Selcafe database name from Part A, Section A4.
     Example: [SELCAFE_DB_NAME_PLACEHOLDER]  →  [SelCafe]
     Use Find & Replace (Ctrl+H in SSMS) before running.
   ============================================================================== */

PRINT '--------------------------------------------------------------------------------';
PRINT 'PART B — SCHEMA AND METADATA DISCOVERY';
PRINT 'TARGET DATABASE: SELCAFE_DB_NAME_PLACEHOLDER';
PRINT '⚠  SCHEMA AND SYSTEM CATALOG QUERIES ONLY — NO ROW DATA ⚠';
PRINT '--------------------------------------------------------------------------------';
PRINT '';


/* ---- B1. TARGET DATABASE PROPERTIES AND COLLATION ------------------------- */
PRINT '>>> B1. TARGET DATABASE PROPERTIES AND COLLATION';
PRINT '    Purpose: confirms the target database is accessible and records';
PRINT '    its collation (Turkish character support assessment).';

SELECT
    name                                   AS database_name,
    collation_name                         AS database_collation,
    compatibility_level,
    recovery_model_desc                    AS recovery_model,
    is_read_only,
    state_desc,
    create_date,
    page_verify_option_desc                AS page_verify_option,
    log_reuse_wait_desc                    AS log_reuse_wait
FROM sys.databases
WHERE name = N'SELCAFE_DB_NAME_PLACEHOLDER';

PRINT '';


/* ---- B2. SCHEMA INVENTORY ------------------------------------------------- */
PRINT '>>> B2. SCHEMA INVENTORY (user-created schemas only)';
PRINT '    Purpose: identifies whether Selcafe uses non-default schemas';
PRINT '    (e.g. [dbo], [cafe], [app]).  Relevant to adapter query construction.';

SELECT
    sch.schema_id,
    sch.name                               AS schema_name,
    dp.name                                AS schema_owner
FROM [SELCAFE_DB_NAME_PLACEHOLDER].sys.schemas   sch
LEFT JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.database_principals dp
    ON dp.principal_id = sch.principal_id
WHERE sch.name NOT IN (
    'sys', 'INFORMATION_SCHEMA', 'guest', 'dbo',
    'db_owner', 'db_accessadmin', 'db_securityadmin', 'db_ddladmin',
    'db_backupoperator', 'db_datareader', 'db_datawriter',
    'db_denydatareader', 'db_denydatawriter'
)
ORDER BY sch.name;

/* Also include dbo separately so Pod C can see if any user tables are under it: */
SELECT
    sch.schema_id,
    sch.name                               AS schema_name,
    dp.name                                AS schema_owner,
    '(standard default schema — listed separately)' AS note
FROM [SELCAFE_DB_NAME_PLACEHOLDER].sys.schemas   sch
LEFT JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.database_principals dp
    ON dp.principal_id = sch.principal_id
WHERE sch.name = 'dbo';

PRINT '';


/* ---- B3. TABLE INVENTORY WITH CATALOG-BASED ROW-COUNT ESTIMATE ------------ */
PRINT '>>> B3. TABLE INVENTORY WITH APPROXIMATE ROW COUNT';
PRINT '    Purpose: lists all user tables and their approximate size.';
PRINT '    Row counts come from sys.partitions (SQL Server internal statistics)';
PRINT '    — this is catalog METADATA, not a SELECT against business tables.';
PRINT '    Sort by approx_row_count_catalog DESC to identify high-volume tables.';

SELECT
    sch.name                               AS schema_name,
    t.name                                 AS table_name,
    t.object_id,
    t.create_date,
    t.modify_date,
    SUM(p.rows)                            AS approx_row_count_catalog,
    t.type_desc
FROM [SELCAFE_DB_NAME_PLACEHOLDER].sys.tables       t
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.schemas      sch
    ON sch.schema_id = t.schema_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.partitions   p
    ON p.object_id   = t.object_id
   AND p.index_id   IN (0, 1)   -- 0 = heap (no clustered index), 1 = clustered index
GROUP BY
    sch.name,
    t.name,
    t.object_id,
    t.create_date,
    t.modify_date,
    t.type_desc
ORDER BY
    sch.name,
    t.name;

PRINT '';


/* ---- B4. COLUMN INVENTORY (data types, nullability, ordinal, collation) --- */
PRINT '>>> B4. COLUMN INVENTORY — ALL TABLES';
PRINT '    Purpose: reveals column names, types, nullability, and collation.';
PRINT '    Key flags for SelcafeAdapter design:';
PRINT '      - column_collation: non-Unicode Turkish collation flags encoding risk';
PRINT '      - is_identity: auto-increment PKs affect join strategy';
PRINT '      - DATA_TYPE = uniqueidentifier: GUID PKs align with Adeks UUID pattern';
PRINT '    ⚠ COPY COLUMN NAMES AND TYPES ONLY — do not copy row values.';

SELECT
    inf.TABLE_SCHEMA,
    inf.TABLE_NAME,
    inf.ORDINAL_POSITION,
    inf.COLUMN_NAME,
    inf.DATA_TYPE,
    inf.CHARACTER_MAXIMUM_LENGTH,
    inf.NUMERIC_PRECISION,
    inf.NUMERIC_SCALE,
    inf.DATETIME_PRECISION,
    inf.IS_NULLABLE,
    inf.COLUMN_DEFAULT,
    sc.collation_name                       AS column_collation,
    sc.is_identity,
    sc.is_computed,
    sc.is_rowguidcol
FROM [SELCAFE_DB_NAME_PLACEHOLDER].INFORMATION_SCHEMA.COLUMNS  inf
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].INFORMATION_SCHEMA.TABLES   tbl
    ON  tbl.TABLE_NAME   = inf.TABLE_NAME
    AND tbl.TABLE_SCHEMA = inf.TABLE_SCHEMA
    AND tbl.TABLE_TYPE   = 'BASE TABLE'
-- Join to sys.columns for fields not exposed in INFORMATION_SCHEMA:
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.schemas  sch
    ON  sch.name         = inf.TABLE_SCHEMA
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.tables   st
    ON  st.schema_id     = sch.schema_id
    AND st.name          = inf.TABLE_NAME
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.columns  sc
    ON  sc.object_id     = st.object_id
    AND sc.name          = inf.COLUMN_NAME
ORDER BY
    inf.TABLE_SCHEMA,
    inf.TABLE_NAME,
    inf.ORDINAL_POSITION;

PRINT '';


/* ---- B5. PRIMARY KEY INVENTORY -------------------------------------------- */
PRINT '>>> B5. PRIMARY KEY CONSTRAINTS';
PRINT '    Purpose: identifies PK structure (integer, GUID, composite).';
PRINT '    One row per PK column; composite PKs appear as multiple rows.';

SELECT
    sch.name                               AS schema_name,
    t.name                                 AS table_name,
    kc.name                                AS pk_constraint_name,
    ic.key_ordinal                         AS pk_column_ordinal,
    c.name                                 AS pk_column_name,
    tp.name                                AS pk_column_type,
    sc.is_identity                         AS is_identity_column,
    i.type_desc                            AS index_type
FROM [SELCAFE_DB_NAME_PLACEHOLDER].sys.key_constraints     kc
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.tables              t
    ON  t.object_id       = kc.parent_object_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.schemas             sch
    ON  sch.schema_id     = t.schema_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.indexes             i
    ON  i.object_id       = t.object_id
    AND i.is_primary_key  = 1
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.index_columns       ic
    ON  ic.object_id      = i.object_id
    AND ic.index_id       = i.index_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.columns             c
    ON  c.object_id       = ic.object_id
    AND c.column_id       = ic.column_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.types               tp
    ON  tp.user_type_id   = c.user_type_id
LEFT JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.columns        sc
    ON  sc.object_id      = t.object_id
    AND sc.name           = c.name
WHERE kc.type = 'PK'
ORDER BY
    sch.name,
    t.name,
    ic.key_ordinal;

PRINT '';


/* ---- B6. FOREIGN KEY MAP (referential integrity structure) ----------------- */
PRINT '>>> B6. FOREIGN KEY MAP';
PRINT '    Purpose: reveals entity relationships in the Selcafe schema.';
PRINT '    Used to understand join paths for the read adapter.';
PRINT '    One row per FK column; composite FKs appear as multiple rows.';

SELECT
    fk.name                                AS fk_constraint_name,
    sch_from.name                          AS from_schema,
    pt.name                                AS from_table,
    c_from.name                            AS from_column,
    sch_to.name                            AS to_schema,
    rt.name                                AS to_table,
    c_to.name                              AS to_column,
    fkc.constraint_column_id              AS fk_column_ordinal,
    fk.delete_referential_action_desc      AS on_delete,
    fk.update_referential_action_desc      AS on_update,
    fk.is_not_trusted                      AS is_not_trusted,
    fk.is_disabled                         AS is_disabled
FROM [SELCAFE_DB_NAME_PLACEHOLDER].sys.foreign_keys            fk
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.foreign_key_columns     fkc
    ON  fkc.constraint_object_id = fk.object_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.tables                  pt
    ON  pt.object_id             = fk.parent_object_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.schemas                 sch_from
    ON  sch_from.schema_id       = pt.schema_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.columns                 c_from
    ON  c_from.object_id         = fkc.parent_object_id
    AND c_from.column_id         = fkc.parent_column_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.tables                  rt
    ON  rt.object_id             = fk.referenced_object_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.schemas                 sch_to
    ON  sch_to.schema_id         = rt.schema_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.columns                 c_to
    ON  c_to.object_id           = fkc.referenced_object_id
    AND c_to.column_id           = fkc.referenced_column_id
ORDER BY
    sch_from.name,
    pt.name,
    fk.name,
    fkc.constraint_column_id;

PRINT '';


/* ---- B7. UNIQUE CONSTRAINTS AND UNIQUE INDEXES ---------------------------- */
PRINT '>>> B7. UNIQUE CONSTRAINTS AND UNIQUE INDEXES';
PRINT '    Purpose: identifies natural keys and uniqueness guarantees.';
PRINT '    One row per unique-constraint/unique-index column.';

SELECT
    sch.name                               AS schema_name,
    t.name                                 AS table_name,
    i.name                                 AS index_or_constraint_name,
    i.type_desc                            AS index_type,
    CASE WHEN i.is_unique_constraint = 1
         THEN 'UNIQUE CONSTRAINT'
         ELSE 'UNIQUE INDEX'
    END                                    AS uniqueness_type,
    ic.key_ordinal                         AS column_ordinal_in_key,
    c.name                                 AS column_name,
    tp.name                                AS column_data_type,
    CASE WHEN ic.is_descending_key = 1
         THEN 'DESC' ELSE 'ASC'
    END                                    AS sort_direction,
    i.filter_definition                    AS filter_expression   -- for filtered unique indexes
FROM [SELCAFE_DB_NAME_PLACEHOLDER].sys.indexes           i
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.tables            t
    ON  t.object_id       = i.object_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.schemas           sch
    ON  sch.schema_id     = t.schema_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.index_columns     ic
    ON  ic.object_id      = i.object_id
    AND ic.index_id       = i.index_id
    AND ic.is_included_column = 0          -- key columns only, not INCLUDE columns
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.columns           c
    ON  c.object_id       = ic.object_id
    AND c.column_id       = ic.column_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.types             tp
    ON  tp.user_type_id   = c.user_type_id
WHERE i.is_unique       = 1
  AND i.is_primary_key  = 0
ORDER BY
    sch.name,
    t.name,
    i.name,
    ic.key_ordinal;

PRINT '';


/* ---- B8. FULL INDEX INVENTORY --------------------------------------------- */
PRINT '>>> B8. FULL INDEX INVENTORY (all indexes, key columns only)';
PRINT '    Purpose: reveals query patterns and table access strategies.';
PRINT '    Indexed columns indicate likely query filters in the read adapter.';
PRINT '    One row per index/column combination.';

SELECT
    sch.name                               AS schema_name,
    t.name                                 AS table_name,
    i.index_id,
    i.name                                 AS index_name,
    i.type_desc                            AS index_type,
    i.is_unique,
    i.is_primary_key,
    i.is_unique_constraint,
    i.is_disabled,
    i.has_filter                           AS is_filtered_index,
    i.filter_definition,
    ic.is_included_column,
    ic.key_ordinal,
    c.name                                 AS column_name,
    tp.name                                AS column_data_type,
    CASE WHEN ic.is_descending_key = 1
         THEN 'DESC' ELSE 'ASC'
    END                                    AS sort_direction
FROM [SELCAFE_DB_NAME_PLACEHOLDER].sys.indexes           i
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.tables            t
    ON  t.object_id      = i.object_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.schemas           sch
    ON  sch.schema_id    = t.schema_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.index_columns     ic
    ON  ic.object_id     = i.object_id
    AND ic.index_id      = i.index_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.columns           c
    ON  c.object_id      = ic.object_id
    AND c.column_id      = ic.column_id
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.types             tp
    ON  tp.user_type_id  = c.user_type_id
ORDER BY
    sch.name,
    t.name,
    i.index_id,
    ic.is_included_column,
    ic.key_ordinal;

PRINT '';


/* ---- B9. NULLABLE / UNICODE COLUMN SUMMARY PER TABLE ---------------------- */
PRINT '>>> B9. DATA QUALITY INDICATOR: NULLABLE AND ENCODING SUMMARY PER TABLE';
PRINT '    Purpose: identifies tables with high nullable ratios (data quality risk)';
PRINT '    and tables using non-Unicode character columns (Turkish encoding risk).';
PRINT '    This is a catalog-level summary — no row data is accessed.';

SELECT
    inf.TABLE_SCHEMA,
    inf.TABLE_NAME,
    COUNT(*)                                                    AS total_columns,
    SUM(CASE WHEN inf.IS_NULLABLE = 'YES' THEN 1 ELSE 0 END)  AS nullable_columns,
    SUM(CASE WHEN inf.IS_NULLABLE = 'NO'  THEN 1 ELSE 0 END)  AS not_null_columns,
    /* Unicode (nvarchar, nchar, ntext) — safe for Turkish characters */
    SUM(CASE WHEN inf.DATA_TYPE IN ('nvarchar','nchar','ntext')
             THEN 1 ELSE 0 END)                                AS unicode_columns,
    /* Non-Unicode (varchar, char, text) — Turkish char risk if not Turkish collation */
    SUM(CASE WHEN inf.DATA_TYPE IN ('varchar','char','text')
             THEN 1 ELSE 0 END)                                AS non_unicode_columns,
    /* Date/time columns — relevant for session/booking timestamp handling */
    SUM(CASE WHEN inf.DATA_TYPE IN ('datetime','datetime2','date',
                                    'time','datetimeoffset','smalldatetime')
             THEN 1 ELSE 0 END)                                AS datetime_columns,
    /* Numeric/monetary — relevant to value/balance surface assessment */
    SUM(CASE WHEN inf.DATA_TYPE IN ('decimal','numeric','money',
                                    'smallmoney','float','real')
             THEN 1 ELSE 0 END)                                AS numeric_columns,
    /* Binary/BLOB — indicates image, file, or opaque payload columns */
    SUM(CASE WHEN inf.DATA_TYPE IN ('binary','varbinary','image')
             THEN 1 ELSE 0 END)                                AS binary_columns
FROM [SELCAFE_DB_NAME_PLACEHOLDER].INFORMATION_SCHEMA.COLUMNS   inf
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].INFORMATION_SCHEMA.TABLES    tbl
    ON  tbl.TABLE_NAME   = inf.TABLE_NAME
    AND tbl.TABLE_SCHEMA = inf.TABLE_SCHEMA
    AND tbl.TABLE_TYPE   = 'BASE TABLE'
GROUP BY
    inf.TABLE_SCHEMA,
    inf.TABLE_NAME
ORDER BY
    inf.TABLE_SCHEMA,
    inf.TABLE_NAME;

PRINT '';


/* ---- B10. VIEW INVENTORY (read-only views relevant to adapter) ------------ */
PRINT '>>> B10. VIEW INVENTORY';
PRINT '    Purpose: identifies any pre-built views in Selcafe that may expose';
PRINT '    computed or joined data useful to the read adapter.';
PRINT '    Pod B assesses whether adapter should read from base tables or views.';

SELECT
    vw.TABLE_SCHEMA,
    vw.TABLE_NAME                          AS view_name,
    st.create_date,
    st.modify_date
FROM [SELCAFE_DB_NAME_PLACEHOLDER].INFORMATION_SCHEMA.TABLES    vw
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.schemas                  sch
    ON  sch.name     = vw.TABLE_SCHEMA
JOIN [SELCAFE_DB_NAME_PLACEHOLDER].sys.views                    st
    ON  st.schema_id = sch.schema_id
    AND st.name      = vw.TABLE_NAME
WHERE vw.TABLE_TYPE = 'VIEW'
ORDER BY vw.TABLE_SCHEMA, vw.TABLE_NAME;

PRINT '';


/* ---- B11. STORED PROCEDURE AND FUNCTION INVENTORY (names only) ------------ */
PRINT '>>> B11. STORED PROCEDURE AND FUNCTION NAMES (metadata only)';
PRINT '    Purpose: reveals whether Selcafe uses stored procedures for business';
PRINT '    logic that the read adapter should be aware of.';
PRINT '    Names only — no procedure text is read.';

SELECT
    SCHEMA_NAME(obj.schema_id)            AS schema_name,
    obj.name                              AS object_name,
    obj.type_desc                         AS object_type,
    obj.create_date,
    obj.modify_date
FROM [SELCAFE_DB_NAME_PLACEHOLDER].sys.objects   obj
WHERE obj.type IN ('P', 'FN', 'IF', 'TF', 'TR')
  -- P=stored procedure, FN=scalar fn, IF=inline table fn, TF=table fn, TR=trigger
ORDER BY
    obj.type_desc,
    schema_name,
    obj.name;

PRINT '';


/* ---- B12. PERMISSION CHECK — CURRENT USER IN TARGET DATABASE ------------- */
PRINT '>>> B12. DATABASE ROLE MEMBERSHIP OF CURRENT LOGIN IN TARGET DATABASE';
PRINT '    Purpose: confirms read-only posture within the Selcafe database.';
PRINT '    Expected: db_datareader (or equivalent); NOT db_datawriter,';
PRINT '    db_ddladmin, db_owner, or db_securityadmin.';

SELECT
    dp.name                               AS database_role,
    IS_ROLEMEMBER(dp.name)                AS is_member
    -- IS_ROLEMEMBER checks membership within current connection DB context.
    -- If connected to master/other DB when running with 3-part names,
    -- this reflects the context DB, not the target DB.
    -- For accurate results, run this section while directly connected
    -- to [SELCAFE_DB_NAME_PLACEHOLDER].
FROM [SELCAFE_DB_NAME_PLACEHOLDER].sys.database_principals   dp
WHERE dp.type = 'R'
  AND dp.is_fixed_role = 1
ORDER BY dp.name;

PRINT '';
PRINT '    ⚠ NOTE ON B12: IS_ROLEMEMBER() checks the current connection context.';
PRINT '    For a definitive check, connect directly to [SELCAFE_DB_NAME_PLACEHOLDER]';
PRINT '    and run: SELECT IS_MEMBER(''db_owner''), IS_MEMBER(''db_datawriter''),';
PRINT '                    IS_MEMBER(''db_datareader'');';
PRINT '    Both must be 0 except db_datareader (or a custom read-only role).';

PRINT '';
PRINT '================================================================================';
PRINT 'PART B COMPLETE.';
PRINT '';
PRINT 'Transfer output to /docs/SELCAFE_SPIKE_REPORT.md.';
PRINT 'COLUMN NAMES AND TYPES ONLY — do NOT include row-level data values.';
PRINT 'Route the completed report to Kerem and Pod B for feasibility review.';
PRINT '================================================================================';

/*
================================================================================
  END OF SCRIPT
  
  This script queries SQL Server system catalogs and INFORMATION_SCHEMA views only.
  It does not read business data, customer records, session data, order data,
  payment data, or any row-level values from Selcafe business tables.
  
  Produced by Pod B — Architecture, Logic & Risk (Adeks Platform)
  K-10 / M3 / ROADMAP Seq 14
  HEAD SHA at production: d76eede939514cf1051e1521415c0754a749a05e
================================================================================
*/
