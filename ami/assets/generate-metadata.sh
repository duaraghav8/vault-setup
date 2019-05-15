#!/usr/bin/env bash

set -xeou pipefail

vault_cluster_name_tag_key="cluster-name"
region=$(curl -s 169.254.169.254/latest/meta-data/placement/availability-zone | sed "s/.$//")
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
instance_private_ip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
tag_cluster_name=$(aws --region ${region} ec2 describe-tags --filters "Name=resource-id,Values=${instance_id}" "Name=key,Values=${vault_cluster_name_tag_key}" --query "Tags[].Value" --output text)

if [[ -z "${tag_cluster_name}" ]]
then
    echo "EC2 tag \"${vault_cluster_name_tag_key}\" is either empty or does not exist"
    exit 1
fi

cat > $1 << EOF
AWS_DEFAULT_REGION=${region}
VAULT_AWSKMS_SEAL_KEY_ID=alias/vault-${tag_cluster_name}-unseal-key
AWS_DYNAMODB_TABLE=vault-${tag_cluster_name}-storage-backend
VAULT_API_ADDR=http://${instance_private_ip}:8200
VAULT_CLUSTER_ADDR=https://${instance_private_ip}:8201
EOF
