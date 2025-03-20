provider "aws" {
  region = var.region
}

resource "aws_vpc" "testingInstance" {
  cidr_block = "10.20.0.0/16"
  instance_tenancy = "default"
}

resource "aws_internet_gateway" "IG" {
    vpc_id = aws_subnet.vpc1.id
}

resource "aws_subnet" "vpc1" {
  vpc_id = aws_vpc.testingInstance.id
  cidr_block = "10.20.0.0/16"
}

resource "aws_instance" "serv1" {
  ami = var.goldenAmi
  instance_type = var.instance-type
  subnet_id = aws_subnet.vpc1.id
  tags = {
    Name = var.env
  }
}

variable "goldenAmi" {
    description = "AMI of Choice.. Amazon Linux Default"
    default = "ami-04aa00acb1165b32a"
}

variable "instanceName" {}

variable "env" {}

variable "region" {}

variable "instance-type" {}  
