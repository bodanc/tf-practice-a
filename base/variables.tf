variable "aws_region" {
  description = "main AWS region to use"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = ""
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet1_cidr_block" {
  description = ""
  type        = string
  default     = "10.0.0.0/24"
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

variable "sg_ingress_port_number" {
  description = ""
  type        = number
}

variable "ec2_instance_type" {
  description = ""
  type        = string
}

#####

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
