-- Name: IO Usage For DB
-- Level: server
-- Explanation: Databases with high IO can affect performance of SQLs in those databases, as well as contribute to reduced performance of SQLs on other databases as well. High disk reads could be due to SQLs that do not use indexes efficiently, SQLs that read majority of rows in the tables or too many processes accessing different rows of the tables. High writes could be due to too much workload. Analyze such potential causes.
-- Suggestion: "Tune the SQLs to use indexes, reduce amount of data fetched by the SQL, select only necessary columns in queries"

-- Order by reads
SELECT 
  name AS [Db Name],
  SUM(num_of_reads) AS 'Number of Read' , 
  SUM(num_of_bytes_read)/(1024*1024) AS 'Number of MB Read' ,
  SUM(num_of_writes) AS 'Number of Writes' , 
  SUM(num_of_bytes_written)/(1024*1024) AS 'Number of MB Written' , 
  SUM(io_stall)/1000 AS 'Seconds Waited for File IO' , 
  SUM(io_stall_queued_read_ms)/1000 AS 'Seconds Waited for File Reads' , 
  SUM(io_stall_queued_write_ms)/1000 AS 'Seconds Waited for File Writes' 
  FROM sys.dm_io_virtual_file_stats(NULL, NULL) I 
  INNER JOIN sys.databases D   
  ON I.database_id = d.database_id 
  GROUP BY name 
  ORDER BY 'Number of Read' DESC

-- Order by write avg latency
SELECT  
  COALESCE(vfs.database_id, -1) as [Db ID], 
  COALESCE(DB_NAME(vfs.database_id), 'Unknown') AS [Database], 
  avg(CAST(io_stall_write_ms/(1.0 + num_of_writes) AS NUMERIC(10,1))) AS [Average Write latency (ms)] , 
  avg(CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1))) AS [Average Read latency (ms)] , 
  avg(CAST((io_stall_read_ms + io_stall_write_ms) /(1.0 + num_of_reads + num_of_writes)  AS NUMERIC(10,1))) AS [Average Total Latency (ms)], 
  avg(num_of_bytes_read / NULLIF(num_of_reads, 0)) AS    [Average Bytes Per Read], avg(num_of_bytes_written / NULLIF(num_of_writes, 0)) AS   [Average Bytes Per Write] 
  FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs 
  group by vfs.database_id 
  ORDER BY [Average Write Latency (ms)] DESC

