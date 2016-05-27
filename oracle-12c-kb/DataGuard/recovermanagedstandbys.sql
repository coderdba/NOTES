set echo on

alter database recover managed standby database using current logfile disconnect from session;
select PROCESS,STATUS,THREAD#,SEQUENCE# from v$managed_standby;
