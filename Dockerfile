FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app

COPY pom.xml .
RUN MAVEN_OPTS="-Xmx256m -XX:MaxMetaspaceSize=128m" mvn -q dependency:go-offline -Dmaven.test.skip=true

COPY src ./src
RUN MAVEN_OPTS="-Xmx256m -XX:MaxMetaspaceSize=128m -XX:+TieredCompilation -XX:TieredStopAtLevel=1" mvn clean package -DskipTests

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /app/target/duoclone-backend-*.jar app.jar
CMD java -Xmx256m -Xms256m -XX:MaxMetaspaceSize=128m -Xss512k -jar /app/app.jar --spring.profiles.active=prod