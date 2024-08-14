SELECT TOP 20 
    -- d.object_id, 
    db_name(d.database_id) 'DB Name', 
	OBJECT_NAME(object_id, database_id) 'Stored Proc Name',   
    --d.sql_handle,
    d.total_worker_time/1000000/d.execution_count AS 'Avg CPU Sec',  
  d.max_worker_time/1000000 as 'Max CPU Sec', 
  d.min_worker_time/1000000 as 'Min CPU Sec', 
  d.last_worker_time/1000000 as 'Last CPU Sec', 
	d.total_worker_time/1000000 as 'Tot CPU Sec',  
	d.execution_count as 'Exec Count',
	d.cached_time as 'Cached Time', 
	d.last_execution_time as 'Last Exec Time'
FROM sys.dm_exec_procedure_stats AS d 
where db_name(d.database_id) = 'WebEc'
ORDER BY 'Avg CPU Sec' DESC;
