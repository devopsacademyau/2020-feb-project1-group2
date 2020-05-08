####### ALB #######

##### ALB config #####
resource "aws_alb" "alb-da-wordpress" {
  name = "alb-da"
  security_groups = ["${aws_security_group.sg-alb.id}"]
  subnets = ["${aws_subnet.public-wp-a.id}", "${aws_subnet.public-wp-b.id}"]
  
}

# target group
resource "aws_alb_target_group" "target-group-alb" {
    name = "alb-group"
    port = 80
    protocol = "HTTP"
    vpc_id = "${aws_vpc.da-wordpress-vpc.id}"

    #depends_on = [aws_alb.alb-da-wordpress]
    lifecycle {
      create_before_destroy = true
  }
}

# port listener
resource "aws_alb_listener" "albListeners-wp" {
  load_balancer_arn = "${aws_alb.alb-da-wordpress.arn}"
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.target-group-alb.arn}"

    #redirect {
    #  port        = "443"
    #  protocol    = "HTTPS"
    #  status_code = "HTTP_301"
    #}
  }
  #port = "443"
  #protocol = "HTTPS"
  #ssl_policy = "ELBSecurityPolicy-2016-08"
  #default_action {
  #  target_group_arn = "${aws_alb_target_group.target-group-alb.arn}"
  #  type = "forward"
  #}
  #lifecycle {
  #  create_before_destroy = true
  #}
}
