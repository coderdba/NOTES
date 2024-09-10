
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
