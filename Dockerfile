FROM centos:latest

MAINTAINER Anton Melnikov <amiller@yandex.ru>

RUN dnf update -y 

#git
RUN dnf install -y git

# maven
RUN dnf install -y maven

# JDK
RUN dnf install -y java-11-openjdk-devel

# Tomcat
RUN useradd -r tomcat
RUN curl -o /tmp/tomcat9.tar.gz http://mirror.linux-ia64.org/apache/tomcat/tomcat-9/v9.0.38/bin/apache-tomcat-9.0.38.tar.gz 
RUN tar -xf /tmp/tomcat9.tar.gz -C /usr/local
RUN chown -R tomcat:tomcat /usr/local/apache-tomcat-9.0.38
RUN export CATALINA_HOME="/usr/local/apache-tomcat-9.0.38"

# удаляем дефолтные страницы из папки томката
RUN rm -rf /usr/local/apache-tomcat-9.0.38/webapps/ROOT/*

# клонируем проект
RUN cd /tmp && git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git 

# собираем и публикуем
RUN mvn package -f /tmp/boxfuse-sample-java-war-hello/pom.xml
RUN cp -r /tmp/boxfuse-sample-java-war-hello/target/hello-1.0/* /usr/local/apache-tomcat-9.0.38/webapps/ROOT/

# открываем порт
EXPOSE 8080

ENTRYPOINT /usr/local/apache-tomcat-9.0.38/bin/catalina.sh run


