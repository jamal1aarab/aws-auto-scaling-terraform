output "iam_role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.auto_scaling_role.name
}

output "instance_profile_name" {
  description = "The name of the IAM instance profile"
  value       = aws_iam_instance_profile.auto_scaling_instance_profile.name
}

# Data source to get instances with a specific tag (ASG's tag)
data "aws_instances" "asg_instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.asg.name]
  }
}

# Output instance IDs of instances associated with the ASG
output "instance_ids" {
  value = data.aws_instances.asg_instances.ids
}