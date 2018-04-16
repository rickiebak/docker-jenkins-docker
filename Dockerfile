FROM jenkins:2.60.3
MAINTAINER rickie.bak@gmail.com
ENV REFRESHED_AT 2018-04-12

# change root user
USER root

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --assume-yes apt-utils

# install docker
RUN apt-get install -qqy iptables ca-certificates lxc
RUN apt-get install -y libdevmapper-dev
RUN apt-get install -y libltdl7
ADD ./bin/docker-ce_18.03.0~ce-0~ubuntu_amd64.deb .
RUN dpkg -i ./docker-ce_18.03.0~ce-0~ubuntu_amd64.deb
RUN service docker start

# git ssl config 
RUN git config --global http.sslVerify false

VOLUME /var/lib/docker

# increase jenkins JVM memory 
ENV JAVA_ARGS -Xms512m -Xmx1024m

ADD ./bin/jenkins_dind.sh /usr/local/bin/jenkins_dind.sh
RUN chmod +x /usr/local/bin/jenkins_dind.sh

CMD ["/usr/local/bin/jenkins_dind.sh"]
