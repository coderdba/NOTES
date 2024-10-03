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
   datediff(MINUTE, msdb.dbo.backupset.backup_start_date, msdb.dbo.backupset.backup_finish_date) duration_min,
   --msdb.dbo.backupset.expiration_date, 
   CASE msdb..backupset.type 
      WHEN 'D' THEN 'Full' 
	  WHEN 'I' THEN 'Differential'
      WHEN 'L' THEN 'Log' 
      END AS backup_type, 
   msdb.dbo.backupset.backup_size, 
   format(msdb.dbo.backupset.backup_size, 'N0') backup_size_bytes
   --msdb.dbo.backupset.name AS backupset_name, 
   --msdb.dbo.backupset.description 
FROM 
   msdb.dbo.backupset
WHERE 
   (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 1) 
   and user_name = 'PTFS\sqlsa'
ORDER BY 
   msdb.dbo.backupset.database_name, 
   msdb.dbo.backupset.backup_start_date

-- WITH BACKUP MEDIA INFO (from the website)
------------------------------------------------------------------------------------------------------
-- Database Backups for all databases For Previous Week - WITH MEDIA PHYSICAL-DRIVE INFORMATION
------------------------------------------------------------------------------------------------------
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
   format(msdb.dbo.backupset.backup_size, 'N0')
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

-- same query with distinct of only the media
SELECT DISTINCT physical_device_name 
FROM (
    SELECT 
        CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
        msdb.dbo.backupset.database_name, 
        msdb.dbo.backupset.backup_start_date, 
        msdb.dbo.backupset.backup_finish_date, 
        msdb.dbo.backupset.expiration_date, 
        CASE msdb.dbo.backupset.type 
            WHEN 'D' THEN 'Full' 
            WHEN 'I' THEN 'Differential'
            WHEN 'L' THEN 'Log'
        END AS backup_type, 
        FORMAT(msdb.dbo.backupset.backup_size, 'N0') AS backup_size,
        msdb.dbo.backupmediafamily.logical_device_name, 
        msdb.dbo.backupmediafamily.physical_device_name, 
        msdb.dbo.backupset.name AS backupset_name, 
        msdb.dbo.backupset.description 
    FROM 
        msdb.dbo.backupmediafamily 
        INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
    WHERE 
        CONVERT(DATETIME, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 1
) AS subquery;

