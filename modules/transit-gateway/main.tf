# Creating Transit Gateway

resource "aws_ec2_transit_gateway" "aws_ec2_transit_gateway" {

  auto_accept_shared_attachments   = var.auto_accept_shared_attachments
  amazon_side_asn                  = var.amazon_side_asn
  vpn_ecmp_support                 = var.vpn_ecmp_support
  default_route_table_association  = var.default_route_table_association
  default_route_table_propagation  = var.default_route_table_propagation
  dns_support                      = var.dns_support

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "ski-tgw"
  }
}

#  Creating Transit Gateway Attachment

resource "aws_ec2_transit_gateway_vpc_attachment" "aws_ec2_transit_gateway_vpc_attachment" {
  subnet_ids = var.subnet_ids
  transit_gateway_id = var.transit_gateway_id
  vpc_id = var.vpc_id
  tags = {
    Name = var.aws_ec2_transit_gateway_vpc_attachment_name
  }
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation

}


#  Creating Transit Gateway Route table

resource "aws_ec2_transit_gateway_route_table" "aws_ec2_transit_gateway_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.aws_ec2_transit_gateway.id
}

resource "aws_ec2_transit_gateway_route" "aws_ec2_transit_gateway_route" {
  destination_cidr_block         = var.other-region-cidr
  transit_gateway_attachment_id  = var.transit-gateway-attachment-id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.aws_ec2_transit_gateway.association_default_route_table_id
}