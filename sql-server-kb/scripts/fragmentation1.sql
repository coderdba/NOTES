SELECT object_name(IPS.object_id) AS [Table Name], SI.name AS [Index Name], IPS.Index_type_desc AS [Index Type Desc], IPS.avg_fragmentation_in_percent AS [Avg Fragmetation In Percent], IPS.avg_fragment_size_in_pages AS [Avg Fragment Size In Pages], IPS.fragment_count AS [Fragment Count] 
FROM sys.dm_db_index_physical_stats(NULL, NULL, NULL, NULL , NULL) IPS 
JOIN 
sys.tables ST WITH (nolock) ON IPS.object_id = ST.object_id 
JOIN 
sys.indexes SI WITH (nolock) ON IPS.object_id = SI.object_id 
AND IPS.index_id = SI.index_id 
WHERE ST.is_ms_shipped = 0 
AND IPS.avg_fragmentation_in_percent > 30 
ORDER BY IPS.avg_fragmentation_in_percent DESC
