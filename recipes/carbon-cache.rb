include_recipe "graphite::carbon"

service "carbon_cache" do
   start_command "/opt/graphite/bin/carbon-cache.py start"
   stop_command "/opt/graphite/bin/carbon-cache.py stop"
   status_command "/opt/graphite/bin/carbon-cache.py status"
   restart_command "/opt/graphite/bin/carbon-cache.py stop && /opt/graphite/bin/carbon-cache.py start"
   supports :start => true, :stop => true, :status => true, :restart => true
   action :start
end
