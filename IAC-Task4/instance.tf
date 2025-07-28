resource "aws_instance" "strapi_instance" {
  ami                    = "ami-0d1b5a8c13042c939"
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.public_subnet[0].id
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  key_name               = var.key_name


  user_data = file("user_data.sh")

  tags = {
    Name = "Strapi-Server-Govind"
  }
}
 