provider "aws" {
  region = var.region
}

resource "aws_vpc" "testingInstance" {
  cidr_block       = "10.20.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "VPC-${var.env}"
  }
}

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.testingInstance.id

  tags = {
    Name = "IG-${var.env}"
  }
}

resource "aws_subnet" "vpc1" {
  vpc_id     = aws_vpc.testingInstance.id
  cidr_block = "10.20.1.0/24"  # Subnet must be a subset of the VPC CIDR

  tags = {
    Name = "Subnet-${var.env}"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.testingInstance.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }

  tags = {
    Name = "RouteTable-${var.env}"
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.vpc1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_instance" "serv1" {
  ami           = "ami-04aa00acb1165b32a"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.vpc1.id

  tags = {
    Name = var.env
  }
}

variable "env" {
  description = "Environment name (e.g., Dev, QA, UAT)"
}

variable "region" {
  description = "AWS Region (e.g., us-east-1)"
}

variable "instance_type" {
  description = "EC2 Instance Type (e.g., t2.large, t3.medium)"
}
