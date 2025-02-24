-- Level: Server
-- Notes: Settings of SQL Server that influence performance, and other important settings.
SELECT name as [Name],value as [Value],minimum as [Minimum],maximum as [Maximum] 
  FROM sys.configurations 
  WHERE name in ('min server memory (MB)','max server memory (MB)','remote query timeout (s)','user connections' , 'max worker threads')
