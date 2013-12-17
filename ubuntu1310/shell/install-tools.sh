#!/bin/sh
sudo apt-get -y install compizconfig-settings-manager
sudo apt-get -y install vim git
sudo apt-get -y install nodejs nodejs-legacy npm
sudo npm install -g yo
sudo npm install -g generator-webapp
sudo npm install -g generator-angular

echo "vagrant soft nofile 80000" | sudo tee -a /etc/security/limits.conf
echo "vagrant hard nofile 80000" | sudo tee -a /etc/security/limits.conf

echo "export GIT_EDITOR=vim" >> /home/vagrant/.bashrc

# git clone https://StefanScherer@bitbucket.org/StefanScherer/node-netserver-test.git
