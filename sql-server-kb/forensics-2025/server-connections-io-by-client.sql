-- Name: Connection count and IO Ordered by Client Machine
-- Level: server
-- Explanation: Gives data of Connection count and IO by Client Machine.
-- Suggestion: "Too many connections, idle connections can contribute to reduced performance.  Consider reducing unnecessary connections, or spread the workload to different times."

select 
  dbid AS [Db ID], 
  DB_NAME(dbid) AS [Database], 
  hostname as [Host Name], 
  status as [Status], 
  count(*) as [Count], 
  sum(physical_io) as [Physical IO Cumulative], 
  sum(memusage) as [Mem Usage Cumulative], 
  sum(cpu) as [Cpu Time Cumulative] 
  from sys.sysprocesses 
  group by dbid, hostname, status 
  order by dbid, hostname, status
