resource "aws_security_group" "database" {
    name = "database"
    description = "Allow inbound traffic"
    vpc_id = "${aws_vpc.da-wordpress-vpc.id}"

    tags = {
        Name = "database"
    }
}

##### SG ALB #####
resource "aws_security_group" "sg-alb" {
  name        = "alb-sg"
  vpc_id      = "${aws_vpc.da-wordpress-vpc.id}"
}

resource "aws_security_group_rule" "sg-alb" {
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg-alb.id}"
}

