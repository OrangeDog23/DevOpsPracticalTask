resource "aws_vpc" "main" {
  cidr_block = var.base_cidr_block
}

#public subnet configuration

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "az_public" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.availability_zone
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, 3)
  tags = {
   Name = "public_1" 
  }
}

resource "aws_subnet" "az_public_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.availability_zone_2
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, 4)
  tags = {
	Name = "public_2" 
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }
  tags = {
   Name = "public_1" 
  }
}

resource "aws_route_table" "public_2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }
  tags = {
	Name = "public_2" 
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.az_public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.az_public_2.id
  route_table_id = aws_route_table.public.id
}


# private subnets config

resource "aws_subnet" "az_private" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.availability_zone
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, 1)
  tags = {
   Name = "private_1" 
  }
}

resource "aws_subnet" "az_private_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.availability_zone_2
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, 2)
  tags = {
   Name = "private_2" 
  }
}


resource "aws_eip" "nat" {
  vpc      = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.az_public.id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
	Name = "private_1" 
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.az_private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.az_private_2.id
  route_table_id = aws_route_table.private.id
}



