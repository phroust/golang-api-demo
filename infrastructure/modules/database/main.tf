resource "aws_dynamodb_table" "this" {
  name = var.name

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "ID"

  attribute {
    name = "ID"
    type = "S"
  }
}