output "nginx1_public_dns" {
  description = ""
  value       = "http://${aws_instance.nginx1.public_dns}:${var.http_port}"
}

output "vpc_id" {
  value = aws_vpc.app.id
}

output "subnet_id" {
  value = aws_subnet.public_subnet1.id
}
