terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-3"

}



resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Sonal_Khare_VPC"
  }

}


resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "ap-northeast-3a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}


resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "private_subnet"
  }
}


# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Sonal_igw"
  }
}


# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "Sonal_Elastic_IP"
  }
}


resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  

  tags = {
    Name = "Sonal_NAT_GateWay"
  }
}


# Create Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Sonal_public_route_table"
  }
}

# Associate Public Route Table with Public Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
  
}

# Create Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Sonal_private_route_table"
  }
}

# Associate Private Route Table with Private Subnet
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}


resource "aws_security_group" "web_sg" {
  name        = "sonal_security_group"
  description = "Allow HTTP, HTTPS, and SSH inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow 3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow 3001"
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "Allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/32"]
  }


  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sonal_security_group"
  }
}



resource "aws_instance" "custom_ec2_backend" {
  #count                       = length(data.aws_instance.existing.id) == 0 ? 1 : 0
  ami                         = var.custom_ami_id_backend
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

    user_data = <<-EOF
              #!/bin/bash
              # Create the backend directory if it doesn't exist
              cd /home/ubuntu/TravelMemory/backend

              # Create the .env file with the specified content
              cat <<EOT >> /home/ubuntu/TravelMemory/backend/.env
              MONGO_URI="mongodb+srv://sonal:sonal1189@cluster-sonal.0ktone2.mongodb.net/MERN?retryWrites=true&w=majority"
              PORT=3001
              EOT

              # Set appropriate permissions (optional)
              chown ubuntu:ubuntu /home/ubuntu/TravelMemory/backend/.env
              chmod 600 /home/ubuntu/TravelMemory/backend/.env
              EOF

  tags = {
    Name = "Sonal_EC2_Backend"
  }

}

resource "aws_instance" "custom_ec2" {
  ami                         = var.custom_ami_id_frontend
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = var.key_name
  availability_zone           = "ap-northeast-3a"
  associate_public_ip_address = true

  tags = {
    Name = "Sonal_EC2_Frontend"
  }

  user_data = file("${path.module}/user_data.sh")



}