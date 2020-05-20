# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-ecs"
}

# Launch Configuration
resource "aws_launch_configuration" "main" {
  name_prefix = "${var.project_name}-lc"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.ecs.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ec2.arn}"
  user_data = <<EOF
                  #!/bin/bash
                  echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config
                  mkdir -p /mnt/efs
                  mount -t efs ${var.efs_id}:/ /mnt/efs
                EOF

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "main" {
  name                 = "${var.project_name}-asg"
  depends_on           = ["aws_launch_configuration.main"]
  vpc_zone_identifier  = "${var.subnet_private_id}"
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  launch_configuration = "${aws_launch_configuration.main.name}"
  target_group_arns    = ["${var.lb_tg_arn}"]
  health_check_type    = "EC2"
  health_check_grace_period = 0
  default_cooldown          = 300
  termination_policies      = ["OldestInstance"]
  tag {
    key                 = "Name"
    value               = "${var.project_name}-ECS"
    propagate_at_launch = true
  }
}

# Auto Scaling Policy
resource "aws_autoscaling_policy" "main" {
  name                      = "${var.project_name}-asg-policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = "${aws_autoscaling_group.main.name}"

  target_tracking_configuration {
    predefined_metric_specification {
    predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40
  }
}

# ECS Security Group 
resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-ECS-Access"
  description = "Manage access to ECS"
  vpc_id      = "${var.vpc_id}"

 ingress {
    from_port       = 0
    to_port         = 0 
    protocol        = "-1" 
    cidr_blocks     = ["${var.cidr_block_all}"]
    security_groups = ["${var.sg_lb_id}"] 
    description     = "From ALB"
    }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["${var.cidr_block_all}"]
    }

  tags = {
    Name = "${var.project_name}-ECS-Access"
  }
}

# EC2 Instance Role
resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-EC2"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
    "Effect": "Allow",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }
]
}
EOF
}

# EC2 Instance Profile
resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-EC2"
  role = "${aws_iam_role.ec2.name}"
}

# EC2 Instance ARNs
resource "aws_iam_role_policy_attachment" "ec2" {
  role       = "${aws_iam_role.ec2.name}"
  count      = "${length(var.iam_policy_arn_ec2)}"
  policy_arn = "${var.iam_policy_arn_ec2[count.index]}"
}
