-- https://docs.aws.amazon.com/dms/latest/userguide/CHAP_SupportScripts.PostgreSQL.html
---- https://d2pwp9zz55emqw.cloudfront.net/scripts/awsdms_support_collector_postgres.sql

-- Usage:
-- psql -h psql -h <host_name> -p <port> -U <user_name> -d <database> -f awsdms_support_collector_postgres.sql
--

\set VERBOSITY terse
\pset footer off

\qecho  '_______________________________________________________________'
\qecho AWS DMS Support Collector for Postgres
\qecho
\qecho Version 1.0
\qecho
\qecho
\qecho This script will collect information on your database to help troubleshoot issues you are having with the DMS service.
\qecho
\qecho Before running the script, you should read and understand the sql which will be executed from both a performance and security perspective.
\qecho
\qecho If you are not comfortable executing or sharing the data from any of the sql, you may comment/remove that SQL.
\qecho
\qecho Once the script is complete, it will display the html output file name.
\qecho Please review the information which you are sending to aws and if comfortable, upload it using the instructions found on the following link...
\qecho https://docs.aws.amazon.com/dms/latest/userguide/CHAP_SupportScripts.html
\qecho
\qecho
\qecho
\qecho

\prompt 'Please enter the Schema name to Migrate/Replicate : ' v_owner
\prompt 'Please enter the Postgres username that DMS will use to connect to your database : ' v_connector
\qecho 
\qecho ----------------------------------------------------------------------------------------------------------
\qecho Note: PSQL client version 10 or above is needed to run this script. 
\qecho Using PSQL client 9.x or below will cause errors such as "invalid command \if".
\qecho ----------------------------------------------------------------------------------------------------------
\qecho 
\o /dev/null
select regexp_replace(current_setting('server_version')::text,'\..*','') as db_major_version
from pg_settings where name = 'server_version';
\gset

select (:'db_major_version')::integer as db_major_version;
\gset

select (9 = :'db_major_version') as is_eq_9; \gset

select (10 <= :'db_major_version') as is_ge_10; \gset

select :'HOST' ~ '.\.rds\.amazonaws\.com$' as is_rds; \gset

select :'HOST' !~ '.\.rds\.amazonaws\.com$' as is_non_rds;
\gset


\if :is_eq_9
  select pg_current_xlog_location(); \gset
\elif :is_ge_10
  select pg_current_wal_lsn(); \gset
\endif

\o dms_support_script_postgres.html


--
-- This Section contains the table of contents.
--
--

\qecho <head>
\qecho <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
\qecho <meta name="generator" content="PSQL">
\qecho <style type='text/css'> body {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} p {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} table,tr,td {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#F2F3F4; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;} th {font:bold 10pt Arial,Helvetica,sans-serif; color:#425b5e; background:#ffc100; padding:0px 0px 0px 0px;} h1 {font:16pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; border-bottom:1px solid #ffc100; margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;-
\qecho } h2 {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#425b5e; background-color:White; margin-top:4pt; margin-bottom:0pt;} a {font:10pt Arial,Helvetica,sans-serif; color:#663300; background:#ffffff; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} .anchor {position: relative; top: -50px;} .table-content a{font-size:9pt}</style><title>AWS DMS PostgreSQL Support Bundle</title>
\qecho </head>

\qecho <h1 style="font-family:verdana"align="center"><u>DMS PostgreSQL Support Bundle</u></h1>
\qecho <div class="table-content">
\qecho <p style="font-family:verdana"><strong>Contents</strong></p>
\qecho <ol>
\qecho <li><a href="#Overview">Overview</a>
\qecho </li>
\qecho <li><a href="#DatabaseConfiguration">Database Configuration</a>
\qecho <ol>
\qecho <li><a href="#DatabaseConfiguration1">Database Name and Locale</a></li>
\qecho <li><a href="#DatabaseConfiguration2">Database Version</a></li>
\qecho <li><a href="#DatabaseConfiguration3">Operating System version</a></li>
\qecho <li><a href="#DatabaseConfiguration4">Database Host</a></li>
\qecho <li><a href="#DatabaseConfiguration5">RDS / Non-RDS</a></li>
\qecho <li><a href="#DatabaseConfiguration6">Database Parameter Prerequisites</a></li>
\qecho <li><a href="#DatabaseConfiguration7">Replication Slot Details</a></li>
\qecho <li><a href="#DatabaseConfiguration8">Is High Availability set</a></li>
\qecho <li><a href="#DatabaseConfiguration9">Extension Check</a></li>
\qecho </ol>
\qecho </li>

\qecho <li><a href="#SizeDetails">Size Details</a>
\qecho <ol>
\qecho <li><a href="#SizeDetails1">Database size</a></li>
\qecho <li><a href="#SizeDetails2">Schema Size</a></li>
\qecho <li><a href="#SizeDetails3">Total size of migration schema tables</a></li>
\qecho <li><a href="#SizeDetails5">Top objects by size</a></li>
\qecho </ol>
\qecho </li>

\qecho <li><a href="#DatabaseLoad">Database Load</a>
\qecho <ol>
\qecho <li><a href="#DatabaseLoad1">Rate of WAL generation</a></li>
\qecho <li><a href="#DatabaseLoad2">CDC specific Load summary table</a></li>
\qecho </ol>
\qecho </li>

\qecho <li><a href="#Table Load">Table Load</a>
\qecho <ol>
\qecho <li><a href="#TableLoad1">Top Objects by DML Changes</a></li>
\qecho <li><a href="#TableLoad2">Top 25 tables by inserts </a></li>
\qecho <li><a href="#TableLoad3">Top 25 tables by updates </a></li>
\qecho <li><a href="#TableLoad4">Top 25 tables by deletes </a></li>
\qecho </ol>
\qecho </li>

\qecho <li><a href="#TableDetails">Table Details</a>
\qecho <ol>
\qecho <li><a href="#TableDetails1">Existing Materialized Views</a></li>
\qecho <li><a href="#TableDetails2">Object Type count</a></li>
\qecho <li><a href="#TableDetails3">Data Type count</a></li>
\qecho <li><a href="#TableDetails4">Replica Identity details</a></li>
\qecho <li><a href="#TableDetails5">DMS Artifacts</a></li>
\qecho </ol>
\qecho </li>

\qecho <li><a href="#ArchivalInformation">Archival Information</a>
\qecho <ol>
\qecho <li><a href="#ArchivalInformation1">Archive mode and other details</a></li>
\qecho </ol>
\qecho </li>



\qecho <li><a href="#Permissions">Permissions</a>
\qecho <ol>
\qecho <li><a href="#Permissions1">System privileges</a></li>
\qecho <li><a href="#Permissions2">Table Grants</a></li>
\qecho </ol>
\qecho </li>


\qecho <li><a href="#PotentialIssues">Potential Issues</a>
\qecho <ol>
\qecho <li><a href="#PotentialIssues1">Unsupported DataTypes</a></li>
\qecho <li><a href="#PotentialIssues2">Tables with No PK</a></li>
\qecho <li><a href="#PotentialIssues3">TEXT and JSONB columns with NOT NULL set</a></li>
\qecho <li><a href="#PotentialIssues4">Long running sql (more than 10 minutes)</a></li>
\qecho <li><a href="#PotentialIssues5">Tables with triggers</a></li>
\qecho <li><a href="#PotentialIssues6">Database Views</a></li>
\qecho </ol>
\qecho <li><a href="#EndOfReport">End of the report</a></li>
\qecho </li>


\qecho </div>


-- 
-- This Section contains the actual sql to extract the information.
-- 
-- Please review and feel free to comment out anything you are not comfortable sharing, or running against your database.
--



\qecho <title>AWS DMS Support bundle script for Postgres</title>

-- New Major heading :
\qecho <hr>
\qecho <p id="Overview" class="anchor"></p>
\qecho <h2 style="font-family:verdana">Overview</h2>


\qecho <h5 style="font-family:verdana;list-style-type:none">
\qecho   <li>This is the output from the DMS Support script for PostgreSQL.</li>
\qecho   <li>Please upload to AWS Support via a Customer Support Case.</li>
\qecho </h5>
\qecho <br>

\t
select 'Current Database Time : <b>' || date_trunc('second', clock_timestamp()::timestamp) || '</b>';
\qecho <br>
SELECT 'Database Startup Time : <b>' || date_trunc('second', pg_postmaster_start_time()::timestamp) || '</b>';
\qecho <br>
SELECT 'Total Active Sessions : <b>' || count(*) || '</b>' from pg_stat_activity where state ='active' ;
\qecho <br>
SELECT 'Total Number of  Sessions : <b>' || count(*) || '</b>' from pg_stat_activity;
\qecho <br>
\qecho Schema name being Migrated/Replicated :<b> :v_owner</b>
\qecho <br>
\qecho PostgreSQL User Name which DMS will use to connect :<b> :v_connector</b>
\qecho <br>
\qecho <br>
\qecho <br>
\qecho <br>
\t
          
\pset format html
                 
-- New Major heading :
\qecho <hr>
\qecho <p id="DatabaseConfiguration" class="anchor"></p>
\qecho <h2 style="font-family:verdana">Database Configuration</h2>

-- New Minor heading and block :

\qecho <p id="DatabaseConfiguration1" class="anchor"></p>
\qecho <h2>Database Name and Locale:</h2>
\qecho  <li><a href="#Top">previous : </a><a href="#Top">top : </a><a href="#DatabaseConfiguration2">next</a></li>
\qecho <br>

-- START SQL
with db_role as
    (
 select case pg_is_in_recovery()
 when true then 'Slave'
 else 'Master' end as database_role
    ),
tz as
    (
 SELECT current_setting('TIMEZONE') as timezone
    ),
enc as 
    (
	SELECT pg_encoding_to_char(encoding) as encoding
		FROM pg_database 
	WHERE datname = current_database()
    ), 
db_details as
    (
 select datname as name,
     age(datfrozenxid) max_frozen_txn,
     encoding as character_set,
     datctype as locale
 from pg_database
 where datname = current_database()
    )
select name, encoding, locale, timezone, database_role, max_frozen_txn as "Maximum Used Transaction IDs" 
from db_role, tz, enc, db_details;
-- END SQL
  
\qecho <br>
\qecho <br>


-- New Minor heading and block :
\qecho <p id="DatabaseConfiguration2" class="anchor"></p>
\qecho <h2>Database Version :</h2>
\qecho <li><a href="#DatabaseConfiguration1">previous : </a><a href="#Top">top : </a><a href="#DatabaseConfiguration3">next</a></li>
\qecho <br>

\qecho Please check the following documentation for supported database versions. <br>
\qecho <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html">PostgreSQL Source</a><br>
\qecho <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.PostgreSQL.html">PostgreSQL Target</a><br>
\qecho <br>
\qecho <b>Note: </b><br>
\qecho <ul>
\qecho <li>For PostgreSQL 10.x, if you use a AWS DMS version earlier than 3.3.1, prepare the PostgreSQL source using <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html#CHAP_Source.PostgreSQL.v10">the wrapper functions</a>.</li>
\qecho <li>For PostgreSQL 11.x, Use AWS DMS version 3.3.1 or higher.</li>
\qecho <li>For PostgreSQL 12.x, Use AWS DMS version 3.3.3 or higher.</li>
\qecho </ul>
\qecho <br>
  
-- START SQL
select substring(version()::text from '(^.*) on') as "PostgreSQL Version";
-- END SQL
  
\qecho <br>
\qecho <br>


-- Operating System version
\qecho <p id="DatabaseConfiguration3" class="anchor"></p>
\qecho <h2>Operating System version</h2>
\qecho <li><a href="#DatabaseConfiguration2">previous : </a><a href="#Top">top : </a><a href="#DatabaseConfiguration4">next</a></li>
\qecho <br>

-- START SQL
select substring(version()::text from '(?<=on ).*') as "Operating System";
-- END SQL
  
\qecho <br>
\qecho <br>

-- Database Host
\qecho <p id="DatabaseConfiguration4" class="anchor"></p>
\qecho <h2>Database Host :</h2>
\qecho <li><a href="#DatabaseConfiguration3">previous : </a><a href="#Top">top : </a><a href="#DatabaseConfiguration5">next</a></li>
\qecho <br>

-- START SQL
select :'HOST' as "Database host";
-- END SQL
  
\qecho <br>
\qecho <br>

-- RDS / Non RDS : :
\qecho <p id="DatabaseConfiguration5" class="anchor"></p>
\qecho <h2>RDS / Non RDS :</h2>
\qecho <li><a href="#DatabaseConfiguration4">previous : </a><a href="#Top">top : </a><a href="#DatabaseConfiguration6">next</a></li>
\qecho <br>

-- START SQL
\if :is_rds
	\qecho Database Type: <b>RDS</b>
\else
	\qecho Database Type: <b>NON-RDS</b>
\endif
-- END SQL
  
\qecho <br>
\qecho <br>

-- Database Parameter Prerequisites
\qecho <p id="DatabaseConfiguration6" class="anchor"></p>
\qecho <h2>Database Parameter Prerequisites :</h2>
\qecho <li><a href="#DatabaseConfiguration5">previous : </a><a href="#Top">top : </a><a href="#DatabaseConfiguration7">next</a></li>
\qecho <br>
  
-- START SQL
select name as "Database Parameter", 
       setting as "Current Value",
	   CASE name
		   WHEN 'wal_level' THEN 'logical'
		   WHEN 'max_wal_senders' THEN '>1'
		   WHEN 'max_replication_slots' THEN '>1'
		   WHEN 'idle_in_transaction_session_timeout' THEN '0'
		   WHEN 'wal_sender_timeout' THEN '0'
	   END as "Required Value"	
	from pg_settings
	where name in ('wal_level',
		       'max_replication_slots',
		       'max_wal_senders',
               'wal_sender_timeout',
               'idle_in_transaction_session_timeout',
	       'shared_preload_libraries')
order by 1;
\qecho <br>
\qecho <br>
\if :is_rds
  \qecho <b>Note:</b> If the source is RDS or Aurora PostgreSQL, please set rds.logical_replication to 1. As part of applying this parameter, AWS DMS sets parameters wal_level, max_wal_senders, max_replication_slots above.<br>
  \qecho <a href="https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraPostgreSQL.Replication.Logical.html#AuroraPostgreSQL.Replication.Logical.Configure">Using PostgreSQL Logical Replication with Aurora</a><br>
  \qecho <a href="https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts.General.FeatureSupport.LogicalReplication">Logical Replication for PostgreSQL on Amazon RDS</a><br>
  \qecho <br>
	show rds.logical_replication;
\else
	\qecho <b>Note:</b> Please ensure the above parameter prerequisites for using a PostgreSQL database as a source.
\endif
-- END SQL
  
\qecho <br>
\qecho <br>

-- Replication Slot Details
\qecho <p id="DatabaseConfiguration7" class="anchor"></p>
\qecho <h2>Replication Slot Details :</h2>
\qecho <li><a href="#DatabaseConfiguration6">previous : </a><a href="#Top">top : </a><a href="#DatabaseConfiguration8">next</a></li>
\qecho <br>
\qecho <b>Replication Slot</b> (Ignore if no rows returned)<br>
\qecho <br>
\qecho <b>Note:</b> <br>
\qecho <ul>
\qecho <li>Cross check the count of replication slots against max_replication_slots found above. Also useful to find if physical/logical is already configured. Ignore if no rows returned.</li>
\qecho <li>DMS uses PostgreSQL plugin "test_decoding" or "pglogical" for replicating on-going changes (CDC). Need to set shared_preload_libraries to pglogical to create extension pglogical for CDC <a href="#DatabaseConfiguration9">if extension pglogical is available</a>. </li>
\qecho </ul>
-- START SQL
select 
	regexp_replace(slot_name::text,'(?<=^.{26}).*' ,repeat('X',45)) as slot_name_obfuscated        
	, plugin             
	, slot_type          
	, datoid             
	, database    
\if :is_ge_10
	, temporary          
\endif       
	, active             
	, active_pid         
	, xmin               
	, catalog_xmin       
	, restart_lsn        
	, confirmed_flush_lsn
from pg_replication_slots;
\qecho <br>
\qecho <b>Replication Slot Size</b> (Ignore if no rows returned)<br>
\qecho <br>
\qecho <b>Note:</b> <br>
\qecho <ul>
\qecho <li>If the size of the replication slot becomes an issue to the source database storage when the replication task is stopped or no longer needed, consider dropping the associated slot to release the storage (e.g.  <span style="font-style: italic;font-family:Consolas,Monaco;background:#F5F5F5">SELECT pg_drop_replication_slot(slot_name);</span> ). Please note that once the replication slot is dropped, the task will not be able to resume.</li>
\qecho <li>If the column restart_lsn is not seen progressing over time and causes the replication slot size of your RDS postgresql source to grow: <br>
\qecho <ul>
\qecho <li>If the source PostgreSQL does not have sufficient workload to advances restart_lsn, please use the following extra connection attributes in the source PostgreSQL endpoint: <br><span style="font-style: italic;font-family:Consolas,Monaco;background:#F5F5F5">heartbeatEnable=Y;heatbeatFrequency=1</span><br><b>heartbeatEnable:</b> DMS task will create a dummy table "awsdms_heartbeat" in public schema to advance restart_lsn to mitigate the storage issue. <br> <b>heatbeatFrequency:</b> The frequency to advance restart_lsn. Default is 5 minutes.</li>
\qecho <li>The address (LSN) of oldest WAL which still might be required by the consumer of this slot and thus will not be automatically removed during checkpoints. Cross check <a href="#PotentialIssues4">long transactions</a> from <a href="https://www.postgresql.org/docs/11/monitoring-stats.html#PG-STAT-ACTIVITY-VIEW">pg_stat_activity</a> (including the ones in idle state) / <a href="https://www.postgresql.org/docs/11/view-pg-prepared-xacts.html">pg_prepared_xacts</a>, catalog_xmin in <a href="https://www.postgresql.org/docs/11/view-pg-replication-slots.html">pg_replication_slots</a>, and the relevant transactions in PostgreSQL error log; Check if any other consumers use the same replication slot. </li>
\qecho </ul>
\qecho </li>
\qecho </ul>
\if :is_eq_9
  select regexp_replace(slot_name::text,'(?<=^.{26}).*' ,repeat('X',45)) as slot_name_obfuscated, 
	  pg_size_pretty(pg_xlog_location_diff(pg_current_xlog_location(), restart_lsn)) as replicationSlotLag, 
	  active 
  from pg_replication_slots ;
\elif :is_ge_10
  select regexp_replace(slot_name::text,'(?<=^.{26}).*' ,repeat('X',45)) as slot_name_obfuscated, 
	  pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) as replicationSlotLag, 
	  active 
  from pg_replication_slots;
\endif
-- END SQL
\qecho <br>
\qecho <br>

-- Is High Availability set
\qecho <p id="DatabaseConfiguration8" class="anchor"></p>
\qecho <h2>Is High Availability set :</h2>
\qecho <li><a href="#DatabaseConfiguration7">previous : </a><a href="#Top">top : </a><a href="#DatabaseConfiguration9">next</a></li>
\qecho <br>
\qecho <b>Note: </b><br>
\qecho <ul>
\qecho <li>Listing below information from view <a href="https://www.postgresql.org/docs/11/monitoring-stats.html#PG-STAT-REPLICATION-VIEW">pg_stat_replication</a> view for high availability information. One row per WAL sender process, showing statistics about replication to the connected standby server of the sender.</a>.</li>
\qecho <li>The output below only displays data related to the account provided while running this script. Information related to other users and applications is obfuscated.</li>
\qecho </ul>
\qecho <br>

-- START SQL
select case when usename = :'v_connector' then usename else 'other user' end as "User name"
, case when usename = :'v_connector' then application_name else 'other application' end as "Application name"
, client_hostname, backend_start, backend_xmin, state -- ,  sent_lsn, write_lag, flush_lag
from pg_stat_replication;
-- END SQL

\qecho <br>

-- If it is read replica :
\qecho <b>If the <a href="#DatabaseConfiguration4">current PostgreSQL database</a> is a master or replica:</b>
\qecho <br>
\qecho <br>
\qecho <b>Note:</b> You cannot use Amazon RDS PostgreSQL Read Replicas for CDC ongoing replication. Refer to <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html#CHAP_Source.PostgreSQL.RDSPostgreSQL">setting up an Amazon RDS PostgreSQL DB instance as a source</a>. <br>
\qecho <br>
-- START SQL
select case when pg_is_in_recovery='t' then 'Replica' else 'Master' end as "Master/Replica" from pg_is_in_recovery();
-- END SQL

\qecho <br>
\qecho <br>


-- >Extension Check:
\qecho <p id="DatabaseConfiguration9" class="anchor"></p>
\qecho <h2>Extension Check :</h2>
\qecho <li><a href="#DatabaseConfiguration8">previous : </a><a href="#Top">top : </a><a href="#SizeDetails">next</a></li>
\qecho <br>
-- PostgreSQL extension supported by DMS for CDC
-- START SQL
select * from pg_Available_Extensions where name like 'pglogical';
-- END SQL
  
\qecho <br>
\qecho <br>

------------------------------------------------------------------------------------------------------------------------------------------

-- New Major heading :
\qecho <hr>
\qecho <p id="SizeDetails" class="anchor"></p>
\qecho <h2 style="font-family:verdana">Size Details</h2>


-- New Minor heading and block :
\qecho <p id="SizeDetails1" class="anchor"></p>
\qecho <h2>Database size :</h2>
\qecho <li><a href="#DatabaseConfiguration9">previous : </a><a href="#Top">top : </a><a href="#SizeDetails2">next</a></li>
\qecho <br>

-- START SQL
select pg_size_pretty(pg_database_size(current_database())) as "Database Size";
-- END SQL
  
\qecho <br>
\qecho <br>


-- New Minor heading and block :
\qecho <p id="SizeDetails2" class="anchor"></p>
\qecho <h2>Schema Sizes :</h2>
\qecho <li><a href="#SizeDetails1">previous : </a><a href="#Top">top : </a><a href="#SizeDetails3">next</a></li>
\qecho <br>
\qecho <b>Note:</b> This section gives approximate total size of tables in the schema being migrated and compares it to rest of the database.
\qecho <br>
\qecho <br>

  
-- START SQL
SELECT schema_name as "Schema Name",
       pg_size_pretty(sum(table_size)::bigint) as "Total table Size",
       trunc((sum(table_size) / pg_database_size(current_database()) * 100),2) as "Percentage Size"
FROM (

  SELECT case when pg_catalog.pg_namespace.nspname = :'v_owner' then pg_catalog.pg_namespace.nspname else 'other schemas' end as schema_name,
         pg_relation_size(pg_catalog.pg_class.oid) as table_size
  FROM   pg_catalog.pg_class
     JOIN pg_catalog.pg_namespace ON relnamespace = pg_catalog.pg_namespace.oid
) t
GROUP BY schema_name
ORDER BY schema_name;
-- END SQL
  
\qecho <br>
\qecho <br>


-- New Minor heading and block :
\qecho <p id="SizeDetails3" class="anchor"></p>
\qecho <h2>Total size of migration schema tables :</h2>
\qecho <li><a href="#SizeDetails2">previous : </a><a href="#Top">top : </a><a href="#SizeDetails4">next</a></li>
\qecho <br>

-- START SQL
WITH RECURSIVE pg_inherit(inhrelid, inhparent) AS
    (select inhrelid, inhparent
    FROM pg_inherits
    UNION
    SELECT child.inhrelid, parent.inhparent
    FROM pg_inherit child, pg_inherits parent
    WHERE child.inhparent = parent.inhrelid),
pg_inherit_short AS (SELECT * FROM pg_inherit WHERE inhparent NOT IN (SELECT inhrelid FROM pg_inherit)),
all_tables as (
	SELECT pg_class.oid
		, reltuples
		, relname
		, relnamespace
		, pg_class.reltoastrelid
		, COALESCE(inhparent, pg_class.oid) parent
        , CASE WHEN pg_class.oid = (COALESCE(inhparent, pg_class.oid)) THEN 'parent' ELSE 'child' END as "parent_or_child"
	FROM pg_class
		LEFT JOIN pg_inherit_short ON inhrelid = oid
		LEFT JOIN pg_namespace n ON n.oid = relnamespace
	WHERE relkind IN ('r', 'p') and n.nspname = :'v_owner'
    )
select pg_size_pretty(sum(pg_total_relation_size(oid))) as "Size", 
	case when parent_or_child = 'parent' then 'non-partitioned tables' else 'partitioned tables' end as "Table Type"
from all_tables 
group by parent_or_child;
-- END SQL
  
\qecho <br>
\qecho <br>


-- New Minor heading and block :
\qecho <p id="SizeDetails4" class="anchor"></p>
\qecho <h2>Top objects by size :</h2>
\qecho <li><a href="#SizeDetails3">previous : </a><a href="#Top">top : </a><a href="#DatabaseLoad1">next</a></li>
\qecho <br>

-- START SQL
WITH RECURSIVE pg_inherit(inhrelid, inhparent) AS
    (select inhrelid, inhparent
    FROM pg_inherits
    UNION
    SELECT child.inhrelid, parent.inhparent
    FROM pg_inherit child, pg_inherits parent
    WHERE child.inhparent = parent.inhrelid),
pg_partitions AS (SELECT * FROM pg_inherit WHERE inhparent NOT IN (SELECT inhrelid FROM pg_inherit))
SELECT table_schema
    , TABLE_NAME
    , row_estimate
    , pg_size_pretty(total_bytes) AS total
    , pg_size_pretty(index_bytes) AS INDEX
    , pg_size_pretty(toast_bytes) AS toast
    , pg_size_pretty(table_bytes) AS TABLE
  FROM (
    SELECT *, total_bytes-index_bytes-COALESCE(toast_bytes,0) AS table_bytes
    FROM (
         SELECT c.oid
              , nspname AS table_schema
              , relname AS TABLE_NAME
              , SUM(c.reltuples) OVER (partition BY parent) AS row_estimate
              , SUM(pg_total_relation_size(c.oid)) OVER (partition BY parent) AS total_bytes
              , SUM(pg_indexes_size(c.oid)) OVER (partition BY parent) AS index_bytes
              , SUM(pg_total_relation_size(reltoastrelid)) OVER (partition BY parent) AS toast_bytes
              , parent
          FROM (
                SELECT pg_class.oid
                    , reltuples
                    , relname
                    , relnamespace
                    , pg_class.reltoastrelid
                    , COALESCE(inhparent, pg_class.oid) parent
                FROM pg_class
                    LEFT JOIN pg_partitions ON inhrelid = oid
                WHERE relkind IN ('r', 'p')
             ) c
             LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
  ) a
  WHERE oid = parent and table_schema = :'v_owner'
) a
ORDER BY total_bytes DESC;
-- END SQL
  
\qecho <br>
\qecho <br>


-- Database Load
\qecho <hr>
\qecho <p id="DatabaseLoad" class="anchor"></p>
\qecho <h2 style="font-family:verdana">Database Load</h2>


-- Rate of WAL generation
\qecho <p id="DatabaseLoad1" class="anchor"></p>
\qecho <h2>Rate of WAL generation:</h2>
\qecho <li><a href="#SizeDetails4">previous : </a><a href="#Top">top : </a><a href="#DatabaseLoad2">next</a></li>
\qecho <br>
\qecho <b>Note:</b> In this section, we find the volume of WAL generated in last 10 minutes. Though this may not paint complete picture considering that 
\qecho several factors can impact WAL generation, we are just getting a rough idea. This information may be useful to troubleshoot replication latency issues.
\qecho <br>
\qecho <ul>
\qecho <li>This check is supported for PostgreSQL versions 10.x and above. For PostgreSQL versions 9.x and below please work with AWS Support to find WAL size if needed. </li>
\qecho <li>For RDS or Aurora PostgreSQL check CloudWatch metric <a href="https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MonitoringOverview.html#metrics_dimensions">TransactionLogsGeneration</a> (The size of transaction logs generated per second. Units: Bytes/Second) to understand the source workloads.</li>
\qecho </ul>
\qecho <br>
  
-- START SQL
\if :is_eq_9
        select 'For PostgreSQL versions 9.x and below, please work with AWS support to find WAL size' as WAL_size;
\endif

\if :is_ge_10
  select pg_size_pretty(sum(size)) as "Volume of WAL generated in last 10 minutes"
	from pg_ls_waldir() where modification > (now() - interval '10 minutes') ;
\endif

-- END SQL
  
\qecho <br>
\qecho <br>

\qecho <p id="DatabaseLoad2" class="anchor"></p>
\qecho <h2>CDC specific Load summary table :</h2>
\qecho <li><a href="#DatabaseLoad1">previous : </a><a href="#Top">top : </a><a href="#TableLoad1">next</a></li>
\qecho <br>
\qecho Taking a snapshot of database view PG_STAT_DATABASE because of the important database statistics in it.
\qecho <br>  For more information, refer to: 
\qecho <a href="https://www.postgresql.org/docs/11/monitoring-stats.html#PG-STAT-DATABASE-VIEW">PG_STAT_DATABASE view</a><br>
  
-- START SQL
\qecho <br>
\qecho <b>PG_STAT_DATABASE</b>
select * from pg_stat_database
where datname = current_database();
\qecho <br>
\qecho <br>
\qecho Taking a snapshot of database view PG_STAT_BGWRITER to gather information related to database checkpoints. 
\qecho Needed to troubleshoot replication performance issues.
\qecho <br>  For more information, refer to: 
\qecho <a href="https://www.postgresql.org/docs/11/monitoring-stats.html#PG-STAT-BGWRITER-VIEW">PG_STAT_BGWRITER view</a><br>
\qecho <br>
\qecho <b>PG_STAT_BGWRITER</b>
select * from pg_stat_bgwriter ;
-- END SQL
  
\qecho <br>
\qecho <br>

------------------------------------------------------------------------------------------------------------------------------------

-- New Major heading :
\qecho <hr>
\qecho <p id="Table Load" class="anchor"></p>
\qecho <h2 style="font-family:verdana">Table Load</h2>


-- New Minor heading and block :
\qecho <p id="TableLoad1" class="anchor"></p>
\qecho <h2>Top 25 Objects by total DML Changes :</h2>
\qecho <li><a href="#DatabaseLoad5">previous : </a><a href="#Top">top : </a><a href="#TableLoad2">next</a></li>
\qecho <br>
\qecho <b>Note:</b> DMS being a logical replication tool, we find volume of DML activity here. We also need to know if vacuuming is done regularly for performance reasons.<br>
\qecho <br>

  
-- START SQL
select relname as "Table name",
	n_tup_ins as "# Inserts",
	n_tup_upd as "# Updates",
	n_tup_del as "# Deletes",
	n_tup_hot_upd as "# Hot Updates",
	(n_tup_ins + n_tup_upd + n_tup_del) as "Total changes",
	n_live_tup as "# Live tuples = # NUM ROWS",
	n_dead_tup as "# Dead tuples",
	n_mod_since_analyze as "# Changes since last analyze",
	vacuum_count as "# Manual vacuum counts",
	autovacuum_count as "# Auto vacuum counts"
FROM pg_stat_all_tables 
WHERE schemaname = :'v_owner'
order by (n_tup_ins + n_tup_upd + n_tup_del) desc
limit 25;
-- END SQL
  
\qecho <br>
\qecho <br>


-- New Minor heading and block :
\qecho <p id="TableLoad2" class="anchor"></p>
\qecho <h2>Top 25 tables by inserts :</h2>
\qecho <li><a href="#TableLoad1">previous : </a><a href="#Top">top : </a><a href="#TableLoad3">next</a></li>
\qecho <br>

-- START SQL
select relname as "Table name",
    n_tup_ins as "# Inserts"
FROM pg_stat_all_tables 
WHERE schemaname = :'v_owner'
order by n_tup_ins desc
limit 25;
-- END SQL
  
\qecho <br>
\qecho <br>



-- New Minor heading and block :
\qecho <p id="TableLoad3" class="anchor"></p>
\qecho <h2>Top 25 tables by updates :</h2>
\qecho <li><a href="#DatabaseLoad2">previous : </a><a href="#Top">top : </a><a href="#TableLoad4">next</a></li>
\qecho <br>

-- START SQL
select relname as "Table name",
    n_tup_upd as "# Updates"
FROM pg_stat_all_tables 
WHERE schemaname = :'v_owner'
order by n_tup_upd desc
limit 25;
-- END SQL
  
\qecho <br>
\qecho <br>



-- New Minor heading and block :
\qecho <p id="TableLoad4" class="anchor"></p>
\qecho <h2>Top 25 tables by deletes :</h2>
\qecho <li><a href="#TableLoad3">previous : </a><a href="#Top">top : </a><a href="TableDetails1">next</a></li>
\qecho <br>

-- START SQL
select relname as "Table name",
    n_tup_del as "# Deletes"
FROM pg_stat_all_tables 
WHERE schemaname = :'v_owner'
order by n_tup_del desc
limit 25;
-- END SQL
  
\qecho <br>
\qecho <br>

------------------------------------------------------------------------------------------------------------------------------
-- New Major heading :
\qecho <hr>
\qecho <p id="TableDetails" class="anchor"></p>
\qecho <h2 style="font-family:verdana">Table Details</h2>


-- New Minor heading and block :
\qecho <p id="TableDetails1" class="anchor"></p>
\qecho <h2>Existing Materialized Views :</h2>
\qecho <li><a href="#TableLoad4">previous : </a><a href="#Top">top : </a><a href="#TableDetails2">next</a></li>
\qecho <br>

-- START SQL
select schemaname as schema_name
       ,matviewname as view_name
       ,matviewowner as owner
       ,ispopulated as is_populated
from pg_matviews
order by schema_name, view_name;
-- END SQL
  
\qecho <br>
\qecho <br>


-- New Minor heading and block :
\qecho <p id="TableDetails2" class="anchor"></p>
\qecho <h2>Object Type count :</h2>
\qecho <li><a href="#TableDetails1">previous : </a><a href="#Top">top : </a><a href="#TableDetails3">next</a></li>
\qecho <br>

-- START SQL
SELECT
	n.nspname as schema_name
	,CASE c.relkind
	   WHEN 'r' THEN 'table'
	   WHEN 'v' THEN 'view'
	   WHEN 'i' THEN 'index'
	   WHEN 'S' THEN 'sequence'
	   WHEN 'm' THEN 'materialized view'
	   WHEN 's' THEN 'special'
	END as object_type
	,count(1) as object_count
FROM pg_catalog.pg_class c
LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r','v','i','S','m','s')
AND n.nspname = :'v_owner'
GROUP BY  n.nspname,
	CASE c.relkind
	   WHEN 'r' THEN 'table'
	   WHEN 'v' THEN 'view'
	   WHEN 'i' THEN 'index'
	   WHEN 'S' THEN 'sequence'
	   WHEN 'm' THEN 'materialized view'
	   WHEN 's' THEN 'special'
	END
ORDER BY n.nspname,
	CASE c.relkind
	   WHEN 'r' THEN 'table'
	   WHEN 'v' THEN 'view'
	   WHEN 'i' THEN 'index'
	   WHEN 'S' THEN 'sequence'
	   WHEN 'm' THEN 'materialized view'
	   WHEN 's' THEN 'special'
	END;
-- END SQL
  
\qecho <br>
\qecho <br>


-- New Minor heading and block :
\qecho <p id="TableDetails3" class="anchor"></p>
\qecho <h2>Data Type count :</h2>
\qecho <li><a href="#TableDetails2">previous : </a><a href="#Top">top : </a><a href="#TableDetails4">next</a></li>
\qecho <br>

-- START SQL
select table_schema as Schema ,data_type as "Data type", count(*) 
from information_schema.columns where 
table_schema = :'v_owner'
group by table_schema,data_type order by 3 desc;
-- END SQL
  
\qecho <br>
\qecho <br>


-- New Minor heading and block :
\qecho <p id="TableDetails4" class="anchor"></p>
\qecho <h2>Replica Identity details :</h2>
\qecho <li><a href="#TableDetails3">previous : </a><a href="#Top">top : </a><a href="#TableDetails5">next</a></li>
\qecho <br>
\qecho <b>Note:</b> Replica Identity controls the WAL records for a table being modified. Use REPLICATE IDENTITY FULL carefully for each table as FULL generates an extra amount of WAL that may not be necessary. 
\qecho <ul>
\qecho <li>REPLICATE IDENTITY FULL records the old values of all columns in the row. Useful to troubleshoot issues related to missing changes in target.</li>
\qecho <li>Useful to replicate to data-streaming target like AWS Kinesis to reveal the before-image data for the changes made. Check DMS <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.Kinesis.html#CHAP_Target.Kinesis.BeforeImage">BeforeImageSettings</a> for details.</li>
\qecho </ul>
\qecho <br>
  
-- START SQL
SELECT relname AS table_name,
       CASE relreplident
          WHEN 'd' THEN 'default'
          WHEN 'n' THEN 'nothing'
          WHEN 'f' THEN 'full'
          WHEN 'i' THEN 'index'
       END AS replica_identity,
       n.nspname AS "Table schema"
FROM pg_class c JOIN PG_NAMESPACE n ON c.relnamespace = n.oid
WHERE n.nspname = :'v_owner'
    AND relkind in ('r','p')
    AND relreplident <> 'd'
ORDER BY 1;
-- END SQL
  
\qecho <br>
\qecho <br>


-- DMS Artifacts
\qecho <p id="TableDetails5" class="anchor"></p>
\qecho <h2>DMS Artifacts</h2>
\qecho <li><a href="#TableDetails4">previous : </a><a href="#Top">top : </a><a href="#ArchivalInformation1">next</a></li>
\qecho <br>
\qecho <b>Note:</b> DMS creates several objects to capture data definition language (DDL) events, implement <a href="#DatabaseConfiguration7">heartbeat mechanism</a> for advancing restart_lsn, and provide useful migration statistics for migration status. Refer to <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html#CHAP_Source.PostgreSQL.RDSPostgreSQL.NonMasterUser"> DMS artifacts of a PostgreSQL source</a>, <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.ControlTable.html">DMS control table task settings</a>, and <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Validating.html#CHAP_Validating.Troubleshooting">DMS data validation</a> for details.
\qecho <ul>
\qecho <li>DMS control tables and related objects: awsdms_apply_exceptions, awsdms_history_*, awsdms_status_*, awsdms_suspended_tables_*</li>
\qecho <li>DMS validation table: awsdms_validation_failures_v1</li>
\qecho <li>Source PostgreSQL heartbeat table and related objects: awsdms_heartbeat_*</li>
\qecho <li>DMS artifacts for capturing DDL events: awsdms_ddl_audit_*</li>
\qecho <li>Schema Conversion Tool (SCT) created objects: aws_*</li>
\qecho </ul>
\qecho <br>
-- START SQL
SELECT
         c.relname
	,n.nspname as schema_name
	,CASE c.relkind
	   WHEN 'r' THEN 'table'
	   WHEN 'v' THEN 'view'
	   WHEN 'i' THEN 'index'
	   WHEN 'S' THEN 'sequence'
	   WHEN 'm' THEN 'materialized view'
	   WHEN 's' THEN 'special'
	END as object_type
FROM pg_catalog.pg_class c
LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r','v','i','S','m','s')
AND c.relname like 'aws%'
order by 1;
-- END SQL
\qecho <br>
\qecho <br>

------------------------------------------------------------------------------
-- New Major heading :
\qecho <hr>
\qecho <p id="ArchivalInformation" class="anchor"></p>
\qecho <h2 style="font-family:verdana">Archival Information</h2>


-- New Minor heading and block :
\qecho <p id="ArchivalInformation1" class="anchor"></p>
\qecho <h2>Archive mode and other details :</h2>
\qecho <li><a href="#TableDetails5">previous : </a><a href="#Top">top : </a><a href="#Permissions1">next</a></li>
\qecho <br>
  
-- START SQL
show archive_mode;
\qecho <br>
\if :is_non_rds
	show archive_command;
\endif
\qecho <br>
show wal_level; 
-- END SQL
  
\qecho <br>
\qecho <br>


------------------------------------------------------------------------------
-- New Major heading :
\qecho <hr>
\qecho <p id="Permissions" class="anchor"></p>
\qecho <h2 style="font-family:verdana">Permissions</h2>


-- New Minor heading and block :
\qecho <p id="Permissions1" class="anchor"></p>
\qecho <h2>System privileges :</h2>
\qecho <li><a href="#ArchivalInformation1">previous : </a><a href="#Top">top : </a><a href="#Permissions2">next</a></li>
\qecho <br>
\qecho <b>Note:</b><br> 
\qecho <ul>
\qecho <li><b>PostgreSQL source:</b> refer to <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html#CHAP_Source.PostgreSQL.Prerequisites">PostgreSQL source permissions</a> needed. Additionally, refer to <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html#CHAP_Source.PostgreSQL.RDSPostgreSQL">RDS or Aurora PostgreSQL permissions</a> needed.</li>
\qecho <li><b>PostgreSQL target:</b> refer to <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.PostgreSQL.html#CHAP_Target.PostgreSQL.Security">minimum PostgreSQL user permissions</a> to run DMS tasks.</li>
\qecho </ul>
\qecho <br>

-- START SQL
\du+ :v_connector
-- END SQL

\qecho <br>
\qecho <br>

-- New Minor heading and block :
\qecho <p id="Permissions2" class="anchor"></p>
\qecho <h2>Table Grants :</h2>
\qecho <li><a href="#Permissions1">previous : </a><a href="#Top">top : </a><a href="#PotentialIssues">next</a></li>
\qecho <br>  For more information, refer to: 
\qecho <a href="https://www.postgresql.org/docs/10/sql-grant.html">GRANT on Database Objects</a><br>
\qecho <br>
  
-- START SQL
with obj_permissions as
(
  select 
      c.relname,
      coalesce(nullif(s[1], ''), 'public') as grantee, 
      s[2] as privileges
  from 
      pg_class c
      join pg_namespace n on n.oid = relnamespace
      join pg_roles r on r.oid = relowner,
      unnest(coalesce(relacl::text[], format('{%s=arwdDxt/%s}', rolname, rolname)::text[])) acl, 
      regexp_split_to_array(acl, '=|/') s
  where nspname = :'v_owner'
	and relkind in ('r','p')
)
select * from obj_permissions
  where grantee = :'v_connector';
-- END SQL
  
\qecho <br>
\qecho <br>


------------------------------------------------------------------------------
-- New Major heading :
\qecho <hr>
\qecho <p id="PotentialIssues" class="anchor"></p>
\qecho <h2 style="font-family:verdana">Potential Issues</h2>

-- New Minor heading and block :
\qecho <p id="PotentialIssues1" class="anchor"></p>
\qecho <h2>Unsupported data types :</h2>
\qecho <li><a href="#ArchivalInformation1">previous : </a><a href="#Top">top : </a><a href="#PotentialIssues2">next</a></li>
\qecho <br>
\qecho <b>Note: </b> Refer to <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html#CHAP_Source-PostgreSQL-DataTypes">the default mapping to AWS DMS data types from PostgreSQL source</a> and <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.PostgreSQL.html#CHAP_Target.PostgreSQL.DataTypes">the target PostgreSQL data types mapped from the AWS DMS data types</a>.<br>
\qecho <br>

-- START SQL
select table_schema as Schema 
	,data_type as "Data type"
	, count(*)
	from information_schema.columns where
table_schema = :'v_owner' 
	and data_type in ('timestamp with time zone')
group by table_schema,data_type order by 3 desc;
-- END SQL
  
\qecho <br>
\qecho <br>


-- Tables with No PK 
\qecho <p id="PotentialIssues2" class="anchor"></p>
\qecho <h2>Tables with No PK :</h2>
\qecho <li><a href="#PotentialIssues1">previous : </a><a href="#Top">top : </a><a href="#PotentialIssues3">next</a></li>
\qecho <br>
\qecho <b>Note:</b> 
\qecho <ul>
\qecho <li>If a table does not have a primary key, AWS DMS ignores DELETE and UPDATE record operations for that table. Refer to <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html#CHAP_Source.PostgreSQL.Limitations">limitations on using a PostgreSQL database as a source for AWS DMS</a>.</li>
\qecho <li>Primary key or unique key is needed for migrating LOB in a FULL LOAD or CDC tasking using FULL LOB mode. Primary key is also needed for migrating LOB in CDC task using Limited LOB mode. Refer to <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_BestPractices.html#CHAP_BestPractices.LOBS">Best practices for AWS Database Migration Service -  Migrating large binary objects (LOBs)</a>.</li>
\qecho <li>Primary key or unique key is needed for using batch apply for improving CDC performance. Refer to <a href="https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.ChangeProcessingTuning.html">change processing tuning settings</a>.</li>
\qecho </ul>
\qecho <br>
  
-- START SQL
select tbl.table_schema, 
       tbl.table_name
from information_schema.tables tbl
where table_type = 'BASE TABLE'
  and table_schema not in ('pg_catalog', 'information_schema')
  and table_schema = :'v_owner'
  and table_name not like 'awsdms%'
  and not exists (select 1 
                  from information_schema.key_column_usage kcu
                  where kcu.table_name = tbl.table_name 
                    and kcu.table_schema = tbl.table_schema);
-- END SQL
  
\qecho <br>
\qecho <br>


-- New Minor heading and block :
\qecho <p id="PotentialIssues3" class="anchor"></p>
\qecho <h2>TEXT and JSONB columns with NOT NULL set :</h2>
\qecho <li><a href="#PotentialIssues2">previous : </a><a href="#Top">top : </a><a href="#PotentialIssues4">next</a></li>
\qecho <br>
\qecho <b>Note:</b> TEXT and JSONB data types are treated as LOB during DMS replication. Full LOB mode comes with penalty of slow performance.
\qecho <br>
\qecho <br>
  
-- START SQL
-- JSONB columns with NOT NULL set
select table_name as "Table name" 
	,column_name as "Column name"
	,data_type as "Data type"
	from information_schema.columns 
where is_nullable = 'NO'
and table_schema = :'v_owner'
and data_type in ('jsonb','text')
and table_name not like 'awsdms%';
-- END SQL
  
\qecho <br>
\qecho <br>


-- New Minor heading and block :
\qecho <p id="PotentialIssues4" class="anchor"></p>
\qecho <h2>Long running sql (more than 10 minutes) :</h2>
\qecho <li><a href="#PotentialIssues3">previous : </a><a href="#Top">top : </a><a href="#PotentialIssues5">next</a></li>
\qecho <br>
\qecho <b>Note:</b><br>
\qecho <ul>
\qecho <li>Cross check with <a href="#DatabaseConfiguration7">Replication Slot Details</a> for long running transactions preventing restart_lsn to advance which result in WAL significant growth.</li>
\qecho <li>Check if any long running transactions that prevent DMS full load and CDC task or CDC-only task to start.</li>
\qecho <li>Long running transactions can result in poor replication performance due to the nature of logical replication used by DMS. </li>
\qecho </ul>
\qecho <br>
  
-- START SQL
-- Long running sql for more than 10 minutes
SELECT
    pid as "process id",
    usename as username,
    xact_start as "transaction start",
    current_timestamp - query_start AS runtime,
    wait_event_type,
    state,
    backend_xid,
    backend_xmin,
\if :is_ge_10
    backend_type,
\endif
    query
FROM pg_stat_activity
WHERE state = 'active'
	AND (current_timestamp - query_start) > interval '10 minutes'
	AND query not like '%vacuum%'
ORDER BY 1 DESC
LIMIT 10;
-- END SQL
  
\qecho <br>
\qecho <br>


-- New Minor heading and block :
\qecho <p id="PotentialIssues5" class="anchor"></p>
\qecho <h2>Tables with triggers :</h2>
\qecho <li><a href="#PotentialIssues4">previous : </a><a href="#Top">top : </a><a href="PotentialIssues6">next</a></li>
\qecho <br>
\qecho <b>Note:</b> Though triggers on source do not have much impact from DMS standpoint, it is important to know if these triggers exist on target or not. For brevity purpose we list only first 10 triggers.
\qecho <br>
\qecho <b>tgenabled:</b> O = trigger fires in "origin" and "local" modes, D = trigger is disabled, R = trigger fires in "replica" mode, A = trigger fires always.
\qecho <br>
\qecho <br>
  
-- START SQL
SELECT cast(tgrelid::regclass as text) as table_name, tgname, tgenabled
  FROM   pg_trigger
  WHERE  tgisinternal is false
  AND    tgrelid in
       (SELECT oid
       FROM    pg_class
       WHERE   relkind = 'r'
       AND     relnamespace in
               (SELECT oid
               FROM   pg_namespace
               WHERE  nspname = :'v_owner'
    	       )
      )          
  ORDER BY cast(tgrelid::regclass as text)
  LIMIT 10;
-- END SQL

\qecho <br>
\qecho <br>

-- New Minor heading and block :
\qecho <p id="PotentialIssues6" class="anchor"></p>
\qecho <h2>Database Views :</h2>
\qecho <li><a href="#PotentialIssues5">previous : </a><a href="#Top">top : </a><a href="EndOfReport">next</a></li>
\qecho <br>
\qecho <b>Note:</b> Currently AWS DMS supports only the Full Load for views in PostgreSQL source endpoints.
\qecho <br>
\qecho <br>
  
-- START SQL
SELECT
    c.relname as "View"
    ,n.nspname as "Schema"
FROM pg_catalog.pg_class c
LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind IN ('v')
and n.nspname = :'v_owner';
-- END SQL
  
\qecho <br>
\qecho <br>
\qecho <p id="EndOfReport"><h2>End of the report</h2></p>
\qecho <li><a href="#PotentialIssues5">previous : </a><a href="#Top">top : </a></li>

\o
\pset format aligned
\echo
\echo
\echo Output report dms_support_script_postgres.html can be found in current directory.
\echo
\echo
