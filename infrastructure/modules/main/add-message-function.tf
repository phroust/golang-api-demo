resource "aws_cloudwatch_log_group" "add_message" {
  name              = "/aws/lambda/${aws_lambda_function.add_message.function_name}"
  retention_in_days = 14

  kms_key_id = module.kms.key_arn
}


data "archive_file" "add_message" {
  type        = "zip"
  source_file = "${path.module}/../../../out/AddMessage"
  output_path = "${path.module}/out/add-message.zip"
}

resource "aws_lambda_function" "add_message" {
  function_name    = "add-message"
  description      = "Adds a message to SQS"
  filename         = data.archive_file.add_message.output_path
  source_code_hash = data.archive_file.add_message.output_base64sha256
  role             = aws_iam_role.add_message.arn
  runtime          = "go1.x"
  handler          = "AddMessage"

  environment {
    variables = {
      QUEUE_URL = module.queue.queue_url
    }
  }
}


resource "aws_apigatewayv2_integration" "add_message" {
  api_id = module.api_gateway.api_id

  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.add_message.invoke_arn
}

resource "aws_apigatewayv2_route" "post_message_handler" {
  api_id    = module.api_gateway.api_id
  route_key = "POST /message"

  target = "integrations/${aws_apigatewayv2_integration.add_message.id}"
}

resource "aws_lambda_permission" "add_message" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add_message.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${module.api_gateway.execution_arn}/*/*"
}