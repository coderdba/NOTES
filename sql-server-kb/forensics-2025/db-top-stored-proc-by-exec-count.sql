SELECT TOP 20 
    -- d.object_id, 
    db_name(d.database_id) 'DB Name', 
	OBJECT_NAME(object_id, database_id) 'Stored Proc Name',   
    --d.sql_handle,
	d.execution_count as 'Exec Count',
    d.total_elapsed_time/1000/d.execution_count AS 'Avg Exec ms',  
	d.max_elapsed_time/1000 as 'Max Exec ms',
    d.total_physical_reads/d.execution_count AS 'Avg Phy Reads',
	d.max_physical_reads as 'Max Phy Reads',
	d.cached_time as 'Cached Time', 
	d.last_execution_time as 'Last Exec Time'
FROM sys.dm_exec_procedure_stats AS d 
where db_name(d.database_id) = 'WebEc'
ORDER BY 'Exec Count' DESC;
