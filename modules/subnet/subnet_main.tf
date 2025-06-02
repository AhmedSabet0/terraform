resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
    availability_zone       = var.availability_zones[count.index]


  tags ={
      Name = "public-subnet-${count.index + 1}"
      Type = "public"
    }
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zones[count.index]
  tags ={
      Name = "private-subnet-${count.index + 1}"
      Type = "private"
    }
  
}
resource "aws_internet_gateway" "gw" {
  vpc_id =  var.vpc_id
  tags = {
    Name = "main"
  }
}

#
# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  
  tags = {
      Name = "nat-eip"
    }
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
      Name = "nat-gateway"
     }
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
      Name = "public-route-table"
    }
}

# Route to Internet Gateway for Public Subnets
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Route Table for Private Subnets
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
      Name = "private-route-table"
    }
}

# Route to NAT Gateway for Private Subnets
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}