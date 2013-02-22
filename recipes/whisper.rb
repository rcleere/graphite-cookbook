#
# Cookbook Name:: graphite
# Recipe:: whisper
#
# Copyright 2012, Rackspace
#
# All rights reserved - Do Not Redistribute
#

# This installs whisper from source on a debian squeeze box

include_recipe "graphite::common"

# Install whisper dependencies
node["whisper"]["dependencies"].each do |pkg|
  package pkg 
end

remote_file "#{node["graphite"]["local_source"]}/whisper.tar.gz" do
  source "#{node["whisper"]["source"]}"
  action :create_if_missing
end

### FIXME: remove the hardcoded version below
bash "install_whisper" do
  #not_if "test -f /usr/local/bin/whisper-info.py" # Dont need, "creates" does the same thing
  cwd "#{node["graphite"]["local_source"]}"
  code <<-EOH
    tar zxf whisper.tar.gz
    cd whisper-0.9.10 
    python setup.py install
  EOH
  creates "/usr/local/bin/whisper-info.py"
end
