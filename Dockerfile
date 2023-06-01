FROM openjdk:19-alpine
WORKDIR /app
COPY target/Uber.jar /app/Uber.jar
EXPOSE 9099

ENTRYPOINT [ "java","-jar", "./Uber.jar" ]