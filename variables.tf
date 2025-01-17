variable "region" {
  description = "AWS region"
  default     = "eu-west-2"
}

variable "availability_zones" {
  description = "List of Availability Zones for the Auto Scaling group"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

# variable "availability_zone" {
#   description = "Availability Zone for the Auto Scaling group"
#   type        = string
#   default     = "eu-west-2a"
# }


# data "aws_ami" "latest_amazon_linux" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }
# }

# variable "latest_amazon_linux" {
#   description = "AMI ID used for EC2 instances"
#   default     = data.aws_ami.latest_amazon_linux.id
# }

# output "latest_amazon_linux" {
#   description = "AMI ID used for EC2 instances"
#   value       = data.aws_ami.latest_amazon_linux.id
# }

variable "debian_ami" {
  description = "Debian AMI ID"
  default     = "ami-0efc5833b9d584374"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "min_size" {
  description = "Minimum number of instances in Auto Scaling group"
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in Auto Scaling group"
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances in Auto Scaling group"
  default     = 2
}