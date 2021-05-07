FROM registry.redhat.io/codeready-workspaces/plugin-java8-rhel8:2.7-5

USER root
WORKDIR /opt

RUN yum update -y -q

RUN yum install -y -q yum-utils; \
    yum install -y -q httpd; \
    yum install -y -q net-tools; \
    yum install -y -q bind-utils; \
    yum install -y -q lsof; \
    yum install -y -q device-mapper-persistent-data; \
    yum install -y -q vim; \
    yum install -y -q jq

COPY resources/RPM-GPG-KEY-centos-packages RPM-GPG-KEY-centos-packages
RUN curl -sSL -O http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/telnet-0.17-73.el8_1.1.x86_64.rpm \
    && rpm --import --quiet RPM-GPG-KEY-centos-packages \
    && rpm --quiet --checksig telnet-0.17-73.el8_1.1.x86_64.rpm \
    && rpm -ivh --quiet telnet-0.17-73.el8_1.1.x86_64.rpm \
    && rm -f RPM-GPG-KEY-centos-packages telnet-0.17-73.el8_1.1.x86_64.rpm

RUN chmod -R 777 \
    /opt \
    /home/jboss \
    /usr/local/ \
    /usr/lib/ \
    /usr/lib64 \
    /usr/bin

USER jboss


