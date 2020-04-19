###**EFS**

**1) Creating Security Groups for accessing EFS:**
    https://docs.aws.amazon.com/efs/latest/ug/wt1-create-ec2-resources.html
    https://medium.com/swlh/attach-an-aws-efs-to-an-ecs-cluster-from-scratch-d34d83ccc5ae
    https://www.terraform.io/docs/providers/aws/r/security_group.html#ingress


**2) Creating EFS with terraform:**
    https://www.terraform.io/docs/providers/aws/r/efs_file_system.html
    https://www.terraform.io/docs/providers/aws/r/efs_mount_target.html

**3) Creating an Access Point (CLI):**
    aws efs create-access-point --file-system-id fs-01234567 --client-token 010102020-3
    {
        "ClientToken": "010102020-3",
        "Tags": [],
        "AccessPointId": "fsap-092e9f80b3fb5e6f3",
        "AccessPointArn": "arn:aws:elasticfilesystem:us-east-2:111122223333:access-point/fsap-092e9f80b3fb5e6f3",
        "FileSystemId": "fs-01234567",
        "RootDirectory": {
            "Path": "/"
        },
        "OwnerId": "111122223333",
        "LifeCycleState": "creating"
    }

    More details can be found at https://docs.aws.amazon.com/efs/latest/ug/create-access-point.html

**4) Mounting efs volumes:**
    https://github.com/aws/efs-utils
    https://docs.aws.amazon.com/efs/latest/ug/mounting-fs.html


