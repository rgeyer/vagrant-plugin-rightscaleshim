# Copyright (c) 2013 Ryan J. Geyer
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

begin
  require "vagrant"
rescue LoadError
  raise "The RightscaleShim plugin must be run within Vagrant."
end

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.2.0"
  raise "The RightscaleShim plugin is only compatible with Vagrant 1.2+"
end

module VagrantPlugins
  module RightscaleShim
    class Plugin < Vagrant.plugin("2")
      class << self
        def provision(hook)
          hook.before(::Vagrant::Action::Builtin::Provision, VagrantPlugins::RightscaleShim::Action.config_chef_solo)
        end
      end

      name "RightScale Vagrant Shim"

      config :rightscaleshim do
        require_relative 'config'
        VagrantPlugins::RightscaleShim::Config
      end

      action_hook(:rightscaleshim_provision, :machine_action_up, &method(:provision))
      action_hook(:rightscaleshim_provision, :machine_action_reload, &method(:provision))
      action_hook(:rightscaleshim_provision, :machine_action_provision, &method(:provision))

      action_hook(:rightscaleshim_provision_clean, :machine_action_provision) do |hook|
        hook.after(::Vagrant::Action::Builtin::Provision, VagrantPlugins::RightscaleShim::Action.clean_one_time_runlist_file)
      end

      action_hook(:rightscaleshim_clean, :machine_action_destroy) do |hook|
        hook.after(::Vagrant::Action::Builtin::GracefulHalt, VagrantPlugins::RightscaleShim::Action.cleanup)
      end
    end
  end
end