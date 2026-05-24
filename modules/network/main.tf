resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "project-vpc"
    ManagedBy   = "Terraform"
    Environment = "Dev"
    Project     = "IaC-Project"
  }
}


resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
  Name        = "public-subnet"
  ManagedBy   = "Terraform"
  Environment = "Dev"
  Project     = "IaC-Project"
}
}


resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name        = "private-subnet-1"
    ManagedBy   = "Terraform"
    Environment = "Dev"
    Project     = "IaC-Project"
  }
}



resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "ap-south-1b"

  tags = {
    Name        = "private-subnet-2"
    ManagedBy   = "Terraform"
    Environment = "Dev"
    Project     = "IaC-Project"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
  Name        = "project-igw"
  ManagedBy   = "Terraform"
  Environment = "Dev"
  Project     = "IaC-Project"
}
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
  Name        = "public-route-table"
  ManagedBy   = "Terraform"
  Environment = "Dev"
  Project     = "IaC-Project"
}
}



resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}