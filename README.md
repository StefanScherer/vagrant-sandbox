vagrant-sandbox
===============

This is a collection of some Vagrantfile's used to test the Windows baseboxes
built with basebox-packer.

Getting Started
===============

First install packer and vagrant on your windows host.
Then create some baseboxes with packer.

Additionally install the vagrant-multiprovider-snap plugin to take snapshots with VirtualBox or VMware. Vagrant also has a snap function, but I still like this plugin a little more.

    vagrant plugin install vagrant-multiprovider-snap

Another useful plugin is vagrant-reload as Windows VM's tend to need restarts during provisioning.

    vagrant plugin install vagrant-reload

Setup a new directory for a vagrant environment

    cd /D B:\
    mkdir test
    cd test
    vagrant init StefanScherer/windows_10

Edit the newly created Vagrantfile if you like.

    vi Vagrantfile

Boot a Vagrant box

    vagrant up

Debugging Vagrant
=================

To turn on logging enter the following

```
set VAGRANT_LOG=info
vagrant up
```

