#!/bin/bash

user="ec2-user"

as_user() {
  if [ $(whoami) = $user ]; then
    bash -c "$1"
  else
    sudo -u $user /bin/bash -c "$1" || exit 1
  fi
}


echo 'This script will create the necessary directory structure, move files und create links to run a minecraft server. It should be run with sudo.'
echo 'It expects all files distributed with the package to be in the same directory as this script.'
echo 'When using dos_ctrl_ec2 package, the path should be /mnt/app.'
echo 'It expects the installation directory to be /mnt/app and the persistent target device to be mounted  on this directory. The device needs to be partitioned (sudo cfdisk /mnt/sdf), contain a filesystem (sudo mke2fs /dev/sdf1) and should be marked as persistent on the AWS console.'
echo 'Before running the minecraft server you will have to accept the eula.txt.'
echo '*************************************'
echo

target="/mnt/app"
source="${BASH_SOURCE%/*}"

chown $user "$target"
chgrp $user "$target"

# Setup directories.
echo "Creating directory structure in ${target}..."
as_user "mkdir -p \"${target}/backup/worlds\" || { echo 'Failed!'; exit 1 ; }"
as_user "mkdir -p \"${target}/minecraft-jar\" || { echo 'Failed!'; exit 1 ; }"
as_user "mkdir -p \"${target}/minecraft-server/logs\" || { echo 'Failed!'; exit 1 ; }"
as_user "mkdir -p \"${target}/minecraft-server/map\" || { echo 'Failed!'; exit 1 ; }"
as_user "mkdir -p \"${target}/service-script\" || { echo 'Failed!'; exit 1 ; }"
as_user "ln -s \"${target}/minecraft-server/map\" \"${target}/minecraft-server/world\" || { echo 'Failed!'; exit 1 ; }"

echo "Copying and moving files..."
as_user "cp \"${source}/start.sh\" \"${target}\" || { echo 'Failed!'; exit 1 ; }"
as_user "cp \"${source}/minecraft\" \"${target}/service-script\" || { echo 'Failed!'; exit 1 ; }"
as_user "cp \"${source}/config.default\" \"${target}/service-script\" || { echo 'Failed!'; exit 1 ; }"
as_user "cp \"${source}/config.default\" \"${target}/service-script/config\" || { echo 'Failed!'; exit 1 ; }"

echo "Marking files as executable..."
chmod u+x "${target}/start.sh" || { echo 'Failed!'; exit 1 ; }
chmod u+x "${target}/service-script/minecraft" || { echo 'Failed!'; exit 1 ; }
chmod u+x "${target}/service-script/config.default" || { echo 'Failed!'; exit 1 ; }
chmod u+x "${target}/service-script/config" || { echo 'Failed!'; exit 1 ; }

# Install service.
echo "Installing LSB core for init script."
yum install -y redhat-lsb-core

echo 'Installing Minecraft service script in init.d.'
ln -s "${target}/service-script/config" /etc/default/minecraft
ln -s "${target}/service-script/minecraft" /etc/init.d/minecraft
chkconfig --add minecraft

echo 'Preparing Minecraft server config...'
service minecraft config server "${target}/minecraft-server"
service minecraft config resources "${target}/minecraft-jar"

echo 'Downloading Minecraft server jar file of current release.'
# Simulate outdated minecraft version.
echo minecraft server version 1.7.2 > "${target}/minecraft-server/console.output"
service minecraft update

service minecraft start

if [[ $? ]]; then
    echo 'Minecraft service could not be started.'
    echo "Please check eula.txt and logs in ${target}."
fi
