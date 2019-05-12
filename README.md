# vault-setup
Setup for a production-grade Vault cluster

1. Run Packer with `ami/vault.json` to build the AMI. Its ID will be used in the next step.
2. Run Terraform inside `infrastructure/` to build a High-Availability Vault cluster with DynamoDB as Storage backend. Information such as AWS Profile and AMI ID must be populated in the code or entered when TF CLI prompts you to.
3. Use AWS Session Manager to get Shell access inside one of the Vault machines. Post initialization, Vault should be unsealed automatically via AWS KMS.