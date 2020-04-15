data "aws_availability_zones" "iac-azs" {
    state = "available"
}

resource "aws_vpc" "da-wordpress-vpc" {
  cidr_block = "${var.cidr_vpc}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "da-wordpress-vpc"
  }
}

resource "aws_eip" "da-wordpress-eip" {
  vpc=true
}

resource "aws_internet_gateway" "da-wordpress-igw" {
  vpc_id = "${aws_vpc.da-wordpress-vpc.id}"
  tags = {
    Name ="terra-igw"
  }
}

resource "aws_nat_gateway" "da-wordpress-nat-b" {
  allocation_id           = "${aws_eip.da-wordpress-eip.id}"
  subnet_id               =  aws_subnet.public-wp-b.id
  tags = {
    Name = "da-wordpress-nat-b"
  }
}

resource "aws_subnet" "private-wp-a" {
  vpc_id                  = "${aws_vpc.da-wordpress-vpc.id}"
  cidr_block              = "${var.private_subnet-wp-a}"
  availability_zone       = "${data.aws_availability_zones.iac-azs.names[0]}"

  tags = {
    Name = "private-subnet-a"
  }
}

resource "aws_subnet" "private-wp-b" {
  vpc_id                  = "${aws_vpc.da-wordpress-vpc.id}"
  cidr_block              = "${var.private_subnet-wp-b}"
  availability_zone       = "${data.aws_availability_zones.iac-azs.names[1]}"

  tags = {
    Name = "private-subnet-b"
  }
}
resource "aws_subnet" "public-wp-a" {
  vpc_id                  = "${aws_vpc.da-wordpress-vpc.id}"
  cidr_block              = "${var.public_subnet-wp-a}"
  availability_zone       = "${data.aws_availability_zones.iac-azs.names[2]}"

  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "public-wp-b" {
  vpc_id                  = "${aws_vpc.da-wordpress-vpc.id}"
  cidr_block              = "${var.public_subnet-wp-b}"
  availability_zone       = "${data.aws_availability_zones.iac-azs.names[2]}"

  tags = {
    Name = "public-subnet-b"
  }
}

resource "aws_route_table" "public-access" {
  vpc_id = "${aws_vpc.da-wordpress-vpc.id}"

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.da-wordpress-igw.id}"
  }
}

resource "aws_default_route_table" "private-access" {
  default_route_table_id = "${aws_vpc.da-wordpress-vpc.default_route_table_id}"
  tags = {
    Name = "da-wordpress-default-route"
  }
}

resource "aws_route_table_association" "public-access-a-rt" {
  subnet_id      = aws_subnet.public-wp-a.id
  route_table_id = "${aws_route_table.public-access.id}"
}

resource "aws_route_table_association" "public-access-b-rt" {
  subnet_id      = aws_subnet.public-wp-b.id
  route_table_id = "${aws_route_table.public-access.id}"
}

resource "aws_route_table_association" "private-access-a-rt" {
  subnet_id      = aws_subnet.private-wp-a.id
  route_table_id = "${aws_vpc.da-wordpress-vpc.default_route_table_id}"
}

resource "aws_route_table_association" "private-access-b-rt" {
  subnet_id      = aws_subnet.private-wp-b.id
  route_table_id = "${aws_vpc.da-wordpress-vpc.default_route_table_id}"
}
