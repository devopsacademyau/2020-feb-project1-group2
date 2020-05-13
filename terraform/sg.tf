# ECS Security Group 
resource "aws_security_group" "ecs" {
  name        = "ECS-Access"
  description = "Manage access to ECS"
  vpc_id      = "${aws_vpc.da-wordpress-vpc.id}"

 ingress {
    from_port       = 0
    to_port         = 0 
    protocol        = "-1" 
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = ["${aws_security_group.sg-alb.id}"] 
    description     = "From ALB"
    }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = {
    Name = "ECS-Access"
  }
}

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = {
    Name = "ECS-Access"
  }
}

# EFS Security Group 
resource "aws_security_group" "efs" {
  name        = "EFS-Access"
  description = "Manage access to EFS"
  vpc_id      = "${aws_vpc.da-wordpress-vpc.id}"

  ingress {
    description     = "Access to NFS"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ecs.id}"]
    cidr_blocks     = ["${aws_subnet.private-wp-a.cidr_block}", "${aws_subnet.private-wp-b.cidr_block}"]
  }

  egress {
    description     = "Access to NFS"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ecs.id}"]
    cidr_blocks     = ["${aws_subnet.private-wp-a.cidr_block}", "${aws_subnet.private-wp-b.cidr_block}"]
  }

  tags = {
    Name = "EFS-Access"
  }
}

resource "aws_security_group" "database" {
  name        = "database"
  description = "Allow inbound traffic"
  vpc_id      = "${aws_vpc.da-wordpress-vpc.id}"
  
 ingress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        cidr_blocks     = [var.cidr_vpc]
        security_groups = [aws_security_group.ecs.id] 
   } 
  tags = {
    Name = "database"
  }
}


# ALB Security Group
resource "aws_security_group" "sg-alb" {
  name   = "alb-sg"
  vpc_id = "${aws_vpc.da-wordpress-vpc.id}"
}

resource "aws_security_group_rule" "sg-alb" {
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg-alb.id}"
}

