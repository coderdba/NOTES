DECLARE @sqltext VARBINARY(128)
SELECT @sqltext = sql_handle
FROM sys.sysprocesses
WHERE spid = (YourSessionID)
SELECT TEXT
FROM sys.dm_exec_sql_text(@sqltext)
GO

-- To find the actual statement from within a sp being executed by a session
SELECT 
    r.session_id,
    r.start_time,
    r.status,
    r.command,
    r.sql_handle,
    t.text AS sql_text
FROM 
    sys.dm_exec_requests r
CROSS APPLY 
    sys.dm_exec_sql_text(r.sql_handle) t
WHERE 
    r.session_id = 444;


SELECT 
    r.session_id,
    r.start_time,
    r.status,
    r.command,
    r.sql_handle,
    t.text AS sql_text,
    SUBSTRING(t.text, 
              (r.statement_start_offset/2) + 1, 
              ((CASE r.statement_end_offset 
                    WHEN -1 THEN DATALENGTH(t.text)
                    ELSE r.statement_end_offset 
                END - r.statement_start_offset)/2) + 1
             ) AS statement_text
FROM 
    sys.dm_exec_requests r
CROSS APPLY 
    sys.dm_exec_sql_text(r.sql_handle) t
WHERE 
    r.session_id = 427;
