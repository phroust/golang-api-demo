data "aws_iam_policy_document" "add_item" {

  statement {
    sid       = "AllowLogWrite"
    effect    = "Allow"
    actions   = ["logs:PutLogEvents", "logs:CreateLogStream"]
    resources = ["${aws_cloudwatch_log_group.add_item.arn}:*"]
  }

  statement {
    sid       = "AllowTableWrite"
    effect    = "Allow"
    actions   = ["dynamodb:PutItem"]
    resources = [data.aws_dynamodb_table.this.arn]
  }
}

resource "aws_iam_policy" "add_item" {
  policy = data.aws_iam_policy_document.add_item.json
}


resource "aws_iam_role_policy_attachment" "add_item" {
  policy_arn = aws_iam_policy.add_item.arn
  role       = aws_iam_role.add_item.name
}



resource "aws_iam_role" "add_item" {
  name = "${var.name}_AddItem"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}