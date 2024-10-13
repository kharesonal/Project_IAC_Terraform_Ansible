output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.my_vpc.id
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = aws_vpc.my_vpc.tags["Name"]

}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "elastic_ip_id" {
  description = "The assigned elastic ip id"
  value       = aws_eip.nat_eip.id
}

output "elastic_public_ip" {
  description = "The assigned elastic public ip"
  value       = aws_eip.nat_eip.public_ip
}


output "nat_gateway_id" {
  description = "Id of the NAT gateway"
  value       = aws_nat_gateway.nat_gw.id
}

output "ec2_frontend" {
  description = "ip address of the EC2 frontend"
  value       = aws_instance.custom_ec2.public_ip

}

output "ec2_backend" {
  description = "ip address of the EC2 backend"
  value = aws_instance.custom_ec2_backend.public_ip
  

}