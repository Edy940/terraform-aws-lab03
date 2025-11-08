resource "aws_instance" "foo" {
  ami           = "ami-05134c8ef96964280"
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name        = "foo-instance"
    Environment = "dev"
  }
}
