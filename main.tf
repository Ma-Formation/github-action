# Créer un VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "terraform-vpc"
  }
}

# Créer un sous-réseau
resource "aws_subnet" "subnet_terraform" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.1.0/24"
  
  tags = {
    Name = "terraform-subnet"
  }
}

# Créer un groupe de sécurité pour l'instance EC2
resource "aws_security_group" "sg_terraform_ec2" {
  vpc_id = aws_vpc.terraform_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-ec2-sg"
  }
}

# Créer une instance EC2
resource "aws_instance" "ec2_action" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_terraform.id
  security_groups = [aws_security_group.sg_terraform_ec2.name]

  tags = {
    Name = "GitHub-Action-EC2"
  }
}

# Créer un groupe de sécurité pour le Load Balancer
resource "aws_security_group" "sg_terraform_lb" {
  vpc_id = aws_vpc.terraform_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-lb-sg"
  }
}

# Créer un Load Balancer (ALB)
resource "aws_lb" "terraform_lb" {
  name               = "terraform-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_terraform_lb.id]
  subnets            = [aws_subnet.subnet_terraform.id]

  enable_deletion_protection = false

  tags = {
    Name = "terraform-lb"
  }
}

# Créer un Target Group pour enregistrer l'instance EC2
resource "aws_lb_target_group" "terraform_tg" {
  name     = "terraform-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraform_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "terraform-target-group"
  }
}

# Enregistrer l'instance EC2 dans le Target Group
resource "aws_lb_target_group_attachment" "terraform_tg_attachment" {
  target_group_arn = aws_lb_target_group.terraform_tg.arn
  target_id        = aws_instance.ec2_action.id
  port             = 80
}

# Configurer un Listener pour le Load Balancer
resource "aws_lb_listener" "terraform_lb_listener" {
  load_balancer_arn = aws_lb.terraform_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terraform_tg.arn
  }
}
