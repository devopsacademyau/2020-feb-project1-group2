##### route 53 #####

# Route53 - Add Zone
#resource "aws_route53_zone" "app-wordpress-zone" {
#  name = "wordpress"
#  vpc {
#    vpc_id = "${aws_vpc.da-wordpress-vpc.id}"
#  }
#}

# Route53 - Add record
#resource "aws_route53_record" "app-wordpress-record" {
#    zone_id = "${var.azs[0]}"
#    name = "intra.wordpress"
#    type = "A"
#    records = ["${aws_alb.alb-da-wordpress.dns_name}"]
#}
