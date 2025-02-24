-- Name : Top Sqls Ordered by Disk Read Time
-- Explanation: These are SQLs with their execution times across all databases, in descending order of average execution times. Statistics are averages for all executions since Postgres server restarted. 
-- Suggestion: For poorly performing SQLs, tune them to use indexes, reduce amount of data fetched, updated or deleted per execution, collect statistics on underlying tables with ANALYZE command or auto-analyze settings. Defragmenting the underlying tables and indexes can help as well.

SELECT 
  TOP(15) qs.execution_count AS [Execution Count], 
  (qs.total_physical_reads)/1000.0 AS [Total Physical Reads], 
  (qs.total_physical_reads/qs.execution_count)/1000.0 AS [Avg Physical Reads], 
  (qs.total_logical_reads)/1000.0 AS [Total Logical Reads], 
  (qs.total_logical_reads/qs.execution_count)/1000.0 AS [Avg Logical Reads], 
  (qs.total_worker_time)/1000.0 AS [Total Worker Time], 
  (qs.total_worker_time/qs.execution_count)/1000.0 AS [Avg Worker Time], 
  (qs.total_elapsed_time)/1000.0 AS [Total Elapsed Time in ms], 
  (qs.total_elapsed_time/qs.execution_count)/1000.0 AS [Avg Elapsed Time], 
  qs.creation_time AS [Creation Time] , 
  LEFT(t.text, 1000) AS [Partial Query Text] 
  FROM sys.dm_exec_query_stats AS qs WITH (NOLOCK) 
  CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t 
  CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp 
  WHERE t.dbid = DB_ID() 
  ORDER BY [Total Physical Reads] DESC 

  SELECT 
  TOP(15) qs.execution_count AS [Execution Count], 
  (qs.total_physical_reads)/1000.0 AS [Total Physical Reads], 
  (qs.total_physical_reads/qs.execution_count)/1000.0 AS [Avg Physical Reads], 
  (qs.total_logical_reads)/1000.0 AS [Total Logical Reads], 
  (qs.total_logical_reads/qs.execution_count)/1000.0 AS [Avg Logical Reads], 
  (qs.total_worker_time)/1000.0 AS [Total Worker Time], 
  (qs.total_worker_time/qs.execution_count)/1000.0 AS [Avg Worker Time], 
  (qs.total_elapsed_time)/1000.0 AS [Total Elapsed Time in ms], 
  (qs.total_elapsed_time/qs.execution_count)/1000.0 AS [Avg Elapsed Time], 
  qs.creation_time AS [Creation Time] , 
  LEFT(t.text, 1000) AS [Partial Query Text] 
  FROM sys.dm_exec_query_stats AS qs WITH (NOLOCK) 
  CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t 
  CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp 
  WHERE t.dbid = DB_ID() 
  ORDER BY [Avg Physical Reads] DESC 
