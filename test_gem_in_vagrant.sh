#!/bin/sh

vagrant plugin uninstall vagrant-rightscaleshim
rake gem
vagrant plugin install pkg/vagrant-rightscaleshim-1.0.1.gem
