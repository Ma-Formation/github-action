resource "aws_instance" "ec2-action" {
  ami           = "ami-0866a3c8686eaeeba"  # AMI Amazon Linux, changer selon la région
  instance_type = "t2.micro"

  tags = {
    Name = "GitHub-Action-EC2"
  }
}
