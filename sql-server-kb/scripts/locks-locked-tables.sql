
SELECT 
    OBJECT_NAME(p.OBJECT_ID) AS TableName, 
    l.resource_type, 
    l.request_mode, 
    COUNT(*) AS LockCount
FROM 
    sys.dm_tran_locks l
JOIN 
    sys.partitions p ON l.resource_associated_entity_id = p.hobt_id
GROUP BY 
    OBJECT_NAME(p.OBJECT_ID), l.resource_type, l.request_mode
ORDER BY 
    LockCount DESC;

-----
-- https://stackoverflow.com/questions/694581/how-to-check-which-locks-are-held-on-a-table
USE yourdatabase;
GO

SELECT * FROM sys.dm_tran_locks
  WHERE resource_database_id = DB_ID()
  AND resource_associated_entity_id = OBJECT_ID(N'dbo.yourtablename');
