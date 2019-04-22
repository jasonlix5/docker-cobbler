FROM centos:7.6.1810

MAINTAINER Jasonli

ENV COBBLER_VERSION 2.8.4

RUN yum -y install wget epel-release && \
    wget -O /etc/yum.repos.d/cobbler28.repo http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler28/CentOS_7/home:libertas-ict:cobbler28.repo && \
    yum -y install cobbler tftp-server dhcp openssl cobbler-web supervisor && \
    yum -y update && \
    yum clean all

ADD supervisord.d/conf.ini /etc/supervisord.d/conf.ini
ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]