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

resource "aws_instance" "ec2_instance" {
  count         = 2
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = module.vpc.private_subnets[count.index]
  tags = {
    Name = "Instance-${count.index + 1}"
  }
}

resource "aws_elb" "elb" {
  name     = "my-elb"
  subnets  = module.vpc.public_subnets
  instances = aws_instance.ec2_instance[*].id
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
} 