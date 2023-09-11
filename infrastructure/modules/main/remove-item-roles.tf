data "aws_iam_policy_document" "remove_item" {

  statement {
    sid       = "AllowLogWrite"
    effect    = "Allow"
    actions   = ["logs:PutLogEvents", "logs:CreateLogStream"]
    resources = ["${aws_cloudwatch_log_group.remove_item.arn}:*"]
  }

  statement {
    sid       = "AllowTableWrite"
    effect    = "Allow"
    actions   = ["dynamodb:DeleteItem"]
    resources = [module.database.database_arn]
  }
}

resource "aws_iam_policy" "remove_item" {
  policy = data.aws_iam_policy_document.remove_item.json
}


resource "aws_iam_role_policy_attachment" "remove_item" {
  policy_arn = aws_iam_policy.remove_item.arn
  role       = aws_iam_role.remove_item.name
}



resource "aws_iam_role" "remove_item" {
  name = "${var.name}_RemoveItem"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}