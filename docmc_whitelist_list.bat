@ECHO OFF
REM Batch file to list whitelisted user on EC2 Minecraft Server.
SETLOCAL enabledelayedexpansion
REM Remember previous current directory.
SET EXCURRENTDIR=%CD%

REM Switch current directory to installation directory.
CD /D %~dp0

SET _CONFIG=%1
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

ECHO Rufe Whitelist des Minecraft Servers ab.
CALL %CTRL_PATH%ec2_send_command.bat %_CONFIG% sudo -u ec2-user %SRV_INSTALL_PATH%bin/app_cmd.sh 'whitelist list'
 
PAUSE
