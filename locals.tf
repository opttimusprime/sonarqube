locals {
  name = "${var.project}-${var.environment}-sonarqube"

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
    Component   = "sonarqube"
  }
}