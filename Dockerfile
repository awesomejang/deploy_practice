# 1. Base Image 설정
FROM eclipse-temurin:21-jdk-alpine

# 필요한 패키지 설치
# 여러개 RUN 명령어를 하나로 합쳐 이미지 크기를 줄인다.
#RUN yum update -y && \
#    yum install -y java-21-openjdk-devel wget curl
# 2. 작업 디렉토리 설정
# 이후 모든 명령은 기본적으로 /app 디렉토리 기준으로 실행
WORKDIR /app

# 3. Gradle 빌드된 JAR 파일 복사
# ARG = Docker 이미지 빌드 시에만 유효한 빌드 타임 변수 선언
ARG JAR_FILE=build/libs/deploy-test-*.jar
COPY ${JAR_FILE} deploy-application.jar

# 4. 프로필 환경변수 설정 (예: prod)
# docker 전역에서 사용가능한 환경변수 설정
ENV SPRING_PROFILES_ACTIVE=dev

# 5. 포트 노출
# 단순히 명시일뿐
EXPOSE 8080

# 6. 실행 명령어
# 컨테이너가 시작될때 실행되는 명령어
# 배열의 각 명령어는 공백을 기준으로 붙어서 실행된다.
# "sh", "-c",
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=${SPRING_PROFILES_ACTIVE}", "-Dserver.port=8080", "deploy-application.jar"]