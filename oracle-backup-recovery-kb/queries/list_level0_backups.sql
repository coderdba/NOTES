-- https://dbaharrison.blogspot.com/2014/02/finding-completion-time-of-last-rman.html

with times as (
select distinct bsd.session_key session_key ,to_char(bjd.start_time,'dd-mon-yyyy hh24:mi:ss') st, to_char(bjd.end_time,'dd-mon-yyyy hh24:mi:ss') et
  from rc_rman_backup_job_details bjd, rc_backup_set_details bsd
 where bsd.session_recid = bjd.session_recid
   and bsd.session_key = bjd.session_key
   and bsd.SESSION_STAMP = bjd.SESSION_STAMP
   and bsd.BACKUP_TYPE || bsd.INCREMENTAL_LEVEL = 'D0'
   and bjd.status = 'COMPLETED'
   and bsd.db_name='you-database-name_here')
select st,et,output from times,rc_rman_output op
where op.session_key=times.session_key
order by op.session_key,op.recid
/
