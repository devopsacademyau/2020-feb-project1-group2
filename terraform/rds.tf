resource "aws_rds_cluster" "wp-db" {
  cluster_identifier      = "wp-db"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.03.2"
  availability_zones      = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
  database_name           = "wpdb"
  master_username         = "wpadmin"
  master_password         = "iammradmin"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
}
