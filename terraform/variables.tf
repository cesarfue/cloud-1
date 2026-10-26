variable "region" {
  description = "AWS region hosting the instances."
  type        = string
  default     = "eu-west-3"
}

variable "instance_count" {
  description = "Number of identical instances to deploy the stack on in parallel."
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count >= 1
    error_message = "instance_count must be at least 1."
  }
}

variable "instance_type" {
  description = "EC2 instance type, free tier eligible by default."
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size" {
  description = "Root volume size in GiB."
  type        = number
  default     = 20
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key installed for the ubuntu user."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to reach port 22, typically the operator's public IP as x.x.x.x/32."
  type        = string

  validation {
    condition     = can(cidrhost(var.ssh_allowed_cidr, 0))
    error_message = "ssh_allowed_cidr must be a valid CIDR block, such as 203.0.113.7/32."
  }
}
