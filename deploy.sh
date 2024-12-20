#!/bin/bash

# 프로젝트 경로 설정
PROJECT_DIR="/opt/servers/deploy_practice"
SYMBOLIC_LINK_NAME="current.jar"
BRANCH="main"
PORT=8080

# 하나라도 실패하면 정지
set -e

# 2. Git Pull
echo "Pulling latest changes from $BRANCH..."
git pull origin $BRANCH --rebase

git clean -fd

# Gradle 데몬 중지
echo "Stopping any existing Gradle daemons..."
./gradlew --stop

# 3. Build
echo "Building the project..."
./gradlew clean bootJar

set +e

BUILD_JAR_FILE=$(ls ./build/libs/deploy-test-*.jar)
echo "build jar file name : $BUILD_JAR_FILE"

SYMBOLIC_LINK="$PROJECT_DIR/current.jar"

echo "Copying jar file to the upper directory..."
cp "$BUILD_JAR_FILE" "$PROJECT_DIR/"


TARGET_JAR_FILE=$(basename $BUILD_JAR_FILE)

echo "Link symbol with $TARGET_JAR_FILE..."
ln -sf "$TARGET_JAR_FILE" "$SYMBOLIC_LINK"

# 4. Kill existing process on port 8080
PID=$(lsof -ti tcp:$PORT)
if [ -z "$PID" ]; then
    echo "No process using port $PORT found."
else
    echo "Process $PID is using port $PORT."
    echo "Killing process $PID..."
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
fi

# 6. 애플리케이션 실행
echo "Starting new application on port $PORT..."
echo "symbolic link : $SYMBOLIC_LINK"
cd "$PROJECT_DIR" || { echo "Project directory not found! Exiting."; exit 1; }
# 2 >&1 예외, 정상 로그 출력 한곳에서 처리
nohup java -jar -Dserver.port=$PORT "$PROJECT_DIR/$TARGET_JAR_FILE" --spring.profiles.active=prod > app.log 2>&1 &
#disown
#nohup java -jar -Dserver.port=$PORT "$SYMBOLIC_LINK" --spring.profiles.active=prod > app.log 2>&1 &

sleep 2  # 애플리케이션 시작 대기 시간

echo "Application started successfully. Tailing logs..."
tail -1000f app.log