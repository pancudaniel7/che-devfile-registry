FROM codesquaddev/codeready-base-stack:1.0.0

USER root

RUN yum install -y -q java-11-openjdk-devel-11.0.11.0.9-0.el8_3.x86_64
RUN update-alternatives --set java /usr/lib/jvm/java-11-openjdk-11.0.11.0.9-0.el8_3.x86_64/bin/java

USER jboss

RUN whoami
RUN java --version