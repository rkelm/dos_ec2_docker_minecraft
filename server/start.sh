#!/bin/bash
# Start script for setup and start of minecraft server.
# Should be called with root user rights, after server initialization.
echo start.sh script is starting.

# Get path to mount point.
mnt_pt=$(dirname `which $0`)

# Install LSB core for init script.
yum install -y redhat-lsb-core

# Install Minecraft service init script.
echo 'Installing Minecraft server script in init.d.'
ln -s "${mnt_pt}/service-script/config" /etc/default/minecraft
ln -s "${mnt_pt}/service-script/minecraft" /etc/init.d/minecraft
chkconfig --add minecraft

echo 'Starting Minecraft service.'
service minecraft start

echo start.sh script done.
