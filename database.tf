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

# RDS Security Group
resource "aws_security_group" "db_sg" {
  name        = "db-security-group"
  description = "Security group for RDS MySQL"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow MySQL traffic from WordPress servers"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    security_groups = [aws_security_group.allow_http.id] # WordPress SG
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS MySQL Security Group"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "mysql_subnets" {
  name       = "mysql-subnet-group"
  subnet_ids = aws_subnet.public_subnet[*].id

  tags = {
    Name = "MySQL Subnet Group"
  }
}