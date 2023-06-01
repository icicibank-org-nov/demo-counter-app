FROM maven:3-alpine as build
WORKDIR /app
RUN mvn clean package
COPY . .

FROM openjdk:19-alpine
COPY --from=build app/target/springboot-1.0.0.jar springboot.jar
EXPOSE 8080

ENTRYPOINT [ "java","-jar", "./springboot-*.jar" ]
