FROM maven:3 as build 
WORKDIR /app
COPY . .
RUN mvn clean install 

FROM openjdk:12-alpine
WORKDIR /app
COPY /app/target/Uber.jar /app/Uber.jar

EXPOSE 9099

ENTRYPOINT [ "java","-jar","./Uber.jar" ]