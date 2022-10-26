resource "aws_security_group" "allow-ext-ssh" {
  vpc_id = aws_default_vpc.default.id

  # allow ssh
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_server_sg" {
  vpc_id = aws_default_vpc.default.id

  # allow ssh
  ingress {
    protocol    = "tcp"
    security_groups = [aws_security_group.allow-ext-ssh.id]
    from_port   = 22
    to_port     = 22
  }

  ingress {
    from_port   = 3000
    protocol    = "tcp"
    to_port     = 3000
    cidr_blocks = ["172.31.0.0/16"]
  }

  # allow all
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb_sg" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 3000
    protocol  = "tcp"
    to_port   = 3000
    security_groups = [aws_security_group.app_server_sg.id]
  }
}


resource "aws_security_group" "database_sg" {
  name        = "allow inbound db traffic"
  description = "Allow DB inbound traffic only from app servers"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description     = "db connection from app servers"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_server_sg.id]
  }

  tags = {
    Name = "allow_db_connection"
  }
}