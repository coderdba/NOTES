set pages 1000
set lines 180

column db_unique_name format a15

spool backup-summary

select substr(db_unique_name, 1, 4), db_unique_name, db_name, backup_type, st_time_hh_mi, round(avg(elapsed_min)), round(avg(input_mb)) avg_input_mb
from
(
--
select 
        a.db_name,
        b.db_unique_name,
        a.db_key,
        a.dbinc_key,
        a.site_key,
        a.session_key,
        c.input_type,
        d.backup_type,
        to_char(c.start_time, 'hh24:mi') st_time_hh_mi,
        to_char(c.start_time, 'dd-mon-yyyy hh24:mi') st_time,
        to_char(c.end_time,'dd-mon-yyyy hh24:mi') end_time,
        round((c.end_time - c.start_time) * 24 * 60) elapsed_min,
        round(c.input_bytes/(1024*1024)) input_mb,
        round(c.output_bytes/(1024*1024)) output_mb
from
(select distinct db_name, db_key, dbinc_key, session_key, site_key from rc_rman_status) a,
rc_site b,
rc_rman_backup_job_details c,
(select distinct db_key, session_key, backup_type from rc_backup_set_details d1 
  where exists (select 1 from rc_backup_set_details d2 where d1.db_key = d2.db_key and d2.session_key = d1.session_key and d2.backup_type = 'I')) d
where
    a.db_key = b.db_key 
and a.dbinc_key = b.dbinc_key 
and a.site_key = b.site_key 
--and b.db_unique_name like 'XYZ%' 
and b.database_role = 'PRIMARY'
and b.db_key = c.db_key
and a.session_key = c.session_key
--
and c.db_key = d.db_key
and c.session_key = d.session_key
and d.backup_type in ('I')
--
and c.input_type = 'DB INCR'
and c.status = 'COMPLETED'
and c.start_time > SYSDATE - 15
order by 1, 3, c.start_time
)
--
group by substr(db_unique_name, 1, 4), db_name, db_unique_name, backup_type, st_time_hh_mi
order by db_unique_name, backup_type, st_time_hh_mi
;

select substr(db_unique_name, 1, 4), db_unique_name, db_name, backup_type, st_time_hh_mi, round(avg(elapsed_min)), round(avg(input_mb)) avg_input_mb
from
(
--
select 
        a.db_name,
        b.db_unique_name,
        a.db_key,
        a.dbinc_key,
        a.site_key,
        a.session_key,
        c.input_type,
        d.backup_type,
        to_char(c.start_time, 'hh24:mi') st_time_hh_mi,
        to_char(c.start_time, 'dd-mon-yyyy hh24:mi') st_time,
        to_char(c.end_time,'dd-mon-yyyy hh24:mi') end_time,
        round((c.end_time - c.start_time) * 24 * 60) elapsed_min,
        round(c.input_bytes/(1024*1024)) input_mb,
        round(c.output_bytes/(1024*1024)) output_mb
from
(select distinct db_name, db_key, dbinc_key, session_key, site_key from rc_rman_status) a,
rc_site b,
rc_rman_backup_job_details c,
(select distinct db_key, session_key, backup_type from rc_backup_set_details d1 
  where not exists (select 1 from rc_backup_set_details d2 where d1.db_key = d2.db_key and d2.session_key = d1.session_key and d2.backup_type = 'I')) d
where
    a.db_key = b.db_key 
and a.dbinc_key = b.dbinc_key 
and a.site_key = b.site_key 
--and b.db_unique_name like 'XYZ%' 
and b.database_role = 'PRIMARY'
and b.db_key = c.db_key
and a.session_key = c.session_key
--
and c.db_key = d.db_key
and c.session_key = d.session_key
and d.backup_type in ('D')
--
and c.input_type = 'DB INCR'
and c.status = 'COMPLETED'
and c.start_time > SYSDATE - 15
order by 1, 3, c.start_time
)
--
group by substr(db_unique_name, 1, 4), db_name, db_unique_name, backup_type, st_time_hh_mi
order by db_unique_name, backup_type, st_time_hh_mi
;

spool off
