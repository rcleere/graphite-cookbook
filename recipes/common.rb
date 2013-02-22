#
# Cookbook Name:: graphite
# Recipe:: common
#
# Copyright 2012, Rackspace
#
# All rights reserved - Do Not Redistribute
#

# If its not debian GTFO
if node['platform'] != "debian"
  Chef::Log.error("Installing on #{node['platform']} is not supported at this time.")
  raise "Unsupported OS"
end

# Make sure destination local_source exists
directory "#{node['graphite']['local_source']}" do
  action :create
  recursive true
end
