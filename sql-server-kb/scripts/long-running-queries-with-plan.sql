SELECT     
qsqt.query_sql_text,    
qsp.query_id,    
qsp.plan_id,    
qsr.execution_type_desc,    
qsr.count_executions,    
qsr.avg_duration / 1000.0 AS avg_duration_sec,     
qsr.max_duration / 1000.0 AS max_duration_sec,     
qsr.avg_cpu_time / 1000.0 AS avg_cpu_time_sec,    
qsr.avg_logical_io_reads,    
qsr.avg_logical_io_writes,    
qsr.avg_physical_io_reads,    
qsr.first_execution_time,    
qsr.last_execution_time,    
qsp.query_plan
FROM sys.query_store_runtime_stats qsr
JOIN sys.query_store_plan qsp ON qsr.plan_id = qsp.plan_id
JOIN sys.query_store_query qsq ON qsp.query_id = qsq.query_id
JOIN sys.query_store_query_text qsqt ON qsq.query_text_id = qsqt.query_text_id
WHERE qsr.avg_duration > 300000000  
ORDER BY qsr.avg_duration DESC; 
