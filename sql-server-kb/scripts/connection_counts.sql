SELECT
DB_NAME(dbid) as DBName, loginame as LoginName, COUNT(*) as NumberOfConnections 
FROM master.dbo.sysprocesses 
WHERE dbid > 0
GROUP BY dbid,loginame
order by dbid,loginame;

select count(*) from master.dbo.sysprocesses;
