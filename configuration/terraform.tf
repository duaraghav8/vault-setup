provider "vault" {
  address = "${var.vault_cluster_address}"
  token   = "${var.vault_token}"
}
