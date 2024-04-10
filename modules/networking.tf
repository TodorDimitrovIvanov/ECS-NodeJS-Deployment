variable "vpc_cidr" {}
variable "sub1_cidr" {}
variable "sub2_cidr" {}
variable "zone1" {}
variable "zone2" {}
variable "cluster_name" {}


// The networking containing a list of available addresses 
resource "aws_vpc" "cluster-vpc" {
  cidr_block = "${var.vpc_cidr}"
}

# The subnetwork for the ECS cluster and its containers 
resource "aws_subnet" "cluster-subnet-1" {
  vpc_id     = aws_vpc.cluster-vpc.id
  cidr_block = "${var.sub1_cidr}" 
  availability_zone = "${var.zone1}" 

  # Enable public access for internet gateway attachment later
  map_public_ip_on_launch = true
}

resource "aws_subnet" "cluster-subnet-2" {
  vpc_id     = aws_vpc.cluster-vpc.id
  cidr_block = "${var.sub2_cidr}" 
  availability_zone = "${var.zone2}" 

  # Enable public access for internet gateway attachment later
  map_public_ip_on_launch = true
}

# Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.cluster-vpc.id
}

# Network access rules
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.cluster-vpc.id

  route {
    cidr_block = "0.0.0.0/0" # Route all outbound traffic to internet gateway
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

# Security group for the ECS cluster and its containers
resource "aws_security_group" "cluster-sec-grp" {
  name        = "${var.cluster_name}-sec-grp"
  description = "Security group for ECS"
  vpc_id = aws_vpc.cluster-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow inbound traffic from all sources on port 80
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow outbound traffic to all destinations (0.0.0.0/0) on all ports and protocols
  }
}
