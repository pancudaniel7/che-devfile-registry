FROM registry.redhat.io/codeready-workspaces/plugin-java8-rhel8

USER root
WORKDIR /opt

RUN yum update -y -q

RUN yum install yum-utils -y -q; \
    yum install vim -y -q; \
    yum install jq -y -q; \
    yum install httpd -y -q; \
    yum install net-tools -y -q; \
    yum install bind-utils -y -q; \
    yum install lsof -y -q; \
    yum install device-mapper-persistent-data -y; \ 
    yum install lvm2 -y

COPY resources/RPM-GPG-KEY-centos-packages /etc/rpm-gpg/RPM-GPG-KEY-centos-packages
RUN rpm --import /etc/rpm-gpg/RPM-GPG-KEY-centos-packages --quiet && \
    rpm --checksig http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/telnet-0.17-73.el8_1.1.x86_64.rpm  --quiet && \
    rpm -ivh http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/telnet-0.17-73.el8_1.1.x86_64.rpm --quiet

COPY resources/docker-20.10.6.tgz.sha512 ./docker-20.10.6.tgz.sha512
RUN wget https://download.docker.com/linux/static/stable/x86_64/docker-20.10.6.tgz -q && \
    sha512sum --check docker-20.10.6.tgz.sha512 && \
    tar xzvf docker-20.10.6.tgz && \
    cp docker/* /usr/bin && \
    rm -rf docker/ docker-20.10.6.tgz.sha512

COPY resources/get_helm.sha512 ./get_helm.sha512
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    sha512sum --check get_helm.sha512 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

COPY keys/apache-pulsar-2.7.1-bin.tar.gz.sha512 apache-pulsar-2.7.1-bin.tar.gz.sha512
RUN wget https://archive.apache.org/dist/pulsar/pulsar-2.7.1/apache-pulsar-2.7.1-bin.tar.gz -q && \
    echo "$(cat apache-pulsar-2.7.1-bin.tar.gz.sha512)" | sha512sum --check && \
    tar xvfz apache-pulsar-2.7.1-bin.tar.gz 1>/dev/null && \
    rm -rf apache-pulsar-2.7.1-bin.tar.gz && \
    echo 'PATH=$PATH:/opt/apache-pulsar-2.7.1/bin' > /etc/environment

USER jboss
