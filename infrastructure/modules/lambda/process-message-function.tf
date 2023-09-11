resource "aws_cloudwatch_log_group" "process_message" {
  name              = "/aws/lambda/${aws_lambda_function.process_message.function_name}"
  retention_in_days = 14

  kms_key_id = var.kms_key_arn
}


data "archive_file" "process_message" {
  type        = "zip"
  source_file = "${path.module}/../../../out/ProcessMessage"
  output_path = "${path.module}/out/process-message.zip"
}

resource "aws_lambda_function" "process_message" {
  function_name    = "process-message"
  description      = "Process a message from SQS"
  filename         = data.archive_file.process_message.output_path
  source_code_hash = data.archive_file.process_message.output_base64sha256
  role             = aws_iam_role.process_message.arn
  runtime          = "go1.x"
  handler          = "ProcessMessage"
}

resource "aws_lambda_event_source_mapping" "process_message" {
  event_source_arn = data.aws_sqs_queue.this.arn
  enabled          = true
  function_name    = aws_lambda_function.process_message.arn
  batch_size       = 10

  # report failed messages
  function_response_types = ["ReportBatchItemFailures"]
}