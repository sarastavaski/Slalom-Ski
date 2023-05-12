# VPC

variable "enable-dns-support" {
  description = "Should be true to enable DNS support in the VPC"
  default = "true"
}

variable "enable-dns-hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  default = "true"
}

variable "vpc-cidr" {
  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  default = ""
}

variable "vpc-name" {
  description = "Name of the VPC"
  type        = string
  default = ""
}

# Subnets

variable "vpc-public-subnet-cidr" {
  description = "A list of public subnets inside the VPC"
  type = list(string)
}


variable "vpc-private-subnet-cidr" {
  description = "A list of private subnets inside the VPC"
  type = list(string)
}

variable "availability-zones" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "private-route-cidr" {
  default = "0.0.0.0/0"
}

# TGW

variable "tgw-route-cidr" {}

variable "transit_gateway_id" {}