FROM registry.redhat.io/codeready-workspaces/stacks-golang-rhel8:2.10-2

USER root
WORKDIR /opt

RUN yum update -y -q

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
    
RUN curl -LO https://github.com/tektoncd/cli/releases/download/v0.20.0/tkn_0.20.0_Linux_x86_64.tar.gz && \
    tar xvzf tkn_0.20.0_Linux_x86_64.tar.gz -C /usr/local/bin/ tkn

RUN curl -sL https://istio.io/downloadIstioctl | sh - && \
    ln -s $HOME/.istioctl/bin/istioctl /usr/local/bin/istioctl

COPY resources/get_helm.sha512 ./get_helm.sha512
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && sha512sum --check get_helm.sha512 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm -f get_helm.sh get_helm.sha512

COPY resources/kubeseal-v0.13.1.sha512 ./kubeseal-v0.13.1.sha512
RUN curl -fsSL -o kubeseal https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.13.1/kubeseal-linux-amd64 \
    && sha512sum --check kubeseal-v0.13.1.sha512 \
    && install -m 755 kubeseal /usr/local/bin/kubeseal \
    && rm -rf kubeseal-v0.13.1.sha512 kubeseal
    
RUN chmod -R 777 \
    /opt \
    /home/jboss \
    /usr/local/ \
    /usr/lib/ \
    /usr/lib64 \
    /usr/bin

USER jboss
