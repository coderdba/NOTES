#
# Dockerfile for cassandra without systemd service
#

FROM centos/systemd

#MAINTAINER "Your Name" <you@example.com>

ENV yumrepo=/etc/yum.repos.d/cassandra.repo

# install missing network diagnostic tools (not essential for cassandra)
RUN yum -y install iptables 
RUN yum -y install net-tools 

RUN echo [cassandra] > $yumrepo
RUN echo name=Apache Cassandra >> $yumrepo
RUN echo baseurl=https://www.apache.org/dist/cassandra/redhat/311x/ >> $yumrepo
RUN echo gpgcheck=1 >> $yumrepo
RUN echo repo_gpgcheck=1 >> $yumrepo
RUN echo gpgkey=https://www.apache.org/dist/cassandra/KEYS >> $yumrepo
RUN echo sslverify=false >> $yumrepo

COPY cassandra.yaml.mod /var/lib/.

RUN yum -y install cassandra 
RUN yum clean all 
RUN systemctl enable cassandra.service
RUN systemctl list-unit-files | grep enabled

RUN ls /etc/init.d/cas*
RUN ls -l /etc/rc.d/*/* 

#RUN /etc/init.d/cassandra stop
RUN mv /etc/cassandra/conf/cassandra.yaml /etc/cassandra/conf/cassandra.yaml.orig
RUN cp /var/lib/cassandra.yaml.mod /etc/cassandra/conf/cassandra.yaml
#RUN /etc/init.d/cassandra start

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Required ports
# 7000: intra-node communication
# 7001: TLS intra-node communication
# 7199: JMX
# 9042: CQL
# 9160: thrift service

EXPOSE 7000 7001 7199 9042 9160

# init may not be required as we are not creating cassandra.service file in this case
#CMD ["/usr/sbin/init"]
