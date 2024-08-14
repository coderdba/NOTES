-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-procedure-stats-transact-sql?view=sql-server-ver16

-- For specific database
SELECT TOP 20 
    -- d.object_id, 
    db_name(d.database_id) 'DB Name', 
	OBJECT_NAME(object_id, database_id) 'Stored Proc Name',   
    --d.sql_handle,
	d.total_elapsed_time/1000000 as [total_elapsed_time_s],  
    d.total_elapsed_time/1000000/d.execution_count AS [avg_elapsed_time_s],  
    d.last_elapsed_time/1000000 as [last_elapsed_time], 
	d.execution_count,
	d.cached_time, 
	d.last_execution_time
FROM sys.dm_exec_procedure_stats AS d 
where db_name(d.database_id) = 'MyDB'
ORDER BY [avg_elapsed_time_s] DESC;
--ORDER BY [total_worker_time] DESC;

-- Across all databases
SELECT TOP 10 d.object_id, d.database_id, OBJECT_NAME(object_id, database_id) 'proc name',   
    d.sql_handle,
    d.cached_time, d.last_execution_time, d.total_elapsed_time,  
    d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],  
    d.last_elapsed_time, d.execution_count  
FROM sys.dm_exec_procedure_stats AS d  
ORDER BY [avg_elapsed_time_s] DESC;
--ORDER BY [total_worker_time] DESC;
