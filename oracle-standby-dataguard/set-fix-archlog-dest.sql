--
--  switching destination specifications based on role will be done by dataguard broker if setup and enabled
--
--  if broker is not enabled, then upon role change, reverse them manually
--

-- To verify the effect of log_archive_config setting, query v$dataguard_config
alter system set log_archive_config = 'dg_config=(SITE1_DB_UNIQUE_NAME,SITE2_DB_UNIQUE_NAME,SITE3_DB_UNIQUE_NAME)' scope=both sid='*';

-- To query statuses of destinations, query select dest_name || ' ' || status from V$ARCHIVE_DEST order by 1;

alter system set log_archive_dest_1 = 'LOCATION=USE_DB_RECOVERY_FILE_DEST valid_for=(all_logfiles,all_roles)', 'db_unique_name=SITE1_DB_UNIQUE_NAME';

ALTER SYSTEM SET log_archive_dest_2='service="(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=rac2-vip1)(PORT=1521))(ADDRESS=(PROTOCOL=TCP)(HOST=rac2-vip2)(PORT=1521))(LOAD_BALANCE=yes)(CONNECT_DATA=(SERVICE_NAME=SITE2_DB_UNIQUE_NAME)))"','LGWR ASYNC NOAFFIRM delay=0 optional compression=disable max_failure=0 max_connections=1 reopen=300 db_unique_name=SITE2_DB_UNIQUE_NAME net_timeout=30','valid_for=(all_logfiles,primary_role)' ;

ALTER SYSTEM SET log_archive_dest_3='service="(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=rac3-vip1)(PORT=1521))(ADDRESS=(PROTOCOL=TCP)(HOST=rac3-vip2)(PORT=1521))(LOAD_BALANCE=yes)(CONNECT_DATA=(SERVICE_NAME=SITE3_DB_UNIQUE_NAME)))"','LGWR ASYNC NOAFFIRM delay=0 optional compression=disable max_failure=0 max_connections=1 reopen=300 db_unique_name=SITE3_DB_UNIQUE_NAME net_timeout=30','valid_for=(all_logfiles,primary_role)' ;

ALTER SYSTEM SET log_archive_dest_state_2 = enable;
ALTER SYSTEM SET log_archive_dest_state_2 = enable;

-- Verify
select * from v$dataguard_config;
select dest_name || ' ' || status from V$ARCHIVE_DEST order by 1;

