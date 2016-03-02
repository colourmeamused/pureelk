FROM registry.access.redhat.com/rhel
MAINTAINER Gary Yang <garyyang@purestorage.com>; Cary Li <cary.li@purestorage.com>
RUN rpm -Uvh http://katello.phoenix.local/pub/katello-ca-consumer-latest.noarch.rpm
# Expose a web endpoint for the management website
EXPOSE 8080
RUN yum install -y curl
# RHEL 7.2 and CentOS 7.2 have a regression that breaks SSL in Python 2.7.5 https://github.com/gevent/gevent/issues/702
# Installing Python 2.7.11 from Copr repo to fix
RUN  curl https://copr.fedorainfracloud.org/coprs/vrusinov/sundry/repo/epel-7/vrusinov-sundry-epel-7.repo -o /etc/yum.repos.d/python2710.repo
RUN yum-config-manager --disablerepo=vrusinov-sundry
RUN yum --enablerepo=vrusinov-sundry install python -y
RUN yum update -y
RUN rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
RUN echo $'\n\
[elasticsearch-2.x] \n\
name=Elasticsearch repository for 2.x packages \n\
baseurl=https://packages.elastic.co/elasticsearch/2.x/centos \n\
gpgcheck=1 \n\
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch \n\
enabled=0 \n\
' > /etc/yum.repos.d/elasticsearch.repo
RUN yum localinstall -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN yum install -y rabbitmq-server python-pip python-dev vim nodejs npm curl elasticsearch python-devel python-requests ruby-devel gcc python
RUN apt-get update && apt-get install -y rabbitmq-server python-pip python-dev vim nodejs-legacy npm curl
RUN pip install Celery==3.1.18
RUN pip install purestorage==1.4.0
RUN pip install gevent==1.0.2
RUN pip install Flask==0.10.1
RUN pip install elasticsearch==1.6.0
RUN pip install python-dateutil==2.4.2
RUN pip install enum34==1.0.4
RUN npm install elasticdump@0.15.0
ENV target_folder /pureelk
ADD container/ $target_folder
ADD conf/logrotate-pureelk.conf /etc/logrotate.d/pureelk
WORKDIR $target_folder

RUN chmod +x start.sh
RUN mkdir -p /var/log/pureelk

# Run the startup script. Also run a long running process to prevent docker from existing. 
CMD ./start.sh && exec tail -f /etc/hosts

