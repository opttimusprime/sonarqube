bucket         = "opttimusprime-sonarqube-tf-state"
key            = "sonarqube/preprod/terraform.tfstate"
dynamodb_table = "opttimusprime-sonarqube-tf-lock"
region         = "us-east-1"
encrypt        = true