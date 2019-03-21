FROM tomcat:9.0-jre8-alpine
LABEL version = "1.1.4"
COPY target/petclinic.war /usr/local/tomcat/webapps/petclinic.war
