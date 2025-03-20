########################################
# Variables
########################################
variable "env" {
  description = "Environment name (e.g., Dev, QA, UAT)"
}

variable "region" {
  description = "AWS Region (e.g., us-east-1)"
}

variable "instance_type" {
  description = "EC2 Instance Type (e.g., t2.micro, t2.large)"
}

########################################
# AWS Provider
########################################
provider "aws" {
  region = var.region
}

########################################
# VPC
########################################
resource "aws_vpc" "main" {
  cidr_block = "10.20.0.0/16"

  tags = {
    Name = "VPC-${var.env}"
  }
}

########################################
# Internet Gateway
########################################
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW-${var.env}"
  }
}

########################################
# Subnet
########################################
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.20.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-${var.env}"
  }
}

########################################
# Route Table & Association
########################################
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "RouteTable-${var.env}"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

########################################
# EC2 Instance
########################################
resource "aws_instance" "main" {
  ami           = "ami-04aa00acb1165b32a"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "Instance-${var.env}"
  }
}
