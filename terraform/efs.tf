# EFS
resource "aws_efs_file_system" "da-wordpress-efs" {
  creation_token = "wordpress"
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"

  tags = {
    Name = "wordpress-efs"
  }
}

# EFS Mount
resource "aws_efs_mount_target" "da-wordpress-efs-target-a" {
  file_system_id = "${aws_efs_file_system.da-wordpress-efs.id}"
  subnet_id      = "${aws_subnet.private-wp-a.id}"
  security_groups = ["${aws_security_group.efs.id}"]  
}

resource "aws_efs_mount_target" "da-wordpress-efs-target-b" {
  file_system_id = "${aws_efs_file_system.da-wordpress-efs.id}"
  subnet_id      = "${aws_subnet.private-wp-b.id}"
  security_groups = ["${aws_security_group.efs.id}"]  
}

