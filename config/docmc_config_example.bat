REM @ECHO OFF
REM Path to dos_ctrl_ec2 batch files. Must end with a backslash. (Required)
SET CTRL_PATH=..\dos_ctrl_ec2\

REM Load dos_ctrl_ec2 config.
SET _CONFIG=%1
IF NOT DEFINED _CONFIG (
  ECHO Es muss ein Konfigurationskuerzel als Parameter angegeben werden.
  EXIT /B 1
)
SET CONFIGFILE=%CTRL_PATH%\config\ec2_config_%_CONFIG%.bat

REM Check if config file exists. If not complain.
IF NOT EXIST %CONFIGFILE% (
	ECHO Konfigurationsdatei %CONFIGFILE% nicht gefunden.
	EXIT /B 1
	)

REM Load configuration variables.
CALL %CONFIGFILE%

REM ******* Configuration ******* 
REM Edit here to setup script for your environment.

REM Bucket Name for storage of maps, logs, config-templates. (Required)
SET BUCKET=my-mc-bucket

REM S3 Prefix for storing maps. (Required)
SET MAP_S3_KEY=maps/

REM URL to download file with map_ids to choose from in docmc_runmap.bat
SET URL_MAP_ID_FILE=https://s3.eu-central-1.amazonaws.com/my-mc-bucket/map_ids.txt

REM Path to app installation on ec2 server. (Required)
SET SRV_INSTALL_PATH=/opt/app/
