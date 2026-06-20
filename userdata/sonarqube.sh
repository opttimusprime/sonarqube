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

docker network create sonarqube-net || true

docker volume create sonarqube_postgres_data || true
docker volume create sonarqube_data || true
docker volume create sonarqube_logs || true
docker volume create sonarqube_extensions || true

docker run -d \
  --name sonarqube-postgres \
  --restart always \
  --network sonarqube-net \
  -e POSTGRES_USER=sonar \
  -e POSTGRES_PASSWORD=sonarpassword \
  -e POSTGRES_DB=sonarqube \
  -v sonarqube_postgres_data:/var/lib/postgresql/data \
  postgres:15

sleep 30

docker run -d \
  --name sonarqube \
  --restart always \
  --network sonarqube-net \
  -p 9000:9000 \
  -e SONAR_JDBC_URL=jdbc:postgresql://sonarqube-postgres:5432/sonarqube \
  -e SONAR_JDBC_USERNAME=sonar \
  -e SONAR_JDBC_PASSWORD=sonarpassword \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_logs:/opt/sonarqube/logs \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  sonarqube:community