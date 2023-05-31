FROM maven:3-alpine as build
WORKDIR /app
RUN mvn clean package
COPY . .

FROM openjdk:19-alpine
COPY --from=build /app target/
