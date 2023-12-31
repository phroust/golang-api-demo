data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_sqs_queue" "this" {
  name = var.name

  kms_master_key_id = var.kms_key_arn

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter.arn
    maxReceiveCount     = var.max_receive_count
  })
}

resource "aws_sqs_queue" "deadletter" {
  name = "${var.name}_dlq"

  kms_master_key_id = var.kms_key_arn

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns = [
      # needed to break dependency cycle
      "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.name}"
    ]
  })
}