# vagrant-rightscaleshim

A Vagrant plugin which (along with [rightscaleshim](https://github.com/rgeyer-rs-cookbooks/rightscaleshim)) allows the use of RightScale specific Chef resources (right_link_tag, remote_recipe, server_collection) in a Vagrant VM.

## Installation

Install Vagrant 1.2.x from the [Vagrant downloads page](http://downloads.vagrantup.com/)

Install the Vagrant RightScale Shim plugin

    $ vagrant plugin install vagrant-rightscaleshim

## Usage

You can setup your vagrantfile thusly

    Vagrant.configure("2") do |config|
      config.vm.hostname = "centos"

      config.vm.box = "ri_centos6.3_v5.8.8"
      config.vm.box_url = "https://s3.amazonaws.com/rgeyer/pub/ri_centos6.3_v5.8.8_vagrant.box"

      config.vm.network :private_network, ip: "33.33.33.10"

      config.ssh.max_tries = 40
      config.ssh.timeout   = 120

      config.rightscaleshim.run_list_dir = "runlists/centos"
      config.rightscaleshim.shim_dir = "rightscaleshim/centos"
      config.vm.provision :chef_solo do |chef|
        # This intentionally left blank
      end
    end

Then create some new runlists at runlists/default/new_runlist.json

Run some of the other runlists by copying them to rightscaleshim/default/dispatch

    cp runlists/default/new_runlist.json rightscaleshim/default/dispatch/
    vagrant provision

Or specifying a "runlist" environment variable

    runlist=new_runlist vagrant provision

## Features

Uses JSON files which are essentially Chef-Solo node.json files as "runlists".  As shown above you can specify a runlist to execute, or if there is a runlist file in the "dipatch" directory of a particular VM, the next `vagrant provision` execution will run it and delete the file in the dispatch directory.

Tag data is stored in rightscaleshim/#{vnname}/persist.json and used to simulate the functionality of the right_link_tag resource.

The following RightScale/RightLink specific resoures are stubbed/simulated by this gem and cookbook

  * right_link_tag
  * remote_recipe
  * server_collection
