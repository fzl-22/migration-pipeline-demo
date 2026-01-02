resource "aws_vpc" "demo_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-demo-vpc"
    Environment = var.environment
    ManagedBy   = var.managed_by
  }
}

resource "aws_subnet" "demo_public_subnet" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name        = "${var.environment}-demo-public-subnet"
    Environment = var.environment
    ManagedBy   = var.managed_by
  }
}
