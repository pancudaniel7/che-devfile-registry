FROM registry.redhat.io/codeready-workspaces/stacks-golang-rhel8:2.7-4

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

COPY resources/get_helm.sha512 ./get_helm.sha512
RUN curl -fsSL --silent -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && sha512sum --check get_helm.sha512 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm -f get_helm.sh get_helm.sha512

COPY resources/kubeseal-v0.13.1.sha512 ./kubeseal-v0.13.1.sha512
RUN curl -fsSL --silent -o kubeseal https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.13.1/kubeseal-linux-amd64 \
    && sha512sum --check kubeseal-v0.13.1.sha512 \
    && install -m 755 kubeseal /usr/local/bin/kubeseal \
    && rm -rf kubeseal-v0.13.1.sha512 kubeseal
    
RUN chown -R jboss \
    /opt \
    /home/jboss \
    /usr/local/ \
    /usr/lib/ \
    /usr/lib64 \
    /usr/bin

USER jboss
