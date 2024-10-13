variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "15.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "15.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "15.0.2.0/24"
}


variable "custom_ami_id_frontend" {
  description = "The AMI ID for frontend server"
  type        = string
  default     = "ami-0be9d1d0d97a3f358"
}


variable "custom_ami_id_backend" {
  description = "The AMI ID for backend server"
  type        = string
  default     = "ami-017761facd1d38fca"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "availability_zone" {
  description = "EC2 availability zone"
  type        = string
  default     = "ap-northeast-3a"

}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "sonal_instance"
}