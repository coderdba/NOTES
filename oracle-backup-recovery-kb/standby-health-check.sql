--
--  RUN ON BOTH PRIMARY AND STANDBY AND COMPARE
--

spool loglist

set lines 200
set pages 1000

set echo on

select open_mode, to_char(current_scn) from v$database;

select name || ' ' || value from v$parameter where name in ('log_archive_dest_1', 'log_archive_dest_2');

select * from v$archive_gap;

--select * from gv$log order by group#, thread#;

select inst_id, group#, thread#, sequence# from gv$log order by group#, thread#;

select inst_id, thread#, applied, max(sequence#) from gv$archived_log  group by inst_id, thread#, applied order by 1,2,3;

--select * from gv$archived_log order by thread#, sequence# ;

select * from v$dataguard_status order by timestamp asc;

set echo off
