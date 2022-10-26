resource "aws_db_subnet_group" "default" {
  name       = "main"
  depends_on = [aws_subnet.private_1, aws_subnet.private_2]
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  tags       = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 100
  db_name                = "mydb"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = false
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.default.id
  vpc_security_group_ids = [aws_security_group.database_sg.id]
}

