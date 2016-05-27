
set echo on

spool setinitparam-primary

-- Primary Unique Name = DBUNIQUENAME_PRIM
-- Standby Unique Name = DBUNIQUENAME_STBY

--alter system set log_archive_config='dg_config=(primary_db_unique_name,standby_db_unique_name)' scope=both;
alter system set log_archive_config='dg_config=(DBUNIQUENAME_PRIM,DBUNIQUENAME_STBY)' scope=both;

alter system set log_archive_dest_1=
'LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=DBUNIQUENAME_PRIM'
scope=both;

alter system set log_archive_dest_2='SERVICE=DBUNIQUENAME_STBY LGWR  ASYNC  VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=DBUNIQUENAME_STBY' scope=both;

alter system set standby_file_management=AUTO scope=both;

alter system set fal_client='DBUNIQUENAME_PRIM' scope=both;
alter system set fal_server='DBUNIQUENAME_STBY' scope=both;

alter system set remote_login_passwordfile=EXCLUSIVE scope=both;

spool off
set echo off
