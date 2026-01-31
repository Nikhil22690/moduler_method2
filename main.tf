# -----------------------------
# VPC and Subnet (Create new ones)
# -----------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "terraform-subnet"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Key pair (create a new one for demo)
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "deployer" {
  key_name   = "terraform-key"
  public_key = tls_private_key.main.public_key_openssh
}

# Get AMI for Ubuntu 22.04
data "aws_ami" "ubuntu_2204" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# -----------------------------
# One Security Group (shared by both EC2 instances)
# -----------------------------
resource "aws_security_group" "ssh_sg" {
  name        = "ec2-ssh-sg"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
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
    Name = "ec2-ssh-sg"
  }
}

# -----------------------------
# Create 2 instances using for_each (easy + readable)
# -----------------------------
locals {
  instances = {
    "ubuntu-22-04-1" = {
      instance_type = var.instance_type
      volume_size   = var.volume_size
    }
    "ubuntu-22-04-2" = {
      instance_type = var.instance_type
      volume_size   = var.volume_size
    }
  }
}

module "ec2" {
  source = "./modules/ec2"

  for_each = local.instances

  name          = each.key
  ami_id        = data.aws_ami.ubuntu_2204.id
  instance_type = each.value.instance_type
  subnet_id     = aws_subnet.main.id
  sg_ids        = [aws_security_group.ssh_sg.id]
  key_name      = aws_key_pair.deployer.key_name
  volume_size   = each.value.volume_size
}

# -----------------------------
# S3 Bucket Module
# -----------------------------
module "s3" {
  source = "./modules/s3"

  bucket_name = "terraform-demo-bucket-${data.aws_caller_identity.current.account_id}"
  environment = "dev"
}

data "aws_caller_identity" "current" {}
