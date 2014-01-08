#!/bin/sh
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get -y -f install
rm google-chrome-stable_current_amd64.deb

sudo apt-get -y install compizconfig-settings-manager
sudo apt-get -y install vim git
sudo apt-get -y install nodejs nodejs-legacy npm
sudo npm install -g yo
sudo npm install -g generator-webapp
sudo npm install -g generator-angular
sudo npm install -g express

git config --global user.name "StefanScherer"
git config --global user.email scherer_stefan@icloud.com
git config --global credential.helper cache

echo "vagrant soft nofile 80000" | sudo tee -a /etc/security/limits.conf
echo "vagrant hard nofile 80000" | sudo tee -a /etc/security/limits.conf

echo "export GIT_EDITOR=vim" >> /home/vagrant/.bashrc

# git clone https://StefanScherer@bitbucket.org/StefanScherer/node-netserver-test.git
