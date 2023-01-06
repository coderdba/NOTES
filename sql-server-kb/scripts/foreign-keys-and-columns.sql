-- https://simplesqltutorials.com/sql-server-find-foreign-key-references/

SELECT F.NAME as 'Foreign key constraint name',
OBJECT_NAME(F.parent_object_id) AS 'Referencing/Child Table',
COL_NAME(FC.parent_object_id, FC.parent_column_id) AS 'Referencing/Child Column',
OBJECT_NAME(FC.referenced_object_id) AS 'Referenced/Parent Table',
COL_NAME(FC.referenced_object_id, FC.referenced_column_id) AS 'Referenced/Parent Column'
FROM sys.foreign_keys AS F
INNER JOIN sys.foreign_key_columns AS FC
ON F.OBJECT_ID = FC.constraint_object_id
--WHERE OBJECT_NAME (F.referenced_object_id) = 'table_name'
ORDER BY OBJECT_NAME(F.parent_object_id)
