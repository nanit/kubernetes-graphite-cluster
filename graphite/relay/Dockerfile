from	ubuntu:14.04
run	echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty universe' >> /etc/apt/sources.list
run	apt-get -y update

# Install required packages
run	apt-get -y install python-ldap python-cairo python-django python-twisted python-django-tagging python-simplejson python-memcache python-pysqlite2 python-support python-tz python-pip
run	pip install carbon==0.9.15
run	pip install whisper==0.9.15
run mkdir -p /var/log/carbon

add conf/carbon.conf /opt/graphite/conf/carbon.conf
add conf/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf

EXPOSE 2003/udp

CMD ["/opt/graphite/bin/carbon-relay.py", "--debug", "--logdir=/var/log/carbon", "start"]
