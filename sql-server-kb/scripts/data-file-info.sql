-- https://stackoverflow.com/questions/9630279/listing-information-about-all-database-files-in-sql-server

-- List file and purpose (ROWS, LOG)
SELECT
    db.name AS DBName,
    type_desc AS FileType,
    Physical_Name AS Location,
    Cast(Cast(Round(cast(size as decimal) * 8.0/1024.0,2) as decimal(18,2)) as nvarchar) SizeMb
FROM
    sys.master_files mf
INNER JOIN 
    sys.databases db ON db.database_id = mf.database_id

SELECT
    db.name AS DBName,
    type_desc AS FileType,
	substring(Physical_Name,1,1) DriveName,
    Physical_Name AS Location,
    Cast(Cast(Round(cast(size as decimal) * 8.0/1024.0,2) as decimal(18,2)) as nvarchar) SizeMb
FROM
    sys.master_files mf
INNER JOIN 
    sys.databases db ON db.database_id = mf.database_id

SELECT
    db.name AS DBName,
    type_desc AS FileType,
	substring(Physical_Name,1,1) DriveName,
    sum(Cast(Round(cast(size as decimal) * 8.0/1024.0,2) as decimal(18,0))) FilesSizeMb
FROM
    sys.master_files mf
INNER JOIN 
    sys.databases db ON db.database_id = mf.database_id
GROUP BY db.name, type_desc, substring(Physical_Name,1,1) 
ORDER BY DBName, DriveName, FileType

SELECT
    type_desc AS FileType,
	substring(Physical_Name,1,1) DriveName,
    sum(Cast(Round(cast(size as decimal) * 8.0/1024.0,2) as decimal(18,0))) FilesSizeMb
FROM
    sys.master_files mf
INNER JOIN 
    sys.databases db ON db.database_id = mf.database_id
GROUP BY db.name, type_desc, substring(Physical_Name,1,1) 
ORDER BY DriveName, FileType

SELECT
	substring(Physical_Name,1,1) DriveName,
    sum(Cast(Round(cast(size as decimal) * 8.0/1024.0,2) as decimal(18,0))) FilesSizeMb
FROM
    sys.master_files mf
INNER JOIN 
    sys.databases db ON db.database_id = mf.database_id
GROUP BY substring(Physical_Name,1,1) 
ORDER BY DriveName

SELECT	
    type_desc AS FileType,	
	substring(Physical_Name,1,1) DriveName,
    sum(Cast(Round(cast(size as decimal) * 8.0/1024.0,2) as decimal(18,0))) FilesSizeMb	
FROM	
    sys.master_files mf	
INNER JOIN 	
    sys.databases db ON db.database_id = mf.database_id	
GROUP BY  substring(Physical_Name,1,1), type_desc	
ORDER BY DriveName, FileType

-- EMPTY SPACE
-- I am using script to get empty space in each file:

Create Table ##temp
(
    DatabaseName sysname,
    Name sysname,
    physical_name nvarchar(500),
    size decimal (18,2),
    FreeSpace decimal (18,2)
)   
Exec sp_msforeachdb '
Use [?];
Insert Into ##temp (DatabaseName, Name, physical_name, Size, FreeSpace)
    Select DB_NAME() AS [DatabaseName], Name,  physical_name,
    Cast(Cast(Round(cast(size as decimal) * 8.0/1024.0,2) as decimal(18,2)) as nvarchar) Size,
    Cast(Cast(Round(cast(size as decimal) * 8.0/1024.0,2) as decimal(18,2)) -
        Cast(FILEPROPERTY(name, ''SpaceUsed'') * 8.0/1024.0 as decimal(18,2)) as nvarchar) As FreeSpace
    From sys.database_files
'
Select * From ##temp
drop table ##temp

-- EMPTY SPACE
-- I've created this query:

SELECT 
    db.name AS                                   [Database Name], 
    mf.name AS                                   [Logical Name], 
    mf.type_desc AS                              [File Type], 
    mf.physical_name AS                          [Path], 
    CAST(
        (mf.Size * 8
        ) / 1024.0 AS DECIMAL(18, 1)) AS         [Initial Size (MB)], 
    'By '+IIF(
            mf.is_percent_growth = 1, CAST(mf.growth AS VARCHAR(10))+'%', CONVERT(VARCHAR(30), CAST(
        (mf.growth * 8
        ) / 1024.0 AS DECIMAL(18, 1)))+' MB') AS [Autogrowth], 
    IIF(mf.max_size = 0, 'No growth is allowed', IIF(mf.max_size = -1, 'Unlimited', CAST(
        (
                CAST(mf.max_size AS BIGINT) * 8
        ) / 1024 AS VARCHAR(30))+' MB')) AS      [MaximumSize]
FROM 
     sys.master_files AS mf
     INNER JOIN sys.databases AS db ON
            db.database_id = mf.database_id
