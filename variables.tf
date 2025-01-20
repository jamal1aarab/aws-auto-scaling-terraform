variable "region" {
  description = "AWS region"
  default     = "eu-west-2"
}

variable "availability_zones" {
  description = "List of Availability Zones for the Auto Scaling group"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

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


# Variables for the MySQL RDS instance

variable "db_name" {
  description = "The name of the MySQL database"
  type        = string
  default     = "wordpress-db"
}

variable "db_username" {
  description = "The username for the MySQL database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The password for the MySQL database"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "The port for the MySQL database"
  type        = number
  default     = 3306
}

variable "db_instance_class" {
  description = "The instance class for the MySQL database"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "The allocated storage size in GB for the MySQL database"
  type        = number
  default     = 20
}

variable "db_storage_type" {
  description = "The storage type for the MySQL database (e.g., gp2, io1)"
  type        = string
  default     = "gp2"
}