--
--  NOTE - Joining by DB_KEY will not work because it is for DB_NAME - not DB_UNIQUE_NAME - and will be same for all DR sites
--         Therefore, join by site_key.
--
--         And, rc_rman_backup_job_details does not have site_key - therefore, need to join with rc_rman_status also
--
--

set pages 1000
set lines 180

column db_unique_name format a15

spool backup-size

select
        a.db_name,
        c.session_key,
        b.db_unique_name,
        c.input_type,
        c.status,
        to_char(c.start_time, 'dd-mon-yyyy hh24:mi') st_time,
        to_char(c.end_time,'dd-mon-yyyy hh24:mi') end_time,
        c.input_bytes
        --,c.time_taken_display, 3600*c.input_bytes_per_sec/1024/1024/1024 input_gbh
--
from   (select distinct db_name, session_key, site_key from rc_rman_status) a,
       rc_site b,
       rc_rman_backup_job_details c
--
where  b.site_key = a.site_key
  and  c.session_key = a.session_key
  and  trunc(c.start_time) > sysdate-15
  and  b.DB_UNIQUE_NAME like 'XYZ%_SITE1'
  and  c.input_type='DB INCR'
  -- more than 500G input
  --and c.input_bytes/1024/1024/1024 > 500
--
  -- L0 like backups
  --and c.input_bytes*0.9<c.input_bytes
order by 3, 2, c.start_time
;


spool off
