resource "aws_ssm_parameter" "wordpress-db-host" {
  name        = "/wordpress/WORDPRESS_DB_HOST"
  description = "The host parameter to be used by the container"
  type        = "SecureString"
  value       = "secret"
}

resource "aws_ssm_parameter" "wordpress-db-user" {
  name        = "/wordpress/WORDPRESS_DB_USER"
  description = "The user parameter to be used by the container"
  type        = "SecureString"
  value       = "secret"
}

resource "aws_ssm_parameter" "wordpress-db-password" {
  name        = "/wordpress/WORDPRESS_DB_PASSWORD"
  description = "The password parameter to be used by the container"
  type        = "SecureString"
  value       = "secret"
}

resource "aws_ssm_parameter" "wordpress-db-name" {
  name        = "/wordpress/WORDPRESS_DB_NAME"
  description = "The name parameter to be used by the container"
  type        = "SecureString"
  value       = "secret"
}
