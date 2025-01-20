# MySQL RDS Subnet Group (using private subnets)
resource "aws_db_subnet_group" "mysql_subnets" {
  name       = "mysql-subnet-group"
  subnet_ids = aws_subnet.private_subnet[*].id  # Using private subnets for MySQL DB

  tags = {
    Name = "MySQL Subnet Group"
  }
}

# MySQL RDS Instance
resource "aws_db_instance" "mysql" {
  identifier              = var.db_name
  allocated_storage       = var.db_allocated_storage
  storage_type            = var.db_storage_type
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.db_instance_class
  username                = var.db_username
  password                = var.db_password
  port                    = var.db_port
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.mysql_subnets.name
  backup_retention_period = 7
  multi_az                = true
  skip_final_snapshot     = true

  tags = {
    Name = "WordPress MySQL DB"
  }
}

# RDS Security Group (Allow access from WordPress EC2 instances)
resource "aws_security_group" "db_sg" {
  name        = "db-security-group"
  description = "Security group for RDS MySQL"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow MySQL traffic from WordPress servers"
    from_port        = var.db_port
    to_port          = var.db_port
    protocol         = "tcp"
    security_groups  = [aws_security_group.allow_http.id]  # WordPress Security Group
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS MySQL Security Group"
  }
}

# Create Private Subnets across multiple Availability Zones
resource "aws_subnet" "private_subnet" {
  count                  = length(var.availability_zones)
  vpc_id                 = aws_vpc.main.id
  cidr_block             = local.private_subnet_cidr_blocks[count.index]
  availability_zone      = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_eip" "nat" {
  vpc = true # deprecated
}

# NAT Gateway in the public subnet
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id  # Public subnet should be defined beforehand
  depends_on = [aws_eip.nat]
}

# Route Table for Private Subnets (Route through the NAT Gateway)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id  # Internet-bound traffic routed to NAT Gateway
  }

  tags = {
    Name = "Private Route Table"
  }
}

# Route Table Association for Private Subnets
resource "aws_route_table_association" "private_subnet_association" {
  count              = length(var.availability_zones)
  subnet_id          = aws_subnet.private_subnet[count.index].id
  route_table_id     = aws_route_table.private_route_table.id
}
