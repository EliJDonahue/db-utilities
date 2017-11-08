@echo off
setlocal enabledelayedexpansion

REM Set parameters
@CALL preferences.cmd

REM get target server and database name
REM set svr to the name of your machine
set svr=%svr%
set /p db= Enter target database name: 
set db1='%db%'
set bak= %1%
set bak=%bak:"='%
for /f "tokens=* delims= " %%a in ("%bak%") do set bak=%%a
set bak=N%bak%

REM check whether input file is a .bak
set ext=%bak:~-5,4%
if /i %ext% EQU .bak goto continue
echo.         
echo .... NOT A .BAK FILE!
echo. 
echo Press any key to exit and try another file.
pause>nul
exit

:continue
REM check whether database exists and make sure user wants to overwrite it
echo.         
echo .... CHECKING WHETHER DATABASE EXISTS
echo.     
sqlcmd -U sa -P innovator -S %svr% -i C:\Utilities\BAKTools\queries\exists.sql -v dbname=%db1% bak_file="%bak%" -o C:\Utilities\BAKTools\logs\exists.log
type C:\Utilities\BAKTools\logs\exists.log
pause>nul

REM run restore query
echo.      
echo .... BEGINNING RESTORE NOW
echo.     
sqlcmd -U sa -P innovator -S %svr% -i C:\Utilities\BAKTools\queries\restore_db.sql -v dbname=%db1% bak_file="%bak%" -o C:\Utilities\BAKTools\logs\log.log

REM run three queries
echo ..............................................................
echo.  
echo .... RUNNING POST-RESTORE QUERIES
echo.     
echo .... QUERY 1
echo.     
sqlcmd -U sa -P innovator -S %svr% -i C:\Utilities\BAKTools\queries\sp_change_users_login.sql -v dbname=%db% -o C:\Utilities\BAKTools\logs\users.log
echo .... QUERY 2
echo.     
sqlcmd -U sa -P innovator -S %svr% -i C:\Utilities\BAKTools\queries\sp_grantdbaccess.sql -v dbname=%db% -o C:\Utilities\BAKTools\logs\access.log 
echo .... QUERY 3
echo.     
sqlcmd -U sa -P innovator -S %svr% -i C:\Utilities\BAKTools\queries\sp_addrolemember.sql -v dbname=%db% -o C:\Utilities\BAKTools\logs\role.log
echo ..............................................................
echo.       

@REM is it a customer database?
@REM :check_if_customer
@REM set /p cust= Restoring a customer database? [y/n] 
@REM if /i %cust% EQU y goto is_customer
@REM if /i %cust% EQU n goto restore_done
@REM REM invalid input
@REM echo "Choose y or n."
@REM echo.
@REM goto check_if_customer

	@REM REM it's a customer db, so run customer queries
	@REM :is_customer
	@REM echo.     
	@REM echo .... RUNNING CUSTOMER RESTORE QUERIES
	@REM echo.     
	@REM sqlcmd -U sa -P innovator -S %svr% -i C:\Utilities\BAKTools\queries\customer_restore.sql -v dbname=%db% -o C:\Utilities\BAKTools\logs\customer.log

REM done running queries!
:restore_done
echo.
echo ..............................................................
echo.    
echo .... RESTORE PROCESS COMPLETE
echo.    
pause