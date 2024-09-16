-- TO ESTIMATE TOTAL TRANSACTIONS IN A SYSTEM

select top 2 * from sys.dm_exec_query_stats

SELECT 
    OBJECT_NAME(I.object_id) AS [TableName],
    SUM(I.user_seeks + I.user_scans + I.user_lookups) AS [TotalReads],
    SUM(I.user_updates) AS [TotalWrites]
FROM 
    sys.dm_db_index_usage_stats AS I
INNER JOIN 
    sys.objects AS O
    ON I.object_id = O.object_id
WHERE 
    I.database_id = DB_ID()
    AND (
        I.last_user_seek >= DATEADD(HOUR, -24, GETDATE()) OR
        I.last_user_scan >= DATEADD(HOUR, -24, GETDATE()) OR
        I.last_user_lookup >= DATEADD(HOUR, -24, GETDATE()) OR
        I.last_user_update >= DATEADD(HOUR, -24, GETDATE())
    )
GROUP BY 
    OBJECT_NAME(I.object_id)
ORDER BY 
    [TableName];


SELECT 
       DB_NAME(vfs.database_id) AS database_name, 
       SUM(num_of_reads) AS reads, 
       SUM(num_of_writes) AS writes,
       SUM(io_stall_read_ms) AS read_latency_ms,
       SUM(io_stall_write_ms) AS write_latency_ms
   FROM sys.dm_io_virtual_file_stats(NULL, NULL) vfs
   GROUP BY vfs.database_id
   order by vfs.database_id;

SELECT 
       database_id, 
       instance_name AS transaction_type,
       cntr_value AS count
   FROM sys.dm_os_performance_counters
   WHERE counter_name IN ('Transactions', 'Active Transactions');

select instance_name, counter_name, cntr_value as count 
from sys.dm_os_performance_counters
WHERE counter_name IN ('Transactions', 'Active Transactions');


use WebEC
SELECT 
    OBJECT_NAME(I.object_id) AS [TableName],
    SUM(I.user_seeks + I.user_scans + I.user_lookups) AS [TotalReads],
    SUM(I.user_updates) AS [TotalWrites]
FROM 
    sys.dm_db_index_usage_stats AS I
INNER JOIN 
    sys.objects AS O
    ON I.object_id = O.object_id
WHERE 
    I.database_id = DB_ID()
    AND I.last_user_seek >= CAST(GETDATE() AS DATE)
    AND I.last_user_scan >= CAST(GETDATE() AS DATE)
    AND I.last_user_lookup >= CAST(GETDATE() AS DATE)
    AND I.last_user_update >= CAST(GETDATE() AS DATE)
GROUP BY 
    OBJECT_NAME(I.object_id)
ORDER BY 
    [TableName];
