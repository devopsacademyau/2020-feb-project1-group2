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

