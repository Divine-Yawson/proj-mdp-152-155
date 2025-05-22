# Build stage
FROM maven:3.8.6-openjdk-11 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

# Runtime stage
FROM tomcat:9.0.87-jre11
COPY --from=build /app/target/WebAppCal-*.war /usr/local/tomcat/webapps/WebAppCal.war
EXPOSE 8080
CMD ["catalina.sh", "run"]