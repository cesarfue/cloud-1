output "public_ips" {
  description = "Public IPv4 addresses of the instances, to put in the Ansible inventory."
  value       = aws_instance.web[*].public_ip
}

output "ansible_inventory" {
  description = "Ansible inventory listing the instances, written to ansible/inventory/aws.ini by make up."
  value       = "[web]\n${join("", [for ip in aws_instance.web[*].public_ip : "${ip} ansible_user=ubuntu\n"])}"
}
