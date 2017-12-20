@ECHO OFF
REM Batch file to save the currently running map without stopping it.
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

ECHO Speichere aktuelle Karte.
CALL %CTRL_PATH%ec2_send_command.bat %1 sudo -u ec2-user %SRV_INSTALL_PATH%bin/save_map.sh

PAUSE

REM Restore previous current directory.
CD /D %EXCURRENTDIR%
