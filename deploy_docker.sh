# 변수 설정
PROJECT_DIR="/opt/servers/deploy_practice"
BRANCH="main"
PORT=8080

# 실패 시 스크립트 중단
set -e

# 1. Git Pull
echo "Pulling latest changes from $BRANCH..."
git pull origin $BRANCH --rebase
git clean -fd

# Gradle 데몬 중지
echo "Stopping any existing Gradle daemons..."
./gradlew --stop

# 2. Build JAR
echo "Building the project..."
./gradlew clean bootJar

# 3. Docker 이미지 빌드
echo "Building Docker image..."
docker build -t spring-app:latest .

# 4. 기존 컨테이너 중지 및 제거
if [ "$(docker ps -q -f name=spring-app-container)" ]; then
    echo "Stopping existing container..."
    docker stop spring-app-container
    echo "Removing existing container..."
    docker rm spring-app-container
else
    echo "No existing container with name 'spring-app-container' found."
fi

# 5. 새 컨테이너 실행
echo "Starting new container..."
docker run -d \
  --name spring-app-container \
  -p $PORT:8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  -v $PROJECT_DIR/logs:/app/logs \
  spring-app:latest

# 6. 로그 출력
echo "Application started successfully. Tailing logs..."
docker logs -f spring-app-container