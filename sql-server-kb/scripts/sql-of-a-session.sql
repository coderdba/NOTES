DECLARE @sqltext VARBINARY(128)
SELECT @sqltext = sql_handle
FROM sys.sysprocesses
WHERE spid = (YourSessionID)
SELECT TEXT
FROM sys.dm_exec_sql_text(@sqltext)
GO
