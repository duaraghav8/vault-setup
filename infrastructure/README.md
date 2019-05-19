# Vault Infrastructure
**WARNING:** This Terraform code is merely written for the convenience of quickly spinning up and destroying resources for Vault. Do not use it for your production deployments.

The current configuration is to store state locally.

All values in `terraform.tfvars` must be reviewed by the user before deploying to their own environment. Note that some values like main VPC ID need to be [supplied](https://www.terraform.io/docs/configuration/variables.html#variables-on-the-command-line) by the user and are not included in this repository's code. This is because this configuration assumes that there is already a VPC & Subnet setup with appropriate routing tables to accommodate the cluster.

Post initialization, run Terraform using:
```bash
terraform apply
```

See [Provider documentation](https://www.terraform.io/docs/providers/aws/index.html#environment-variables) to know how to supply AWS credentials to Terraform.

The EC2 machines are configured to spin up without any SSH keys, thereby closing down SSH access. AWS Session Manager is enabled in order to start a Shell session inside the server.

```bash
aws ssm start-session --target [INSTANCE-ID]
```