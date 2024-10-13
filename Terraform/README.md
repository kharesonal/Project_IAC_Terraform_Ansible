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


  










  



