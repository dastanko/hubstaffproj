resource "aws_instance" "bastion" {
  ami             = "ami-0d593311db5abb72b"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.deployer.id
  security_groups = [aws_security_group.allow-ext-ssh.id]
  subnet_id       = aws_default_subnet.public_1.id
}