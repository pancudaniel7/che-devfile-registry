FROM codesquaddev/parent-java-stack:v1.0.0

WORKDIR /opt

RUN pip install --user --quiet pipenv