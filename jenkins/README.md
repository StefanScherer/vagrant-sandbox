# jenkins
This is a example of setting up a Jenkins server with a Windows slave
and an Ubuntu slave.

# Getting started
If you want to use the backup and restore function using grunt, install some
dependencies with

    npm install

After that, you only have to type

    vagrant up

and both the Jenkins server and the Windows and Ubuntu slaves will be started.
For Windows, you need a `windows_2012_r2` box. For Ubuntu, the default
precise64 box will be used.

## Manage Jenkins configuration

After each time you made changes to the global Jenkins configuration, plugins
or jobs just do:

    grunt jenkins-backup

This will backup all stuff to the jenkins-configuration folder. You may put it
under version control, yay!

You can install jenkins configuration using:

    grunt jenkins-install

When you added / removed plugins you must restart Jenkins:

    open http://192.168.33.214:8080/safeRestart

## View Jenkins Web Interface
If you just want to view into Jenkins use this command:

    open http://192.168.33.214:8080/


## TODO
* After starting the jenkins server, it does not create its config.xml which is needed by the swarm-clients. So open the Browser and once enter the Jenkins -> Manage Jenkins -> System configuration and press Save. After that the swarm-clients are able to connect.
