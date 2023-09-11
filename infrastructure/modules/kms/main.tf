data "aws_caller_identity" "current" {}

data "aws_region" "current" {}


data "aws_iam_policy_document" "kms" {

  # for backwards compatibility with default policy
  policy_id = "key-default-1"

  #  the default key policy
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  # grant access to cloudwatch log groups
  statement {
    sid = "allowLogGroupAccess"

    principals {
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
      type        = "Service"
    }

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]

    resources = [
      "*",
    ]

    condition {
      test = "ArnEquals"
      values = [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"
      ]
      variable = "kms:EncryptionContext:aws:logs:arn"
    }

    effect = "Allow"
  }
}

resource "aws_kms_key" "this" {

  description = "KMS key used by demo application"

  is_enabled = true

  deletion_window_in_days = 14

  policy = data.aws_iam_policy_document.kms.json
}