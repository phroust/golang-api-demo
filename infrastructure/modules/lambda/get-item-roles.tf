data "aws_iam_policy_document" "get_item" {

  statement {
    sid       = "AllowLogWrite"
    effect    = "Allow"
    actions   = ["logs:PutLogEvents", "logs:CreateLogStream"]
    resources = ["${aws_cloudwatch_log_group.get_item.arn}:*"]
  }

  statement {
    sid       = "AllowTableWrite"
    effect    = "Allow"
    actions   = ["dynamodb:GetItem"]
    resources = [data.aws_dynamodb_table.this.arn]
  }
}

resource "aws_iam_policy" "get_item" {
  policy = data.aws_iam_policy_document.get_item.json
}


resource "aws_iam_role_policy_attachment" "get_item" {
  policy_arn = aws_iam_policy.get_item.arn
  role       = aws_iam_role.get_item.name
}



resource "aws_iam_role" "get_item" {
  name = "${var.name}_GetItem"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}