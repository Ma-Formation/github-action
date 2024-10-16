# -----------code importation de target group deja creer ------------
# Recuperation d'un target group deja utiliser par d'autres applications par terraform, uniquement en mode prod
# Code d'importation: 
# terraform import aws_lb_target_group.terraform_tg arn:aws:elasticloadbalancing:us-east-1:654654270281:targetgroup/terraform-target-group/e55e5c6f6baf614f

# VPC
# resource "aws_vpc" "terraform_vpc" {
#   cidr_block = "10.0.0.0/16"
  
#   tags = {
#     Name = "terraform-vpc"
#   }
# }

# # Sous-réseau 1
# resource "aws_subnet" "subnet_terraform" {
#   vpc_id     = aws_vpc.terraform_vpc.id
#   cidr_block = "10.0.1.0/24"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "terraform-subnet"
#   }
# }

# # Sous-réseau 2
# resource "aws_subnet" "subnet_terraform_az2" {
#   vpc_id     = aws_vpc.terraform_vpc.id
#   cidr_block = "10.0.2.0/24"
#   availability_zone = "us-east-1b"

#   tags = {
#     Name = "terraform-subnet-az2"
#   }
# }

# # Groupe de sécurité pour l'EC2
# resource "aws_security_group" "sg_terraform_ec2" {
#   vpc_id = aws_vpc.terraform_vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "terraform-ec2-sg"
#   }
# }

# # Instance EC2
# resource "aws_instance" "ec2_action" {
#   ami                   = "ami-0866a3c8686eaeeba"
#   instance_type         = "t2.micro"
#   subnet_id             = aws_subnet.subnet_terraform.id
#   vpc_security_group_ids = [aws_security_group.sg_terraform_ec2.id]

#   tags = {
#     Name = "GitHub-Action-EC2"
#   }
# }

# # Groupe de sécurité pour le Load Balancer
# resource "aws_security_group" "sg_terraform_lb" {
#   vpc_id = aws_vpc.terraform_vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "terraform-lb-sg"
#   }
# }

# # Load Balancer (ALB)
# resource "aws_lb" "terraform_lb" {
#   name               = "terraform-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.sg_terraform_lb.id]
#   subnets            = [
#     aws_subnet.subnet_terraform.id,
#     aws_subnet.subnet_terraform_az2.id
#   ]

#   enable_deletion_protection = false

#   tags = {
#     Name = "terraform-lb"
#   }
# }

# # Enregistrement de l'instance dans le Target Group importé
# resource "aws_lb_target_group_attachment" "terraform_tg_attachment" {
#   target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:654654270281:targetgroup/terraform-target-group/e55e5c6f6baf614f"  # L'ARN du Target Group déjà importé
#   target_id        = aws_instance.ec2_action.id
#   port             = 80
# }

# # Listener pour le Load Balancer
# resource "aws_lb_listener" "terraform_lb_listener" {
#   load_balancer_arn = aws_lb.terraform_lb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:654654270281:targetgroup/terraform-target-group/e55e5c6f6baf614f"  # L'ARN du Target Group déjà importé
#   }
# }



















#-----------code avec creation de creation de target_group-------------
# VPC
# VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "terraform-vpc"
  }
}

# Ajouter une Internet Gateway pour le VPC
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-igw"
  }
}

# Ajouter une table de routage pour permettre le trafic Internet
resource "aws_route_table" "terraform_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }

  tags = {
    Name = "terraform-route-table"
  }
}

# Associer la table de routage au sous-réseau 1
resource "aws_route_table_association" "terraform_rta_subnet1" {
  subnet_id      = aws_subnet.subnet_terraform.id
  route_table_id = aws_route_table.terraform_route_table.id
}

# Associer la table de routage au sous-réseau 2
resource "aws_route_table_association" "terraform_rta_subnet2" {
  subnet_id      = aws_subnet.subnet_terraform_az2.id
  route_table_id = aws_route_table.terraform_route_table.id
}

# Sous-réseau 1
resource "aws_subnet" "subnet_terraform" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "terraform-subnet"
  }
}

# Sous-réseau 2
resource "aws_subnet" "subnet_terraform_az2" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "terraform-subnet-az2"
  }
}

# Groupe de sécurité pour l'EC2
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

# Instance EC2
resource "aws_instance" "ec2_action" {
  ami                   = "ami-0866a3c8686eaeeba"
  instance_type         = "t2.micro"
  subnet_id             = aws_subnet.subnet_terraform.id
  vpc_security_group_ids = [aws_security_group.sg_terraform_ec2.id]

  tags = {
    Name = "GitHub-Action-EC2"
  }
}

# Groupe de sécurité pour le Load Balancer
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

# Load Balancer (ALB)
resource "aws_lb" "terraform_lb" {
  name               = "terraform-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_terraform_lb.id]
  subnets            = [
    aws_subnet.subnet_terraform.id,
    aws_subnet.subnet_terraform_az2.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "terraform-lb"
  }
  
  lifecycle {
    ignore_changes = [name, tags]  # Empêche Terraform de recréer ou modifier ces champs
  }
}

# Target Group (important)
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

# Enregistrement de l'instance dans le Target Group
resource "aws_lb_target_group_attachment" "terraform_tg_attachment" {
  target_group_arn = aws_lb_target_group.terraform_tg.arn
  target_id        = aws_instance.ec2_action.id
  port             = 80
}

# Listener pour le Load Balancer
resource "aws_lb_listener" "terraform_lb_listener" {
  load_balancer_arn = aws_lb.terraform_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terraform_tg.arn
  }
}
