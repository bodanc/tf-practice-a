/*
this Terraform configuration sets up a basic web application on AWS using an EC2 instance running NGINX;
it includes the necessary networking components such as a VPC, subnet, internet gateway, and security groups;
*/

terraform {

  backend "local" {
    path = "./terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      created_by = "terraform"
    }
  }
}

##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# output "a" {
#   value = nonsensitive(data.aws_ssm_parameter.amzn2_linux)
# }

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
resource "aws_vpc" "app" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.vpc_enable_dns_hostnames

  # tags = local.common_tags
  tags = merge(local.common_tags, { Name = lower("${local.prefix}-vpc") })

}

resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id

  tags = merge(local.common_tags, { Name = lower("${local.prefix}-igw") })
}

resource "aws_subnet" "public_subnet1" {
  cidr_block              = var.subnet1_cidr_block
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = var.subnet_map_public_ip_on_launch

  tags = merge(local.common_tags, { Name = lower("${local.prefix}-pub-sub1") })
}

# ROUTING #
resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app.id
  }

  tags = merge(local.common_tags, { Name = lower("${local.prefix}-pub-rtb") })
}

resource "aws_route_table_association" "app_subnet1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.app.id
}

# security groups #
resource "aws_security_group" "sg_nginx" {
  name = lower("${local.prefix}-sg-nginx")

  vpc_id = aws_vpc.app.id

  # http-only access from anywhere
  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# ec2 instances #
resource "aws_instance" "nginx1" {
  ami                         = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.public_subnet1.id
  vpc_security_group_ids      = [aws_security_group.sg_nginx.id]
  user_data_replace_on_change = true

  tags = merge(local.common_tags, { Name = lower("${local.prefix}-nginx1") })

  user_data = templatefile("./templates/startup.tpl", { environment = var.environment })
}
