# Secret Engine
resource "vault_aws_secret_backend" "secrets_engine_aws" {
  access_key = ""
  secret_key = ""
  region     = "${var.vault_cluster_aws_region}"
}

# AWS role
resource "vault_aws_secret_backend_role" "background_worker" {
  backend         = "${vault_aws_secret_backend.secrets_engine_aws.path}"
  name            = "background-worker"
  credential_type = "iam_user"
  policy_arns     = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
}
