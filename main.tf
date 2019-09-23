# Populate state file with AZ info.

data "aws_availability_zones" "available" {}

#############################################################################################################
# Create VPC network
#############################################################################################################
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"
}

#############################################################################################################
# Create public subnet to attach Internet Gateway route
#############################################################################################################
resource "aws_subnet" "public" {
  count                   = "${var.public_subnet_count}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(aws_vpc.main.cidr_block, 8, var.public_subnet_init_value + count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count                   = "${var.private_subnet_count}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(aws_vpc.main.cidr_block, 8, var.private_subnet_init_value + count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
}

#############################################################################################################
# Attach internet gateway to created VPC
#############################################################################################################
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "route_table_ig_gw" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_route_table_association" "route_public_subnets" {
  for_each = toset(aws_subnet.public.*.id)
  subnet_id = each.key
  route_table_id = "${aws_route_table.route_table_ig_gw.id}"
}

resource "aws_eip" "private_nat_eip" {
  count = "${var.enable_nat > 0 ? 1 : 0}"
  vpc   = true
}

resource "aws_nat_gateway" "private_nat_gw" {
  count = "${var.enable_nat > 0 ? 1 : 0}"
  allocation_id = "${aws_eip.private_nat_eip[0].id}"
  subnet_id = "${aws_subnet.public[0].id}"
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_route_table" "route_table_private_nat" {
  count = "${var.enable_nat > 0 ? 1 : 0}"
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.private_nat_gw[0].id}"
  }
}

resource "aws_route_table_association" "nat_route_private_subnets" {
  for_each  = (var.enable_nat > 0 ? toset(aws_subnet.private.*.id) : [])
  subnet_id = each.key
  route_table_id = "${aws_route_table.route_table_private_nat[0].id}"
}

resource "aws_route_table_association" "override_nat_route_private_subnets" {
  for_each  = (var.associate_existing_nat > 0 ? toset(aws_subnet.private.*.id) : [])
  subnet_id = each.key
  route_table_id = "${var.existing_private_nat_gateway_id != "" ? var.existing_private_nat_gateway_id : aws_route_table.route_table_private_nat[0].id}"
}

resource "aws_vpc_endpoint" "s3" {
  count        = "${var.create_vpc_endpoint > 0 ? 1 : 0}"
  vpc_id       = "${aws_vpc.main.id}"
  service_name = "${var.vpc_endpoint}"
  subnet_ids   = "${aws_subnet.private.*.id}"
}

