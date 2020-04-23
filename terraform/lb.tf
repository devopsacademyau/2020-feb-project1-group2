####### ALB #######

##### ALB config #####
resource "aws_alb" "alb-da-wordpress" {
  name = "alb-da"
  security_groups = "${aws_security_group.sg-alb.id}"
  subnets = ["${aws_subnet.public-wp-a.id}", "${aws_subnet.public-wp-b.id}"]
  lifecycle {
    create_before_destroy = true
  }
}

# port listener
resource "aws_alb_listener" "albListeners-wp" {
  load_balancer_arn = "${aws_alb.alb-da-wordpress.arn}"
  port = "443"
  protocol = "HTTPS"
  default_action {
    target_group_arn = "${aws_alb_target_group.target-group-alb}"
    type = "forward"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# target group
resource "aws_alb_target_group" "target-group-alb" {
    name = "alb-group"
    port = 443
    protocol = "HTTPS"
    vpc_id = "${aws_vpc.da-wordpress-vpc}"
}


##### SG #####
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

##### route 53 #####
# add a domain name
resource "aws_route53_record" "app-wordpress" {
    zone_id = ["${var.azs}"]
    name = "https://loadbalanceurl"
    type = "CNAME"
    ttl = "60"
    records = ["${aws_alb.alb-da-wordpress.dns_name}"]
}