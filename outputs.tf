# VPC and Networking
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.gw.id
}

output "route_table_id" {
  description = "The ID of the route table"
  value       = aws_route_table.main.id
}

# IAM Role and Launch Template
output "iam_role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.auto_scaling_role.name
}

output "launch_template_id" {
  description = "The ID of the launch template used by the Auto Scaling Group"
  value       = aws_launch_template.ec2_launch_template.id
}


# Auto Scaling Group (ASG)
output "asg_id" {
  description = "The ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.id
}

output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.name
}

# output "asg_instances" {
#   description = "The EC2 instance IDs created by the Auto Scaling Group"
#   value       = aws_autoscaling_group.asg.instances
# }

output "asg_availability_zones" {
  description = "The availability zones of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.availability_zones
}


# RDS MySQL Database
output "db_endpoint" {
  description = "The endpoint of the RDS MySQL database"
  value       = aws_db_instance.mysql.endpoint
}

output "db_port" {
  description = "The port of the RDS MySQL database"
  value       = aws_db_instance.mysql.port
}

output "db_name" {
  description = "The name of the MySQL database"
  value       = aws_db_instance.mysql.identifier
}

output "db_user" {
  description = "The username for the MySQL database"
  value       = aws_db_instance.mysql.username
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}


output "wordpress_alb_dns" {
  value = aws_lb.wordpress_lb.dns_name
}

