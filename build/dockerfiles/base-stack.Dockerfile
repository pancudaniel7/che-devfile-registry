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
    yum install device-mapper-persistent-data -y -q; \
    yum install lvm2 -y -q
    
RUN yum module install go-toolset -y -q && \
    GO111MODULE=on go get github.com/bitnami-labs/sealed-secrets/cmd/kubeseal@d15c388248912213c930d1dc5b0f84c627bca3ea && \
    ln -s $HOME/go/bin/kubeseal /usr/local/bin/kubeseal

COPY resources/RPM-GPG-KEY-centos-packages /etc/rpm-gpg/RPM-GPG-KEY-centos-packages
RUN wget http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/telnet-0.17-73.el8_1.1.x86_64.rpm -q && \
    rpm --import /etc/rpm-gpg/RPM-GPG-KEY-centos-packages --quiet && \
    rpm --checksig telnet-0.17-73.el8_1.1.x86_64.rpm  --quiet && \
    rpm -ivh telnet-0.17-73.el8_1.1.x86_64.rpm --quiet

COPY resources/RPM-GPG-KEY-fedora-docker-packages /etc/rpm-gpg/RPM-GPG-KEY-fedora-docker-packages
RUN rpm --import /etc/rpm-gpg/RPM-GPG-KEY-fedora-docker-packages && \
    dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo && \
    dnf upgrade && \
    dnf install docker-ce-cli -y

COPY resources/get_helm.sha512 ./get_helm.sha512
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    sha512sum --check get_helm.sha512 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

COPY resources/apache-pulsar-2.7.1-bin.tar.gz.sha512 apache-pulsar-2.7.1-bin.tar.gz.sha512
RUN wget https://archive.apache.org/dist/pulsar/pulsar-2.7.1/apache-pulsar-2.7.1-bin.tar.gz -q && \
    sha512sum --check apache-pulsar-2.7.1-bin.tar.gz.sha512 && \
    tar xvfz apache-pulsar-2.7.1-bin.tar.gz 1>/dev/null && \
    rm -rf apache-pulsar-2.7.1-bin.tar.gz

RUN usermod -G root jboss    
USER jboss

