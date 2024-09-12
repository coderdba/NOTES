SELECT 
    name, 
    value_in_use 
FROM 
    sys.configurations 
WHERE 
    name IN ('min server memory (MB)', 'max server memory (MB)');
