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
