resource "aws_vpc" "Main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "public0" {
  vpc_id     = aws_vpc.Main.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "public0"
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.Main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public1"
  }
}

resource "aws_subnet" "private0" {
  vpc_id     = aws_vpc.Main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private0"
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.Main.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "private1"
  }
}

resource "aws_internet_gateway" "Main" {
  vpc_id = aws_vpc.Main.id

  tags = {
    Name = "Main"
  }
}

resource "aws_eip" "nat0" {
  domain = "vpc"

  tags = {
    Name = "nat0"
  }
}

resource "aws_eip" "nat1" {
  domain = "vpc"

  tags = {
    Name = "nat1"
  }
}

resource "aws_nat_gateway" "Main0" {
  allocation_id = aws_eip.nat0.id
  subnet_id     = aws_subnet.public0.id

  tags = {
    Name = "Main0"
  }
}

resource "aws_nat_gateway" "Main1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "Main1"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Main.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "private0" {
  vpc_id = aws_vpc.Main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Main0.id
  }

  tags = {
    Name = "private0"
  }
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.Main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Main1.id
  }

  tags = {
    Name = "private1"
  }
}

resource "aws_route_table_association" "public0" {
  subnet_id      = aws_subnet.public0.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private0" {
  subnet_id      = aws_subnet.private0.id
  route_table_id = aws_route_table.private0.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}
