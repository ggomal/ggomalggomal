# Docker file

# jdk17 Image Start
FROM openjdk:17-jdk

# 인자 정리 - Jar
ARG JAR_FILE=build/libs/*.jar

# jar file copy
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-Dspring.profiles.active=docker", "-jar", "app.jar"]