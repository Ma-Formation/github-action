resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_subnet" "subnet_terraform" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.1.0/24"
  
  tags = {
    Name = "terraform-subnet"
  }
}

resource "aws_instance" "ec2-action" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_terraform.id

  tags = {
    Name = "GitHub-Action-EC2"
  }
}

