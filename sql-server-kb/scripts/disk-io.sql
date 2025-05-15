
SELECT 
    DB_NAME(vfs.database_id) AS DatabaseName,
    mf.physical_name AS FileName,
    mf.type_desc AS FileType,
    vfs.num_of_reads,
    vfs.num_of_writes,
    vfs.io_stall_read_ms AS TotalReadStallTimeMs,
    vfs.io_stall_write_ms AS TotalWriteStallTimeMs,
    vfs.io_stall_read_ms / NULLIF(vfs.num_of_reads, 0) AS AvgReadResponseTimeMs,
    vfs.io_stall_write_ms / NULLIF(vfs.num_of_writes, 0) AS AvgWriteResponseTimeMs
FROM 
    sys.dm_io_virtual_file_stats(NULL, NULL) vfs
JOIN 
    sys.master_files mf
ON 
    vfs.database_id = mf.database_id AND vfs.file_id = mf.file_id
ORDER BY 
    AvgReadResponseTimeMs DESC, AvgWriteResponseTimeMs DESC;
