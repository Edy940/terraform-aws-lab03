resource "aws_network_interface" "foo" {
  subnet_id = aws_subnet.my_subnet.id

  tags = {
    Name = "foo-network-interface"
  }
}

resource "aws_instance" "foo" {
  ami           = "ami-05134c8ef96964280"
  instance_type = "t3.micro"

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }

  tags = {
    Name        = "foo-instance"
    Environment = "dev"
  }
}
