-- from copilot

SELECT TOP 10
    qs.creation_time,
    qs.execution_count,
    qs.total_worker_time AS total_cpu_time,
    qs.total_logical_reads,
    qs.total_physical_reads,
    qs.total_elapsed_time,
    SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
    ((CASE qs.statement_end_offset
        WHEN -1 THEN DATALENGTH(st.text)
        ELSE qs.statement_end_offset
    END - qs.statement_start_offset)/2) + 1) AS query_text,
    qp.query_plan
FROM
    sys.dm_exec_query_stats AS qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
    CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
WHERE
    qs.total_worker_time > 1000000 -- High CPU time
    OR qs.total_logical_reads > 1000000 -- High logical reads
    OR qs.execution_count > 1000 -- High execution count
ORDER BY
    qs.total_worker_time DESC;
