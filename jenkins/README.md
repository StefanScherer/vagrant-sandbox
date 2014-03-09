# jenkins
This is an example to set up a Jenkins server with a Windows slave and an Ubuntu slave.  
The following machines will be created

* `192.168.33.214 ci    ` - the Jenkins Server with web interface listening on port 80
* `192.168.33.215 slave1` - the Windows 2012 R2 slave
* `192.168.33.216 slave2` - the Ubuntu 12.04 LTS slave

The slaves will be plugged in with the swarm-client, so feel free to add more slaves in the Vagrantfile if you need more.

# Getting started
If you want to use the backup and restore function to save and install Jenkins job configurations
using grunt, install some dependencies with

    npm install

Otherwise, or after that, you only have to type

    vagrant up

and then the Jenkins server and the Windows and Ubuntu slaves will be started.  
For Windows, you need a `windows_2012_r2` box.  
For Ubuntu, the default `precise64` box will be used.

## Manage Jenkins configuration

After each time you made changes to the global Jenkins configuration, plugins
or jobs just do:

    grunt jenkins-backup

This will backup all stuff to the jenkins-configuration folder. You may put it
under version control, yay!

You can install jenkins configuration using:

    grunt jenkins-install

When you added / removed plugins you must restart Jenkins:

    open http://192.168.33.214/safeRestart

## View Jenkins Web Interface
If you just want to view into Jenkins use this command:

    open http://192.168.33.214/


## TODO
* In both install-jenkins-slave scripts the autoDiscoveryAddress must match your internal network for the UDP broadcast. So if you change the network address, change it in these scripts as well.
