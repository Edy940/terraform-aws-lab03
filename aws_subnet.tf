resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.foo.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name        = "my-subnet"
    Environment = "MyEnv"
  }
}

