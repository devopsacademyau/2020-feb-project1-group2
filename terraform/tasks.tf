# wordpress

##### EFS volume #####
resource "aws_efs_file_system" "fs" {
    tags = {
    Name = "ECS-EFS-FS"
    }
}

##### task definition #####
data "template_file" "task_definition_json" {
    template = "${file("${path.module}/tasks/wp_task_definition.json")}"
}
resource "aws_ecs_task_definition" "wordpress-app" {
    family = "ecs-task-wp"

    container_definitions  = "${data.template_file.task_definition_json.rendered}"
    #image = "${aws_ecr_repository.da-wordpress-ecr.repository_url}"

    volume {
    name = "service-storage-wp"

    efs_volume_configuration {
        file_system_id = "${aws_efs_file_system.fs.id}"
        root_directory = "/var/www/html"
        }
    }
    memory                   = "256"
    cpu                      = "128"
    requires_compatibilities = ["EC2"]  
    network_mode     = "awsvpc"
    task_role_arn    = "${aws_iam_role.ecs-ec2-role.arn}"
}


##### ECS service #####
resource "aws_ecs_service" "wordpress-app" {
    name = "ecs-wp"
    cluster = "${aws_ecs_cluster.ecs-da-migration.id}"
    task_definition = "${aws_ecs_task_definition.wordpress-app.arn}"
    desired_count = 2
    launch_type   = "EC2"

    # attaching an ELB with an ECS service
    load_balancer {
        elb_name = "${aws_alb.alb-da-wordpress.id}"
        container_name = "wordpress-container"
        container_port = 80
    }

    # providing our containers with public IPs
    network_configuration {
    subnets          = ["${aws_subnet.public-wp-a.id}", "${aws_subnet.public-wp-b.id}"]
    assign_public_ip = true 
    }
}