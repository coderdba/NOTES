-- Title: Connection count and IO Ordered by Application
-- level: server
-- Explanation: Gives data of Connection count and IO by Application.
-- Suggestion: "Too many connections, idle connections can contribute to reduced performance.  Consider reducing unnecessary connections, or spread the workload to different times."

select 
  dbid AS [Db ID], 
  DB_NAME(dbid) AS [Database], 
  program_name,
  hostname as [Host Name], 
  status as [Status], count(*) as [Count], 
  sum(physical_io) as [Physical IO Cumulative], 
  sum(memusage) as [Mem Usage Cumulative], 
  sum(cpu) as [Cpu Time Cumulative] 
  from sys.sysprocesses 
  group by dbid, hostname, program_name, status 
  order by DB_NAME(dbid), hostname, program_name, status

