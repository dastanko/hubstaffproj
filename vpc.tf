resource "aws_default_vpc" "default" {

  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "public_1" {
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet for a lb 1"
  }
}

resource "aws_default_subnet" "public_2" {
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet for a lb 2"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id                  = aws_default_vpc.default.id
  availability_zone       = "us-west-2a"
  cidr_block              = "172.31.64.0/20"
  map_public_ip_on_launch = false

  tags = {
    Name = "Subnet for a appserver"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_default_vpc.default.id
  availability_zone       = "us-west-2b"
  cidr_block              = "172.31.80.0/20"
  map_public_ip_on_launch = false

  tags = {
    Name = "Subnet for a appserver"
  }
}

resource "aws_eip" "nat_gateway_ip" {
  vpc = true

  tags = {
    Name = "NatGatewayEIP"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_default_subnet.public_1.id
  allocation_id = aws_eip.nat_gateway_ip.id
  depends_on    = [aws_default_subnet.public_1]
}

resource "aws_route_table" "app_rt" {
  vpc_id = aws_default_vpc.default.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "private_ass_1" {
  route_table_id = aws_route_table.app_rt.id
  subnet_id      = aws_subnet.private_1.id
}

resource "aws_route_table_association" "private_ass_2" {
  route_table_id = aws_route_table.app_rt.id
  subnet_id      = aws_subnet.private_2.id
}