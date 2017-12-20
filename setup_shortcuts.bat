@ECHO OFF
SETLOCAL enabledelayedexpansion

ECHO Dieser Batch erstellt in diesem Verzeichnis Verknuepfungen zu den Batch Dateien und benennt diese. Sie muss im Verzeichnis oberhalb von dos_ec2_docker_minecraft ausgefuehrt werden.

SET _DIR=%~dp0

REM Are we in the right directory?
IF EXIST %_DIR%docmc_launch.bat (
	REM We dont need to use a subdirectory.
	SET _BAT_DIR=
) ELSE (
	IF NOT EXIST %_DIR%dos_ec2_docker_minecraft\docmc_launch.bat (
		ECHO Konnte zu verknuepfende Dateien weder unter %_DIR% noch unter %_DIR%%_BAT_DIR% finden
		ECHO Breche ab.
		PAUSE
		EXIT /B 1
	)
	SET _BAT_DIR=dos_ec2_docker_minecraft
)

ECHO Bitte geben Sie das Kuerzel der zu verwendenden dos_ctrl_ec2 Konfigurationsdatei ein.
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

IF NOT DEFINED _output (
	ECHO Sie haben keinen gueltigen Wert fuer das Kuerzel eingegeben.
	EXIT /B 1
	PAUSE
)

REM docmc_save_map.bat
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%_DIR%\AWS EC2 Karte speichern %_output%.lnk');$s.TargetPath='%_DIR%%_BAT_DIR%\docmc_savemap.bat'; $s.Arguments='%_output%'; $s.WorkingDirectory='%_DIR%%_BAT_DIR%';$s.Save()"

REM docmc_render_map.bat
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%_DIR%\AWS EC2 Kartenuebersicht aktualisieren %_output%.lnk');$s.TargetPath='%_DIR%%_BAT_DIR%\docmc_rendermap.bat'; $s.Arguments='%_output%'; $s.WorkingDirectory='%_DIR%%_BAT_DIR%'; $s.Save()"

REM docmc_kick.bat
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%_DIR%\AWS EC2 Kick Spieler vom Server %_output%.lnk');$s.TargetPath='%_DIR%%_BAT_DIR%\docmc_kick.bat'; $s.Arguments='%_output%'; $s.WorkingDirectory='%_DIR%%_BAT_DIR%'; $s.Save()"

REM docmc_launch.bat
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%_DIR%\AWS EC2 STARTE Server %_output%.lnk');$s.TargetPath='%_DIR%%_BAT_DIR%\docmc_launch.bat'; $s.Arguments='%_output%'; $s.WorkingDirectory='%_DIR%%_BAT_DIR%'; $s.Save()"

REM docmc_punish.bat
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%_DIR%\AWS EC2 Bestrafe Spieler %_output%.lnk');$s.TargetPath='%_DIR%%_BAT_DIR%\docmc_punish.bat'; $s.Arguments='%_output%'; $s.WorkingDirectory='%_DIR%%_BAT_DIR%'; $s.Save()"

REM docmc_runmap.bat
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%_DIR%\AWS EC2 Karte laden %_output%.lnk');$s.TargetPath='%_DIR%%_BAT_DIR%\docmc_runmap.bat'; $s.Arguments='%_output%'; $s.WorkingDirectory='%_DIR%%_BAT_DIR%'; $s.Save()"

REM docmc_terminate.bat
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%_DIR%\AWS EC2 BEENDE Server %_output%.lnk');$s.TargetPath='%_DIR%%_BAT_DIR%\docmc_terminate.bat'; $s.Arguments='%_output%'; $s.WorkingDirectory='%_DIR%%_BAT_DIR%'; $s.Save()"

REM docmc_whitelist_add.bat
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%_DIR%\AWS EC2 Spieler zur Whitelist hinzufuegen %_output%.lnk');$s.TargetPath='%_DIR%%_BAT_DIR%\docmc_whitelist_add.bat'; $s.Arguments='%_output%'; $s.WorkingDirectory='%_DIR%%_BAT_DIR%'; $s.Save()"

REM docmc_whitelist_list.bat
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%_DIR%\AWS EC2 Namen auf der Whitelist anzeigen %_output%.lnk');$s.TargetPath='%_DIR%%_BAT_DIR%\docmc_whitelist_list.bat'; $s.Arguments='%_output%'; $s.WorkingDirectory='%_DIR%%_BAT_DIR%'; $s.Save()"

REM docmc_whitelist_remove.bat
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%_DIR%\AWS EC2 Namen von der Whitelist entfernen %_output%.lnk');$s.TargetPath='%_DIR%%_BAT_DIR%\docmc_whitelist_remove.bat'; $s.Arguments='%_output%'; $s.WorkingDirectory='%_DIR%%_BAT_DIR%'; $s.Save()"

ECHO Verknuepfungen wurden erstellt und koennen jetzt ins Zielverzeichnis verschoben werden.

PAUSE
