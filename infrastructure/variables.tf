variable "main_vpc_id" {
  description = "ID of the VPC inside which Vault cluster will be created"
}

variable "iam_policy_session_management_arn" {
  description = "ARN of the AWS-managed IAM Policy to enable AWS Session Manager. This is a well-known ARN."
}

variable "vault_ami_id" {
  description = "Vault AMI ID"
}

variable "vault_cluster_size" {
  description = "Number of servers in the Vault cluster"
}

variable "vault_server_instance_type" {
  description = "EC2 instance type to use for Vault server"
}

variable "vault_tags" {
  type        = "map"
  description = "Tags for Vault server"
}

variable "vault_server_disk_size" {
  description = "Root block device storage size for Vault server"
}

variable "vault_cluster_subnet_id" {
  description = "ID of Subnet reserved for Vault Cluster inside the main VPC"
}

variable "vault_dynamo_read_cap" {
  description = "Provisioned Read capacity for DynamoDB Table used as Vault cluster storage backend"
}

variable "vault_dynamo_write_cap" {
  description = "Provisioned Write capacity for DynamoDB Table used as Vault cluster storage backend"
}
