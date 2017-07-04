set pages 1000
set lines 180

column db_unique_name format a15

spool backup-schedule

prompt
prompt SCHEDULE DAY TIME SIZE
prompt


select 
db_unique_name,
st_day_number,
st_day_name,
st_hr,
max(st_mi),
max(input_mb)
--
from
(
select 
        a.db_name,
        b.db_unique_name,
        a.db_key,
        a.dbinc_key,
        a.site_key,
        a.session_key,
        c.input_type,
        to_char(c.start_time, 'dd-mon-yyyy hh24:mi') st_time,
        to_char(c.end_time,'dd-mon-yyyy hh24:mi') end_time,
        round((c.end_time - c.start_time) * 24 * 60) elapsed_min,
        to_char(c.start_time, 'D') st_day_number,
        to_char(c.start_time, 'DAY') st_day_name,
        to_char(c.start_time, 'HH24') st_hr,
        to_char(c.start_time, 'MI') st_mi,
        round(c.input_bytes/(1024*1024)) input_mb,
        round(c.output_bytes/(1024*1024)) output_mb
from
(select distinct db_name, db_key, dbinc_key, session_key, site_key from rc_rman_status) a,
rc_site b,
rc_rman_backup_job_details c
where
    a.db_key = b.db_key 
and a.dbinc_key = b.dbinc_key 
and a.site_key = b.site_key 
--and b.db_unique_name like 'EXD01%' 
and b.database_role = 'PRIMARY'
and b.db_key = c.db_key
and a.session_key = c.session_key
and c.input_type = 'DB INCR'
and c.status = 'COMPLETED'
and c.start_time > SYSDATE - 15
order by 1, 3, c.start_time
)
group by db_unique_name, st_day_number, st_day_name, st_hr
order by 1,2,4
;


prompt
prompt ALL RUNS DETAIL
prompt

select 
        a.db_name,
        b.db_unique_name,
        a.db_key,
        a.dbinc_key,
        a.site_key,
        a.session_key,
        c.input_type,
        to_char(c.start_time, 'dd-mon-yyyy hh24:mi') st_time,
        to_char(c.end_time,'dd-mon-yyyy hh24:mi') end_time,
        round((c.end_time - c.start_time) * 24 * 60) elapsed_min,
        round(c.input_bytes/(1024*1024)) input_mb,
        round(c.output_bytes/(1024*1024)) output_mb
from
(select distinct db_name, db_key, dbinc_key, session_key, site_key from rc_rman_status) a,
rc_site b,
rc_rman_backup_job_details c
where
    a.db_key = b.db_key 
and a.dbinc_key = b.dbinc_key 
and a.site_key = b.site_key 
--and b.db_unique_name like 'EXD01%' 
and b.database_role = 'PRIMARY'
and b.db_key = c.db_key
and a.session_key = c.session_key
and c.input_type = 'DB INCR'
and c.status = 'COMPLETED'
and c.start_time > SYSDATE - 15
order by 1, 3, c.start_time
;

spool off
