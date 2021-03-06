variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "default_tag_map" {
  type = map
  default = {
    "Name" = "VPC-Terraform"
  }
}

variable "vpc_tag_map" {
  type = map
  default = null
}

variable "subnet_tag_map" {
  type = map
  default = {
    "Name" = "VPC-Terraform"
  }
}

variable "public_subnet_init_value" {}
variable "public_subnet_count" {
  default = 1
}

variable "private_subnet_init_value" {}
variable "private_subnet_count" {
  default = 0
}

variable "enable_nat" {
  default = 0
}
variable "force_nat_egress" {
  default = 0
}

