resource "ncloud_access_control_group" "develop_bastion_acg" {
  name   = "${var.zone_name}-${var.terraform_name}-bastion-acg"
  vpc_no = ncloud_vpc.develop_vpc.id
}

resource "ncloud_access_control_group_rule" "develop_bastion_acg" {
  access_control_group_no = ncloud_access_control_group.develop_bastion_acg.id

  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "22"
    description = "accept 22 port(all ip)"
  }
  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "3000"
    description = "accept 3000 port(all ip)"
  }
  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "80"
    description = "accept 80 port(all ip)"
  }
  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "443"
    description = "accept 443 port(all ip)"
  }
  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "3306"
    description = "accept 3306 port(all ip)"
  }
  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "6379"
    description = "accept 6379 port(all ip)"
  }
  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "8080"
    description = "accept 8080 port(all ip)"
  }
  inbound {
    protocol    = "UDP"
    ip_block    = "0.0.0.0/0"
    port_range  = "1194"
    description = "accept 1194 port(all ip)"
  }
  outbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "1-65535"
    description = "accept TCP 1-65535 port"
  }
  outbound {
    protocol    = "UDP"
    ip_block    = "0.0.0.0/0"
    port_range  = "1-65535"
    description = "accept UDP 1-65535 port"
  }
  outbound {
    protocol    = "ICMP"
    ip_block    = "0.0.0.0/0"
    description = "accept ICMP"
  }
}

resource "ncloud_network_interface" "develop_bastion_nic" {
  name                  = "${var.terraform_name}-bastion-nic"
  subnet_no             = ncloud_subnet.develop_net_subnet.id
  access_control_groups = [ncloud_access_control_group.develop_bastion_acg.id]
}

resource "ncloud_server" "develop_bastion_server" {
  subnet_no                 = ncloud_subnet.develop_net_subnet.id
  name                      = "${var.zone_name}-${var.terraform_name}-bastion"
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  server_product_code       = "SVR.VSVR.STAND.C002.M008.NET.HDD.B050.G002"
  login_key_name            = ncloud_login_key.develop_key.key_name
  network_interface {
    network_interface_no = ncloud_network_interface.develop_bastion_nic.id
    order                = 0
  }
}

data "ncloud_root_password" "develop_bastion_root_password" {
  server_instance_no = ncloud_server.develop_bastion_server.instance_no
  private_key        = ncloud_login_key.develop_key.private_key
}

resource "local_file" "develop_bastion_root_password_file" {
  filename = "${ncloud_server.develop_bastion_server.name}-root-password.txt"
  content  = "${ncloud_server.develop_bastion_server.name} => ${data.ncloud_root_password.develop_bastion_root_password.root_password}"
}

resource "ncloud_public_ip" "develop_bastion_ip" {
  server_instance_no = ncloud_server.develop_bastion_server.id
  description        = "for ${ncloud_server.develop_bastion_server.name} public ip"
}
