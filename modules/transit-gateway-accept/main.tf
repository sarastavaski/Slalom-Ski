# Accept Peer
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "accept" {
  transit_gateway_attachment_id = var.transit-gateway-attachment-id
  tags = {
    Name = "us-east-2"
    Side = "Acceptor"
  }
}