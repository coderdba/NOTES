-- Level: server
-- This must be high - like 95% and above

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
