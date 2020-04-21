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

