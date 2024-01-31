resource "ncloud_login_key" "develop_key" {
  key_name = "${var.terraform_name}-key"
}

resource "local_file" "develop_pem" {
  filename = "${ncloud_login_key.develop_key.key_name}.pem"
  content  = ncloud_login_key.develop_key.private_key
}
