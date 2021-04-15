FROM codesquaddev/parent-java-stack:v1.0.0

USER root
WORKDIR /opt

RUN yum install java-11-openjdk-devel -y -q && \
    update-alternatives --set java /usr/lib/jvm/java-11-openjdk-11.0.10.0.9-4.el8_3.x86_64/bin/java
