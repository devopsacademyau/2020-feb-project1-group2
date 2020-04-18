resource "aws_security_group" "wordpress-access" {
    name = "wordpress-access"
    description = "Allow inbound traffic to Wordpress Instance"
    vpc_id = "${aws_vpc.da-wordpress-vpc.id}"

    tags = {
        Name = "wordpress-access"
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
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

