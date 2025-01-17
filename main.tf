# VPC Creation
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Main VPC"
  }
}

# Create Public Subnet
resource "aws_subnet" "public_subnet" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.1.0/24"
    count                  = length(var.availability_zones)
    availability_zone       = element(var.availability_zones, count.index)
    # availability_zone = var.availability_zone
    map_public_ip_on_launch = true
    tags = {
        Name = "Public Subnet ${count.index + 1}"
        # Name = "Public Subnet"
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Main IGW"
  }
}

# Create Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Main Route Table"
  }
}

# Associate Route Table with the Public Subnet
resource "aws_route_table_association" "public_subnet_association" {
    count              = length(var.availability_zones)
    subnet_id          = aws_subnet.public_subnet [count.index + 1].id
    route_table_id     = aws_route_table.main.id
}

# Security group to allow HTTP traffic
resource "aws_security_group" "allow_http" {
    name        = "allow_http"
    description = "Allow inbound HTTP traffic"
    vpc_id = aws_vpc.main.id
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# IAM Role for Auto Scaling
resource "aws_iam_role" "auto_scaling_role" {
  name = "auto-scaling-role"

  assume_role_policy = jsonencode({
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to the role
resource "aws_iam_role_policy_attachment" "policy_attachments" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AutoScalingFullAccess",
    "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  ])
  role       = aws_iam_role.auto_scaling_role.name
  policy_arn = each.value
}

# Create IAM instance profile
resource "aws_iam_instance_profile" "auto_scaling_instance_profile" {
  name = "auto-scaling-instance-profile"
  role = aws_iam_role.auto_scaling_role.name
}
