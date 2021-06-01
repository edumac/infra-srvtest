FROM tomcat:8.5.57-jdk8-openjdk

WORKDIR /

COPY ./startup /startup
RUN chmod +x /startup/install/*.sh

ENTRYPOINT /startup/install/run-start.sh