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

data "aws_dynamodb_table" "this" {
  name = var.name
}

data "aws_apigatewayv2_api" "this" {
  api_id = var.api_gateway_id
}

data "aws_sqs_queue" "this" {
  name = var.queue_name
}