# vault-setup
Setup for a production-grade Vault cluster

1. Run Packer with `ami/vault.json` to build the AMI. This AMI will be used to create Vault servers.
2. Run Terraform inside `infrastructure/` to build a High-Availability Vault cluster with DynamoDB as Storage backend.
3. Use AWS Session Manager to get Shell access inside one of the Vault machines. Post initialization, Vault should be unsealed automatically via AWS KMS.
4. Head to `configuration/` to configure Vault in automation. Vault cluster's address and root token need to be supplied to this module in order to configure the cluster.

See documentation inside a specific directory for details on that step.