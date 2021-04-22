FROM codesquaddev/parent-java-stack:v1.0.0

WORKDIR /opt
RUN echo $PATH

RUN pip install --user --no-warn-script-location pipenv==2020.11.15 \
    grpcio==1.27.2 \
    pulsar-client==2.7.1 \
    unittest-xml-reporting==3.0.2 \
    requests==2.23.0 \
    junit2html==023
    
