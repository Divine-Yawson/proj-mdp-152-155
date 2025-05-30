provider "aws" {
  region = var.aws_region
}

# IAM Role
resource "aws_iam_role" "kops_admin_role" {
  name = "KopsAdminRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy Attachment
resource "aws_iam_role_policy_attachment" "kops_policy_attach" {
  role       = aws_iam_role.kops_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "kops_instance_profile" {
  name = "KopsAdminInstanceProfile"
  role = aws_iam_role.kops_admin_role.name
}

# S3 Bucket for kops state storage
resource "aws_s3_bucket" "kops_state" {
  bucket = var.kops_s3_bucket

  tags = {
    Name        = "kops-state-store"
    Environment = "k8s-prod"
  }
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "k8s-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "k8s-igw"
  }
}

# Public Subnets across two Availability Zones
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "k8s-public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "k8s-public-subnet-2"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "k8s-public-route-table"
  }
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Security Group for Controller Instance
resource "aws_security_group" "controller_sg" {
  name        = "controller-sg"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.main.id

  ingress {
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
    Name = "controller-sg"
  }
}

# EC2 Instance for Ansible Controller (Amazon Linux 2)
resource "aws_instance" "controller" {
  ami                         = "ami-0953476d60561c955" # Amazon Linux 2 AMI for us-east-1
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_1.id
  associate_public_ip_address = true
  key_name                    = "tonykey" # Replace with your actual key pair
  vpc_security_group_ids      = [aws_security_group.controller_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.kops_instance_profile.name

  tags = {
    Name = "ansible-controller"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras enable ansible2",
      "sudo yum install -y ansible",
      "ansible --version"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("C:/Users/divin/Downloads/tonykey.pem") # Replace with your private key path
      host        = self.public_ip
    }
  }
}

