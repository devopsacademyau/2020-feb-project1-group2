# ECS
resource "aws_ecs_cluster" "ecs-da-wordpress" {
  name = "${var.project_name}-ecs"
}

# LC
resource "aws_launch_configuration" "instance-ecs-da" {
  name     = "${var.project_name}-lc"
  security_groups = ["${aws_security_group.ecs.id}"]

  image_id             = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-role.id}"
  user_data            = <<EOF
                    #!/bin/bash
                    echo ECS_CLUSTER=${aws_ecs_cluster.ecs-da-wordpress.name} >> /etc/ecs/ecs.config
                    echo EFS_DIR=/mnt/efs
                    echo EFS_ID=${aws_efs_file_system.da-wordpress-efs.id}
                    echo mkdir -p $${EFS_DIR}
                    echo "$${EFS_ID}:/ $${EFS_DIR} efs tls,_netdev" >> /etc/fstab
                          for i in $(seq 1 20); do mount -a -t efs defaults && break || sleep 60; done
                          EOF

  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

# ASG
resource "aws_autoscaling_group" "cluster-asg-da" {
  name             = "${var.project_name}-asg"
  vpc_zone_identifier       = ["${aws_subnet.private-wp-a.id}", "${aws_subnet.private-wp-b.id}"]
  min_size         = 1
  max_size         = 4
  desired_capacity = 2
  launch_configuration      = "${aws_launch_configuration.instance-ecs-da.name}"
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
/*resource "aws_autoscaling_policy" "cluster-asg-da-policy" {
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
  
}*/