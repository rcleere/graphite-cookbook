#
# Cookbook Name:: graphite
# Recipe:: graphite
#
# Copyright 2012, Rackspace
#
# All rights reserved - Do Not Redistribute
#

# This installs carbon from source on a debian squeeze box

include_recipe "graphite::common"
#include_recipe "graphite::whisper" # I think the front end can run without carbon, should test!
include_recipe "graphite::carbon"

# Install graphite dependencies
node["graphite"]["dependencies"].each do |pkg|
  package pkg 
end

remote_file "#{node["graphite"]["local_source"]}/graphite-web.tar.gz" do
  source "#{node["graphite"]["source"]}"
  action :create_if_missing
end

### FIXME: remove the hardcoded version below
bash "install_graphite" do
  #not_if "test -f /usr/local/bin/whisper-info.py" # Dont need, "creates" does the same thing
  cwd "#{node["graphite"]["local_source"]}"
  code <<-EOH
    tar zxf graphite-web.tar.gz
    cd graphite-web-0.9.10 
    python setup.py install
  EOH
  #creates "/opt/graphite/bin/carbon-cache.py"
end

template "/opt/graphite/webapp/graphite/initial_data.json" do
  source "initial_data.json.erb"
  action :create
end

### Config apache
bash "config_graphite_apache" do
  #creates "/etc/apache2/sites-available/graphite"
  code <<-EOH
    cp /opt/graphite/examples/example-graphite-vhost.conf /etc/apache2/sites-available/graphite
    mkdir /etc/apache2/run
    a2ensite graphite
    a2dissite default
    sed -i 's/@DJANGO_ROOT@/\/usr\/lib\/pymodules\/python2.6\/django/' /etc/apache2/sites-available/graphite
    sed -i 's/run\/wsgi/\/var\/run\/apache2\/wsgi/g' /etc/apache2/sites-available/graphite.conf
    cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
    cp /opt/graphite/conf/carbon.conf.example /opt/graphite/conf/carbon.conf
    cp /opt/graphite/conf/storage-schemas.conf.example /opt/graphite/conf/storage-schemas.conf
    cd /opt/graphite/webapp/graphite
    python manage.py syncdb --noinput
    chown www-data:www-data /opt/graphite/storage
    chown www-data:www-data /opt/graphite/storage/graphite.db
    chown -R www-data:www-data /opt/graphite/storage/log/webapp/
    cp /opt/graphite/webapp/graphite/local_settings.py.example /opt/graphite/webapp/graphite/local_settings.py
    sed -i "s/#MEMCACHE_HOSTS.*/MEMCACHE_HOSTS = ['127.0.0.1:11211']/" /opt/graphite/webapp/graphite/local_settings.py
#   touch /opt/graphite/storage/index
#
    /etc/init.d/apache2 restart
  EOH
end

#service apache2 do
#  supports [:status]
#  action :start
#end
