output "lb_tg_arn" {
  value = "${aws_alb_target_group.main.arn}"
}
output "efs_id" {
  value = "${aws_efs_file_system.main.id}"
}
output "sg_lb_id" {
  value = "${aws_security_group.lb.id}"
}