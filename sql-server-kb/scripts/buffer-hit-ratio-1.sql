-- https://www.sqlshack.com/sql-server-memory-performance-metrics-part-4-buffer-cache-hit-ratio-page-life-expectancy/

-- Use this:
SELECT
CAST(bc.cntr_value AS FLOAT) / NULLIF(bc_base.cntr_value, 0) * 100 AS BufferCacheHitPercentage
FROM
sys.dm_os_performance_counters AS bc
INNER JOIN
sys.dm_os_performance_counters AS bc_base
ON bc.[object_name] = bc_base.[object_name]
AND bc.instance_name = bc_base.instance_name
WHERE
bc.counter_name = 'Buffer cache hit ratio'
AND bc_base.counter_name = 'Buffer cache hit ratio base';

-- Use this:
https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-performance-counters-transact-sql?view=sql-server-ver16
DECLARE @CacheHits BIGINT, @CacheLookups BIGINT;

SELECT 
    @CacheHits = (SELECT cntr_value FROM sys.dm_os_performance_counters 
                  WHERE counter_name = 'Buffer cache hit ratio'),
    @CacheLookups = (SELECT cntr_value FROM sys.dm_os_performance_counters 
                     WHERE counter_name = 'Buffer cache hit ratio base');

SELECT 
    CASE 
        WHEN @CacheLookups = 0 THEN 0
        ELSE (@CacheHits * 100.0 / @CacheLookups)
    END AS [Buffer Cache Hit Ratio Percentage];

-- This can be erroneous
SELECT object_name, counter_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE [object_name] LIKE '%Buffer Manager%'
AND [counter_name] = 'Buffer cache hit ratio'

-- Use supplemental metrics like this
SELECT object_name, counter_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE [object_name] LIKE '%Buffer Manager%'
AND [counter_name] = 'Page life expectancy'
