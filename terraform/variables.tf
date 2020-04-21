
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
    type = list(string)
    default = ["ap-southeast-2a", "ap-southeast-2b"]
}
