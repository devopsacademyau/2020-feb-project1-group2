##### route 53 #####
# add a domain name
resource "aws_route53_record" "app-wordpress" {
    zone_id = ["${var.azs}"]
    name = "https://loadbalanceurl"
    type = "CNAME"
    ttl = "60"
    records = ["${aws_alb.alb-da-wordpress.dns_name}"]
}