iam_policy_session_management_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"

vault_cluster_size         = 2
vault_server_disk_size     = 20
vault_dynamo_read_cap      = 10
vault_dynamo_write_cap     = 15
vault_server_instance_type = "t2.micro"

vault_tags = {
  "Name"          = "vault"
  "resource-type" = "vault"
  "cluster-name"  = "caribou"
}
