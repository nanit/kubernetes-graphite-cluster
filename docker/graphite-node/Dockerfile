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


RUN     git clone https://github.com/graphite-project/graphite-web.git /src/graphite-web  &&\
        cd /src/graphite-web                                                              &&\
        git checkout 1.0.x								                                                &&\
        python setup.py install                                                           &&\
        pip install -r requirements.txt                                                   &&\
        python check-dependencies.py

# fixes fatal error "Your WhiteNoise configuration is incompatible with WhiteNoise v4.0"
RUN     /usr/bin/yes | pip uninstall whitenoise                                           &&\
        pip install "whitenoise<4"

# Add system service config
add	./nginx/nginx.conf /etc/nginx/nginx.conf
add	./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add graphite config
add	./webapp/initial_data.json /opt/graphite/webapp/graphite/initial_data.json
add	./webapp/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
add	./conf/carbon.conf /opt/graphite/conf/carbon.conf
add	./conf/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
add	./conf/storage-aggregation.conf /opt/graphite/conf/storage-aggregation.conf
run	mkdir -p /opt/graphite/storage/whisper
run	touch /opt/graphite/storage/graphite.db /opt/graphite/storage/index
run	chmod 0775 /opt/graphite/storage /opt/graphite/storage/whisper
run	chmod 0664 /opt/graphite/storage/graphite.db
RUN cp /src/graphite-web/webapp/manage.py /opt/graphite/webapp

# Install curator cron job
ADD curator/cron /etc/cron.d/curator.cron
ADD curator/run.sh /etc/cron.d/curator.sh
RUN chmod +x /etc/cron.d/curator.sh

ADD entrypoint.sh /entrypoint.sh

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

cmd	["/entrypoint.sh"]
