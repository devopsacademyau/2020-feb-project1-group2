resource "aws_security_group" "database" {
    name = "database"
    description = "Allow inbound traffic"
    vpc_id = "${aws_vpc.da-wordpress-vpc.id}"

    tags = {
        Name = "database"
    }
}
