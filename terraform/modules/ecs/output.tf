output "sg_ecs_id" {
  value = "${aws_security_group.ecs.id}"
}
output "ecs_cluster" {
  value = "${aws_ecs_cluster.main.id}"
}

