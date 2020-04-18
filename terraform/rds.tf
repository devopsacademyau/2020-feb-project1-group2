resource "aws_rds_cluster" "wp-db" {
  
    cluster_identifier            = "wp-db"
    database_name                 = "wpdb"
    availability_zones            = ["ap-southeast-2a", "ap-southeast-2b"]
    engine                        = "aurora-mysql"
    engine_version                = "5.7.12"
    engine_mode                   = "serverless"
    master_username               = "${var.rds_master_username}"
    master_password               = "${var.rds_master_password}"
    backup_retention_period       = 1
    preferred_backup_window       = "02:00-03:00"
    preferred_maintenance_window  = "wed:03:00-wed:04:00"
    db_subnet_group_name          = "${aws_db_subnet_group.wpdb_subnet_group.name}"
    final_snapshot_identifier     = "wpdb-aurora-cluster"
    lifecycle {
        create_before_destroy = true
    }

}

resource "aws_rds_cluster_instance" "aurora_cluster_instance" {

    identifier            = "da-wordpress-db"
    cluster_identifier    = "${aws_rds_cluster.wp-db.id}"
    instance_class        = "db.t2.micro"
    db_subnet_group_name  = "aws_db_subnet_group.wpdb_subnet_group.name"
    publicly_accessible   = false

    lifecycle {
        create_before_destroy = true
    }

}

resource "aws_db_subnet_group" "wpdb_subnet_group" {

    name          = "wp-db_subnet_group"
    description   = "Allowed subnets for Aurora DB cluster instances"
    subnet_ids    = ["${aws_subnet.private-wp-a.id}", "${aws_subnet.private-wp-b.id}"]
}

