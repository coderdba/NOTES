-- https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-index-columns-transact-sql?view=sql-server-ver16

USE mydb;
GO
SELECT i.name AS index_name
    ,COL_NAME(ic.object_id,ic.column_id) AS column_name
    ,ic.index_column_id
    ,ic.key_ordinal
,ic.is_included_column
FROM sys.indexes AS i
INNER JOIN sys.index_columns AS ic
    ON i.object_id = ic.object_id AND i.index_id = ic.index_id
WHERE i.object_id = OBJECT_ID('myTable');
