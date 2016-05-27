--
-- DBUNIQUENAME_PRIM - Primary unique name
-- DBUNIQUENAME_STBY  - Standby unique name
--
--
--
run
{

allocate channel c1 device type disk;
allocate channel c2 device type disk;
allocate auxiliary channel c3 device type disk;
allocate auxiliary channel c4 device type disk;

DUPLICATE TARGET DATABASE
   FOR STANDBY
   FROM ACTIVE DATABASE
   DORECOVER
   SPFILE
     SET DB_UNIQUE_NAME='DBUNIQUENAME_STBY'
     SET LOG_ARCHIVE_DEST_1='LOCATION=USE_DB_RECOVERY_FILE_DEST  valid_for=(all_logfiles,all_roles) db_unique_name=DBUNIQUENAME_STBY'
     SET LOG_ARCHIVE_DEST_2='SERVICE=DBUNIQUENAME_PRIM lgwr async valid_for=(online_logfiles,primary_role) db_unique_name=DBUNIQUENAME_PRIM'
     SET FAL_CLIENT='DBUNIQUENAME_STBY'
     SET FAL_SERVER='DBUNIQUENAME_PRIM'
     SET REMOTE_LISTENER='rcll05-scan:1522'
     SET AUDIT_FILE_DEST='/u01/app/oracle/admin/DBUNIQUENAME_STBY/adump'
   NOFILENAMECHECK;
}

