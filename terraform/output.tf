
output "ecr-url" {
  value = ["${aws_ecr_repository.da-wordpress-ecr.repository_url}"]
}
