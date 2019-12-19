output "vpc_main_id" {
  value = "${aws_vpc.main.id}"
}

output "vpc_public_subnet_ids" {
  value = "${aws_subnet.public.*.id}"
}

output "vpc_private_subnet_ids" {
  value = "${aws_subnet.private.*.id}"
}

output "public_network_route_table" {
  value = "${aws_route_table.route_table_ig_gw.id}"
}

output "private_network_route_table" {
  value = "${aws_route_table.route_table_private_nat[0].id}"
}

output "private_nat_gateway_id" {
  value = "${aws_nat_gateway.private_nat_gw[0].id}"
}

