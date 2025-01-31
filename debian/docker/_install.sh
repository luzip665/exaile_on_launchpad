#!/bin/bash -x

echo "MIRROR=ftp.debian.org" > /etc/pbuilderrc

apt update
apt -y upgrade
apt -y install devscripts debhelper-compat python3 python3-sphinx python3-gi-cairo help2man licenserecon
apt -y install pbuilder
