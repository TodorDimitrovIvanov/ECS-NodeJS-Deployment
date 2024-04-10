
// The networking containing a list of available addresses 
resource "aws_vpc" "nodejs-cluster-vpc" {
  cidr_block = "10.0.0.0/24" #256 address network 
}

# The subnetwork for the ECS cluster and its containers 
resource "aws_subnet" "nodejs-cluster-subnet" {
  vpc_id     = aws_vpc.nodejs-cluster-vpc.id
  cidr_block = "10.0.0.0/16" 
  availability_zone = "eu-central-1a" 

  # Enable public access for internet gateway attachment later
  map_public_ip_on_launch = true
}

# Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.nodejs-cluster-vpc.id
}

# Network access rules
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.nodejs-cluster-vpc.id

  route {
    cidr_block = "0.0.0.0/0" # Route all outbound traffic to internet gateway
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

# Security group for the ECS cluster and its containers
resource "aws_security_group" "nodejs-cluster-sec-grp" {
  name        = "nodejs-cluster-sec-grp"
  description = "Security group for ECS"

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
