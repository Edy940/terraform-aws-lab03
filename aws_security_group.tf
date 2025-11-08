resource "aws_security_group" "web_sg" {
  name        = "web-security-group"
  description = "Security group para servidores web"
  vpc_id      = aws_vpc.foo.id

  # Regras de entrada (ingress) usando dynamic
  dynamic "ingress" {
    for_each = [
      {
        description = "HTTP"
        port        = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "HTTPS"
        port        = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "SSH"
        port        = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Atenção: Em produção, restringir ao seu IP
      }
    ]

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # Regra de saída (egress) - permite todo tráfego de saída
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "web-security-group"
    Environment = var.env
  }
}

# Security Group para banco de dados (exemplo)
resource "aws_security_group" "db_sg" {
  name        = "db-security-group"
  description = "Security group para banco de dados"
  vpc_id      = aws_vpc.foo.id

  # Regras de entrada usando dynamic
  dynamic "ingress" {
    for_each = [
      {
        description     = "PostgreSQL from web servers"
        port            = 5432
        protocol        = "tcp"
        security_groups = [aws_security_group.web_sg.id]  # Só aceita do SG web
      },
      {
        description     = "MySQL from web servers"
        port            = 3306
        protocol        = "tcp"
        security_groups = [aws_security_group.web_sg.id]
      }
    ]

    content {
      description     = ingress.value.description
      from_port       = ingress.value.port
      to_port         = ingress.value.port
      protocol        = ingress.value.protocol
      security_groups = ingress.value.security_groups
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "db-security-group"
    Environment = var.env
  }
}
