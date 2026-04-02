/*--------------------------------------------------------------------------
  03/30/2026:
  This script returns backup history of all databases on the instance
--------------------------------------------------------------------------*/
SELECT
    CONVERT(sysname, SERVERPROPERTY('ServerName'))          ServerName,
    bs.database_name                                        DBName,
    bs.backup_start_date                                    BackupStartDate,
    bs.backup_finish_date                                   BackupFinishDate,
    DATEDIFF(SECOND, bs.backup_start_date, bs.backup_finish_date) 
                                                            DurationInSeconds,
    CASE bs.type
        WHEN 'D' THEN 'Full'
        WHEN 'I' THEN 'Differential'
        WHEN 'L' THEN 'Log'
        WHEN 'F' THEN 'File/Filegroup'
        WHEN 'G' THEN 'Differential File'
        WHEN 'P' THEN 'Partial'
        WHEN 'Q' THEN 'Differential Partial'
    END AS                                                  BackupType,
    CAST(bs.backup_size / 1024.0 / 1024.0 AS DECIMAL(18,2)) BackupSizeMB,
    bmf.physical_device_name                                BackupDevice,
    bmf.device_type                                         DeviceType,
    bs.name                                                 BackupsetName,
    bs.description                                          Descr
FROM msdb.dbo.backupset AS bs
JOIN msdb.dbo.backupmediafamily AS bmf
    ON bs.media_set_id = bmf.media_set_id
WHERE DATEDIFF(DAY,bs.backup_start_date, GETDATE()) <= 90 --********Change this value ***********
ORDER BY
    bs.database_name,
    bs.backup_finish_date DESC;