# Template for EC2 Instances
resource "aws_launch_template" "ec2_launch_template" {
  name_prefix   = "ec2_launch_template-"
  image_id      = var.debian_ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.auto_scaling_instance_profile.name
  }
}

# resource "aws_placement_group" "test" {
#     name     = "test"
#     strategy = "cluster"
# }

# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
    desired_capacity       = var.desired_capacity
    min_size               = var.min_size
    max_size               = var.max_size
    vpc_zone_identifier    = aws_subnet.public_subnet[*].id  # Include all public subnets

    launch_template {
        id       = aws_launch_template.ec2_launch_template.id
        version  = aws_launch_template.ec2_launch_template.latest_version
    }

    health_check_type          = "EC2"
    health_check_grace_period  = 300
    force_delete               = true
    wait_for_capacity_timeout  = "0"
}



# Scaling policies
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  metric_aggregation_type = "Average"
  autoscaling_group_name = aws_autoscaling_group.asg.name
}
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  metric_aggregation_type = "Average"
  autoscaling_group_name = aws_autoscaling_group.asg.name
}
