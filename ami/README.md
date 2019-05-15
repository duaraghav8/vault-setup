# Packer template for Vault
- Base AMI: Amazon Linux 2 (latest at the time of creation)
- Storage backend is `DynamoDB`. Vault is configured to expect that the dynamo table already exists and that it doesn't need to create one.

The EC2 machine must have the following *tags*:
- `cluster-name`: Unique for every Vault cluster in the infrastructure. If 2 vault machines belong to the same cluster, they must have the same value for this tag. Machines of 2 different Vault clusters must never have the same value for this tag.

See [Authentication](https://www.packer.io/docs/builders/amazon.html#authentication) on how to provide AWS credentials to Packer.

Build the AMI using `packer build vault.json`.