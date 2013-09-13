#!/bin/sh

# Enable the multiverse repos
sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list

apt-get update

# Install the deps
apt-get -y install ec2-api-tools unzip

# Add the bamboo user
useradd -m bamboo

# Downloading agent installer to the instance
imageVer=3.0
wget https://maven.atlassian.com/content/repositories/atlassian-public/com/atlassian/bamboo/atlassian-bamboo-elastic-image/${imageVer}/atlassian-bamboo-elastic-image-${imageVer}.zip
mkdir -p /opt/bamboo-elastic-agent
unzip -o atlassian-bamboo-elastic-image-${imageVer}.zip -d /opt/bamboo-elastic-agent
chown -R bamboo /opt/bamboo-elastic-agent
chmod -R u+r+w /opt/bamboo-elastic-agent

# Instance configuration

chown -R bamboo:bamboo /home/bamboo/

# Configure path variables
echo "export PATH=/opt/bamboo-elastic-agent/bin:\$PATH" > /etc/profile.d/bamboo.sh

# Configure automatic startup of the Bamboo agent (add before line 14 of /etc/rc.local
sed -i '14 i . /opt/bamboo-elastic-agent/etc/rc.local' /etc/rc.local

# Welcome screen
cp /opt/bamboo-elastic-agent/etc/motd /etc/motd
echo bamboo-5.0.2  >> /etc/motd
