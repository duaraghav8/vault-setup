variable "vault_cluster_address" {
  description = "Complete Vault cluster address with scheme and port. This address should be reachable from host machine."
}

variable "vault_token" {
  description = "Vault token with sufficient priveleges to configure backends and policies"
}

variable "vault_cluster_aws_region" {
  default     = "ap-south-1"
  description = "AWS Region the Vault Cluster is in"
}

variable "okta_organization_name" {
  description = "Organization's subdomain on Okta"
}

variable "okta_admin_group_name" {
  description = "Name of the group for administrators in the Okta organization"
}

variable "okta_admin_user" {
  description = "Name of Okta admin user. This user will also be admin in Vault"
}
