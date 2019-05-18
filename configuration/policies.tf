module "policies" {
  source = "policies"
}

resource "vault_policy" "vault_admin" {
  name   = "vault-admin"
  policy = "${module.policies.superuser}"
}

resource "vault_policy" "app_worker" {
  name   = "app-worker"
  policy = "${module.policies.app_worker}"
}
