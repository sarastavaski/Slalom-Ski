provider "aws" {
  region = "us-east-2"
}

# VPC us-west-1

module "vpc" {
  source = "../../modules/vpc"

  vpc-name                = "ski-vpc" 
  vpc-cidr                = "10.2.0.0/20"
  availability-zones      = ["us-east-2a", "us-east-2b", "us-east-2c"]
  vpc-public-subnet-cidr  = ["10.2.2.0/23", "10.2.4.0/23", "10.2.6.0/23"]
  vpc-private-subnet-cidr = ["10.2.8.0/23", "10.2.10.0/23", "10.2.12.0/23"]
  tgw-route-cidr         =  "10.1.0.0/20"
  transit_gateway_id     = module.transit-gateway.EC2_Transit_Gateway_identifier_ID
}

module "transit-gateway" {
  source = "../../modules/transit-gateway"

  auto_accept_shared_attachments                  = "enable"
  amazon_side_asn                                 = "64513"
  vpn_ecmp_support                                = "enable"
  default_route_table_association                 = "enable"
  default_route_table_propagation                 = "enable"
  dns_support                                     = "enable"
  transit_gateway_name                            = "ski-us-east-2-tgw"
  transit_gateway_id                              = module.transit-gateway.EC2_Transit_Gateway_identifier_ID
  subnet_ids                                      = module.vpc.private-subnet-ids
  vpc_id                                          = module.vpc.vpc-id
  aws_ec2_transit_gateway_vpc_attachment_name     = "ski-us-east-2-tgw-attachments"
  transit_gateway_default_route_table_association = "true"
  transit_gateway_default_route_table_propagation = "true"
}

module "transit-gateway-accept" {
  source = "../../modules/transit-gateway-accept"
  
  transit-gateway-attachment-id = "tgw-attach-0a4d5843e49ab90be"
}

module "s3" {
  source = "../../modules/s3"
  
  domain_name            = "stavaski-bench-us-east-2" 
  use_default_domain     = true
  upload_sample_file     = true
}

module "cloudfront" {
  source = "../../modules/cloudfront"
  
  failover-bucket-regional-domain-name = "stavaski-bench-eu-west-1.s3.eu-west-1.amazonaws.com"
  primary-bucket-regional-domain-name  = "stavaski-bench-us-east-2.s3.us-east-2.amazonaws.com"
}
  