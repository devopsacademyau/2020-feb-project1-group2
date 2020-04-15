  
variable "additional_user_data_script" {
  description = "Additional user data script (default=\"\")"
  default     = ""
}

variable "asg_max_size" {
  description = "Maximum number EC2 instances"
  default     = 2
}

variable "asg_min_size" {
  description = "Minimum number of instances"
  default     = 1
}

variable "asg_desired_size" {
  description = "Desired number of instances"
  default     = 1
}

variable "image_id" {
  description = "AMI image_id for ECS instance"
  default     = "ami-064db566f79006111"
}

variable "instance_keypair" {
  description = "Instance keypair name"
  default     = "starkmatt-box"
}

variable "instance_log_group" {
  description = "Instance log group in CloudWatch Logs"
  default     = ""
}

variable "instance_root_volume_size" {
  description = "Root volume size (default=50)"
  default     = 50
}

variable "instance_type" {
  description = "EC2 instance type (default=t2.micro)"
  default     = "t2.micro"
}

variable "name" {
  description = "Base name to use for resources in the module"
  default     = "da-wordpress"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID to create cluster in"
  default     = "da-wordpress-vpc"
}

variable "vpc_subnets" {
  description = "List of VPC subnets to put instances in"
  default     = ["private-wp-a","private-wp-b","public-wp-a","public-wp-b"]
}


variable "cidr_vpc" {
    type    = string
    default = "10.0.0.0/16"
}

variable "private_subnet-wp-a" {
    type    = string
    default = "10.0.63.0/18"
}

variable "private_subnet-wp-b" {
    type    = string
    default = "10.0.127.0/18"
}

variable "public_subnet-wp-a" {
    type    =  string
    default = "10.0.191.0/18"
}

variable "public_subnet-wp-b" {
    type    =  string
    default = "10.0.255.0/18"
}

