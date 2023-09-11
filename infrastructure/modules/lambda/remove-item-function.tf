resource "aws_cloudwatch_log_group" "remove_item" {
  name              = "/aws/lambda/${aws_lambda_function.remove_item.function_name}"
  retention_in_days = 14

  kms_key_id = var.kms_key_arn
}


data "archive_file" "remove_item" {
  type        = "zip"
  source_file = "${path.module}/../../../out/RemoveItem"
  output_path = "${path.module}/out/remove-item.zip"
}

resource "aws_lambda_function" "remove_item" {
  function_name    = "remove-item"
  description      = "Removes an item from DynamoDB"
  filename         = data.archive_file.remove_item.output_path
  source_code_hash = data.archive_file.remove_item.output_base64sha256
  role             = aws_iam_role.remove_item.arn
  runtime          = "go1.x"
  handler          = "RemoveItem"

  environment {
    variables = {
      DATABASE_TABLE_NAME = var.database_name
    }
  }
}


resource "aws_apigatewayv2_integration" "remove_item" {
  api_id = var.api_gateway_id

  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.remove_item.invoke_arn
}

resource "aws_apigatewayv2_route" "remove_handler" {
  api_id    = var.api_gateway_id
  route_key = "DELETE /item/{itemID}"

  target = "integrations/${aws_apigatewayv2_integration.remove_item.id}"
}

resource "aws_lambda_permission" "remove_item" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.remove_item.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${data.aws_apigatewayv2_api.this.execution_arn}/*/*"
}