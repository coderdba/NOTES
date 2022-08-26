// https://www.sqlshack.com/how-to-identify-and-resolve-sql-server-index-fragmentation/

SELECT OBJECT_NAME(IX.object_id) as db_name, si.name, extent_page_id, allocated_page_page_id, previous_page_page_id, next_page_page_id
FROM sys.dm_db_database_page_allocations(DB_ID('AdventureWorks'), OBJECT_ID('Sales.OrderTracking'),NULL, NULL, 'DETAILED') IX
INNER JOIN sys.indexes si on IX.object_id = si.object_id AND IX.index_id = si.index_id
WHERE si.name = 'IX_OrderTracking_CarrierTrackingNumber'
ORDER BY allocated_page_page_id
