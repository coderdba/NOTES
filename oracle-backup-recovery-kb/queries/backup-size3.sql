-- SQL> desc rc_rman_status
--  Name					   Null?    Type
--  ----------------------------------------- -------- ----------------------------
--  DB_KEY 				   NOT NULL NUMBER
--  DBINC_KEY				   NOT NULL NUMBER
--  DB_NAME				   NOT NULL VARCHAR2(8)
--  RECID					   NOT NULL NUMBER
--  STAMP					   NOT NULL NUMBER
--  RSR_KEY				   NOT NULL NUMBER
--  PARENT_KEY					    NUMBER
--  SESSION_KEY					    NUMBER
--  ROW_TYPE					    VARCHAR2(33)
--  ROW_LEVEL					    NUMBER
--  OPERATION					    VARCHAR2(33)
--  STATUS 					    VARCHAR2(33)
--  COMMAND_ID					    VARCHAR2(33)
--  MBYTES_PROCESSED			   NOT NULL NUMBER
--  START_TIME				   NOT NULL DATE
--  END_TIME					    DATE
--  JOB_KEY					    NUMBER
--  INPUT_BYTES					    NUMBER
--  OUTPUT_BYTES					    NUMBER
--  OPTIMIZED					    VARCHAR2(3)
--  OBJECT_TYPE					    VARCHAR2(80)
--  SESSION_RECID					    NUMBER
--  SESSION_STAMP					    NUMBER
--  OUTPUT_DEVICE_TYPE				    VARCHAR2(17)
--  SITE_KEY					    NUMBER
--  OSB_ALLOCATED					    VARCHAR2(3)
-- 
-- SQL>  desc rc_site
--  Name					   Null?    Type
--  ----------------------------------------- -------- ----------------------------
--  SITE_KEY				   NOT NULL NUMBER
--  DB_KEY 				   NOT NULL NUMBER
--  DATABASE_ROLE				   NOT NULL VARCHAR2(7)
--  CF_CREATE_TIME 				    DATE
--  DB_UNIQUE_NAME 				    VARCHAR2(120)
--  HIGH_CONF_RECID			   NOT NULL NUMBER
--  FORCE_RESYNC2CF			   NOT NULL VARCHAR2(3)
--  HIGH_ROUT_STAMP				    NUMBER
--  INST_STARTUP_STAMP				    NUMBER
--  LAST_KCCDIVTS					    NUMBER
--  HIGH_IC_RECID					    NUMBER
--  DBINC_KEY				   NOT NULL NUMBER
--  CKP_SCN				   NOT NULL NUMBER
--  FULL_CKP_CF_SEQ			   NOT NULL NUMBER
--  JOB_CKP_CF_SEQ 			   NOT NULL NUMBER
--  HIGH_TS_RECID					    NUMBER
--  HIGH_DF_RECID					    NUMBER
--  HIGH_RT_RECID					    NUMBER
--  HIGH_ORL_RECID 				    NUMBER
--  HIGH_OFFR_RECID			   NOT NULL NUMBER
--  HIGH_RLH_RECID 			   NOT NULL NUMBER
--  HIGH_AL_RECID				   NOT NULL NUMBER
--  HIGH_BS_RECID				   NOT NULL NUMBER
--  HIGH_BP_RECID				   NOT NULL NUMBER
--  HIGH_BDF_RECID 			   NOT NULL NUMBER
--  HIGH_CDF_RECID 			   NOT NULL NUMBER
--  HIGH_BRL_RECID 			   NOT NULL NUMBER
--  HIGH_BCB_RECID 			   NOT NULL NUMBER
--  HIGH_CCB_RECID 			   NOT NULL NUMBER
--  HIGH_DO_RECID				   NOT NULL NUMBER
--  HIGH_PC_RECID				   NOT NULL NUMBER
--  HIGH_BSF_RECID 			   NOT NULL NUMBER
--  HIGH_RSR_RECID 			   NOT NULL NUMBER
--  HIGH_TF_RECID				   NOT NULL NUMBER
--  HIGH_GRSP_RECID			   NOT NULL NUMBER
--  HIGH_NRSP_RECID			   NOT NULL NUMBER
--  HIGH_BCR_RECID 			   NOT NULL NUMBER
--  LOW_BCR_RECID				   NOT NULL NUMBER
--  BCR_IN_USE				   NOT NULL VARCHAR2(3)
--  HIGH_PDB_RECID 				    NUMBER
--  HIGH_PIC_RECID 			   NOT NULL NUMBER
-- 
-- SQL> 
-- SQL> desc rc_rman_backup_job_details
--  Name					   Null?    Type
--  ----------------------------------------- -------- ----------------------------
--  DB_KEY 				   NOT NULL NUMBER
--  DB_NAME				   NOT NULL VARCHAR2(8)
--  SESSION_KEY					    NUMBER
--  SESSION_RECID					    NUMBER
--  SESSION_STAMP					    NUMBER
--  COMMAND_ID					    VARCHAR2(33)
--  START_TIME					    DATE
--  END_TIME					    DATE
--  INPUT_BYTES					    NUMBER
--  OUTPUT_BYTES					    NUMBER
--  STATUS_WEIGHT					    NUMBER
--  OPTIMIZED_WEIGHT				    NUMBER
--  INPUT_TYPE_WEIGHT				    NUMBER
--  OUTPUT_DEVICE_TYPE				    VARCHAR2(17)
--  AUTOBACKUP_COUNT				    NUMBER
--  BACKED_BY_OSB					    VARCHAR2(3)
--  AUTOBACKUP_DONE				    VARCHAR2(3)
--  STATUS 					    VARCHAR2(23)
--  INPUT_TYPE					    VARCHAR2(13)
--  OPTIMIZED					    VARCHAR2(3)
--  ELAPSED_SECONDS				    NUMBER
--  COMPRESSION_RATIO				    NUMBER
--  INPUT_BYTES_PER_SEC				    NUMBER
--  OUTPUT_BYTES_PER_SEC				    NUMBER
--  INPUT_BYTES_DISPLAY				    VARCHAR2(4000)
--  OUTPUT_BYTES_DISPLAY				    VARCHAR2(4000)
--  INPUT_BYTES_PER_SEC_DISPLAY			    VARCHAR2(4000)
--  OUTPUT_BYTES_PER_SEC_DISPLAY			    VARCHAR2(4000)
--  TIME_TAKEN_DISPLAY				    VARCHAR2(4000)
-- 
-- SQL> 
-- SQL> desc rc_backup_set_details
--  Name					   Null?    Type
--  ----------------------------------------- -------- ----------------------------
--  SESSION_KEY					    NUMBER
--  SESSION_RECID					    NUMBER
--  SESSION_STAMP					    NUMBER
--  DB_KEY 				   NOT NULL NUMBER
--  DB_NAME				   NOT NULL VARCHAR2(8)
--  BS_KEY 				   NOT NULL NUMBER
--  RECID						    NUMBER
--  STAMP						    NUMBER
--  SET_STAMP				   NOT NULL NUMBER
--  SET_COUNT				   NOT NULL NUMBER
--  BACKUP_TYPE					    VARCHAR2(1)
--  CONTROLFILE_INCLUDED				    VARCHAR2(7)
--  INCREMENTAL_LEVEL				    NUMBER
--  PIECES 				   NOT NULL NUMBER
--  START_TIME					    DATE
--  COMPLETION_TIME				    DATE
--  ELAPSED_SECONDS				    NUMBER
--  BLOCK_SIZE					    NUMBER
--  KEEP						    VARCHAR2(3)
--  KEEP_UNTIL					    DATE
--  KEEP_OPTIONS					    VARCHAR2(11)
--  DEVICE_TYPE					    VARCHAR2(255)
--  COMPRESSED					    VARCHAR2(3)
--  NUM_COPIES					    NUMBER
--  OUTPUT_BYTES					    NUMBER
--  ORIGINAL_INPUT_BYTES				    NUMBER
--  COMPRESSION_RATIO				    NUMBER
--  STATUS 					    CHAR(1)
--  ORIGINAL_INPRATE_BYTES 			    NUMBER
--  OUTPUT_RATE_BYTES				    NUMBER
--  ORIGINAL_INPUT_BYTES_DISPLAY			    VARCHAR2(4000)
--  OUTPUT_BYTES_DISPLAY				    VARCHAR2(4000)
--  ORIGINAL_INPRATE_BYTES_DISPLAY 		    VARCHAR2(4000)
--  OUTPUT_RATE_BYTES_DISPLAY			    VARCHAR2(4000)
--  TIME_TAKEN_DISPLAY				    VARCHAR2(4000)
--  ENCRYPTED					    VARCHAR2(3)
--  BACKED_BY_OSB					    VARCHAR2(3)





set pages 1000
set lines 180

column db_unique_name format a15

spool backup-size3

select 
        a.db_name,
        b.db_unique_name,
        a.db_key,
        a.dbinc_key,
        a.site_key,
        a.session_key,
        c.input_type,
        d.backup_type,
        to_char(c.start_time, 'dd-mon-yyyy hh24:mi') st_time,
        to_char(c.end_time,'dd-mon-yyyy hh24:mi') end_time,
        round((c.end_time - c.start_time) * 24 * 60) elapsed_min,
        round(c.input_bytes/(1024*1024)) input_mb,
        d.output_mb
from
--rc_rman_status a,
(select distinct db_name, db_key, dbinc_key, session_key, site_key from rc_rman_status) a,
rc_site b,
rc_rman_backup_job_details c,
(select distinct db_key, session_key, backup_type, round(sum(output_bytes/(1024*1024))) output_mb 
   from rc_backup_set_details where start_time > sysdate - 15
    group by db_key, session_key, backup_type) d
--rc_backup_set_details d
where
    a.db_key = b.db_key 
and a.dbinc_key = b.dbinc_key 
and a.site_key = b.site_key 
and b.db_unique_name like 'XYZ%' 
and b.database_role = 'PRIMARY'
and b.db_key = c.db_key
and a.session_key = c.session_key
and c.db_key = d.db_key
and c.session_key = d.session_key
and d.backup_type in ('D', 'I')
and c.input_type = 'DB INCR'
and c.status = 'COMPLETED'
and c.start_time > SYSDATE - 15
order by 1, 3, c.start_time
;


spool off
