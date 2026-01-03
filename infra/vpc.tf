resource "aws_vpc" "demo_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name      = "demo-vpc"
    ManagedBy = var.managed_by
  }
}

resource "aws_subnet" "demo_public_subnet" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name      = "demo-public-subnet"
    ManagedBy = var.managed_by
  }
}

# ROUTE TABLES
resource "aws_route_table" "demo_public_route_table" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }

  tags = {
    Name      = "demo-public-route-table"
    ManagedBy = var.managed_by
  }
}

resource "aws_route_table_association" "demo_public_subnet_association" {
  subnet_id      = aws_subnet.demo_public_subnet.id
  route_table_id = aws_route_table.demo_public_route_table.id
}

# INTERNET GATEWAYS
resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name      = "demo-igw"
    ManagedBy = var.managed_by
  }
}
