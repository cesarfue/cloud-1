output "public_ips" {
  description = "Public IPv4 addresses of the instances, to put in the Ansible inventory."
  value       = aws_instance.web[*].public_ip
}
