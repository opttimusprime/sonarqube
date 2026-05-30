#!/bin/bash
set -e

dnf update -y
dnf install -y java-17-amazon-corretto git wget docker

systemctl enable docker
systemctl start docker

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

dnf install -y jenkins

usermod -aG docker jenkins

systemctl enable jenkins
systemctl start jenkins