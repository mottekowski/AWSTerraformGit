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

resource "aws_network_interface" "Priv-Nic-CmZ-EC1-1a" {
  subnet_id   = aws_subnet.Priv-Sub-CmZ-1a.id
  private_ips = ["10.1.1.101"]

  tags = {
    Name = "Priv-Nic-CmZ-EC1-1a"
  }
}

resource "aws_instance" "Priv-Inst-CmZ-EC1-1a" {
  ami           = "ami-0ec7f9846da6b0f61" # eu-central-1
  instance_type = "t2.micro"


  network_interface {
    network_interface_id = aws_network_interface.Priv-Nic-CmZ-EC1-1a.id
    device_index         = 0
  }

  root_block_device {
    tags = {
      Name = "os-disk-EC1"
    }
    volume_type = "gp3"
  }
  tags = {
    Name =  "Priv-Inst-CmZ-EC1-1a"
  }
}

resource "aws_ebs_volume" "EBS-CmZ-1a" {
  availability_zone = "eu-central-1a"
  size              = 20
  type              = "gp3"

  tags = {
    Name = "EBS-CmZ-1a"
  }
}

resource "aws_eip" "Pub-IP-EC1" {
  instance = aws_instance.Priv-Inst-CmZ-EC1-1a.id
  vpc      = true
  depends_on = [
    aws_instance.Priv-Inst-CmZ-EC1-1a
  ]
}
