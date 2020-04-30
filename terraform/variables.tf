
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
  default = "10.0.0.0/16"
}

variable "private_subnet-wp-a" {
  default = "10.0.63.0/24"
}

variable "private_subnet-wp-b" {
  default = "10.0.127.0/24"
}

variable "public_subnet-wp-a" {
  default = "10.0.191.0/24"
}

variable "public_subnet-wp-b" {
  default = "10.0.255.0/24"
}

variable "ecr_repository-image" {
  default = "wp-image"
}
variable "vpc_rds_subnet_ids" {
  description = "The ID's of the VPC subnets that the RDS cluster instances will be created in"
  default = ["private-wp-a", "private-wp-b"]
}

variable "vpc_rds_security_group_id" {
  default     = "aws_security_group.database.name"
}

variable "rds_master_username" {
  description = "The ID's of the VPC subnets that the RDS cluster instances will be created in"
  default     = "wpadmin"
}

variable "azs" {
    default = ["ap-southeast-2a", "ap-southeast-2b"]
}

# the ECS optimized AMI's change by region. You can lookup the AMI here:
variable "image_id" {
  description = "AMI image_id for ECS instance"
  default     = "ami-064db566f79006111"
}

variable  "instance_type" {
    description = "AMI instance_type for ECS instance"
    default     = "t2.micro"
}

variable  "project_name" {
    description = "Wordpress with LAMP stack migration"
    default     = "da-wordpress"
}
