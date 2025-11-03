variable "aws_region" {
  description = "main AWS region to use"
  type        = string
  default     = ""
}

variable "vpc_cidr_block" {
  description = ""
  type        = string
  default     = ""
}

variable "subnet1_cidr_block" {
  description = ""
  type        = string
  default     = ""
}

variable "vpc_enable_dns_hostnames" {
  description = ""
  type        = bool
  default     = true
}

variable "subnet_map_public_ip_on_launch" {
  description = ""
  type        = bool
  default     = true
}

variable "http_port" {
  description = ""
  type        = number
}

variable "ec2_instance_type" {
  description = ""
  type        = string
}

##### locals #####

variable "company_name" {
  description = ""
  type        = string
  default     = "EvilCorp"
}

variable "project" {
  description = ""
  type        = string
  default     = ""
}

variable "environment" {
  description = ""
  type        = string
  default     = ""
}

variable "billing_code" {
  description = ""
  type        = number
}
