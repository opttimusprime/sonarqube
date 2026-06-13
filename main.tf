resource "aws_security_group" "sonarqube" {
  name        = "${local.name}-sg"
  description = "Security group for SonarQube"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "SonarQube UI"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.allowed_sonarqube_cidr]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name}-sg"
  })
}

resource "aws_instance" "sonarqube" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.sonarqube.id]

  user_data = file("${path.module}/userdata/sonarqube.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = merge(local.common_tags, {
    Name = local.name
  })
}

resource "aws_eip" "sonarqube" {
  instance = aws_instance.sonarqube.id
  domain   = "vpc"

  tags = merge(local.common_tags, {
    Name = "${local.name}-eip"
  })
}

resource "aws_route53_record" "sonarqube" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "sonarqube.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.sonarqube.public_ip]
}