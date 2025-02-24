-- name: Get DB I/O stats - Data Space level IO
-- Level: server
-- Explanation: Gives Data Space level Input Output stats of Db.
-- Suggestion: High IO volume and latency indicates high load, SQLs that need optimization with better structure or indexes, hardware insufficiency etc. Analyze the load and SQLs, data volumes and optimize

SELECT 
  COALESCE(vfs.database_id, -1) as [Db ID],
  COALESCE(DB_NAME(vfs.database_id), 'Unknown') AS [Database], 
  ds.name as [Data Space Name], 
  avg(CAST(io_stall_write_ms/(1.0 + num_of_writes) AS NUMERIC(10,1))) AS [Average Write latency (ms)] , 
  avg(CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1))) AS [Average Read latency (ms)] , 
  avg(CAST((io_stall_read_ms + io_stall_write_ms) /(1.0 + num_of_reads + num_of_writes)  AS NUMERIC(10,1))) AS [Average Total Latency (ms)], 
  avg(num_of_bytes_read / NULLIF(num_of_reads, 0)) AS    [Average Bytes Per Read], avg(num_of_bytes_written / NULLIF(num_of_writes, 0)) AS   [Average Bytes Per Write] 
  FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs, sys.database_files df, sys.data_spaces ds 
  where df.file_id = vfs.file_id and ds.data_space_id = df.data_space_id 
  group by vfs.database_id, (vfs.database_id), ds.name 
  ORDER BY [Average Write Latency (ms)] DESC
