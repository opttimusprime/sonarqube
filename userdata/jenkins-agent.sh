#!/bin/bash
set -e

dnf update -y
dnf install -y java-17-amazon-corretto git docker maven nodejs npm

systemctl enable docker
systemctl start docker

useradd -m -s /bin/bash jenkins || true
usermod -aG docker jenkins