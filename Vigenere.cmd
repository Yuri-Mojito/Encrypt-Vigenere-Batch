@echo off 
title ENCRIPT VIGENERE- -coded by YURI
Rem This code encript your password to Vigenere system
Rem o :: comment
setlocal enabledelayedexpansion
color 0A 
Rem color 0A 0=black and A=green Light colors of the console
set TheABC=nam a b c d e f g h i j k l m n o p q r s t u v w x y z
REM English system 26 Letters
@set /a "cont=-1"

set abc[0].Letters=Letters
set abc[0].ID=ID

set key[0].Letters=Letters
set key[0].ID=ID

set pass[0].Letters=Letters
set pass[0].ID=ID

set encrypt[0].Letters=Letters
set encrypt[0].ID=ID

set "strEn="

(for %%v in (%TheABC%) do (
	set /a "cont=1+!cont!"
	set "abc[!cont!].Letters=%%v"
	set "abc[!cont!].ID=!cont!"
))

@ECHO. 
::Echo. REM Line steps
echo "Key"
@ECHO.
set /p key=

echo "Password"
@ECHO.
set /p pass=
:: Echo the length of TEST
::call :strLen pass

:: call the function strLen to lenght the string
call :strLen key keylen
call :strLen pass passlen

set /a q=%passlen% * 1000 / %keylen%
::echo q=%q:~0,-3%.%q:~-3%
REM number with decimal bc the batch system its only integer system
set /a dec=%q:~-3%
set /a int=%q:~0,-3%

if %dec% EQU 0 (
	set /a rounded=%int%-1
)
REM its the times of repeat the key lenght like keykeykey n number depends of password lentgh
if %dec% NEQ 0 (
	set /a rounded=%int%
)

set "name=%key%"
set "num=-1"
set "chain[0]=1"

REM string to char key
:loop
	set /a "num=num+1"
	call set "name2=%%name:~%num%,1%%"
	if defined name2 (
		::echo(%name2%,%num%
		set chain[%num%]=%name2%
		goto :loop
	)	

set "nametwo=%pass%"
set "numtwo=-1"
set "chaintwo[0]=1"
@set /a "con=0"

REM string to char password
:loopone
	set /a "numtwo=numtwo+1"
	call set "nameto=%%nametwo:~%numtwo%,1%%"
	if defined nameto (
		set /a "con=!numtwo!+1"
		::echo(%nameto%,%numtwo%
		set chaintwo[!con!]=%nameto%
		goto :loopone
)

@set /a "nan=%keylen%-1"
set /a "keyString[0]=1"
@set /a "l=0"

REM string to char password
for /l %%n in (0,1,%rounded%) do ( 
	@set /a "m=0"
	for /l %%m in (0,1,%nan%) do ( 
		set /a "l=1+!l!"
		set "keyString[!l!]=!chain[%%m]!"
		if !l! EQU %passlen% (
			goto :continue
		)
	)
)

REM for to debug the arrays
::for /l %%t in (0,1,%passlen%) do ( 
::	echo !keyString[%%t]!
::)

:continue
REM save the arrays 
for /l %%n in (1,1,%passlen%) do (
	set "key[%%n].Letters=!keyString[%%n]!"
	set "pass[%%n].Letters=!chaintwo[%%n]!"
)

REM find ids for key
for /l %%z in (1,1,%passlen%) do (
	call :findStrAndSetId !key[%%z].Letters! abc id
	set "key[%%z].ID=!id!"
)
REM find ids for pass
for /l %%x in (1,1,%passlen%) do (
	call :findStrAndSetId !pass[%%x].Letters! abc id
	set "pass[%%x].ID=!id!"
)
REM find the Encrypted ids 
for /l %%y in (1,1,%passlen%) do (
	call :moduler !key[%%y].ID! !pass[%%y].ID! encryptID
	set "encrypt[%%y].ID=!encryptID!"
)

@ECHO.
REM find the Encrypted Lyrics
for /l %%w in (1,1,%passlen%) do (
	call :findIdAndSetStr !encrypt[%%w].ID! abc str
	set "encrypt[%%w].Letters=!str!"
)

REM Finally char to string Encrypted password
for /l %%v in (1,1,%passlen%) do (
	set "strEn=!strEn!!encrypt[%%v].Letters!"
)
REM Print the var
call echo Encript=%strEn%
echo !strEn!

REM Keep your windows batch open
pause 

REM function string lenght
:strLen  strVar  [rtnVar]
setlocal disableDelayedExpansion
set len=0
if defined %~1 for /f "delims=:" %%N in ('"(cmd /v:on /c echo(!%~1!&echo()|findstr /o ^^"') do set /a "len=%%N-3"
endlocal & if "%~2" neq "" (set %~2=%len%) else echo %len%
exit /b

REM function find the id from the Letters
:findStrAndSetId
set abc = Inner
set "%~2=%abc%"
for /L %%i in (1 1 26) do  (
	if /I "%~1"=="!%~2[%%i].Letters!" (
		set /a "%~3=!%~2[%%i].ID!"
		goto :next
	)	
)
:next
exit /b

REM function find the Letters from id
:findIdAndSetStr
set abc = Inner
set "%~2=%abc%"
for /L %%j in (1 1 26) do  (
	if %~1 EQU !%~2[%%j].ID! (
		set %~3=!%~2[%%j].Letters!
		goto :next1
	)	
)
:next1
exit /b

REM the formule to find encrypted letters
:moduler
	set /a sum=%~1+%~2
	set /a mod=%sum% %% 26
	set /a div=%sum% * 1000/26
	
	REM this formule have 2 errors when 
	REM the sum is equal to 26 and the  
	REM mod is 26 in english language 
	REM the modular is zero but this
	REM error can solved bc in all cases 
	REM the Letter is y 
	if %mod% EQU 0 ( 
		set /a %~3=%div:~0,-3%*25
		goto :jump
	)
	REM and z bc the module 27 mod 26  
	REM its to much decimals in it 
	REM number in batch cant have 
	REM decimal like another languages
	if %sum% EQU 27 ( 
		set /a %~3=%div:~0,-3%*26
		goto :jump
	)
	
	set /a mult=%div:~-3%*26
	set /a %~3=%mult%/1000
	
	:jump
exit /b