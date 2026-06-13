variable "project" {}
variable "environment" {}
variable "aws_region" {}

variable "instance_type" {
  default = "c7i-flex.large"
}

variable "key_name" {}

variable "allowed_ssh_cidr" {}
variable "allowed_sonarqube_cidr" {}

variable "domain_name" {
  default = "optimusprime.uno"
}