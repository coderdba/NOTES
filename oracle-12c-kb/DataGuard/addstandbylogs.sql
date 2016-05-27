-- On primary DB

set echo on

select group#, thread#, bytes from v$log;
select group#, thread#, bytes from v$standby_log;

 ALTER DATABASE ADD STANDBY LOGFILE THREAD 1
 GROUP 21 SIZE 1073741824,
 GROUP 22 SIZE 1073741824,
 GROUP 23 SIZE 1073741824;

 ALTER DATABASE ADD STANDBY LOGFILE THREAD 2
 GROUP 24 SIZE 1073741824,
 GROUP 25 SIZE 1073741824,
 GROUP 26 SIZE 1073741824;

select group#, thread#, bytes from v$log;
select group#, thread#, bytes from v$standby_log;
