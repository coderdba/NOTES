-- https://www.sqlshack.com/sql-server-troubleshooting-disk-i-o-problems/


-- I/O Stalls
-- I/O stall time is an indicator that can be used to detect I/O problems. The dm_io_virtual_file_stats is a dynamic management function that gives detailed information about the stall times of the data and log files so it will simplify the SQL Server troubleshooting process. This dynamic management function takes two parameters first one is database id, and the second one is the database file number.

SELECT * FROM
sys.dm_io_virtual_file_stats (   
    { database_id | NULL },  
    { file_id | NULL }  
)  

-- We can execute this dynamic management function like the below for all databases.

select Db.name ,vfs.* from
  sys.dm_io_virtual_file_stats(NULL, NULL) AS VFS
    JOIN sys.databases AS Db 
  ON vfs.database_id = Db.database_id
  
  
-- Combined query
NOTE: SYS.MASTER_FILES is not in azure sql db.  For such, you can determine that by taking snapshots of sys.dm_io_virtual_file_stats() and looking at the diffs of io_stall_queued_read_ms and io_stall_queued_write_ms (https://github.com/dimitri-furman/managed-instance/issues/4)

SELECT  DB_NAME(vfs.database_id) AS database_name ,physical_name AS [Physical Name],
        size_on_disk_bytes / 1024 / 1024. AS [Size of Disk] ,
        CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1)) AS [Average Read latency] ,
        CAST(io_stall_write_ms/(1.0 + num_of_writes) AS NUMERIC(10,1)) AS [Average Write latency] ,
        CAST((io_stall_read_ms + io_stall_write_ms)
/(1.0 + num_of_reads + num_of_writes) 
AS NUMERIC(10,1)) AS [Average Total Latency],
        num_of_bytes_read / NULLIF(num_of_reads, 0) AS    [Average Bytes Per Read],
        num_of_bytes_written / NULLIF(num_of_writes, 0) AS   [Average Bytes Per Write]
FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs
  JOIN sys.master_files AS mf 
    ON vfs.database_id = mf.database_id AND vfs.file_id = mf.file_id
ORDER BY [Average Total Latency] DESC

- Without sys.master_files
SELECT  DB_NAME(vfs.database_id) AS database_name, file_id,
        CAST(io_stall_write_ms/(1.0 + num_of_writes) AS NUMERIC(10,1)) AS [Average Write latency] ,
        CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1)) AS [Average Read latency] ,
        CAST((io_stall_read_ms + io_stall_write_ms)
/(1.0 + num_of_reads + num_of_writes) 
AS NUMERIC(10,1)) AS [Average Total Latency],
        num_of_bytes_read / NULLIF(num_of_reads, 0) AS    [Average Bytes Per Read],
        num_of_bytes_written / NULLIF(num_of_writes, 0) AS   [Average Bytes Per Write],
        size_on_disk_bytes / 1024 / 1024. AS [Size of Disk]
FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs
ORDER BY [Average Write Latency] DESC

- Without sys.master_files - Adding file names also
SELECT  DB_NAME(vfs.database_id) AS database_name, vfs.file_id, 
		df.name as [File Name], df.physical_name as [Physical File Name],
        CAST(io_stall_write_ms/(1.0 + num_of_writes) AS NUMERIC(10,1)) AS [Average Write latency] ,
        CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1)) AS [Average Read latency] ,
        CAST((io_stall_read_ms + io_stall_write_ms)
/(1.0 + num_of_reads + num_of_writes) 
AS NUMERIC(10,1)) AS [Average Total Latency],
        num_of_bytes_read / NULLIF(num_of_reads, 0) AS    [Average Bytes Per Read],
        num_of_bytes_written / NULLIF(num_of_writes, 0) AS   [Average Bytes Per Write],
        size_on_disk_bytes / 1024 / 1024. AS [Size of Disk]
FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs,
        sys.database_files df
where df.file_id = vfs.file_id
ORDER BY [Average Write Latency] DESC

- Without sys.master_files - Adding file names, data space names also
SELECT  DB_NAME(vfs.database_id) AS database_name, vfs.file_id, 
        ds.name as [Data Space Name],
		df.name as [File Name], df.physical_name as [Physical File Name],
        CAST(io_stall_write_ms/(1.0 + num_of_writes) AS NUMERIC(10,1)) AS [Average Write latency] ,
        CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1)) AS [Average Read latency] ,
        CAST((io_stall_read_ms + io_stall_write_ms)
/(1.0 + num_of_reads + num_of_writes) 
AS NUMERIC(10,1)) AS [Average Total Latency],
        num_of_bytes_read / NULLIF(num_of_reads, 0) AS    [Average Bytes Per Read],
        num_of_bytes_written / NULLIF(num_of_writes, 0) AS   [Average Bytes Per Write],
        size_on_disk_bytes / 1024 / 1024. AS [Size of Disk]
FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs,
        sys.database_files df,
		sys.data_spaces ds
where df.file_id = vfs.file_id and
      ds.data_space_id = df.data_space_id
ORDER BY [Average Write Latency] DESC

-- at database level (however group by lists multiple lines for same db somehow)
SELECT  (vfs.database_id), DB_NAME(vfs.database_id) AS database_name,
		avg(CAST(io_stall_write_ms/(1.0 + num_of_writes) AS NUMERIC(10,1))) AS [Average Write latency] ,
        avg(CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1))) AS [Average Read latency] ,
        avg(CAST((io_stall_read_ms + io_stall_write_ms)
/(1.0 + num_of_reads + num_of_writes) 
AS NUMERIC(10,1))) AS [Average Total Latency],
        avg(num_of_bytes_read / NULLIF(num_of_reads, 0)) AS    [Average Bytes Per Read],
        avg(num_of_bytes_written / NULLIF(num_of_writes, 0)) AS   [Average Bytes Per Write]
FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs
group by vfs.database_id

-- at data-space level
SELECT  (vfs.database_id), DB_NAME(vfs.database_id) AS database_name,
        ds.name as [Data Space Name],
		avg(CAST(io_stall_write_ms/(1.0 + num_of_writes) AS NUMERIC(10,1))) AS [Average Write latency] ,
        avg(CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1))) AS [Average Read latency] ,
        avg(CAST((io_stall_read_ms + io_stall_write_ms)
/(1.0 + num_of_reads + num_of_writes) 
AS NUMERIC(10,1))) AS [Average Total Latency],
        avg(num_of_bytes_read / NULLIF(num_of_reads, 0)) AS    [Average Bytes Per Read],
        avg(num_of_bytes_written / NULLIF(num_of_writes, 0)) AS   [Average Bytes Per Write]
FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs,
        sys.database_files df,
		sys.data_spaces ds
where df.file_id = vfs.file_id and
      ds.data_space_id = df.data_space_id
group by vfs.database_id, (vfs.database_id), ds.name


===================================
Info from the site
===================================

-- Misconfigured or malfunctioning disk subsystems
-- Insufficient disk performances
-- Applications that generate redundant I/O activities
-- Poor designed or unoptimized queries
-- Analyzing the symptoms should be a major principle to clarify the underlying reason that causes the I/O issues on SQL Server. Otherwise, we can waste time dealing with irrelevant issues or discussing the issues with system or storage administrators unnecessarily. Wait types give very useful information for SQL Server troubleshooting. The following wait types can indicate I/O problems, but these wait types do not suffice to decide any problem on the disks.

-- PAGEIOLATCH_*
-- WRITELOG
-- ASYNC_IO_COMPLETION
-- At first, we will briefly describe these wait types and their relations to the I/O problems.

-- PAGEIOLATCH_*
-- SQL Server reserves an area on the memory to itself, and this area uses to cache data and index pages to reduce the disk activities. This reserved memory area is called Buffer Pool. The working mechanism of the buffer pool is very simple; the data loads from the disk to the memory when any request has been received for reading or changing, and they process in the buffer pool. The data is written to the disk again when it is modified. In light of this information, PAGEIOLATCH_* occurs when transferring data from disk to buffer pool. It is very normal to detect some PAGEIOLATCH_* however, it indicates a problem when we see this wait type frequently and more than the other wait types. PAGEIOLATCH_* does not indicate disk problems by oneself because this wait type can occur for a variety of reasons. For example:

-- Outdated statistics or poorly designed indexes can cause to PAGEIOLATCH_* waits because these types of problems cause redundant disk activities
-- Enabling CDC (Change Data Capture) option can cause extra I/O workload
-- Insufficient memory can cause PAGEIOLATCH_* problems because SQL Server does not keep the data pages long enough in the buffer cache. The other sign of this problem is the Page Life Expectancy metric
-- WRITELOG
-- When any modification is performed in the database, SQL Server writes this modification to log buffer, and then it writes this buffer data to disk. Therefore, this wait type is related to the physical disk that contains the log file (ldf). Placing log files (ldf) on as fast and dedicated disks as possible will be the right approach to overcome these problems. At the same time, performance statistics of physical disks that store ldf files should be considered when this problem occurs. The log data is written into the disk sequentially, and the reading process is also performed sequentially. Due to this working principle, the disks selected for the log files must perform well for the sequential read and write throughput along with the minimum latency.

-- ASYNC_IO_COMPLETION
-- This wait type occurs when the SQL Server processes backup and restore operations; however, when this operation takes more time than usual, it might be a warning for the I/O problems. The BACKUPIO can be seen with the ASYNC_IO_COMPLETION so we can consider about any disk problem.


