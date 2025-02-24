-- Unused indexes
-- Run this for some days/weeks and decide 

SELECT 
    OBJECT_NAME(s.[object_id]) AS [Table Name],
    i.name AS [Index Name],
	i.type_desc,
	i.is_unique
FROM 
    sys.dm_db_index_usage_stats AS s
INNER JOIN 
    sys.indexes AS i ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
WHERE 
    OBJECTPROPERTY(s.[object_id],'IsUserTable') = 1
    AND i.type_desc = 'NONCLUSTERED'
    AND i.name IS NOT NULL
    AND (s.user_seeks = 0 AND s.user_scans = 0 AND s.user_lookups = 0)
order by 1,2
