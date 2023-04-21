resource "aws_vpc" "VPC-CmZ" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "VPC-CmZ"
  }
}

resource "aws_subnet" "Priv-Sub-CmZ-1a" {
  vpc_id     = aws_vpc.VPC-CmZ.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "Priv-Sub-CmZ-1a"
  }
}

resource "aws_subnet" "Priv-Sub-CmZ-1b" {
  vpc_id     = aws_vpc.VPC-CmZ.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "eu-central-1b"
  
  tags = {
    Name = "Priv-Sub-CmZ-1b"
  }
}

resource "aws_subnet" "Pub-Sub-CmZ-1a" {
  vpc_id     = aws_vpc.VPC-CmZ.id
  cidr_block = "10.1.3.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch ="true"

  tags = {
    Name = "Pub-Sub-CmZ-1a"
  }
}

resource "aws_subnet" "Pub-Sub-CmZ-1b" {
  vpc_id     = aws_vpc.VPC-CmZ.id
  cidr_block = "10.1.4.0/24"
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch ="true"

  tags = {
    Name = "Pub-Sub-CmZ-1b"
  }
}

resource "aws_internet_gateway" "IGW-01-CmZ" {
  vpc_id = aws_vpc.VPC-CmZ.id

  tags = {
    Name = "IGW-01-CmZ"
  }
}

resource "aws_route_table" "Pub-RT-CmZ" {
  vpc_id = aws_vpc.VPC-CmZ.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW-01-CmZ.id
  }

 
  tags = {
    Name = "Pub-RT-CmZ"
  }
}

resource "aws_route_table_association" "Pub-Sub-Assoc-CmZ-1a" {
  subnet_id      = aws_subnet.Pub-Sub-CmZ-1a.id
  route_table_id = aws_route_table.Pub-RT-CmZ.id
}

resource "aws_route_table_association" "Pub-Sub-Assoc-CmZ-1b" {
  subnet_id      = aws_subnet.Pub-Sub-CmZ-1b.id
  route_table_id = aws_route_table.Pub-RT-CmZ.id
}

resource "aws_route_table" "Priv-RT-CmZ" {
  vpc_id = aws_vpc.VPC-CmZ.id
 
  tags = {
    Name = "Priv-RT-CmZ"
  }
}

resource "aws_route_table_association" "Priv-Sub-Assoc-CmZ-1a" {
  subnet_id      = aws_subnet.Priv-Sub-CmZ-1a.id
  route_table_id = aws_route_table.Priv-RT-CmZ.id
}

resource "aws_route_table_association" "Priv-Sub-Assoc-CmZ-1b" {
  subnet_id      = aws_subnet.Priv-Sub-CmZ-1b.id
  route_table_id = aws_route_table.Priv-RT-CmZ.id
}