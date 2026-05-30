variable "aws_region" {}
variable "project" {}
variable "environment" {}

variable "vpc_id" {}
variable "public_subnet_id" {}
variable "jenkins_vpc_cidr" {}

variable "instance_type" {
  default = "t3.medium"
}

variable "key_name" {}