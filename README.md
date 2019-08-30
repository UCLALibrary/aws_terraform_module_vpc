# aws_terraform_module_vpc [![Build Status](https://travis-ci.com/UCLALibrary/aws_terraform_module_vpc.svg?branch=master)](https://travis-ci.com/UCLALibrary/aws_terraform_module_vpc)

## Fargate Module Usage Example Without Load Balancer
```
module "iiif_cloudfront" {                                                                                                                                                                                                                                                                                                                   
  source                  = "git::https://github.com/UCLALibrary/aws_terraform_module_vpc.git"
  app_origin_dns_name     = "${var.iiif_alb_dns_name}"                                                                                                                                                                                                                                                                                       
  app_public_dns_names    = "${var.iiif_public_dns_names}"                                                                                                                                                                                                                                                                                   
  app_origin_id           = "ALBOrigin-${var.iiif_alb_dns_name}"                                                                                                                                                                                                                                                                             
  app_ssl_certificate_arn = "${var.iiif_cloudfront_ssl_certificate_arn}"                                                                                                                                                                                                                                                                     
  app_path_pattern        = "${var.iiif_thumbnail_path_pattern}"                                                                                                                                                                                                                                                                             
}   
```

## Fargate Module Usage Example With Load Balancer
```
module "iiif_cloudfront" {                                                                                                                                                                                                                                                                                                                   
  source                  = "git::https://github.com/UCLALibrary/aws_terraform_module_vpc.git"
  app_origin_dns_name     = "${var.iiif_alb_dns_name}"                                                                                                                                                                                                                                                                                       
  app_public_dns_names    = "${var.iiif_public_dns_names}"                                                                                                                                                                                                                                                                                   
  app_origin_id           = "ALBOrigin-${var.iiif_alb_dns_name}"                                                                                                                                                                                                                                                                             
  app_ssl_certificate_arn = "${var.iiif_cloudfront_ssl_certificate_arn}"                                                                                                                                                                                                                                                                     
  app_path_pattern        = "${var.iiif_thumbnail_path_pattern}"                                                                                                                                                                                                                                                                             
}   
```


## Dependencies
* Upload ACM certificate prior to running Terraform
* Retrieve ARN in `us-east-1`
