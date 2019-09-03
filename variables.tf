variable "vpc_cidr_block" {
  default = "10.0.0.0/24"
}

variable "subnet_cidr_block" {}
variable "subnet_init_value" {}
variable "subnet_count" { default = 1 }

