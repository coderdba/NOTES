-- Name: Get DB I/O stats - File level IO
-- Level: server
-- Explanation: Gives File level Input Output stats of Db.
-- Suggestion: "High IO volume and latency indicates high load, SQLs that need optimization with better structure or indexes, hardware insufficiency etc. Analyze the load and SQLs, data volumes and optimize"

SELECT  
COALESCE(DB_NAME(vfs.database_id), 'Unknown') AS [Database], 
vfs.file_id as [File ID], 
ds.name as [Data Space Name], 
df.name as [File Name], 
df.physical_name as [Physical File Name], 
CAST(io_stall_write_ms/(1.0 + num_of_writes) AS NUMERIC(10,1)) AS [Average Write latency (ms)] , 
CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1)) AS [Average Read latency (ms)] , 
CAST((io_stall_read_ms + io_stall_write_ms) /(1.0 + num_of_reads + num_of_writes)  AS NUMERIC(10,1)) AS [Average Total Latency (ms)], 
num_of_bytes_read / NULLIF(num_of_reads, 0) AS    [Average Bytes Per Read], num_of_bytes_written / NULLIF(num_of_writes, 0) AS   [Average Bytes Per Write], size_on_disk_bytes / 1024 / 1024. AS [Size of Disk MB] 
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs, 
sys.database_files df, sys.data_spaces ds 
where df.file_id = vfs.file_id 
and ds.data_space_id = df.data_space_id ORDER BY [Average Write Latency (ms)] DESC
