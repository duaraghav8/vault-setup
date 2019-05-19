variable "main_vpc_cidr" {
  description = "Main VPC CIDR block"
}

variable "subnet_size_map" {
  type        = "map"
  description = "Mapping of subnet size to no. of frozen bits required in a /16 VPC CIDR"

  default = {
    "128"  = 9
    "256"  = 8
    "512"  = 7
    "1024" = 6
  }
}

variable "geo" {
  type        = "map"
  description = "Geographical configuration for infrastructure"

  default = {
    "default_region"            = "ap-south-1"
    "default_availability_zone" = "ap-south-1a"
  }
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

variable "vault_dynamo_read_cap" {
  description = "Provisioned Read capacity for DynamoDB Table used as Vault cluster storage backend"
}

variable "vault_dynamo_write_cap" {
  description = "Provisioned Write capacity for DynamoDB Table used as Vault cluster storage backend"
}

variable "vault_subnet_size" {
  default     = "128"
  description = "Size of subnet containing Vault infrastructure"
}
