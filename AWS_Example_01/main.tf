resource "aws_vpc" "YourVPC" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "YourVPC"
  }
}
