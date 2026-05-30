data "terraform_remote_state" "roboshop_vpc" {

  backend = "s3"

  config = {
    bucket = "roboshop-terraform-state"
    key    = "dev/bootstrap/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "terraform_remote_state" "jenkins_vpc" {
  backend = "s3"

  config = {
    bucket = "opttimusprime-jenkins-tf-state"
    key    = "jenkins/dev/terraform.tfstate"
    region = "us-east-1"
  }
}