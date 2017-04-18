--
--  RUN ON BOTH PRIMARY AND STANDBY AND COMPARE
--

-- http://expertoracle.com/2014/03/28/physical-standby-data-guard-useful-sql-scripts/

spool loglist

set lines 200
set pages 1000

set echo on

SELECT DATABASE_ROLE, DB_UNIQUE_NAME, OPEN_MODE, TO_CHAR(CURRENT_SCN),
       PROTECTION_MODE, PROTECTION_LEVEL, SWITCHOVER_STATUS 
FROM V$DATABASE;

select name || ' ' || value from v$parameter where name in ('log_archive_dest_1', 'log_archive_dest_2');

select * from v$archive_gap;

select ‘Last Log applied : ‘ Logs, to_char(next_time,‘DD-MON-YY:HH24:MI:SS’) Time
from v$archived_log
where sequence# = (select max(sequence#) from v$archived_log where applied=’YES’)
union
select ‘Last Log received : ‘ Logs, to_char(next_time,‘DD-MON-YY:HH24:MI:SS’) Time
from v$archived_log
where sequence# = (select max(sequence#) from v$archived_log);

--select * from gv$log order by group#, thread#;

select inst_id, group#, thread#, sequence# from gv$log order by group#, thread#;

select inst_id, thread#, applied, max(sequence#) from gv$archived_log  group by inst_id, thread#, applied order by 1,2,3;

--select * from gv$archived_log order by thread#, sequence# ;

select * from v$recovery_progress;

select name, value from V$DATAGUARD_STATS;

select registrar, creator, thread#, sequence#, first_change#, next_change# from v$archived_log;

select * from v$dataguard_status order by timestamp asc;

set echo off
