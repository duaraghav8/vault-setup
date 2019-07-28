**NOTE**: configuration is incomplete at this time.

# Vault configuration
This directory contains Terraform code to automate configuration of Secret & Authentication backends and Policies in Vault.

The configuration aims to demonstrate how a production application might authenticate with Vault and read static and dynamic secrets on need basis.

Vault cluster should be reachable at the address supplied from the machine executing this Terraform code and must already be initialized.

Post initialization, run Terraform using `terraform apply` to write the configuration to Vault.

## Example application
For the purpose of this repo, all configuration of Vault revolves around the idea of an app that authenticates to and consumes secrets from Vault. This is a background worker app, henceforth known as `worker`.

A User with the role of vault admin can manage secrets, policies and backends. This user will be known as **Alice**.

## Vault token
It is assumed that the Root token generated upon initializing Vault cluster is available to the user for supplying to Terraform for configuring Vault. Alternatively, a separate token can be generated with enough permissions to allow for configuring backends and policies. It is generally a good practice to revoke Root token in Vault post initial configuration.

## Secrets
The following secret engines are enabled and configured for the infrastructure.

### KV
KV `v1` is enabled for static secret storage. Alice can read and write secrets on any path inside this store. Apps have read access to limited paths.

`worker` needs to read payment credentials `merchant-id` & `merchant-secret` from `secret/payments/foo-gateway` in order to use a payment gateway.

Note that static secret values are not written from this TF configuration. The best practice is to populate static secrets manually inside Vault. Alice does it too!

### AWS
AWS secret backend is enabled to generate dynamic IAM credentials with specific policies. Apps can have read access for certain roles based on the need. These roles, in turn, contain IAM policies allowing access to AWS services.

`worker` needs to read data from multiple S3 buckets. This is allowed by `aws/roles/app-worker` role. Hence, `worker` must have read access to `aws/creds/app-worker` in Vault.

### Database
Database secret backend is enabled to dynamically generate credentials for MongoDB.

`worker` needs to read and write to a specific database. This is allowed by the `database/roles/app-worker-mongo` role. Hence, worker must have read access to `database/creds/app-worker-mongo`.

## Authentication
Authentication backends are enabled and configured with the idea that 2 types of entities are able to access Vault: Users (humans) and Apps (running on AWS infrastructure).

### Okta
Okta authentication is configured to allow users of an organization to have access to Vault. Alice authenticate with Vault using this method.

### AWS
AWS `iam` authentication is configured to allow IAM roles to authenticate with Vault.

A common scenario is that the application is running inside an EC2 machine. This machine is able to assume an IAM role. Using this role, the machine can authenticate with Vault and retrieve a token, passing it on to the app. [consul-template](https://github.com/hashicorp/consul-template) is one tool that does this.

The app can then use this token to retrieve secrets from Vault, assuming the token has the required policies attached.

This is the flow for `worker` as well.
