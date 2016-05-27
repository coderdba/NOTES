set echo on

alter database recover managed standby database using current logfile disconnect from session;
select PROCESS,STATUS,THREAD#,SEQUENCE# from v$managed_standby;

$ cat createspfilestandby.sql
set echo on
create pfile='/tmp/pfile' from spfile;
create spfile='+DATA_DG01/DBUNIQUENAME_STBY/spfileDBNAME.ora' from pfile='/tmp/pfile';
