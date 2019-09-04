# aws_terraform_module_vpc [![Build Status](https://travis-ci.com/UCLALibrary/aws_terraform_module_vpc.svg?branch=master)](https://travis-ci.com/UCLALibrary/aws_terraform_module_vpc)

## VPC Module Usage Example
This will create a new VPC with public networks. It assumes a /16 and creates subnets in /24. In the below example, it'll create a VPC network of 10.0.0.0/16 and a subnet of 10.0.1.0/24 in the first AZ.
```
module "vpc" {
  source                    = "git::https://github.com/UCLALibrary/aws_terraform_module_vpc.git"
  vpc_cidr_block            = "10.0.0.0/16"
  subnet_init_value         = 1
  subnet_count              = 1
}
```

## VPC Module Usage Example With Multiple Subnets
This will create a new VPC with public networks. It assumes a /16 and creates subnets in /24. In the below example, it'll create a VPC network of 10.0.0.0/16 and subnets of 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24 in the multiple availability zones.
```
module "vpc" {
  source                    = "git::https://github.com/UCLALibrary/aws_terraform_module_vpc.git"
  vpc_cidr_block            = "10.0.0.0/16"
  subnet_init_value         = 1
  subnet_count              = 3
}
```

## Dependencies
* Provide a Class B CIDR block
