@ECHO OFF
REM Batch file to launch EC2 instance with Minecraft Server for running docker app.
SETLOCAL enabledelayedexpansion

REM Remember previous current directory.
SET EXCURRENTDIR=%CD%

REM Switch current directory to installation directory.
CD /D %~dp0

SET _CONFIG=%1
SET _MAP_ID=%2
IF NOT DEFINED _CONFIG (
  ECHO Es muss ein Konfigurationskuerzel als erster Parameter angegeben werden.
  PAUSE
  EXIT /B 1
)
SET CONFIGFILE=config\docmc_config_%_CONFIG%.bat

REM Check if config file exists. If not complain.
IF NOT EXIST %CONFIGFILE% (
	ECHO Konfigurationsdatei %CONFIGFILE% nicht gefunden.
    PAUSE
	EXIT /B 1
	)

REM Load configuration variables.
CALL %CONFIGFILE% %_CONFIG%

REM Launch ec2 instance.
CALL %CTRL_PATH%ec2_launch.bat %1
IF ERRORLEVEL 1 (
  PAUSE
  EXIT /B 1
  )

echo Warte auf Ende der App Installation.
TIMEOUT /T 30 /NOBREAK > nul

REM Run map.
docmc_runmap.bat %_CONFIG%

REM Restore previous current directory.
CD /D %EXCURRENTDIR%

PAUSE
