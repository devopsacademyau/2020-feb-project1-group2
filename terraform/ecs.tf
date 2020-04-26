# ECS
resource "aws_ecs_cluster" "ecs-da-migration" {
  name = "ecs-cluster-da"
}

# ASG
resource "aws_autoscaling_group" "cluster-asg-da" {
    name = "cluster-asg"
    min_size = 2
    max_size = 3
    desired_capacity = 3
    launch_configuration = "${aws_launch_configuration.instance-ecs-da.name}"
    vpc_zone_identifier = ["${aws_subnet.public-wp-a.id}", "${aws_subnet.public-wp-b.id}"]
    health_check_grace_period = 120
    default_cooldown          = 30
    termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "ECS-demo"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "cluster-asg-da-policy" {
  name                      = "cluster-asg-da-policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = "${aws_autoscaling_group.cluster-asg-da.name}"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}

resource "aws_launch_configuration" "instance-ecs-da" {
  name_prefix                 = "instance-ecs-da"
  security_groups             = ["${aws_security_group.ecs.id}"]
  # key_name                    = "${aws_key_pair.demodev.key_name}"
  image_id                    = "${data.aws_ami.latest_ecs.id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-ec2-role.id}"
user_data = <<SCRIPT
                    echo ECS_CLUSTER=${aws_ecs_cluster.ecs-da-migration.name} >> /etc/ecs/ecs.config
                  SCRIPT

  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}
