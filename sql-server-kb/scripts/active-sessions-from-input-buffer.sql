-- https://www.mssqltips.com/sqlservertip/5122/retrieve-actively-running-tsql-statements-from-sql-server/

For an spid

SELECT * FROM sys.dm_exec_input_buffer(107, null)
