

-- https://learn.microsoft.com/en-us/troubleshoot/sql/database-engine/performance/troubleshoot-slow-running-queries

SELECT top 10
     req.session_id
    , req.sql_handle -- added by me
    , req.total_elapsed_time AS duration_ms
    , req.cpu_time AS cpu_time_ms
    , req.total_elapsed_time - req.cpu_time AS wait_time
    , req.logical_reads
    , SUBSTRING (REPLACE (REPLACE (SUBSTRING (ST.text, (req.statement_start_offset/2) + 1, 
       ((CASE statement_end_offset
           WHEN -1
           THEN DATALENGTH(ST.text)  
           ELSE req.statement_end_offset
         END - req.statement_start_offset)/2) + 1) , CHAR(10), ' '), CHAR(13), ' '), 
      1, 512)  AS statement_text  
FROM sys.dm_exec_requests AS req
    CROSS APPLY sys.dm_exec_sql_text(req.sql_handle) AS ST
ORDER BY total_elapsed_time DESC;
