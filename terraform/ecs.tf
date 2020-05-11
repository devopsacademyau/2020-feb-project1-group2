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
 #key_name        = ""
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
