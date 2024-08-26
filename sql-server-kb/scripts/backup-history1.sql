-- https://www.mssqltips.com/sqlservertip/1601/script-to-retrieve-sql-server-database-backup-history-and-no-backups/

-- WITHOUT BACKUP MEDIA INFO
select * from  msdb.dbo.backupset
where msdb.dbo.backupset.database_name = 'ADM_Archive'
and (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 2) 
and user_name = 'ADMIN\sqlsa'
ORDER BY 
   msdb.dbo.backupset.database_name, 
   msdb.dbo.backupset.backup_finish_date

-- WITHOUT BACKUP MEDIA INFO - EXTENDED
SELECT 
   CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
   msdb.dbo.backupset.database_name, 
   msdb.dbo.backupset.user_name, 
   msdb.dbo.backupset.backup_start_date, 
   msdb.dbo.backupset.backup_finish_date, 
   msdb.dbo.backupset.expiration_date, 
   CASE msdb..backupset.type 
      WHEN 'D' THEN 'Full' 
	  WHEN 'I' THEN 'Differential'
      WHEN 'L' THEN 'Log' 
      END AS backup_type, 
   msdb.dbo.backupset.backup_size, 
   msdb.dbo.backupmediafamily.logical_device_name, 
   msdb.dbo.backupmediafamily.physical_device_name, 
   msdb.dbo.backupset.name AS backupset_name, 
   msdb.dbo.backupset.description 
FROM 
   msdb.dbo.backupmediafamily 
   INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
WHERE 
  -- msdb..backupset.type in ('D') AND
   (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 2) 
   and user_name = 'PTFS\sqlsa'
ORDER BY 
   msdb.dbo.backupset.database_name, 
   msdb.dbo.backupset.backup_finish_date 

-- WITH BACKUP MEDIA INFO (from the website)
--------------------------------------------------------------------------------- 
-- Database Backups for all databases For Previous Week 
--------------------------------------------------------------------------------- 
SELECT 
   CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
   msdb.dbo.backupset.database_name, 
   msdb.dbo.backupset.backup_start_date, 
   msdb.dbo.backupset.backup_finish_date, 
   msdb.dbo.backupset.expiration_date, 
   CASE msdb..backupset.type 
      WHEN 'D' THEN 'Full' 
	   WHEN 'I' THEN 'Differential'
      WHEN 'L' THEN 'Log'
      END AS backup_type, 
   msdb.dbo.backupset.backup_size, 
   msdb.dbo.backupmediafamily.logical_device_name, 
   msdb.dbo.backupmediafamily.physical_device_name, 
   msdb.dbo.backupset.name AS backupset_name, 
   msdb.dbo.backupset.description 
FROM 
   msdb.dbo.backupmediafamily 
   INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
WHERE 
   (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 7) 
   and user_name = 'ADMIN\sqlsa'
ORDER BY 
   msdb.dbo.backupset.database_name, 
   msdb.dbo.backupset.backup_finish_date 
