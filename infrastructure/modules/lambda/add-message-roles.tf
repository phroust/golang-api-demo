data "aws_iam_policy_document" "add_message" {

  statement {
    sid       = "AllowLogWrite"
    effect    = "Allow"
    actions   = ["logs:PutLogEvents", "logs:CreateLogStream"]
    resources = ["${aws_cloudwatch_log_group.add_message.arn}:*"]
  }

  statement {
    sid    = "AllowMessageSend"
    effect = "Allow"
    actions = [
      "sqs:sendmessage"
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

resource "aws_iam_policy" "add_message" {
  policy = data.aws_iam_policy_document.add_message.json
}


resource "aws_iam_role_policy_attachment" "add_message" {
  policy_arn = aws_iam_policy.add_message.arn
  role       = aws_iam_role.add_message.name
}


resource "aws_iam_role" "add_message" {
  name = "${var.name}_AddMessage"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}