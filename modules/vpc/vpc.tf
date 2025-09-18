resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = var.vpc_name }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}


# Public subnets
resource "aws_subnet" "public" {
  for_each                = toset(var.availability_zones)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[index(var.availability_zones, each.key)]
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.vpc_name}-public-${each.key}" }
}


# Private subnets
resource "aws_subnet" "private" {
  for_each          = toset(var.availability_zones)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[index(var.availability_zones, each.key)]
  availability_zone = each.key
  tags              = { Name = "${var.vpc_name}-private-${each.key}" }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
}


resource "aws_route" "default_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}