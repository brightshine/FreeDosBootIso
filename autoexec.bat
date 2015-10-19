@echo off 
set lang=EN
set PATH=%dosdir%
set NLSPATH=%dosdir%
set HELPPATH=%dosdir%
set temp=%dosdir%
set tmp=%dosdir%
SET BLASTER=A220 I5 D1 H5 P330
set DIRCMD=/P /OGN
if "%config%"=="4" goto end
lh doslfn 
SHSUCDX /QQ /D3
IF EXIST FDBOOTCD.ISO LH SHSUCDHD /Q /F:FDBOOTCD.ISO
LH FDAPM APMDOS
if "%config%"=="2" LH SHARE
REM LH DISPLAY CON=(EGA,,1)
REM REM NLSFUNC C:\FDOS\COUNTRY.SYS
REM REM MODE CON CP PREP=((858) A:\cpi\EGA.CPX)
REM REM MODE CON CP SEL=858
REM REM CHCP 858
REM REM LH KEYB US,,C:\FDOS\KEY\US.KL  
REM DEVLOAD /H /Q %dosdir%\uide.sys /D:FDCD0001 /S5
REM ShsuCDX /QQ /~ /D:?SHSU-CDH /D:?FDCD0001 /D:?FDCD0002 /D:?FDCD0003
REM mem /c /n
REM shsucdx /D
REM goto end
REM :end
REM SET autofile=C:\autoexec.bat
REM SET CFGFILE=C:\config.sys
REM alias reboot=fdapm warmboot
REM alias halt=fdapm poweroff
REM echo type HELP to get support on commands and navigation
REM echo.
REM echo Welcome to FreeDOS 1.1
REM echo
