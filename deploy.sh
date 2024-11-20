#!/bin/bash

# 프로젝트 경로 설정
PROJECT_DIR="/opt/servers/deploy_practice:8080"
BRANCH="main"
JAR_NAME="deploy-test-0.0.1.jar" # 실제 jar 이름으로 변경
PORT=8080

# 하나라도 실패하면 정지
set -e

# 1. 프로젝트 디렉토리로 이동
#echo "Navigating to project directory: $PROJECT_DIR"
#cd $PROJECT_DIR || { echo "Project directory not found! Exiting."; exit 1; }

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
./gradlew clean bootJar # Gradle 사용 시

BUILD_JAR_FILE=$(ls ./build/libs/deploy-test-*.jar)
echo "build jar file name : $BUILD_JAR_FILE"

SYMBOLIC_LINK="$PROJECT_DIR/current.jar"

echo "Copying jar file to the upper directory..."
cp "$BUILD_JAR_FILE" "$PROJECT_DIR/"


TARGET_JAR_FILE=$(basename $BUILD_JAR_FILE)

echo "Link symbol with $TARGET_JAR_FILE..."
ln -sf "$TARGET_JAR_FILE" "$SYMBOLIC_LINK"

# 4. Kill existing process on port 8080
echo "Finding process using port $PORT..."
PID=$(lsof -ti tcp:$PORT)
if [ -n "$PID" ]; then
    echo "Killing process $PID using port $PORT..."
    kill -9 "$PID"

    for i in {1..10}; do
      if ps -p "$PID" > /dev/null; then
        echo "Waiting for process $PID to terminate..."
        sleep 1
      else
        echo "Process $PID terminated successfully."
        break
      fi
    done

    if ps -p "$PID" > /dev/null; then
      echo "Process $PID did not terminate gracefully. Forcing termination..."
      kill -9 "$PID"
      sleep 2
    fi
else
    echo "No process using port $PORT found."
fi

# 6. 애플리케이션 실행
echo "Starting new application on port $PORT..."
nohup java -jar -Dserver.port=$PORT "$SYMBOLIC_LINK" --spring.profiles.active=prod > app.log 2>&1 &
#nohup java -jar -Dserver.port=$PORT "$SYMBOLIC_LINK" --spring.profiles.active=prod > app.log 2>&1 &

echo "Deployment complete!"