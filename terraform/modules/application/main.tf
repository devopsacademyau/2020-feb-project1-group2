# EFS
resource "aws_efs_file_system" "main" {
  creation_token = "wordpress"
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  encrypted = true

  tags = {
    Name = "${var.efs_name}"
  }
}

# EFS Mount
resource "aws_efs_mount_target" "main" {
  count = "${length(var.subnet_private_id)}"
  file_system_id = "${aws_efs_file_system.main.id}"
  subnet_id      = "${element(var.subnet_private_id,count.index)}"
  security_groups = ["${aws_security_group.efs.id}"]  
}

# EFS Security Group 
resource "aws_security_group" "efs" {
  name        = "${var.project_name}-EFS-Access"
  description = "Manage access to EFS"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description     = "Access to EFS"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = ["${var.sg_ecs_id}"]
    cidr_blocks     = "${var.subnet_private_cidr}"
  }

  egress {
    description     = "Access to EFS"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = ["${var.sg_ecs_id}"]
    cidr_blocks     = "${var.subnet_private_cidr}"
  }

  tags = {
    Name = "${var.project_name}-EFS-Access"
  }
}

# RDS Security Group
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-RDS"
  description = "Allow inbound traffic"
  vpc_id      = "${var.vpc_id}"
  
 ingress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        cidr_blocks     = ["${var.vpc_cidr}"]
        security_groups = ["${var.sg_ecs_id}"]
   } 
  tags = {
    Name = "${var.project_name}-RDS"
  }
}

# Load Balancer
resource "aws_alb" "main" {
  name = "${var.project_name}-LB"
  load_balancer_type = "application"
  security_groups = ["${aws_security_group.lb.id}", "${var.sg_ecs_id}"]
  subnets = "${var.subnet_public_id}"
}

# Load Balancer - Target Group
resource "aws_alb_target_group" "main" {
    name = "${var.project_name}-LB-Target-Group"
    port = 80
    protocol = "HTTP"
    vpc_id = "${var.vpc_id}"

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200-399"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

    lifecycle {
      create_before_destroy = true
  }
}

# Load Balancer - Listener
resource "aws_alb_listener" "main" {
  load_balancer_arn = "${aws_alb.main.arn}"
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.main.arn}"
   }
}

# LB Security Group
resource "aws_security_group" "lb" {
  name   = "${var.project_name}-Load-Balancer"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "lb" {
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["${var.cidr_block_all}"]
  security_group_id = "${aws_security_group.lb.id}"
}


data "aws_ecs_task_definition" "main" {
  task_definition = "${aws_ecs_task_definition.main.family}"
  depends_on      = ["aws_ecs_task_definition.main"]
}


# ECS Task Defition
data "template_file" "main" {
  template = "${file("${path.module}/task_definition.json")}"

  vars = {
    image = "${var.ecr_url}",
    cw_log_group = "${aws_cloudwatch_log_group.main.name}",
    region = "${var.region}",
    cw_log_stream = "${var.project_name}-Stream"
  }
}

resource "aws_ecs_task_definition" "main" {
    family = "${var.project_name}"
    container_definitions  = "${data.template_file.main.rendered}"
    volume {
      name = "service-storage-wp"
      efs_volume_configuration {
        file_system_id = "${aws_efs_file_system.main.id}"
        root_directory = "/"
      }   
    }
    requires_compatibilities = ["EC2"] 
    execution_role_arn = "${aws_iam_role.task.arn}"
}

# ECS Service
resource "aws_ecs_service" "main" {
    name = "${var.project_name}-Service"
    depends_on = ["aws_alb.main"]
    cluster = "${var.ecs_cluster}"
   #task_definition = "${aws_ecs_task_definition.main.family}"
    desired_count = 4
    load_balancer {
      target_group_arn = "${aws_alb_target_group.main.arn}"
      container_name = "da-wp-task"
      container_port = 80
    }
 task_definition = "${aws_ecs_task_definition.main.family}:${max("${aws_ecs_task_definition.main.revision}", "${data.aws_ecs_task_definition.main.revision}")}"
}

# Task Definition Role
resource "aws_iam_role" "task" {
  name = "${var.project_name}-ECS-Task-Defition"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
    "Effect": "Allow",
    "Principal": {
      "Service": "ecs-tasks.amazonaws.com"
	    },
    "Action": "sts:AssumeRole"
  }
]
}
EOF
}

# Task Definition ARN
resource "aws_iam_role_policy_attachment" "task" {
  role       = "${aws_iam_role.task.name}"
  count      = "${length(var.iam_policy_arn_task)}"
  policy_arn = "${var.iam_policy_arn_task[count.index]}"
}

# RDS Cluster
resource "aws_rds_cluster" "main" {
  database_name                = "${var.db_name}"
  engine                       = "${var.db_engine}"
  engine_version               = "${var.db_engine_version}"
  master_username              = "${var.db_master_username}"
  master_password              = "${random_password.pw.result}"
  backup_retention_period      = 1
  skip_final_snapshot          = true
  apply_immediately            = true
  preferred_backup_window      = "02:00-03:00"
  vpc_security_group_ids       = ["${aws_security_group.rds.id}"]
  preferred_maintenance_window = "wed:03:00-wed:04:00"
  db_subnet_group_name         = "${aws_db_subnet_group.main.name}"
  lifecycle {
    create_before_destroy = false
  }
}

# RDS Instance
resource "aws_rds_cluster_instance" "main" {
  cluster_identifier   = "${aws_rds_cluster.main.id}"
  identifier           = "${var.db_name}-db"
  engine               = "${var.db_engine}"
  engine_version       = "${var.db_engine_version}"
  instance_class       = "${var.db_instance_class}" 
  db_subnet_group_name = "${aws_db_subnet_group.main.name}"
  publicly_accessible  = false
  lifecycle {
    create_before_destroy = true
  }
}

# RDS Instance
resource "aws_db_subnet_group" "main" {
  name        = "${var.db_subnet_group_name}"
  subnet_ids  = "${var.subnet_private_id}"
}

# RDS Password
resource "random_password" "pw" {
  length  = 10
  upper   = true
  special = false
}

# SSM Parameters
resource "aws_ssm_parameter" "wordpress-db-host" {
  name        = "/wordpress/WORDPRESS_DB_HOST"
  description = "The host parameter to be used by the container"
  type        = "SecureString"
  value       = "${aws_rds_cluster.main.endpoint}"
}
resource "aws_ssm_parameter" "wordpress-db-user" {
  name        = "/wordpress/WORDPRESS_DB_USER"
  description = "The user parameter to be used by the container"
  type        = "SecureString"
  value       = "${var.db_master_username}" 
}
resource "aws_ssm_parameter" "wordpress-db-password" {
  name        = "/wordpress/WORDPRESS_DB_PASSWORD"
  description = "The password parameter to be used by the container"
  type        = "SecureString"
  value       = "${random_password.pw.result}"
}
resource "aws_ssm_parameter" "wordpress-db-name" {
  name        = "/wordpress/WORDPRESS_DB_NAME"
  description = "The name parameter to be used by the container"
  type        = "SecureString"
  value       = "${var.db_name}"
}

# CLOUDWATCH
resource "aws_cloudwatch_log_group" "main" {
  name = "${var.project_name}-CW"
  retention_in_days = 30
} 
