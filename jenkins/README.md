# jenkins
This is a example of setting up a Jenkins server with a Windows slave.

# Getting started
Install some dependencies with

    npm install

After that, you only have to type

    vagrant up

and both the Jenkins server and the windows slave will be started.
For the windows, you need a `windows_2012_r2` box.

## Manage Jenkins configuration

After each time you made changes to the global Jenkins configuration, plugins or jobs just do:

    grunt jenkins-backup

This will backup all stuff to the jenkins-configuration folder. You may put it under version control, yay!

You can install jenkins configuration using:

    grunt jenkins-install

When you added / removed plugins you must restart Jenkins:

    open http://192.168.33.214:8080/safeRestart

If you just want to view into Jenkins use this command:

    open http://192.168.33.214:8080/
