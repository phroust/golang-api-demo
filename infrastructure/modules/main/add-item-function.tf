resource "aws_cloudwatch_log_group" "add_item" {
  name              = "/aws/lambda/${aws_lambda_function.add_item.function_name}"
  retention_in_days = 14

  # todo: KMS
}


data "archive_file" "add_item" {
  type        = "zip"
  source_file = "${path.module}/../../../out/AddItem"
  output_path = "${path.module}/out/add-item.zip"
}

resource "aws_lambda_function" "add_item" {
  function_name    = "add-item"
  description      = "Adds an item to DynamoDB"
  filename         = data.archive_file.add_item.output_path
  source_code_hash = data.archive_file.add_item.output_base64sha256
  role             = aws_iam_role.add_item.arn
  runtime          = "go1.x"
  handler          = "AddItem"

  environment {
    variables = {
      DATABASE_TABLE_NAME = module.database.database_name
    }
  }
}


resource "aws_apigatewayv2_integration" "add_item" {
  api_id = module.api_gateway.api_id

  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.add_item.invoke_arn
}

resource "aws_apigatewayv2_route" "post_handler" {
  api_id    = module.api_gateway.api_id
  route_key = "POST /item"

  target = "integrations/${aws_apigatewayv2_integration.add_item.id}"
}

resource "aws_lambda_permission" "add_item" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add_item.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${module.api_gateway.execution_arn}/*/*"
}