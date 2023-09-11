output "database_name" {
  value = aws_dynamodb_table.this.name
}

output "database_arn" {
  value = aws_dynamodb_table.this.arn
}