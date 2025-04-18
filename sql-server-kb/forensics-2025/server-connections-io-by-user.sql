-- Name: Connection count and IO Ordered by User
-- Level: server
-- Explanation: Gives data of Connection count and IO by User.
-- Suggestion: "Too many connections, idle connections can contribute to reduced performance.  Consider reducing unnecessary connections, or spread the workload to different times."

select 
  dbid AS [Db ID], 
  DB_NAME(dbid) AS [Database], 
  user_name(uid) as [Username], 
  hostname as [Host Name], 
  status as [Status], 
  program_name AS [Program Name], 
  count(*) as [Count], 
  sum(physical_io)  as [Physical IO Cumulative], 
  sum(memusage) as [Mem Usage Cumulative], 
  sum(cpu) as [Cpu Time Cumulative] 
  from sys.sysprocesses 
  group by dbid, uid, hostname, program_name, status 
  order by [Database], uid, hostname, program_name, status

