-- https://blog.sqlauthority.com/2019/11/22/sql-server-recompile-stored-procedures-two-easy-ways/
-- Here is the simple script which you can run to identify which stored procedure is cached for your database 
-- and various associated properties of the stored procedure.

SELECT SCHEMA_NAME(SCHEMA_ID) SchemaName, name ProcedureName,
last_execution_time LastExecuted,
last_elapsed_time LastElapsedTime,
execution_count ExecutionCount,
cached_time CachedTime
FROM sys.dm_exec_procedure_stats ps JOIN
sys.objects o ON ps.object_id = o.object_id
WHERE ps.database_id = DB_ID();

-- To recompile
EXEC sp_recompile 'StoredProcedureName'

-- Recompiling while running the SP
-- You can recompile your stored procedure while you execute it. Here is the script.
EXEC StoredProcedureName @parameters WITH RECOMPILE
