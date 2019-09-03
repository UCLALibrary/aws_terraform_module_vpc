variable "vpc_cidr_block" {
  default = "10.0.0.0/24"
}

variable "subnet_cidr_block" {}
variable "subnet_init_value" {}
variable "enable_autocreate_subnet" { default = 0 }
variable "disable_autocreate_subnet" { default = 0}

