include_recipe "graphite::carbon"

template "/opt/graphite/conf/relay-rules.conf" do
  source "relay-rules.conf.erb"
  notifies :restart, "service[carbon_relay]"
end

service "carbon_relay" do
   start_command "/opt/graphite/bin/carbon-relay.py start"
   stop_command "/opt/graphite/bin/carbon-relay.py stop"
   status_command "/opt/graphite/bin/carbon-relay.py status"
   restart_command "/opt/graphite/bin/carbon-relay.py stop && /opt/graphite/bin/carbon-relay.py start"
   supports :start => true, :stop => true, :status => true, :restart => true
   action :start
end
