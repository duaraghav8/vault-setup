#!/usr/bin/env bash

set -xeou pipefail

sudo yum update -y

# Setup utility script(s)
sudo cp /tmp/assets/vault/generate-metadata.sh /usr/bin/generate-metadata
sudo chown root:root /usr/bin/generate-metadata
sudo chmod 0755 /usr/bin/generate-metadata

# Install
sudo wget --quiet https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -O /tmp/assets/vault/vault.zip
sudo unzip -q /tmp/assets/vault/vault.zip -d /usr/bin

sudo chown root:root /usr/bin/vault
sudo chmod 0755 /usr/bin/vault

vault -autocomplete-install
complete -C /usr/bin/vault vault

# Configure
sudo setcap cap_ipc_lock=+ep /usr/bin/vault
sudo useradd --system --home /etc/vault.d --shell /bin/false vault

sudo mkdir -p /etc/vault.d
sudo cp /tmp/assets/vault/vault.hcl /etc/vault.d/vault.hcl
sudo chmod 0640 /etc/vault.d/vault.hcl
sudo chown --recursive vault:vault /etc/vault.d

# Init
sudo cp /tmp/assets/vault/vault.service /usr/lib/systemd/system/vault.service
sudo chown root:root /usr/lib/systemd/system/vault.service
sudo chmod 0644 /usr/lib/systemd/system/vault.service
sudo systemctl enable vault

# Additional configuration could be added. For eg- Monitoring agents,
# Consul agent and Log shippers. This is beyond the scope of this setup.
