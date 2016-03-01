FROM registry.access.redhat.com/rhel
MAINTAINER Gary Yang <garyyang@purestorage.com>; Cary Li <cary.li@purestorage.com>

# Expose a web endpoint for the management website
EXPOSE 8080
RUN yum update -y
RUN rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
RUN echo $'\n\
[elasticsearch-2.x] \n\
name=Elasticsearch repository for 2.x packages \n\
baseurl=https://packages.elastic.co/elasticsearch/2.x/centos \n\
gpgcheck=1 \n\
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch \n\
enabled=1 \n\
' > /etc/yum.repos.d/elasticsearch.repo
RUN yum localinstall -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN yum install -y rabbitmq-server python-pip python-dev vim nodejs-legacy npm curl elasticsearch python-devel python-requests
RUN pip install Celery
RUN pip install purestorage
RUN pip install gevent
RUN pip install Flask
RUN pip install elasticsearch
RUN pip install python-dateutil
RUN pip install enum34
RUN npm install elasticdump

ENV target_folder /pureelk
ADD container/ $target_folder
ADD conf/logrotate-pureelk.conf /etc/logrotate.d/pureelk
WORKDIR $target_folder

RUN chmod +x start.sh
RUN mkdir -p /var/log/pureelk

# Run the startup script. Also run a long running process to prevent docker from existing. 
CMD ./start.sh && exec tail -f /etc/hosts

