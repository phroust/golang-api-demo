resource "aws_cloudwatch_log_group" "get_item" {
  name              = "/aws/lambda/${aws_lambda_function.get_item.function_name}"
  retention_in_days = 14

  kms_key_id = module.kms.key_arn
}


data "archive_file" "get_item" {
  type        = "zip"
  source_file = "${path.module}/../../../out/GetItem"
  output_path = "${path.module}/out/get-item.zip"
}

resource "aws_lambda_function" "get_item" {
  function_name    = "get-item"
  description      = "Gets an item from DynamoDB"
  filename         = data.archive_file.get_item.output_path
  source_code_hash = data.archive_file.get_item.output_base64sha256
  role             = aws_iam_role.get_item.arn
  runtime          = "go1.x"
  handler          = "GetItem"

  environment {
    variables = {
      DATABASE_TABLE_NAME = module.database.database_name
    }
  }
}


resource "aws_apigatewayv2_integration" "get_item" {
  api_id = module.api_gateway.api_id

  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.get_item.invoke_arn
}

resource "aws_apigatewayv2_route" "get_handler" {
  api_id    = module.api_gateway.api_id
  route_key = "GET /item/{itemID}"

  target = "integrations/${aws_apigatewayv2_integration.get_item.id}"
}

resource "aws_lambda_permission" "get_item" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_item.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${module.api_gateway.execution_arn}/*/*"
}