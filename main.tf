provider "aws" {
  region     = var.region
  # Es recomendable usar variables de entorno para las credenciales
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"
  name = var.vpc_name
  cidr = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_security_group" "elb_sg" {
  name        = "elb-sg"
  description = "Allow HTTP from anywhere"
  vpc_id      = module.vpc.vpc_id

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
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow HTTP from ELB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_instance" {
  count         = 2
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = module.vpc.private_subnets[count.index]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "Instance-${count.index + 1}"
  }
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl start nginx
              systemctl enable nginx
              echo "Hello from $(hostname)" > /usr/share/nginx/html/index.html
              EOF
}

resource "aws_elb" "elb" {
  name     = "my-elb"
  subnets  = module.vpc.public_subnets
  instances = aws_instance.ec2_instance[*].id
  security_groups = [aws_security_group.elb_sg.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
} 