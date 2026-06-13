data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "roboshop-tf-state"
    key    = "dev/bootstrap/vpc/terraform.tfstate"
    region = var.aws_region
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}