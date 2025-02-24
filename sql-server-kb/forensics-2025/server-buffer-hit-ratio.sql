-- Level: server
-- This must be high - like 95% and above

-- Formula 1
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

-- Formula 2
select 
  count(*) * 8/1024 As [Buffer Pool Size MB], 
  count(*) As [Total Buffer Cache Pages],
  100 * (1 - cast(sum(case is_modified when 1 then 0 else 1 end) AS DECIMAL(20,2))/cast(count(*) AS DECIMAL(20,2))) [Buffer Cache Hit Ratio] 
  from sys.dm_os_buffer_descriptors
