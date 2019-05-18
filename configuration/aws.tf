# Secrets

# Keys must be left blank so Vault can retrieve AWS
# credentials from the host machine's IAM role
resource "vault_aws_secret_backend" "secrets_engine_aws" {
  access_key = ""
  secret_key = ""
  region     = "${var.vault_cluster_aws_region}"
}

# IAM role
resource "vault_aws_secret_backend_role" "app_worker" {
  backend         = "${vault_aws_secret_backend.secrets_engine_aws.path}"
  policy_arns     = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
  name            = "app-worker"
  credential_type = "iam_user"
}

# Authentication