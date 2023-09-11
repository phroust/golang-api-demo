data "aws_iam_policy_document" "process_message" {

  statement {
    sid       = "AllowLogWrite"
    effect    = "Allow"
    actions   = ["logs:PutLogEvents", "logs:CreateLogStream"]
    resources = ["${aws_cloudwatch_log_group.process_message.arn}:*"]
  }

  statement {
    sid    = "AllowMessageReceive"
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [data.aws_sqs_queue.this.arn]
  }

  statement {
    sid    = "AllowKeyRead"
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]
    resources = [var.kms_key_arn]
  }
}

resource "aws_iam_policy" "process_message" {
  policy = data.aws_iam_policy_document.process_message.json
}


resource "aws_iam_role_policy_attachment" "process_message" {
  policy_arn = aws_iam_policy.process_message.arn
  role       = aws_iam_role.process_message.name
}


resource "aws_iam_role" "process_message" {
  name = "${var.name}_ProcessMessage"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}