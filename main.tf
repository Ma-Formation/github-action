resource "aws_instance" "ec2-action" {
  ami           = "ami-0c55b159cbfafe1f0"  # AMI Amazon Linux, changer selon la région
  instance_type = "t2.micro"

  tags = {
    Name = "GitHubActionEC2"
  }
}
