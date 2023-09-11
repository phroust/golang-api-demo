data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

module "kms" {
  source = "../kms"
  name   = var.name
}

module "database" {
  source = "../database"
  name   = var.name
}

module "api_gateway" {
  source = "../api_gateway"
  name   = var.name

  kms_key_arn = module.kms.key_arn
}

module "queue" {
  source      = "../queue"
  name        = var.name
  kms_key_arn = module.kms.key_arn
}