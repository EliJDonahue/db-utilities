@echo off
setlocal enabledelayedexpansion

REM Set parameters
@CALL preferences.cmd

set svr=%svr%
REM process file path
set bak= %1%
echo %bak%
set bak=%bak:"='%
echo %bak%
for /f "tokens=* delims= " %%a in ("%bak%") do set bak=%%a
set bak=N%bak%
echo %bak%

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
REM run query
echo %bak%
echo.         
echo .... CHECKING HEADER FOR SQL SERVER VERSION
echo.     
REM sqlcmd -U sa -P innovator -S %svr% -i C:\Utilities\BAKTools\queries\check_version.sql -v bak_file= "%bak%" -o C:\Utilities\BAKTools\logs\check_version.log
bcp "EXEC('RESTORE HEADERONLY FROM Disk = ''' + %bak% + '''')" queryout C:\Utilities\BAKTools\logs\check_version.xml -U sa -P innovator -S %svr% -c -x -n
type C:\Utilities\BAKTools\logs\check_version.xml
pause