resource "aws_elb" "wordpress" {
  name                = "wordpress"
  subnets             = ["${aws_subnet.public-wp-a.id}", "${aws_subnet.public-wp-b.id}"]
  security_groups     = ["${aws_security_group.website.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "wordpress-elb"
    Project = "wordpress"
  }
}
