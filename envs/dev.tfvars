project     = "roboshop"
environment = "dev"
aws_region  = "us-east-1"

instance_type = "c7i-flex.large"
key_name      = "roboshop-dev-keypair"

allowed_ssh_cidr       = "0.0.0.0/0"
allowed_sonarqube_cidr = "0.0.0.0/0"

domain_name = "optimusprime.uno"