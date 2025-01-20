# Create an Application Load Balancer (ALB)
resource "aws_lb" "wordpress_lb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = aws_subnet.public_subnet[*].id
  enable_deletion_protection = false

  tags = {
    Name = "WordPress ALB"
  }
}

# Create a Target Group for WordPress EC2 instances
resource "aws_lb_target_group" "wordpress_target_group" {
  name        = "wordpress-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "WordPress Target Group"
  }
}

# Create a listener for the ALB to forward traffic on port 80 to the target group
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.wordpress_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_target_group.arn
  }
}

# Associate the ASG with the Load Balancer Target Group
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn  = aws_lb_target_group.wordpress_target_group.arn
}


