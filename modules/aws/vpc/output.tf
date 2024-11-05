output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "public_subnets_cidr_blocks" {
  value = [for subnet in aws_subnet.public : subnet.cidr_block]
}

output "private_subnets" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "private_subnets_cidr_blocks" {
  value = [for subnet in aws_subnet.private : subnet.cidr_block]
}

output "nat_gateway_ipv4_address" {
  value = aws_eip.nat.public_ip
}
