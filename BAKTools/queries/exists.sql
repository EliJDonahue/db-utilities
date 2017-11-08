if db_id($(dbname)) is not null 
	begin
		print '.... DATABASE ALREADY EXISTS!'
		PRINT '    ';
		print 'Press any key to continue and overwrite the database.'
		print 'Exit the command prompt window to cancel.'
	end
else
	begin
		print '.... NO DATABASE TO OVERWRITE!'
		print '.... NEW DATABASE WILL BE CREATED'
		PRINT '    ';
		print 'Press any key to continue.'
	end