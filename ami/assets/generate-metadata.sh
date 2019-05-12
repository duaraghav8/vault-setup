#!/usr/bin/env bash

set -xeou pipefail

vault_cluster_name_tag_key="cluster-name"
region=$(curl -s 169.254.169.254/latest/meta-data/placement/availability-zone | sed "s/.$//")
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
tag_cluster_name=$(aws --region ${region} ec2 describe-tags --filters "Name=resource-id,Values=${instance_id}" "Name=key,Values=${vault_cluster_name_tag_key}" --query "Tags[].Value" --output text)

if [[ -z "${tag_cluster_name}" ]]
then
    echo "EC2 tag \"${vault_cluster_name_tag_key}\" is either empty or does not exist"
    exit 1
fi

echo "AWS_DEFAULT_REGION=${region}"
echo "VAULT_AWSKMS_SEAL_KEY_ID=alias/vault-${tag_cluster_name}-unseal-key"
echo "AWS_DYNAMODB_TABLE=vault-${tag_cluster_name}-storage-backend"