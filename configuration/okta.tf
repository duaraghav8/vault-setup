resource "vault_okta_auth_backend" "engineering" {
  organization = "${var.okta_organization_name}"
  description  = "Okta authentication to allow Engineering team members to access Vault"

  # Token must be manually updated by administrator in Vault
  token = ""
}

resource "vault_okta_auth_backend_group" "vault_admins" {
  group_name = "${var.okta_admin_group_name}"
  policies   = ["${vault_policy.vault_admin.name}"]
  path       = "${vault_okta_auth_backend.engineering.path}"
}

resource "vault_okta_auth_backend_user" "vault_admin" {
  username = "${var.okta_admin_user}"
  path     = "${vault_okta_auth_backend.engineering.path}"
  groups   = ["${vault_okta_auth_backend_group.vault_admins.group_name}"]
}
