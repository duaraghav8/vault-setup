provider "vault" {
  version = "1.8.0"
  address = "${var.vault_cluster_address}"
  token   = "${var.vault_token}"
}
