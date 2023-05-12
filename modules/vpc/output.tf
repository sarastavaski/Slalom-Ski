# Output of VPC

output "vpc-id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.vpc.*.id, [""])[0]
}


# Output of IGW

output "igw" {
  value = aws_internet_gateway.ig.*.id
}

# Output of Public Subnet

output "public-subnet-ids" {
  description = "Public Subnets IDS"
  value       = aws_subnet.public_subnet.*.id
}

# Output of EIP For NAT Gateways

output "eip-ngw" {
  value = aws_eip.nat_eip.*.id
}

# Output Of NAT-Gateways

output "ngw" {
  value = aws_nat_gateway.nat.*.id
}

# Output Of Private Subnet

output "private-subnet-ids" {
  description = "Private Subnets IDS"
  value       = aws_subnet.private_subnet.*.id
}

# Output Of Public Subnet Associations With Public Route Tables

output "public-association" {
  value = aws_route_table_association.public-association.*.id
}

# Output Of Public Routes

output "aws-route-table-public-routes-id" {
  value = aws_route_table.public_routes.*.id
}


# Output Of Private Route Table ID's

output "aws-route-table-private-routes-id" {
  value = aws_route_table.private_routes.*.id
}