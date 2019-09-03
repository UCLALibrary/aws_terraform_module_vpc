output "vpc_main_id" {
  value = "${aws_vpc.main.id}"
}

#TODO: Output based off of dynamic vs static subnet generation
output "vpc_subnet_ids" {
  value = "${aws_subnet.public_dynamic.*.id}"
}
