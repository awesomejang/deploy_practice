#!/bin/bash

# 프로젝트 경로 설정
PROJECT_DIR="/opt/repositories/deploy_practice"
BRANCH="main"
JAR_NAME="deploy-test-0.0.1.jar" # 실제 jar 이름으로 변경
PORT=8080

# 1. 프로젝트 디렉토리로 이동
echo "Navigating to project directory: $PROJECT_DIR"
cd $PROJECT_DIR || { echo "Project directory not found! Exiting."; exit 1; }

# 2. Git Pull
echo "Pulling latest changes from $BRANCH..."
git fetch origin
git reset --hard origin/$BRANCH
git clean -fd

# Gradle 데몬 중지
echo "Stopping any existing Gradle daemons..."
./gradlew --stop

# 3. Build
echo "Building the project..."
./gradlew clean bootJar   # Gradle 사용 시
# mvn clean package       # Maven 사용 시

# 4. Kill existing process on port 8080
echo "Finding process using port $PORT..."
PID=$(lsof -ti tcp:$PORT)
if [ -n "$PID" ]; then
    echo "Killing process $PID using port $PORT..."
    kill -9 "$PID"
else
    echo "No process found using port $PORT."
fi

# 5. 애플리케이션 종료 (기존 방식으로 실행된 프로세스도 종료)
echo "Stopping any existing application instances..."
pkill -f 'java -jar' || echo "No application instances running"

# 6. 애플리케이션 실행
echo "Starting new application on port $PORT..."
nohup java -jar -Dserver.port=$PORT build/libs/$JAR_NAME --spring.profiles.active=prod > app.log 2>&1 &

echo "Deployment complete!"