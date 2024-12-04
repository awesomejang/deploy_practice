# 1. Base Image 설정
FROM openjdk:21-jdk-alpine

# 2. 작업 디렉토리 설정
WORKDIR /app

# 3. Gradle 빌드된 JAR 파일 복사
ARG JAR_FILE=build/libs/deploy-test-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar

# 4. 프로필 환경변수 설정 (예: prod)
ENV SPRING_PROFILES_ACTIVE=prod

# 5. 포트 노출
EXPOSE 8080

# 6. 실행 명령어
ENTRYPOINT ["java", "-jar", "-Dserver.port=8080", "app.jar"]