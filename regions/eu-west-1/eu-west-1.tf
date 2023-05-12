provider "aws" {
  region = "eu-west-1"
}

# VPC eu-west-1

module "vpc" {
  source = "../../modules/vpc"

  vpc-name                = "ski-vpc" 
  vpc-cidr                = "10.1.0.0/20"
  availability-zones      = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc-public-subnet-cidr  = ["10.1.2.0/23", "10.1.4.0/23", "10.1.6.0/23"]
  vpc-private-subnet-cidr = ["10.1.8.0/23", "10.1.10.0/23", "10.1.12.0/23"]
  tgw-route-cidr         =  "10.2.0.0/20"
  transit_gateway_id     = module.transit-gateway.EC2_Transit_Gateway_identifier_ID
}

module "transit-gateway" {
  source = "../../modules/transit-gateway"

  auto_accept_shared_attachments                  = "enable"
  amazon_side_asn                                 = "64512"
  vpn_ecmp_support                                = "enable"
  default_route_table_association                 = "enable"
  default_route_table_propagation                 = "enable"
  dns_support                                     = "enable"
  transit_gateway_name                            = "ski-eu-west-1-tgw"
  transit_gateway_id                              = module.transit-gateway.EC2_Transit_Gateway_identifier_ID
  subnet_ids                                      = module.vpc.private-subnet-ids
  vpc_id                                          = module.vpc.vpc-id
  aws_ec2_transit_gateway_vpc_attachment_name     = "ski-eu-west-1-tgw-attachments"
  transit_gateway_default_route_table_association = "true"
  transit_gateway_default_route_table_propagation = "true"
}

module "transit-gateway-peer" {
  source = "../../modules/transit-gateway-peer"
  
  peer-transit-gateway-id  = "tgw-06e453d1b04151e41"
  local-transit-gateway-id = module.transit-gateway.EC2_Transit_Gateway_identifier_ID
}


module "s3" {
  source = "../../modules/s3"
  
  domain_name            = "stavaski-bench-eu-west-1" 
  use_default_domain     = true
  upload_sample_file     = true
}