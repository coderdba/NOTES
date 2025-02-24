-- Name: Last Backup
-- Level: server
-- Explanation: If backups are too old, it will affect recovery time
-- Suggestion: Ensure frequent backups

SELECT 
  db.name AS [Db Name] , 
  MAX(backup_finish_date) AS [Last Backup Finish Date] , 
  CASE backup_type WHEN 'D' THEN 'Full' WHEN 'I' THEN 'Differential' WHEN 'L' THEN 'Transaction Log' END AS BackupType , 
  CASE in_retention WHEN 1 THEN 'In Retention' WHEN 0 THEN 'Out of Retention' END AS [Is Backup Available] 
  FROM sys.dm_database_backups AS ddb 
  INNER JOIN sys.databases AS db ON ddb.physical_database_name = db.physical_database_name 
  GROUP BY db.name,backup_type,in_retention

