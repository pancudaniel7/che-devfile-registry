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
    
# RUN yum module install go-toolset -y -q && \
#     GO111MODULE=on go get github.com/bitnami-labs/sealed-secrets/cmd/kubeseal@d15c388248912213c930d1dc5b0f84c627bca3ea && \
#     ln -s $HOME/go/bin/kubeseal /usr/local/bin/kubeseal

# COPY resources/get_helm.sha512 ./get_helm.sha512
# RUN curl -fsSL --silent -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
#     sha512sum --check get_helm.sha512 && \
#     chmod 700 get_helm.sh && \
#     ./get_helm.sh && \
#     rm -f get_helm.sh get_helm.sha512

# COPY resources/apache-pulsar-2.7.1-bin.tar.gz.sha512 apache-pulsar-2.7.1-bin.tar.gz.sha512
# RUN curl -fsSL --silent -o https://archive.apache.org/dist/pulsar/pulsar-2.7.1/apache-pulsar-2.7.1-bin.tar.gz && \
#     sha512sum --check apache-pulsar-2.7.1-bin.tar.gz.sha512 && \
#     tar xvfz apache-pulsar-2.7.1-bin.tar.gz 1>/dev/null && \
#     rm -rf apache-pulsar-2.7.1-bin.tar.gz

RUN usermod -G root jboss    
USER jboss

