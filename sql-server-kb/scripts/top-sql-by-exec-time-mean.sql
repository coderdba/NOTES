-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-query-stats-transact-sql?view=sql-server-ver16#examples

SELECT TOP(15) qs.sql_handle, qs.plan_handle,
	  qs.execution_count AS [Execution Count], (qs.total_physical_reads)/1000.0 AS [Total Physical Reads in ms], 
      (qs.total_physical_reads/qs.execution_count)/1000.0 AS [Avg Physical Reads in ms], 
      (qs.total_logical_reads)/1000.0 AS [Total Logical Reads in ms], 
      (qs.total_logical_reads/qs.execution_count)/1000.0 AS [Avg Logical Reads in ms], 
      (qs.total_worker_time)/1000.0 AS [Total Worker Time in ms], 
      (qs.total_worker_time/qs.execution_count)/1000.0 AS [Avg Worker Time in ms], 
      (qs.total_elapsed_time)/1000.0 AS [Total Elapsed Time in ms], 
      (qs.total_elapsed_time/qs.execution_count)/1000.0 AS [Avg Elapsed Time in ms], 
      qs.creation_time AS [Creation Time] , LEFT(t.text, 1000) AS [Partial Query Text] 
      FROM sys.dm_exec_query_stats AS qs WITH (NOLOCK) 
      CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t 
      WHERE t.dbid = DB_ID() ORDER BY [Avg Elapsed Time]

SELECT TOP 5 query_stats.query_hash AS Query_Hash,   
    SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count) AS Avg_CPU_Time,  
    MIN(query_stats.statement_text) AS Sample_Statement_Text
FROM   
    (SELECT QS.*,   
    SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,  
    ((CASE statement_end_offset   
        WHEN -1 THEN DATALENGTH(ST.text)  
        ELSE QS.statement_end_offset END   
            - QS.statement_start_offset)/2) + 1) AS statement_text  
     FROM sys.dm_exec_query_stats AS QS  
     CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) as ST) as query_stats  
GROUP BY query_stats.query_hash  
ORDER BY 2 DESC; 

-- What is this qp here?
    SELECT TOP(15) qs.execution_count AS [Execution Count], (qs.total_physical_reads)/1000.0 AS [Total Physical Reads in ms], 
      (qs.total_physical_reads/qs.execution_count)/1000.0 AS [Avg Physical Reads in ms], 
      (qs.total_logical_reads)/1000.0 AS [Total Logical Reads in ms], 
      (qs.total_logical_reads/qs.execution_count)/1000.0 AS [Avg Logical Reads in ms], 
      (qs.total_worker_time)/1000.0 AS [Total Worker Time in ms], 
      (qs.total_worker_time/qs.execution_count)/1000.0 AS [Avg Worker Time in ms], 
      (qs.total_elapsed_time)/1000.0 AS [Total Elapsed Time in ms], 
      (qs.total_elapsed_time/qs.execution_count)/1000.0 AS [Avg Elapsed Time in ms], 
      qs.creation_time AS [Creation Time] , LEFT(t.text, 1000) AS [Partial Query Text] 
      FROM sys.dm_exec_query_stats AS qs WITH (NOLOCK) 
      CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t 
      --CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp 
      WHERE t.dbid = DB_ID() ORDER BY [Avg Elapsed Time in ms] DESC OPTION (RECOMPILE);

-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-query-stats-transact-sql?view=sql-server-ver16
-- A. Finding the TOP N queries

SELECT TOP 5 query_stats.query_hash AS Query_Hash,   
    SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count) AS Avg_CPU_Time,  
    MIN(query_stats.statement_text) AS Sample_Statement_Text
FROM   
    (SELECT QS.*,   
    SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,  
    ((CASE statement_end_offset   
        WHEN -1 THEN DATALENGTH(ST.text)  
        ELSE QS.statement_end_offset END   
            - QS.statement_start_offset)/2) + 1) AS statement_text  
     FROM sys.dm_exec_query_stats AS QS  
     CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) as ST) as query_stats  
GROUP BY query_stats.query_hash  
ORDER BY 2 DESC;

-- B. Returning row count aggregates for a query
SELECT qs.execution_count,  
    SUBSTRING(qt.text,qs.statement_start_offset/2 +1,   
                 (CASE WHEN qs.statement_end_offset = -1   
                       THEN LEN(CONVERT(nvarchar(max), qt.text)) * 2   
                       ELSE qs.statement_end_offset end -  
                            qs.statement_start_offset  
                 )/2  
             ) AS query_text,   
     qt.dbid, dbname= DB_NAME (qt.dbid), qt.objectid,   
     qs.total_rows, qs.last_rows, qs.min_rows, qs.max_rows  
FROM sys.dm_exec_query_stats AS qs   
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt   
WHERE qt.text like '%SELECT%'   
ORDER BY qs.execution_count DESC;

