# Prodcution VPC
resource "aws_vpc" "production-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "production-vpc"
    }
}
# Public Subnets

resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.production-vpc.id
  cidr_block = var.public_subnet_1_cidr
  availability_zone = var.availability_zones[0]
  tags = {
    Name = "public-subnet-1"
  }
}
resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.production-vpc.id
  cidr_block = var.public_subnet_2_cidr
  availability_zone = var.availability_zones[1]
  tags = {
    Name = "public-subnet-2"
  }
}

# Private Subnets
resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.production-vpc.id
  cidr_block = var.private_subnet_1_cidr
  availability_zone = var.availability_zones[0]
  tags = {
    Name = "private-subnet-1"
  }
}
resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.production-vpc.id
  cidr_block = var.private_subnet_2_cidr
  availability_zone = var.availability_zones[1]
  tags = {
    Name = "private-subnet-2"
  }
}

# Route tables for the Subnets

resource "aws_route_table" "public-route-table" {
    vpc_id     = aws_vpc.production-vpc.id
}
resource "aws_route_table" "private-route-table" {
    vpc_id     = aws_vpc.production-vpc.id
}

# Associate the newly created route tables to the Subnets

resource "aws_route_table_association" "public-route-1-association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-route-2-association" {
    route_table_id = aws_route_table.public-route-table.id
    subnet_id = aws_subnet.public-subnet-2.id 
}

resource "aws_route_table_association" "private-route-1-association" {
    route_table_id = aws_route_table.private-route-table.id
    subnet_id = aws_subnet.private-subnet-1.id
}

resource "aws_route_table_association" "private-route-2-association" {
    route_table_id = aws_route_table.private-route-table.id
    subnet_id = aws_subnet.private-subnet-2.id
}

# Elastic IP

resource "aws_eip" "elastic-ip-for-nat-gw" {
    vpc = true
    associate_with_private_ip = "10.0.0.5"
    depends_on = [aws_internet_gateway.production-igw]
}

# NAT Gateway 
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip-for-nat-gw.id
  subnet_id     = aws_subnet.public-subnet-1.id
  depends_on = [aws_eip.elastic-ip-for-nat-gw]
}
resource "aws_route" "nat-gw-route" {
    route_table_id = aws_route_table.private-route-table.id
    nat_gateway_id = aws_nat_gateway.nat-gw.id
    destination_cidr_block = "0.0.0.0/0"
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "production-igw" {
    vpc_id = aws_vpc.production-vpc.id
}

# Route the public subnet traffic through the Internet Gateway
resource "aws_route" "public-internet-igw-route" {
    route_table_id = aws_route_table.public-route-table.id
    gateway_id = aws_internet_gateway.production-igw.id
    destination_cidr_block = "0.0.0.0/0"
}

