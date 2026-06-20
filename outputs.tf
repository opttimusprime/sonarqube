output "sonarqube_alb_dns_name" {
  value = aws_lb.sonarqube.dns_name
}

output "sonarqube_private_ip" {
  value = aws_instance.sonarqube.private_ip
}

output "sonarqube_url" {
  value = "https://sonarqube.${var.domain_name}"
}