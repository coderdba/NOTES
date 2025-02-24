-- https://www.mssqltips.com/sqlservertip/5721/script-to-obtain-most-recent-sql-server-backup-information-for-all-databases/

WITH MostRecentBackups
   AS(
      SELECT 
         database_name AS [Database],
         MAX(bus.backup_finish_date) AS LastBackupTime,
         CASE bus.type
            WHEN 'D' THEN 'Full'
            WHEN 'I' THEN 'Differential'
            WHEN 'L' THEN 'Transaction Log'
         END AS Type
      FROM msdb.dbo.backupset bus
      WHERE bus.type <> 'F'
      GROUP BY bus.database_name,bus.type
   ),
   BackupsWithSize
   AS(
      SELECT mrb.*, (SELECT TOP 1 CONVERT(DECIMAL(10,4), b.backup_size/1024/1024/1024) AS backup_size FROM msdb.dbo.backupset b WHERE [Database] = b.database_name AND LastBackupTime = b.backup_finish_date) AS [Backup Size]
      FROM MostRecentBackups mrb
   )
   SELECT 
      SERVERPROPERTY('ServerName') AS Instance, 
      d.name AS [Database],
      d.state_desc AS State,
      d.recovery_model_desc AS [Recovery Model],
      bf.LastBackupTime AS [Last Full],
      DATEDIFF(DAY,bf.LastBackupTime,GETDATE()) AS [Time Since Last Full (in Days)],
      bf.[Backup Size] AS [Full Backup Size],
      bd.LastBackupTime AS [Last Differential],
      DATEDIFF(DAY,bd.LastBackupTime,GETDATE()) AS [Time Since Last Differential (in Days)],
      bd.[Backup Size] AS [Differential Backup Size],
      bt.LastBackupTime AS [Last Transaction Log],
      DATEDIFF(MINUTE,bt.LastBackupTime,GETDATE()) AS [Time Since Last Transaction Log (in Minutes)],
      bt.[Backup Size] AS [Transaction Log Backup Size]
   FROM sys.databases d
   LEFT JOIN BackupsWithSize bf ON (d.name = bf.[Database] AND (bf.Type = 'Full' OR bf.Type IS NULL))
   LEFT JOIN BackupsWithSize bd ON (d.name = bd.[Database] AND (bd.Type = 'Differential' OR bd.Type IS NULL))
   LEFT JOIN BackupsWithSize bt ON (d.name = bt.[Database] AND (bt.Type = 'Transaction Log' OR bt.Type IS NULL))
   WHERE d.name <> 'tempdb' AND d.source_database_id IS NULL

