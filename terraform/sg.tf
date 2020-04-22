# EFS Security Group 
resource "aws_security_group" "efs" {
  name        = "EFS-Access"
  description = "Manage access to EFS"
  vpc_id      = "${aws_vpc.da-wordpress-vpc.id}"

  ingress {
    description = "Access to NFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    #security_groups = ["${aws_security_group.ecs.id}"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EFS-Access"
  }
}

resource "aws_security_group" "database" {
    name = "database"
    description = "Allow inbound traffic"
    vpc_id = "${aws_vpc.da-wordpress-vpc.id}"

    tags = {
        Name = "database"
    }

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups  = ["${aws_security_group.wordpress-access.id}"]
    }
}