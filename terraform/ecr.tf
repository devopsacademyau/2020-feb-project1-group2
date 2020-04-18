resource "aws_ecr_repository" "da-wordpress-ecr" {
  name                 = "${var.ecr_repository-image}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Once we have our IAM policies defined, the following commands should be 
# updated by the one that is commented at the end.
resource "aws_ecr_repository_policy" "da-wordpress-ecr-policy" {
  repository = "${aws_ecr_repository.da-wordpress-ecr.name}"

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "AllowPushPull",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload"
            ]
        }
    ]
}
EOF
}



/*
resource "aws_ecr_repository_policy" "da-wordpress-ecr-policy" {
  repository = "${aws_ecr_repository.da-wordpress-ecr.name}"

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "AllowPushPull",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::123456789012:user/push-pull-user-1",
                    "arn:aws:iam::123456789012:user/push-pull-user-2"
                ]
            },
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload"
            ]
        }
    ]
}
EOF
}
*/
