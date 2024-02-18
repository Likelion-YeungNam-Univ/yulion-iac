# 1. 패키지 리스트 최신 업데이트
sudo apt update
# 2. HTTPS 관련 패키지 설치
sudo apt install apt-transport-https ca-certificates curl software-properties-common
# 3. docker 레포지토리 접근을 위한 GPG Key 설정
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# 4. docker 레포지토리 등록
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
# 5. docker 레포지토리를 포함한 패키지 리스트 재업데이트
sudo apt update
# 6. docker 설치
sudo apt install docker-ce

# 7. docker-compose 설치
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# 8. docker-compose 권한 부여
sudo chmod +x /usr/local/bin/docker-compose
# 9. docker-compose 심볼릭 링크 설정
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
