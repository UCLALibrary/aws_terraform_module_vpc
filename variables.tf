variable "vpc_cidr_block" {
  default = "10.0.0.0/24"
}

variable "public_subnet_init_value" {}
variable "public_subnet_count" { default = 1 }

variable "private_subnet_init_value" {}
variable "private_subnet_count" { default = 0 }

