set echo on

select thread#, groups from v$thread;
select distinct bytes from v$log;
select group#, thread#, bytes from v$log;
select group#, thread#, bytes from v$standby_log;

set echo off
