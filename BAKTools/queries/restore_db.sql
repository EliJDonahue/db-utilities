-- RESTORE DATABASE $(dbname) FROM DISK = $(bak_file)
PRINT '    ';
PRINT '.... BEGINNING RESTORE QUERY';
PRINT '    ';
USE master;
GO

DECLARE @ldf_name nvarchar(160);
DECLARE @mdf_name nvarchar(160);
DECLARE @new_ldf nvarchar(320);
DECLARE @new_mdf nvarchar(320);
DECLARE @dbname nvarchar(320);
DECLARE @disk nvarchar(1020);

-- set database name and file path from bat script
SET @dbname=$(dbname);
SET @disk=$(bak_file);

--PRINT @disk;

--SET @dbname='Test100SP3';
--SET @disk='C:\Utilities\RestoreDB\CoreAndSolutions100.bak';

-- if we're overwriting an existing database, nuke all connections
IF @dbname IS NOT NULL 
BEGIN
	PRINT '    ';
	PRINT '.... KILLING ALL PREVIOUS CONNECTIONS TO RESTORE';
	PRINT '    ';
	declare @kill varchar(8000) = '';
	select @kill=@kill+'kill '+convert(varchar(5),spid)+';'
	from master..sysprocesses 
	where dbid=db_id(@dbname);
	exec (@kill);
END


-- get the logical names of the log and data files
DECLARE @Table TABLE (LogicalName varchar(128),[PhysicalName] varchar(128), [Type] varchar, [FileGroupName] varchar(128), [Size] varchar(128), 
            [MaxSize] varchar(128), [FileId]varchar(128), [CreateLSN]varchar(128), [DropLSN]varchar(128), [UniqueId]varchar(128), [ReadOnlyLSN]varchar(128), [ReadWriteLSN]varchar(128), 
            [BackupSizeInBytes]varchar(128), [SourceBlockSize]varchar(128), [FileGroupId]varchar(128), [LogGroupGUID]varchar(128), [DifferentialBaseLSN]varchar(128), [DifferentialBaseGUID]varchar(128), [IsReadOnly]varchar(128), [IsPresent]varchar(128), [TDEThumbprint]varchar(128)
)
INSERT INTO @table
EXEC('
RESTORE FILELISTONLY 
   FROM DISK=''' +@disk+ '''
   ')
SET @mdf_name=(SELECT LogicalName FROM @Table WHERE Type='D')
SET @ldf_name=(SELECT LogicalName FROM @Table WHERE Type='L')

-- set new names for the log and data files
SET @new_mdf='C:\DataFiles\';
SET @new_ldf='C:\DataFiles\';
SET @new_mdf+=@dbname;
SET @new_ldf+=@dbname;
SET @new_mdf+='_Data.mdf';
SET @new_ldf+='_Log.ldf';

PRINT '    ';
PRINT '.... BEGINNING RESTORE';
PRINT '    ';
-- restore the database
RESTORE DATABASE @dbname 
FROM DISK = @disk
WITH
FILE = 1,
MOVE @mdf_name TO @new_mdf,  
MOVE @ldf_name TO @new_ldf,
REPLACE;
GO

PRINT '    ';
PRINT '.... DATABASE RESTORE COMPLETE';
PRINT '    ';
PRINT '..............................................................';