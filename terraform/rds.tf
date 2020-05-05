resource "aws_rds_cluster" "wp-db" {

  database_name                = var.name
  engine                       = "aurora-mysql"
  engine_version               = "5.7.mysql_aurora.2.03.2"
  master_username              = "${var.rds_master_username}"
  master_password              = "${random_password.pw.result}"
  backup_retention_period      = 1
  skip_final_snapshot          = true
  apply_immediately            = true
  preferred_backup_window      = "02:00-03:00"
  preferred_maintenance_window = "wed:03:00-wed:04:00"
  db_subnet_group_name         = aws_db_subnet_group.wpdb_subnet_group.name
  lifecycle {
    create_before_destroy = false
  }

}

resource "aws_rds_cluster_instance" "aurora_cluster_instance" {

  cluster_identifier   = "${aws_rds_cluster.wp-db.id}"
  identifier           = "${var.name}-db"
  engine               = "aurora-mysql"
  engine_version       = "5.7.mysql_aurora.2.03.2"
  instance_class       = "db.r4.large"
  db_subnet_group_name = aws_db_subnet_group.wpdb_subnet_group.name
  publicly_accessible  = false

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_db_subnet_group" "wpdb_subnet_group" {

  name        = "wp-db_subnet_group"
  description = "Allowed subnets for Aurora DB cluster instances"
  subnet_ids  = ["${aws_subnet.private-wp-a.id}", "${aws_subnet.private-wp-b.id}"]
}

resource "random_password" "pw" {
  length  = 10
  upper   = true
  special = false
}


