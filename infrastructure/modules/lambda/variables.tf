variable "name" {
  type        = string
  description = "The name of the service. Will be used to create resource names. This must match [a-z0-9]."

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.name))
    error_message = "The name must only contain [a-z0-9]."
  }
}

variable "kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key that will be used to encrypt logs"
}

variable "database_name" {
  type        = string
  description = "Name of DynamoDB database used to persist items"
}

variable "api_gateway_id" {
  type        = string
  description = "ID of API Gateway"
}


variable "queue_name" {
  type        = string
  description = "Name of SQS queue for messages"
}