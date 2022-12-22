-- https://www.mssqltips.com/sqlservertip/1255/getting-io-and-time-statistics-for-sql-server-queries

-- SET STATISTICS IO
-- Here is an example of turning the STATISTICS IO on and off.
-- turn on statistics IO
SET STATISTICS IO ON 
GO -- your query goes here
SELECT * FROM Employee
GO
-- turn off statistics IO
SET STATISTICS IO OFF 
GO

-- SET STATISTICS TIME
-- Here is an example of turning the STATISTICS TIME on and off.
-- turn on statistics IO
SET STATISTICS TIME ON 
GO -- your query goes here
SELECT * FROM Employee
GO
-- turn off statistics IO
SET STATISTICS TIME OFF 
GO
