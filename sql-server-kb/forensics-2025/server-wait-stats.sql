-- Level: Server
-- Notes: Analyze high waits and do any possible remediation

with wait_stats as 
  (SELECT [wait_type] as [Wait Type], [wait_time_ms] / 1000.0 AS [Wait (S)], ([wait_time_ms] - [signal_wait_time_ms]) / 1000.0 AS [Resource (S)], 
  [signal_wait_time_ms] / 1000.0 AS [Signal (S)], [waiting_tasks_count] AS [Wait Count], 
  100.0 * [wait_time_ms] / SUM ([wait_time_ms]) OVER() AS [Percentage], ROW_NUMBER() 
  OVER(ORDER BY [wait_time_ms] DESC) AS [Row Num] FROM sys.dm_os_wait_stats )  
  select * from wait_stats 	WHERE [Row Num] BETWEEN 1 AND 20
