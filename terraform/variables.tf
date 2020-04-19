
variable "name" {
  description = "Base name to use for resources in the module"
  default     = "da-wordpress"
}

variable "vpc_id" {
  description = "VPC ID to create cluster in"
  default     = "aws_vpc.da-wordpress-vpc.id"
}

variable "vpc_subnets" {
  description = "List of VPC subnets to put instances in"
  default     = []
}

variable "cidr_vpc" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnet-wp-a" {
  type    = string
  default = "10.0.63.0/24"
}

variable "private_subnet-wp-b" {
  type    = string
  default = "10.0.127.0/24"
}

variable "public_subnet-wp-a" {
  type    = string
  default = "10.0.191.0/24"
}

variable "public_subnet-wp-b" {
  type    = string
  default = "10.0.255.0/24"
}

variable "ecr_repository-image" {
  type    = string
  default = "wp-image"
}

# the ECS optimized AMI's change by region. You can lookup the AMI here:
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
variable "image_id" {
  type        = string
  description = "AMI image_id for ECS instance"
  default     = "ami-064db566f79006111"
}

variable  "instance_type" {
    type        = string
    description = "AMI instance_type for ECS instance"
    default     = "t2.micro"
}