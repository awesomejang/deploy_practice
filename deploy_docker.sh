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

## 3. 기존 컨테이너 중지 및 제거
#echo "Stopping and removing existing containers..."
#docker-compose down || true

# 3. 기존 컨테이너 중지 및 제거
echo "Stopping and removing existing deploy-application container..."
docker-compose stop deploy-application || true
docker-compose rm -f deploy-application || true

# 4. 새 컨테이너 실행
echo "Starting deploy-application container using docker-compose..."
docker-compose up -d --build deploy-application # docker-compose up -d(백그라운드 실행) --build(이미지 빌드)

# 5. 로그 출력
echo "Application started successfully. Tailing logs..."
docker-compose logs -f