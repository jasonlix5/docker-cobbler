FROM centos:7.2.1511

MAINTAINER Jasonli

RUN rpm -ivh http://mirrors.aliyun.com/centos/7.2.1511/os/x86_64/Packages/wget-1.14-10.el7_0.1.x86_64.rpm && \
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo && \
wget -O /etc/yum.repos.d/cobbler26.repo http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/CentOS_CentOS-7/home:libertas-ict:cobbler26.repo

RUN yum -y install cobbler tftp-server dhcp openssl ; yum clean all

RUN apachectl ; cobblerd ; cobbler get-loaders ; pkill cobblerd ; pkill httpd

ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
