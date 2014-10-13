#!/bin/bash
wget -qO - http://apt.sealsystems.local/repository.pub | sudo apt-key add -
UBUNTU_VERSION=`lsb_release -c | grep -o "\S*$"` && \
cat <<APT_SOURCE | sudo tee /etc/apt/sources.list.d/plossys.list
deb http://apt.sealsystems.local/plossys testing main
deb http://apt.sealsystems.local/mirror/nodejs $UBUNTU_VERSION main
APT_SOURCE
sudo apt-get update -y
sudo apt-get install plossys -y
