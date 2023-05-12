# Create VPC

resource "aws_vpc" "vpc" {
  count = 1
  
  cidr_block           = var.vpc-cidr
  enable_dns_support   = var.enable-dns-support
  enable_dns_hostnames = var.enable-dns-hostnames

  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = var.vpc-name
  }
}

# Create IGW

resource "aws_internet_gateway" "ig" {
  count = 1
  vpc_id = aws_vpc.vpc[0].id
  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "ski-igw"
  }
}

# Creating Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}

# Create Public Subnets

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc[0].id
  count                   = length(var.vpc-public-subnet-cidr)
  cidr_block              = var.vpc-public-subnet-cidr[count.index]
  availability_zone       = var.availability-zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "ski-public-subnets"
  }
}

# Creating NAT Gateway
resource "aws_nat_gateway" "nat" {
  count         = 1
  allocation_id = aws_eip.nat_eip.*.id[count.index]
  subnet_id     = aws_subnet.public_subnet.*.id[count.index]
  depends_on    = [aws_internet_gateway.ig]
  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "ski-nat-gw"
  }
}

# Creating Public Routes

resource "aws_route_table" "public_routes" {
  vpc_id = aws_vpc.vpc[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig[0].id
  }
  route {
    cidr_block         = var.tgw-route-cidr
    transit_gateway_id = var.transit_gateway_id
  }
  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "ski-public-subnet-routes"
  }
}

# Creating Associatiation/Link Public-Route With Public-Subnets

resource "aws_route_table_association" "public-association" {
  count          = length(var.vpc-public-subnet-cidr)
  route_table_id = aws_route_table.public_routes.id
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
}

# Create Private Subnets
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc[0].id
  count                   = length(var.vpc-private-subnet-cidr)
  cidr_block              = var.vpc-private-subnet-cidr[count.index]
  availability_zone       = var.availability-zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "ski-private-subnets"
  }
}

# Creating Private Route-Table For Private-Subnets

resource "aws_route_table" "private_routes" {
  count  = length(var.vpc-private-subnet-cidr) 
  vpc_id = aws_vpc.vpc[0].id
  route {
    cidr_block         = var.private-route-cidr
    nat_gateway_id = element(aws_nat_gateway.nat.*.id,count.index)
  }

  route {
    cidr_block         = var.tgw-route-cidr
    transit_gateway_id = var.transit_gateway_id
  }

  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "ski-private-subnet-routes"
  }

}

# Creating Associatiation/Link Private-Routes With Private-Subnets

resource "aws_route_table_association" "private_routes_linking" {
  count          = length(var.vpc-private-subnet-cidr) 
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = aws_route_table.private_routes.*.id[count.index]
}