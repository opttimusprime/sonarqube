output "sonarqube_public_ip" {
  value = aws_eip.sonarqube.public_ip
}

output "sonarqube_private_ip" {
  value = aws_instance.sonarqube.private_ip
}

output "sonarqube_url" {
  value = "http://sonarqube.${var.domain_name}:9000"
}