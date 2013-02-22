
default["graphite"]["version"] = "0.9.10"

default["graphite"]["local_source"] = "/usr/local/src"

default["whisper"]["source"] = "https://github.com/downloads/graphite-project/whisper/whisper-#{node['graphite']['version']}.tar.gz"
default["carbon"]["source"] = "https://github.com/downloads/graphite-project/carbon/carbon-#{node['graphite']['version']}.tar.gz"
default["graphite"]["source"] = "https://github.com/downloads/graphite-project/graphite-web/graphite-web-#{node['graphite']['version']}.tar.gz"

default["whisper"]["dependencies"] =  ["python"]
default[:carbon][:dependencies] = ["python", "python-twisted"]
default[:graphite][:dependencies] = ["python", "python-twisted", "apache2", "python-cairo", "python-django", "python-django-tagging", "python-zope.interface", "libapache2-mod-python", "python-memcache", "memcached", "libapache2-mod-wsgi"]

#web app settings
default["graphite"]["email"] = "bob@mysite.com"
default["graphite"]["web_user"] = "root"
default["graphite"]["passwd_hash"] = nil

# Carbon relay defaults
default["graphite"]["relay"]["destinations"] = ["127.0.0.1:2004"]
