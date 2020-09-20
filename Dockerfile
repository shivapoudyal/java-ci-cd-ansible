# Pull base image 
From tomcat:8.0 

# Maintainer 
 
# COPY /target/*.war /usr/local/tomcat/webapps/

# COPY ./webapp.war /usr/local/tomcat/webapps


COPY target/*.war /usr/local/tomcat/webapps/java-project.war
