resource "ncloud_vpc" "develop_vpc" {
  name            = "${var.zone_name}-${var.terraform_name}-vpc"
  ipv4_cidr_block = var.vpc_cidr
}

resource "ncloud_network_acl" "develop_public_acl" {
  name   = "${var.zone_name}-${var.terraform_name}-net-public"
  vpc_no = ncloud_vpc.develop_vpc.id
}

resource "ncloud_subnet" "develop_net_subnet" {
  name           = "${var.zone_name}-${var.terraform_name}-net-public"
  vpc_no         = ncloud_vpc.develop_vpc.id
  subnet         = cidrsubnet(ncloud_vpc.develop_vpc.ipv4_cidr_block, 8, 0)
  zone           = var.zones
  network_acl_no = ncloud_network_acl.develop_public_acl.id
  subnet_type    = "PUBLIC"
}