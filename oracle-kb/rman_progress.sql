-- http://www.dba-oracle.com/t_monitor_rman_script.htm

select
  sid,
  start_time,
  totalwork
  sofar, 
 (sofar/totalwork) * 100 pct_done
from 
   v$session_longops
where 
   totalwork > sofar
AND 
   opname NOT LIKE '%aggregate%'
AND 
   opname like 'RMAN%';

select 
   sid, 
   spid, 
   client_info, 
   event, 
   seconds_in_wait, 
   p1, p2, p3
 from 
   v$process p, 
   v$session s
 where 
   p.addr = s.paddr
 and 
   client_info like 'rman channel=%';
   
   REM RMAN Progress
alter session set nls_date_format='dd/mm/yy hh24:mi:ss'
/
select SID, START_TIME,TOTALWORK, sofar, (sofar/totalwork) * 100 done,
sysdate + TIME_REMAINING/3600/24 end_at
from v$session_longops
where totalwork > sofar
AND opname NOT LIKE '%aggregate%'
AND opname like 'RMAN%'
/

REM RMAN wiats
set lines 120
column sid format 9999
column spid format 99999
column client_info format a25
column event format a30
column secs format 9999
SELECT SID, SPID, CLIENT_INFO, event, seconds_in_wait secs, p1, p2, p3
  FROM V$PROCESS p, V$SESSION s
  WHERE p.ADDR = s.PADDR
  and CLIENT_INFO like 'rman channel=%'
/

select 
   to_char(start_time,'DD-MON-YY HH24:MI') "BACKUP STARTED",
   sofar, 
   totalwork,
   elapsed_seconds/60 "ELAPSE (Min)",
   round(sofar/totalwork*100,2) "Complete%"
from
   sys.v_$session_longops
where  compnam = 'dbms_backup_restore';
