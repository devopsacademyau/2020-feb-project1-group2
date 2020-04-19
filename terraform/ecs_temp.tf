##### ECS #####
resource "aws_ecs_cluster" "ecs-da-migration" {
  name = "ecs-cluster-da"
}

/* variables.tf
# the ECS optimized AMI's change by region. You can lookup the AMI here:
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
variable "image_id" {
  type        = string
  description = "AMI image_id for ECS instance"
  default     = "ami-064db566f79006111"
}

variable  "instance_type" {
    type        = string
    description = "AMI instance_type for ECS instance"
    default     = "t2.micro"
}
*/

##### launch config #####
resource "aws_launch_configuration" "cluster-ecs-da" {
    name_prefix = "ecs-da"
    instance_type = "${var.instance_type}"

    image_id = "${var.image_id}"
}

##### ASG #####
resource "aws_autoscalling_group" "cluster-asg-da" {
    name = "cluster-da"
    min_size = 2
    max_size = 3
    aws_launch_configuration = "{$aws_launch_configuration.cluster-ecs-da.name}"
}

/* iam.tf

# allow an ECS assume to a role
resource "aws_iam_role" "ecs_role" {
  name = "ecs-role"
  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [{
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }]
    EOF
}
*/


resource "aws_ecs_task_definition" "wordpress-app" {
##### tasks definitions #####
# wordpress
    family = "ecs-task-wp"
  #json file
  #container_definitions    = "${data.template_file.wordpress-app-task.rendered}"
  #container_definitions = <<EOF [{
  #                              "name": "wp-app",
  #                              "image": "Dockerfile",
  #                              "cpu": 1024,
  #                              "memory": 768,
  #                              "essential": true,
  #                              "portMappings": [{"containerPort": 3000, "hostPort": 3000}],
  #                              "enviroment"
  #                          }] EOF
    task_role_arn = ${aws_iam_role.ecs_role.arn}
}

# DB migrate
resource "aws_ecs_task_definition" "aurora-backend" {
    family = "ecs-task-db"
  #json file
  #container_definitions    = "${data.template_file.wordpress-app-task.rendered}"
#  container_definitions = <<EOF [{
#                                "name": "aurora-db",
#                                "image": "Dockerfile",
#                                "cpu": 1024,
#                                "memory": 768,
#                                "essential": true,
#                                "portMappings": [{"containerPort": 4567, "hostPort": 4567}]
#                            }] EOF
    task_role_arn = ${aws_iam_role.ecs_role.arn}
}

##### ECS services #####

resource "aws_ecs_service" "wordpress-app" {
    name = "ecs-wp"
    cluster = "${aws_ecs_cluster.ecs-da-migration.id}"
    task_definition = "${aws_ecs_task_definitions.wordpress-app.arn}"
    desired_count = 2

    # attaching an ELB with an ECS service
    #load_balancer {
    #    elb_name = "${aws_elb.wordpress-app.id}"
    #    container_name = "wordpress-container"
    #    container_port = 3000
    #}
}
resource "aws_ecs_service" "aurora-backend" {
    cluster = "${aws_ecs_cluster.ecs-da-migration.id}"
    task_definition = "${aws_ecs_task_definitions.aurora-backend.arn}"
    desired_count = 2

    # attaching an ELB with an ECS service
    #load_balancer {
    #    elb_name = "${aws_elb.aurora-backend.id}"
    #    container_name = "wordpress-container"
    #    container_port = 4567
    #}
}