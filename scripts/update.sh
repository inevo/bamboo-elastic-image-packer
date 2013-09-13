#!/bin/sh

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoclean

# ensure the correct kernel headers are installed
apt-get -y install linux-headers-$(uname -r)

apt-get -y clean