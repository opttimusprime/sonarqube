#############################################
# Security Group
#############################################

resource "aws_security_group" "sonarqube" {
  name        = "${var.project}-${var.environment}-sonarqube-sg"
  description = "Security Group for SonarQube"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from Jenkins VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.jenkins_vpc_cidr]
  }

  ingress {
    description = "SonarQube UI"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.jenkins_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-sonarqube-sg"
    Project     = var.project
    Environment = var.environment
  }
}

#############################################
# SonarQube EC2
#############################################

resource "aws_instance" "sonarqube" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t3.medium"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.sonarqube.id]
  key_name               = var.key_name

  user_data = file("${path.module}/user_data.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name        = "${var.project}-${var.environment}-sonarqube"
    Project     = var.project
    Environment = var.environment
  }
}

