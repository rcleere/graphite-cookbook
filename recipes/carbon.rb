#
# Cookbook Name:: graphite
# Recipe:: carbon
#
# Copyright 2012, Rackspace
#
# All rights reserved - Do Not Redistribute
#

# This installs carbon from source on a debian squeeze box

include_recipe "graphite::common"
include_recipe "graphite::whisper"

# Install whisper dependencies
node["carbon"]["dependencies"].each do |pkg|
  package pkg 
end

remote_file "#{node["graphite"]["local_source"]}/carbon.tar.gz" do
  source "#{node["carbon"]["source"]}"
  action :create_if_missing
end

### FIXME: remove the hardcoded version below
bash "install_carbon" do
  #not_if "test -f /usr/local/bin/whisper-info.py" # Dont need, "creates" does the same thing
  cwd "#{node["graphite"]["local_source"]}"
  code <<-EOH
    tar zxf carbon.tar.gz
    cd carbon-0.9.10 
    python setup.py install
  EOH
  creates "/opt/graphite/bin/carbon-cache.py"
  creates "/opt/graphite/bin/carbon-relay.py"
end

# /opt/graphite/bin/carbon-cache.py start
