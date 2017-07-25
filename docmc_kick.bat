@ECHO OFF
REM Batch file to kick user off the Minecraft server.
SETLOCAL enabledelayedexpansion

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

REM Let user type in minecraft user name to add.
ECHO Bitte geben Sie den Minecraft User Namen ein, der vom Server gekickt werden soll.
SET /P _input=

REM This remove-unwanted-chars-in-string solution was shared by jeb on stack overflow. Thank you!
set "_output="
set "map=abcdefghijklmnopqrstuvwxyz1234567890_"

:loop
if not defined _input goto endLoop    
for /F "delims=*~ eol=*" %%C in ("!_input:~0,1!") do (
    if "!map:%%C=!" NEQ "!map!" set "_output=!_output!%%C"
)
set "_input=!_input:~1!"
    goto loop
:endLoop

IF DEFINED _output (
	CALL %CTRL_PATH%ec2_send_command.bat %1 sudo -u ec2-user %SRV_INSTALL_PATH%bin/app_cmd.sh 'kick %_output%'
) ELSE (
  ECHO Eingabe des Minecraft User Namen war leer. Kick konnte nicht ausgefuehrt werden.
)

PAUSE
REM Restore previous current directory.
CD /D %EXCURRENTDIR%