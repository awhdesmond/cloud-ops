data "aws_availability_zones" "available" {}

# VPC

resource "aws_vpc" "main" {
	cidr_block = "10.0.0.0/16"

	enable_dns_support = true
	enable_dns_hostnames = true

	tags =  merge(var.default_tags, {
		Name = var.vpc_name
	})
}

# Internet Gateway

resource "aws_internet_gateway" "igw" {
	vpc_id = aws_vpc.main.id
	tags = merge(var.default_tags, {
		Name = "${var.vpc_name}-igw"
	})
}

# Subnets

resource "aws_subnet" "public" {
  count = var.public_subnet_count

	vpc_id = aws_vpc.main.id
	cidr_block = cidrsubnet(var.cidr_block, var.public_subnet_additional_bits, count.index + var.public_subnet_count)
	availability_zone = data.aws_availability_zones.available.names[count.index]

	# Required for EKS. Instances launched in the public subnet
	# should be assigned a public IP address to join the cluster
  # https://aws.amazon.com/blogs/containers/upcoming-changes-to-ip-assignment-for-eks-managed-node-groups/
	map_public_ip_on_launch = true

	tags = merge(var.default_tags, {
		Name = "${var.vpc_name}-public-${count.index + 1}"
		"kubernetes.io/role/elb" = 1 # allow EKS to place ELB in this subnet
	})
}

resource "aws_subnet" "private" {
  count = var.private_subnet_count

	vpc_id = aws_vpc.main.id
	cidr_block = cidrsubnet(var.cidr_block, var.private_subnet_additional_bits, count.index)
	availability_zone = data.aws_availability_zones.available.names[count.index]

	tags = merge(var.default_tags, {
    Name = "${var.vpc_name}-private-${count.index + 1}"
		"kubernetes.io/role/internal-elb" = 1 # allow EKS to place ELB load balancers in this subnet
	})
}

# NAT Gateways

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = merge(var.default_tags, {
    Name = "${var.vpc_name}-nat"
  })
}

resource "aws_nat_gateway" "nat_gw" {
	allocation_id = aws_eip.nat.id
	subnet_id = aws_subnet.public[0].id
	tags = merge(var.default_tags, {
    Name = "${var.vpc_name}-nat"
  })

  # NAT gateway may require internet gateway to be
	# created prior to the association
  depends_on = [aws_internet_gateway.igw]
}


# Route Tables

resource "aws_route_table" "public" {
	vpc_id = aws_vpc.main.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id
	}
	tags = merge(var.default_tags, {
		Name = "${var.vpc_name}-private"
	})
}

resource "aws_route_table" "private" {
	vpc_id = aws_vpc.main.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_nat_gateway.nat_gw.id
	}

  tags = merge(var.default_tags, {
		Name = "${var.vpc_name}-public"
	})
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
