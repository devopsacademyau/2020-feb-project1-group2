project_name = "WordPress-dev"

region = "ap-southeast-2"

cidr_block_all = "0.0.0.0/0"

vpc_cidr = "10.0.0.0/16"

azs = ["ap-southeast-2a", "ap-southeast-2b"]

subnet_private_name = ["private-a_WP", "private-b_WP"]
subnet_private_cidr = ["10.0.63.0/24", "10.0.127.0/24"]

subnet_public_name = ["public-a_WP", "public-b_WP"]
subnet_public_cidr = ["10.0.191.0/24", "10.0.255.0/24"]

db_subnet_group_name = "wordpress"

ecr_repository_image = "placeholder1"

iam_policy_arn_task = ["arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess", "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role", "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy", ]
iam_policy_arn_ec2 = ["arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role", "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess", "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]

db_name = "wpdb"
db_engine = "aurora-mysql"
db_engine_version = "5.7.mysql_aurora.2.03.2"
db_instance_class = "db.r4.large"
db_master_username = "wpadmin"
efs_name = "wordpress"

image_id = "ami-064db566f79006111"
instance_type = "t2.micro"

rule_no_acl = 100
