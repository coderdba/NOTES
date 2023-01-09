-- https://www.sqlshack.com/searching-the-sql-server-query-plan-cache/
-- For searching with LIKE operator within plan xml content: https://social.msdn.microsoft.com/Forums/en-US/ecd7d322-0dca-4d11-84b2-cefb5f495259/argument-data-type-xml-is-invalid-for-argument-1-of-like-function?forum=aspdatasourcecontrols

-- VIEWS USED
-- dm_exec_query_stats
-- dm_exec_query_plan
-- dm_exec_sql_text
-- sys.databases

SELECT TOP 10
		databases.name,
	dm_exec_sql_text.text AS TSQL_Text,
	dm_exec_query_stats.creation_time, 
	dm_exec_query_stats.execution_count,
	dm_exec_query_stats.total_worker_time AS total_cpu_time,
	dm_exec_query_stats.total_elapsed_time, 
	dm_exec_query_stats.total_logical_reads, 
	dm_exec_query_stats.total_physical_reads, 
	dm_exec_query_plan.query_plan
FROM sys.dm_exec_query_stats 
CROSS APPLY sys.dm_exec_sql_text(dm_exec_query_stats.plan_handle)
CROSS APPLY sys.dm_exec_query_plan(dm_exec_query_stats.plan_handle)
INNER JOIN sys.databases
ON dm_exec_sql_text.dbid = databases.database_id
where (cast(query_plan as varchar(max)) like '%scan%')
--where query_plan like '%scan%'
--WHERE dm_exec_sql_text.text LIKE '%SalesOrderHeader%';
