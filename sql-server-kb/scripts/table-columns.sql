SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    tp.name AS DataType,
    c.column_id AS ColumnPosition
FROM 
    sys.tables AS t
    INNER JOIN sys.columns AS c ON t.object_id = c.object_id
    INNER JOIN sys.types AS tp ON c.user_type_id = tp.user_type_id
WHERE t.name = 'XYZ'
ORDER BY 
    t.name,
    c.column_id;
