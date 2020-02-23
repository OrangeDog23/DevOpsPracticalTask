resource "aws_vpc" "main" {
  # Referencing the base_cidr_block variable allows the network address
  # to be changed without modifying the configuration.
  cidr_block = var.base_cidr_block
}

resource "aws_eip" "nat" {
  vpc = true
}


resource "aws_nat_gateway" "private" {
  allocation_id = aws_eip.nat.id
  subnet_id     =  aws_subnet.az_public.id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "az_private" {
  # Create one subnet for each given availability zone.
  vpc_id = aws_vpc.main.id
  availability_zone = var.availability_zone
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, 1)
}

resource "aws_subnet" "az_private_2" {
  # Create one subnet for each given availability zone.
  vpc_id = aws_vpc.main.id
  availability_zone = var.availability_zone_2
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, 2)
}

resource "aws_subnet" "az_public" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.availability_zone
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, 3)
}

resource "aws_subnet" "az_public_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.availability_zone_2
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, 4)
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, 1)
    nat_gateway_id = aws_nat_gateway.private.id
  }
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, 2)
    nat_gateway_id = aws_nat_gateway.private.id
  }
}




