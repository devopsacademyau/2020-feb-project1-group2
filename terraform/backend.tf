terraform {
    backend "s3" {
    bucket = "wordpress-s3"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"
 }
}
