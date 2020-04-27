# ecs ec2 role
resource "aws_iam_role" "ecs-ec2-role_" {
  name = "ecs-ec2-role_"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs-ec2-role" {
  name = "ecs-ec2-role_"
  role = "${aws_iam_role.ecs-ec2-role_.name}"
}

resource "aws_iam_role_policy" "ecs-ec2-role-policy" {
  name = "ecs-ec2-role-policy-test"
  role = "${aws_iam_role.ecs-ec2-role_.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecs:CreateCluster",
              "ecs:DeregisterContainerInstance",
              "ecs:DiscoverPollEndpoint",
              "ecs:Poll",
              "ecs:RegisterContainerInstance",
              "ecs:StartTelemetrySession",
              "ecs:Submit*",
              "ecs:StartTask",
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF
}

##############################################
# ecs service role

resource "aws_iam_role" "ecs-service-role" {
  name = "ecs-service-role-test"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "instance_policy_ecs" {
  name   = "${var.name}-ecs-instance"
  #role = "${aws_iam_role.ecs-service-role.name}"
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue",
        "kms:Decrypt"
      ],
      "Resource": "[
        "arn:aws:ssm:ap-southeast-2:*:parameter/*",
        "arn:aws:secretsmanager:ap-southeast-2:*:secret:*"
      ]"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-service-attach" {
  role       = "${aws_iam_role.ecs-service-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role_policy_attachment" "ecs-service-attach-custom" {
  role       = "${aws_iam_role.ecs-service-role.name}"
  policy_arn = "${aws_iam_policy.instance_policy_ecs.name}"
}