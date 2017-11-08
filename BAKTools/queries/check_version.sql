DECLARE @disk nvarchar(1020);
SET @disk=$(bak_file);	
print @disk;	
EXEC('RESTORE HEADERONLY FROM Disk = ''' + @disk + '''');