-- Name: Index Usage Stats
-- Explanation: Usage of Indexes - new entries, updates and deletes. This indicates how busy the indexes and their tables are. 
-- Suggestion: Investigate the reasons for high usage of tables and indexes and try to reduce usage or distribute the usage across different times of the day.

SELECT 
d.name as [Db Name],
t.name as [Table Name], 
I.[NAME] AS [Index Name], 
(A.LEAF_INSERT_COUNT + A.LEAF_UPDATE_COUNT + A.LEAF_DELETE_COUNT) AS [Total Leaf Activity],
A.LEAF_INSERT_COUNT AS [Leaf Insert Count], 
A.LEAF_UPDATE_COUNT AS [Leaf Update Count], 
A.LEAF_DELETE_COUNT AS [Leaf Delete Count] 
FROM SYS.DM_DB_INDEX_OPERATIONAL_STATS (NULL,NULL,NULL,NULL ) A 
INNER JOIN SYS.INDEXES AS I 
ON I.[OBJECT_ID] = A.[OBJECT_ID] 
join sys.tables t on i.object_id = t.object_id 
join sys.databases d on a.database_id = d.database_id 
AND I.INDEX_ID = A.INDEX_ID 
WHERE OBJECTPROPERTY(A.[OBJECT_ID],'IsUserTable') = 1 
order by A.LEAF_INSERT_COUNT + A.LEAF_UPDATE_COUNT + A.LEAF_DELETE_COUNT desc
