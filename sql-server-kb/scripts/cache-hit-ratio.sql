=======
CORRECT ONE??
https://dba.stackexchange.com/questions/88784/what-does-a-buffer-cache-hit-ratio-of-9990-mean
select convert(DECIMAL(10,2),(100 * a.cntr_value / b.cntr_value))
from
--
(select object_name, cntr_value from sys.dm_os_performance_counters
WHERE counter_name = 'Buffer cache hit ratio'
AND object_name like '%Buffer Manager%') a,
--
(select object_name, cntr_value from sys.dm_os_performance_counters
WHERE counter_name = 'Buffer cache hit ratio base'
AND object_name like '%Buffer Manager%') b
--
WHERE a.object_name = b.object_name;

=======
ORIGINAL: NOT CORRECT

DECLARE @BufferPoolSizeMB DECIMAL(10, 2)
DECLARE @TotalBufferCachePages BIGINT

-- Get the buffer pool size in MB
SELECT @BufferPoolSizeMB = CAST(COUNT(*) * 8/1024.00 AS DECIMAL(10,2)) FROM sys.dm_os_buffer_descriptors

-- Get the total number of pages in the buffer pool
SELECT @TotalBufferCachePages = COUNT(*) FROM sys.dm_os_buffer_descriptors

-- Get the number of clean and dirty buffer pages in the buffer pool
SELECT (1.0 - CAST(SUM(CASE is_modified WHEN 1 THEN 0 ELSE 1 END) AS DECIMAL(20,2))/CAST(@TotalBufferCachePages AS DECIMAL(20,2))) * 100 AS [Buffer Cache Hit Ratio]
FROM sys.dm_os_buffer_descriptors

=======

MODIFIED 1:
select count(*) * 8/1024,
       count(*),
	   100 * (1 - cast(sum(case is_modified when 1 then 0 else 1 end) AS DECIMAL(20,2))/cast(count(*) AS DECIMAL(20,2)))
from sys.dm_os_buffer_descriptors

MODIFIED 2:
select CAST(COUNT(*) * 8/1024.00 AS DECIMAL(10,2)),
       COUNT(*),
	   (1.0 - CAST(SUM(CASE is_modified WHEN 1 THEN 0 ELSE 1 END) AS DECIMAL(20,2))/CAST(COUNT(*) AS DECIMAL(20,2))) * 100
from sys.dm_os_buffer_descriptors
