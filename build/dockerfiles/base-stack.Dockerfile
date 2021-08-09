FROM registry.redhat.io/codeready-workspaces/plugin-java8-rhel8:2.10-4

USER root
WORKDIR /opt

RUN yum update -y

RUN yum install yum-utils -y; \   
    yum install net-tools -y; \   
    yum install bind-utils -y; \   
    yum install lsof -y; \   
    yum install device-mapper-persistent-data -y; \   
    yum install vim -y; \   
    yum install jq -y

COPY resources/RPM-GPG-KEY-centos8-packages RPM-GPG-KEY-centos8-packages
COPY resources/telnet-0.17-76.rpm telnet-0.17-76.rpm
RUN rpm --import RPM-GPG-KEY-centos8-packages && \
    rpm --checksig telnet-0.17-76.rpm && \
    rpm -ivh --quiet telnet-0.17-76.rpm && \
    rm -f RPM-GPG-KEY-centos-packages telnet-0.17-76.rpm

RUN chmod -R 777 \
    /opt \
    /home/jboss \
    /usr/local/ \
    /usr/lib/ \
    /usr/lib64 \
    /usr/bin

USER jboss


