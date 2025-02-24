-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-query-stats-transact-sql?view=sql-server-ver16

SELECT TOP 5 query_stats.query_hash AS Query_Hash,   
    SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count) AS Avg_CPU_Time_MicroSec,  
    SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count) / (1000 * 1000) AS Avg_CPU_Time_sec,  
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
