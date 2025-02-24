SELECT TOP 20 
    -- d.object_id, 
    db_name(d.database_id) 'DB Name', 
	OBJECT_NAME(object_id, database_id) 'Stored Proc Name',   
  d.total_logical_writes as 'Tot Logical Writes',
  --d.sql_handle,
  d.total_physical_reads/d.execution_count AS 'Avg Phy Reads',  
  d.max_physical_reads as 'Max Phy Reads', 
  d.min_physical_reads as 'Min Phy Reads', 
  d.last_physical_reads as 'Last Phy Reads', 
	d.total_physical_reads as 'Tot Phy Reads',  
	d.execution_count as 'Exec Count',
	d.cached_time as 'Cached Time', 
	d.last_execution_time as 'Last Exec Time'
FROM sys.dm_exec_procedure_stats AS d 
where db_name(d.database_id) = 'WebEc'
ORDER BY 'Tot Logical Writes' DESC;
