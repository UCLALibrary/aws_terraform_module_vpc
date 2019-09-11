variable "vpc_cidr_block" {
  default = "10.0.0.0/24"
}

variable "public_subnet_init_value" {}
variable "public_subnet_count" { default = 1 }

variable "private_subnet_init_value" {}
variable "private_subnet_count" { default = 0 }

variable "enable_nat" { default = 0 }
variable "associate_existing_nat" { default = 0 }
variable "existing_private_nat_gateway_id" { default = "" }

variable "vpc_endpoint" {}
variable "create_vpc_endpoint" { default = 0 }

