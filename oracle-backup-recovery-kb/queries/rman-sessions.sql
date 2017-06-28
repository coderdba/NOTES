-- http://www.dba-oracle.com/t_rman_115_kill_hung_session.htm

select b.sid, b.serial#, a.spid, b.client_info 
from
 v$process a, v$session b 
where
 a.addr=b.paddr and client_info 
like
 'rman%';
