# Configuration and Deployment of Mern stack application on aws with Terraform

**Step 1. Install Terraform**

Install terraform for WINDOWS using link https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli  

- **After installation check if the terraform is installed or not:**  
![image](https://github.com/user-attachments/assets/0da08428-1138-4c6f-87dd-33c43e6a1175)

- **Configure aws on the local machine:**
  
![image](https://github.com/user-attachments/assets/d82c7a3c-6d7e-4067-8b16-41a7c86f848f)

- **Create terraform files:**
  
![image](https://github.com/user-attachments/assets/8fd2bd55-fe9c-4330-b8d1-4bb36cfa4db0)


- **Configure providers and region in main.tf:**
  
```
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
```

- **Create VPC:**
```
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Sonal_Khare_VPC"
  }

}
```
- **Define vpc_cidr in variables.tf**
```
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "15.0.0.0/16"
}
```
![VPC](https://github.com/user-attachments/assets/52ef8289-42d4-4563-8ce5-c8be779c3ba5)


- **Create Public and Private Subnet in main.tf**
```
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "15.0.1.0/24"
}
```
```
variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "15.0.2.0/24"
}
```
![subnet](https://github.com/user-attachments/assets/997a85b7-1194-4927-bab6-1f0ba0b546f4)

- **Create internet gateway**
```
# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Sonal_igw"
  }
}
```
![internet_gateways](https://github.com/user-attachments/assets/95ff0dc4-0c09-4bac-8872-3f4554822539)

- **Create elastic IP and nat gateway**
```
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
```
![nat_gateways](https://github.com/user-attachments/assets/16524b5c-68bd-474e-8a8e-d9e24a024d7f)

- **Create public and private route table and associate with public and private subnet respectively**
```
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
```
![routetable](https://github.com/user-attachments/assets/1deebad4-a4ff-4331-b8f4-23d664f81741)

In the end resource map should like this:  
![resource_map](https://github.com/user-attachments/assets/36ff76ed-5943-489c-9b10-d9443f997dd9)


- **Create Security Group**
```
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
    cidr_blocks = ["49.23.42.155/0"]
  }

  tags = {
    Name = "sonal_security_group"
  }
}
```
- **Create backend server and configure startup commands**
```
resource "aws_instance" "custom_ec2_backend" {
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
```
- **Create Frontend machine and update url.js with backend IP**
```
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
```

- **Run the configuration with command terraform apply**

The command should output in the below format
![image](https://github.com/user-attachments/assets/dacb1866-da1f-47b0-a6ff-4f203497acc5)

Fulls logs can be reffered here:  
```
```






  



