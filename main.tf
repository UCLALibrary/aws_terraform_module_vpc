# Populate state file with AZ info.
data "aws_availability_zones" "available" {}

#############################################################################################################
# Create VPC network
#############################################################################################################
resource "aws_vpc" "main" {
  cidr_block              = var.vpc_cidr_block

  tags                    = var.vpc_tag_map
}

#############################################################################################################
# Create public subnet to attach Internet Gateway route
#############################################################################################################
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.public_subnet_init_value + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags                    = var.subnet_tag_map
}

#############################################################################################################
# Create private subnets to attach Internet Gateway route
#############################################################################################################
resource "aws_subnet" "private" {
  count                   = var.private_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.private_subnet_init_value + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags                    = var.subnet_tag_map
}

#############################################################################################################
# Attach internet gateway to created VPC
#############################################################################################################
resource "aws_internet_gateway" "gw" {
  vpc_id                  = aws_vpc.main.id

  tags                    = var.vpc_tag_map
}

#############################################################################################################
# Create a egress global route table for the public subnet to associate
#############################################################################################################
resource "aws_route_table" "egress_global" {
  vpc_id                  = aws_vpc.main.id
  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = aws_internet_gateway.gw.id
  }

  tags                    = var.vpc_tag_map
}

#############################################################################################################
# Assocate route table containing IGW egress access to public subnets
#############################################################################################################
resource "aws_route_table_association" "route_public_subnets" {
  for_each                = toset(aws_subnet.public.*.id)
  subnet_id               = each.key
  route_table_id          = aws_route_table.egress_global.id
}

#############################################################################################################
# If nat flag set reverse an elastic IP 
#############################################################################################################
resource "aws_eip" "private_nat_eip" {
  count                   = var.enable_nat > 0 ? 1 : 0
  vpc                     = true

  tags                    = var.vpc_tag_map
}

#############################################################################################################
# If nat flag set, create a NAT gateway.
# The gateway will be running on the public subnet and has egress access to the world through the IGW
#############################################################################################################
resource "aws_nat_gateway" "private_nat_gw" {
  count                   = var.enable_nat > 0 ? 1 : 0
  allocation_id           = aws_eip.private_nat_eip[count.index].id
  subnet_id               = aws_subnet.public[count.index].id
  depends_on              = [aws_internet_gateway.gw]

  tags                    = var.vpc_tag_map
}

#############################################################################################################
# If nat flag set, create a route table to route all egress traffic to use the NAT gateway
#############################################################################################################
resource "aws_route_table" "nat_egress_global" {
  count                   = var.enable_nat > 0 ? 1 : 0
  vpc_id                  = aws_vpc.main.id
  route {
    cidr_block            = "0.0.0.0/0"
    nat_gateway_id        = aws_nat_gateway.private_nat_gw[count.index].id
  }

  tags                    = var.vpc_tag_map
}

#############################################################################################################
# If force_nat_egress set, associate the global NAT egress route table to the private subnets
# WARNING                 : This can get expensive if you're unsure what your egress traffic looks like
#############################################################################################################
resource "aws_route_table_association" "nat_route_private_subnets" {
  for_each                = (var.force_nat_egress > 0 ? toset(aws_subnet.private.*.id) : [])
  subnet_id               = each.key
  route_table_id          = aws_route_table.nat_egress_global[0].id
}
