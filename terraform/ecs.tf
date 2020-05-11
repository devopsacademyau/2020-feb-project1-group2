# Key-Name
data "template_file" "ecs_public_key" {
  template = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_key_pair" "ecs_key_pair" {
  key_name   = "ecs-key"
  public_key = "${data.template_file.ecs_public_key.rendered}"
}

# ECS
resource "aws_ecs_cluster" "ecs-da-wordpress" {
  name = "${var.project_name}-ecs"
}

# LC
resource "aws_launch_configuration" "instance-ecs-da" {
  name_prefix = "${var.project_name}-lc"

  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = true

  security_groups = ["${aws_security_group.ecs.id}"]
  key_name        = "sydney-key-pair"

  iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-role.arn}"
  user_data = <<EOF
                  #!/bin/bash
                  echo ECS_CLUSTER=${aws_ecs_cluster.ecs-da-wordpress.name} >> /etc/ecs/ecs.config
                  mkdir -p /mnt/efs
                  mount -t efs ${aws_efs_file_system.da-wordpress-efs.id}:/ /mnt/efs
                EOF

  lifecycle {
    create_before_destroy = true
  }
}

/*
                    #!/bin/bash
                    cloud-init-per once install_amazon-efs-utils yum install -y amazon-efs-utils
                    cloud-init-per once mkdir_efs mkdir /efs
                    EFS_DIR=/mnt/efs
                    EFS_ID=${aws_efs_file_system.da-wordpress-efs.id}

                    cloud-init-per once mount_efs echo -e "$${EFS_ID}:/ $${EFS_DIR} efs tls,_netdev" >> /etc/fstab
                    echo ECS_CLUSTER=${aws_ecs_cluster.ecs-da-wordpress.name} >> /etc/ecs/ecs.config
*/


# ASG
resource "aws_autoscaling_group" "cluster-asg-da" {
  name                 = "${var.project_name}-asg"
  vpc_zone_identifier  = ["${aws_subnet.public-wp-a.id}", "${aws_subnet.public-wp-b.id}"]
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  launch_configuration = "${aws_launch_configuration.instance-ecs-da.name}"
  health_check_type    = "EC2"
  health_check_grace_period = 0
  default_cooldown          = 300
  termination_policies      = ["OldestInstance"]
  tag {
    key                 = "Name"
    value               = "ECS WordPress"
    propagate_at_launch = true
  }
}

# ASP
resource "aws_autoscaling_policy" "cluster-asg-da-policy" {
  name                      = "${var.project_name}-asg-policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = "${aws_autoscaling_group.cluster-asg-da.name}"

  target_tracking_configuration {
    predefined_metric_specification {
    predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40
  }
  
}
/*
# TD
resource "aws_ecs_task_definition" "da-ecs-task" {
  family                = var.project_name
  execution_role_arn    = aws_iam_role.ecs-instance-role.arn
  container_definitions = file("tasks/wp_task_definition.json")
  volume {
    name = "service-storage-wp"
    #host_path = "/mnt/efs/wordpress"

    efs_volume_configuration {
      file_system_id = aws_efs_file_system.fs.id
      root_directory = "/mnt/efs/wordpress"
    }
  }
}

# SV
resource "aws_ecs_service" "da-ecs-service" {
  name            = "${var.project_name}-sv"
  cluster         = aws_ecs_cluster.ecs-da-wordpress.id
  task_definition = aws_ecs_task_definition.da-ecs-task.family
  desired_count   = 2
  load_balancer {
    target_group_arn = "${aws_alb_target_group.target-group-alb.arn}"
    container_name   = "da-wp-task"
    container_port   = 80
  }
}
*/
/*<<EOF
                    #!/bin/bash
                    echo ECS_CLUSTER=${aws_ecs_cluster.ecs-da-wordpress.name} >> /etc/ecs/ecs.config
                    echo EFS_DIR=/mnt/efs
                    echo EFS_ID=${aws_efs_file_system.da-wordpress-efs.id}
                    echo mkdir -p $${EFS_DIR}
                    echo "$${EFS_ID}:/ $${EFS_DIR} efs tls,_netdev" >> /etc/fstab
                          for i in $(seq 1 20); do mount -a -t efs defaults && break || sleep 60; done
                          EOF*/

