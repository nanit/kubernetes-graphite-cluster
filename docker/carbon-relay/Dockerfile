from	ubuntu:14.04
run	echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty universe' >> /etc/apt/sources.list
run	apt-get -y update

# Install required packages
RUN     apt-get -y update &&\ 
	apt-get -y install software-properties-common python-django-tagging python-simplejson \
	python-memcache python-ldap python-cairo python-pysqlite2 python-support python-pip \
	gunicorn supervisor nginx-light git wget curl build-essential python-dev libffi-dev vim
RUN     pip install Twisted==13.2.0
RUN     pip install pytz
RUN     git clone https://github.com/graphite-project/whisper.git /src/whisper            &&\
        cd /src/whisper                                                                   &&\
        git checkout 1.0.x                                                                &&\
        python setup.py install

RUN     git clone https://github.com/graphite-project/carbon.git /src/carbon              &&\
        cd /src/carbon                                                                    &&\
        git checkout 1.0.x                                                                &&\
        python setup.py install


add conf/carbon.conf /opt/graphite/conf/carbon.conf
add conf/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
add set-cluster-nodes.sh /set-cluster-nodes.sh
add entrypoint.sh /entrypoint.sh

EXPOSE 2003

CMD ["/entrypoint.sh"]
