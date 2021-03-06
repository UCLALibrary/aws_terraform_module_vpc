output "vpc_main_id" {
  value = aws_vpc.main.id
}

output "vpc_public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "vpc_private_subnet_ids" {
  value = aws_subnet.private.*.id
}

output "public_egress_route_table_id" {
  value = aws_route_table.egress_global.id
}

output "private_nat_egress_route_table_id" {
  value = length(aws_route_table.nat_egress_global) > 0 ? aws_route_table.nat_egress_global[0].id: null
}

output "private_nat_gateway_id" {
  value = length(aws_nat_gateway.private_nat_gw) > 0 ? aws_nat_gateway.private_nat_gw[0].id: null
}

output "public_igw_id" {
  value = aws_internet_gateway.gw.id
}

