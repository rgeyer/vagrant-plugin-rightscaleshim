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

module VagrantPlugins
  module RightscaleShim
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :shim_dir
      attr_accessor :run_list_dir
      attr_accessor :one_time_runlist_file

      def initialize
        super

        @shim_dir = UNSET_VALUE
        @run_list_dir = UNSET_VALUE
        @one_time_runlist_file = UNSET_VALUE
      end

      def finalize!
        @shim_dir = nil if @shim_dir == UNSET_VALUE
        @run_list_dir = nil if @run_list_dir == UNSET_VALUE
        @one_time_runlist_file = nil if @one_time_runlist_file == UNSET_VALUE
      end

      # TODO: Better error handling, verify shim dir and runlist dir exist, catch json errors when parsing runlists
      def validate(machine)
        misconfigured = false
        errors = _detected_errors
        if !machine.config.rightscaleshim.shim_dir || machine.config.rightscaleshim.shim_dir.empty?
          machine.ui.warn(I18n.t("vagrant.config.rightscaleshim.shim_dir_missing"))
          misconfigured = true
        end

        if !machine.config.rightscaleshim.run_list_dir || machine.config.rightscaleshim.run_list_dir.empty?
          machine.ui.warn(I18n.t("vagrant.config.rightscaleshim.run_list_dir_missing"))
          misconfigured
        end

        machine.ui.warn(I18n.t("vagrant.config.rightscaleshim.misconfigured"))

        {'rightscaleshim' => errors}
      end

    end
  end
end