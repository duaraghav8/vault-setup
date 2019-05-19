# VPC that contains entire Vault infrastructure
resource "aws_vpc" "main" {
  cidr_block = "${var.main_vpc_cidr}"
  tags       = "${var.vault_tags}"
}

# Publicly accessible subnet for ease of reachability
# Not recommended for production setup
resource "aws_subnet" "vault_cluster" {
  vpc_id            = "${aws_vpc.main.id}"
  tags              = "${var.vault_tags}"
  availability_zone = "${var.geo["default_availability_zone"]}"
  cidr_block        = "${cidrsubnet(aws_vpc.main.cidr_block, var.subnet_size_map[var.vault_subnet_size], 1)}"

  map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "main_vpc" {
  vpc_id = "${aws_vpc.main.id}"
  tags   = "${var.vault_tags}"
}

resource "aws_route_table" "vault_cluster_subnet" {
  vpc_id = "${aws_vpc.main.id}"
  tags   = "${var.vault_tags}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main_vpc.id}"
  }
}

resource "aws_route_table_association" "vault_subnet_to_igw" {
  route_table_id = "${aws_route_table.vault_cluster_subnet.id}"
  subnet_id      = "${aws_subnet.vault_cluster.id}"
}
