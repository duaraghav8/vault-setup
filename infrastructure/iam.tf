data "aws_iam_policy_document" "vault_server_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "vault_server" {
  name               = "vault-server"
  assume_role_policy = "${data.aws_iam_policy_document.vault_server_assume_role.json}"
}

resource "aws_iam_instance_profile" "vault_server" {
  name = "vault-server"
  role = "${aws_iam_role.vault_server.name}"
}

data "aws_iam_policy_document" "vault_server" {
  # Storage backend
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:ListTables",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:CreateTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:Scan",
      "dynamodb:DescribeTable",
    ]

    resources = ["${aws_dynamodb_table.vault_storage_backend.arn}"]
  }

  # Unseal
  statement {
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
    ]

    resources = ["${aws_kms_key.vault_unseal_key.arn}"]
  }

  # EC2 read
  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
    ]

    resources = ["*"]
  }

  # IAM management
  statement {
    effect = "Allow"

    actions = [
      "iam:AttachUserPolicy",
      "iam:CreateAccessKey",
      "iam:CreateUser",
      "iam:DeleteAccessKey",
      "iam:DeleteUser",
      "iam:DeleteUserPolicy",
      "iam:DetachUserPolicy",
      "iam:GetInstanceProfile",
      "iam:GetRole",
      "iam:GetUser",
      "iam:ListAccessKeys",
      "iam:ListAttachedUserPolicies",
      "iam:ListGroupsForUser",
      "iam:ListUserPolicies",
      "iam:PutUserPolicy",
      "iam:RemoveUserFromGroup",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "vault_server" {
  name   = "vault-server"
  role   = "${aws_iam_role.vault_server.id}"
  policy = "${data.aws_iam_policy_document.vault_server.json}"
}

resource "aws_iam_role_policy_attachment" "vault_server_session_management" {
  role       = "${aws_iam_role.vault_server.name}"
  policy_arn = "${var.iam_policy_session_management_arn}"
}
