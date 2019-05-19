# AMI
data "aws_ami" "vault" {
  owners = ["self"]

  filter {
    name   = "image-id"
    values = ["${var.vault_ami_id}"]
  }
}

# Server(s)
resource "aws_instance" "vault" {
  count      = "${var.vault_cluster_size}"
  depends_on = ["aws_internet_gateway.main_vpc"]

  ami                    = "${data.aws_ami.vault.id}"
  instance_type          = "${var.vault_server_instance_type}"
  tags                   = "${var.vault_tags}"
  volume_tags            = "${var.vault_tags}"
  subnet_id              = "${aws_subnet.vault_cluster.id}"
  iam_instance_profile   = "${aws_iam_instance_profile.vault_server.name}"
  vpc_security_group_ids = ["${aws_security_group.vault.id}"]

  disable_api_termination     = false
  monitoring                  = false
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "${var.vault_server_disk_size}"
    delete_on_termination = true
  }
}

# Security Group
resource "aws_security_group" "vault" {
  name        = "vault-${var.vault_tags["cluster-name"]}"
  description = "Allow ingress requests to Vault API from enclosing VPC"
  vpc_id      = "${aws_vpc.main.id}"
  tags        = "${var.vault_tags}"

  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    self        = true
    cidr_blocks = ["${aws_vpc.main.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Storage backend
# https://www.vaultproject.io/docs/configuration/storage/dynamodb.html#table-schema
resource "aws_dynamodb_table" "vault_storage_backend" {
  name           = "vault-${var.vault_tags["cluster-name"]}-storage-backend"
  read_capacity  = "${var.vault_dynamo_read_cap}"
  write_capacity = "${var.vault_dynamo_write_cap}"
  tags           = "${var.vault_tags}"

  billing_mode = "PROVISIONED"
  hash_key     = "Path"
  range_key    = "Key"

  attribute = [
    {
      name = "Path"
      type = "S"
    },
    {
      name = "Key"
      type = "S"
    },
  ]
}

# Unseal
resource "aws_kms_key" "vault_unseal_key" {
  description = "Vault unseal Master key"
  key_usage   = "ENCRYPT_DECRYPT"
  is_enabled  = true
}

resource "aws_kms_alias" "unseal_key_alias" {
  name          = "alias/vault-${var.vault_tags["cluster-name"]}-unseal-key"
  target_key_id = "${aws_kms_key.vault_unseal_key.id}"

  lifecycle {
    create_before_destroy = true
  }
}
