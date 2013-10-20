#!/bin/sh
sudo apt-get -y install git make
git clone https://github.com/StefanScherer/curl-loader
sudo chown -R vagrant:vagrant curl-loader
cd curl-loader
mkdir obj
make
sudo make install
cd ..
