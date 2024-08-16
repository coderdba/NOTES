-- https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-index-columns-transact-sql?view=sql-server-ver16

USE mydb;
GO

-- FOR SPECIFIC TABLE
SELECT i.name AS index_name
    ,COL_NAME(ic.object_id,ic.column_id) AS column_name
    ,ic.index_column_id
    ,ic.key_ordinal
,ic.is_included_column
FROM sys.indexes AS i
INNER JOIN sys.index_columns AS ic
    ON i.object_id = ic.object_id AND i.index_id = ic.index_id
WHERE i.object_id = OBJECT_ID('myTable');

-- FOR ALL TABLES
-- https://stackoverflow.com/questions/765867/list-of-all-index-index-columns-in-sql-server-db
SELECT 
     TableName = t.name,
     IndexName = ind.name,
     IndexId = ind.index_id,
     ColumnId = ic.index_column_id,
     ColumnName = col.name,
     ind.*,
     ic.*,
     col.* 
FROM 
     sys.indexes ind 
INNER JOIN 
     sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN 
     sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN 
     sys.tables t ON ind.object_id = t.object_id 
WHERE 
    -- UNCOMMENT THESE TO EXCLUDE PRIMARY AND UNIQUE KEYS
     --ind.is_primary_key = 0 
     --AND ind.is_unique = 0 
     --AND ind.is_unique_constraint = 0 
     --AND 
      t.is_ms_shipped = 0 
ORDER BY 
     t.name, ind.name, ind.index_id, ic.is_included_column, ic.key_ordinal;


--- ANOTHER WAY
select schema_name(t.schema_id) + '.' + t.[name] as table_view, 
    case when t.[type] = 'U' then 'Table'
        when t.[type] = 'V' then 'View'
        end as [object_type],
    i.index_id,
    case when i.is_primary_key = 1 then 'Primary key'
        when i.is_unique = 1 then 'Unique'
        else 'Not unique' end as [type],
    i.[name] as index_name,
    substring(column_names, 1, len(column_names)-1) as [columns],
    case when i.[type] = 1 then 'Clustered index'
        when i.[type] = 2 then 'Nonclustered unique index'
        when i.[type] = 3 then 'XML index'
        when i.[type] = 4 then 'Spatial index'
        when i.[type] = 5 then 'Clustered columnstore index'
        when i.[type] = 6 then 'Nonclustered columnstore index'
        when i.[type] = 7 then 'Nonclustered hash index'
        end as index_type
from sys.objects t
    inner join sys.indexes i
        on t.object_id = i.object_id
    cross apply (select col.[name] + ', '
                    from sys.index_columns ic
                        inner join sys.columns col
                            on ic.object_id = col.object_id
                            and ic.column_id = col.column_id
                    where ic.object_id = t.object_id
                        and ic.index_id = i.index_id
                            order by col.column_id
                            for xml path ('') ) D (column_names)
where t.is_ms_shipped <> 1
and index_id > 0
order by schema_name(t.schema_id) + '.' + t.[name], i.index_id
