from	ubuntu:14.04
run	echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty universe' >> /etc/apt/sources.list
run	apt-get -y update

# Install required packages
run	apt-get -y install python-ldap python-cairo python-django python-twisted python-django-tagging python-simplejson python-memcache python-pysqlite2 python-support python-tz python-pip gunicorn supervisor nginx-light
run	pip install whisper==0.9.15
run	pip install carbon==0.9.15
run	pip install graphite-web==0.9.15

# Add system service config
add	./nginx/nginx.conf /etc/nginx/nginx.conf
add	./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add graphite config
add	./webapp/initial_data.json /opt/graphite/webapp/graphite/initial_data.json
add	./webapp/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
add	./conf/carbon.conf /opt/graphite/conf/carbon.conf
add	./conf/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
add	./conf/storage-aggregation.conf /opt/graphite/conf/storage-aggregation.conf
add ./carbon-init.sh /
run	mkdir -p /opt/graphite/storage/whisper
run	touch /opt/graphite/storage/graphite.db /opt/graphite/storage/index
run	chmod 0775 /opt/graphite/storage /opt/graphite/storage/whisper
run	chmod 0664 /opt/graphite/storage/graphite.db
run	cd /opt/graphite/webapp/graphite && python manage.py syncdb --noinput

# Nginx
expose	80
# Carbon line receiver port
# expose	2003
# Carbon UDP receiver port
# expose	2003/udp
# Carbon pickle receiver port
expose	2004
# Carbon cache query port
# expose	7002

cmd	["/usr/bin/supervisord"]
