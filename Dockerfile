FROM tomcat:9.0-jre8-alpine
ARG VERSION
LABEL version = ${VERSION}
COPY target/petclinic.war /usr/local/tomcat/webapps/petclinic.war
