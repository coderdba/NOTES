-- Name: Database throughput - Rows inserted, updated, deleted - by Database
-- Explanation: Gives Metrics for number of rows inserted, updated, deleted by the Database.
-- Suggestion: "High reads and writes into tables may result in performance issues. Analyze the load, SQLs, data volumes and optimize"

SELECT  
DB_NAME(database_id) AS [Database],  
SUM([leaf_insert_count]) AS [Rows Inserted],  
SUM([leaf_update_count]) AS [Rows Updated],  
SUM([leaf_delete_count]) AS [Rows Deleted]  
FROM sys.dm_db_index_operational_stats(DB_ID(), NULL, NULL, NULL) 
WHERE object_name(object_id, database_id) NOT LIKE 'sys%' 
GROUP BY database_id
ORDER BY [Database]
