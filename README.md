vagrant-sandbox
===============

This is a collection of some Vagrantfile's used to test the Windows baseboxes
built with basebox-packer.

Getting Started
===============

First install packer and vagrant on your windows host.
Then create some baseboxes with packer.

Install the vagrant-windows plugin into vagrant:

    vagrant plugin install vagrant-windows

Additionally install the vagrant-berkshelf plugin into vagrant.

    cd /D C:\HashiCorp\Vagrant\embedded\bin
    gem install berkshelf
    cd /
    vagrant plugin install vagrant-berkshelf

Setup a new directory to import a basebox with vagrant

    cd /D B:\
    mkdir test
    cd test
    vagrant init stefan-win81x64preview file:///e:/basebox/stefan-win81x64preview.box

Edit the newly created Vagrantfile

    vi Vagrantfile

Add the following lines to the Vagrantfile

    config.vm.guest = :windows

    # Max time to wait for the guest to shutdown
    config.windows.halt_timeout = 25

    # Admin user name and password
    config.winrm.username = "vagrant"
    config.winrm.password = "vagrant"
    config.winrm.port = 15985

    # Port forward WinRM and RDP
    config.vm.network :forwarded_port, guest: 3389, host: 13389
    config.vm.network :forwarded_port, guest: 5985, host: 15985

And also boot VM without headless if you want by turning on vb.gui = true

