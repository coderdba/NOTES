-- https://dataginger.com/2015/06/04/sql-server-capture-execution-plan-of-a-currently-running-queryprocess-spid/

SELECT CONVERT(XML, c.query_plan) AS ExecutionPlan
FROM sys.dm_exec_requests a with (nolock)
OUTER APPLY sys.dm_exec_sql_text(a.sql_handle) b
OUTER APPLY sys.dm_exec_text_query_plan (a.plan_handle, a.statement_start_offset, a.statement_end_offset) c
LEFT JOIN sys.dm_exec_query_memory_grants m (nolock)
ON m.session_id = a.session_id
AND m.request_id = a.request_id
JOIN sys.databases d
ON d.database_id = a.database_id
WHERE  a.session_id = @@SPID --replace @@SPID with the SPID number for which you want to capture query plan
ORDER BY a.Start_Time
