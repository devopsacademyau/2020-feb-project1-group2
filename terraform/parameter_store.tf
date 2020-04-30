resource "aws_ssm_parameter" "wordpress-db-host" {
  name        = "/wordpress/WORDPRESS_DB_HOST"
  description = "The host parameter to be used by the container and DB"
  type        = "SecureString"
  value       = random_password.value.result
}

resource "aws_ssm_parameter" "wordpress-db-user" {
  name        = "/wordpress/WORDPRESS_DB_USER"
  description = "The user parameter to be used by the container and DB"
  type        = "SecureString"
  value       = random_password.value.result
}

resource "aws_ssm_parameter" "wordpress-db-password" {
  name        = "/wordpress/WORDPRESS_DB_PASSWORD"
  description = "The password parameter to be used by the container and DB"
  type        = "SecureString"
  value       = random_password.value.result
}

resource "aws_ssm_parameter" "wordpress-db-name" {
  name        = "/wordpress/WORDPRESS_DB_NAME"
  description = "The name parameter to be used by the container and DB"
  type        = "SecureString"
  value       = random_password.value.result
}

resource "random_password" "value" {
  length           = 10
  special          = true
  override_special = "_%@"
}


