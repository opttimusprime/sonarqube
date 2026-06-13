#!/bin/bash
set -e

dnf update -y
dnf install -y docker

systemctl enable docker
systemctl start docker

usermod -aG docker ec2-user

sysctl -w vm.max_map_count=262144
sysctl -w fs.file-max=65536

cat <<EOF >> /etc/sysctl.conf
vm.max_map_count=262144
fs.file-max=65536
EOF

mkdir -p /opt/sonarqube
cd /opt/sonarqube

cat > docker-compose.yml <<EOF
version: "3.8"

services:
  postgres:
    image: postgres:15
    container_name: sonarqube-postgres
    restart: always
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: sonarpassword
      POSTGRES_DB: sonarqube
    volumes:
      - postgres_data:/var/lib/postgresql/data

  sonarqube:
    image: sonarqube:community
    container_name: sonarqube
    restart: always
    depends_on:
      - postgres
    ports:
      - "9000:9000"
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://postgres:5432/sonarqube
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: sonarpassword
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_logs:/opt/sonarqube/logs
      - sonarqube_extensions:/opt/sonarqube/extensions

volumes:
  postgres_data:
  sonarqube_data:
  sonarqube_logs:
  sonarqube_extensions:
EOF

docker compose up -d