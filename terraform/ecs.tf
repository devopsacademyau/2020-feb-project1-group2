##### ECS #####
resource "aws_ecs_cluster" "ecs-da-migration" {
  name = "ecs-cluster-da"
}

##### EC2 config #####
resource "aws_launch_configuration" "instance-ecs-da" {
  name_prefix          = "ecs-da"
  image_id             = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_role.ecs_role}"
  security_groups      = "${aws_security_group.sg-ecs.id}"
  key_name             = "TO DO"

  # instances config file
  user_data = <<SCRIPT
                    echo ECS_CLUSTER=${aws_ecs_cluster.ecs-da-migration.name} >> /etc/ecs/ecs.config
                  SCRIPT
  
  lifecycle {
    create_before_destroy = true
  }    
}

##### SG #####
resource "aws_security_group" "sg-ecs" {
  name        = "cluster-sg"
  vpc_id      = "${aws_vpc.da-wordpress-vpc.id}"
}

resource "aws_security_group_rule" "sg-ecs-instances" {
  type              = "egress"
  from_port         = "TO DO"
  to_port           = "TO DO"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg-ecs.id}"
}


##### ASG #####
resource "aws_autoscalling_group" "cluster-asg-da" {
    name = "cluster-asg"
    min_size = 2
    max_size = 3
    desired_capacity = 3
    launch_configuration = "{$aws_launch_configuration.instance-ecs-da.name}"
    vpc_zone_identifier = ["${aws_subnet.public-wp-a.id}", "${aws_subnet.public-wp-b.id}"]
}


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

##### POLICY #####
resource "aws_iam_role_policy_attachment" "ecs_policy" {
  role       = "${aws_iam_role.ecs_role.name}"
  # standard policy from AWS
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

##### ECR #####
resource "aws_ecr_repository" "ecr_img_repos" {
  name = "${var.ecr_repository-image}" 
}