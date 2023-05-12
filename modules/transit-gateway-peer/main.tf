resource "aws_ec2_transit_gateway_peering_attachment" "peering" {
  peer_region             = "us-east-2"
  peer_transit_gateway_id = var.peer-transit-gateway-id
  transit_gateway_id      = var.local-transit-gateway-id

  tags = {
    Name = "TGW Peering Requestor"
  }
}
