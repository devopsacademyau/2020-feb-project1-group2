# ECS EC2 ROLE
resource "aws_iam_role" "ecs-instance-role" {
  name = "${var.project_name}-ecs-role"
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

resource "aws_iam_instance_profile" "ecs-instance-role" {
  name = "${var.project_name}-ecs-profile"
  role = "${aws_iam_role.ecs-instance-role.name}"
}

resource "aws_iam_role_policy_attachment" "ecs-service-attach" {
  role       = "${aws_iam_role.ecs-instance-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
