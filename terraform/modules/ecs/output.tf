output "sg_ecs_id" {
  value = "${aws_security_group.ecs.id}"
}
output "iam_ec2_arn" {
  value = "${aws_iam_role.ec2.arn}"
}
output "ecs_cluster" {
  value = "${aws_ecs_cluster.main.id}"
}

