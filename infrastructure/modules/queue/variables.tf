variable "name" {
  type        = string
  description = "The name of the service. Will be used to create resource names. This must match [a-z0-9]."

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.name))
    error_message = "The name must only contain [a-z0-9]."
  }
}

variable "max_receive_count" {
  type        = number
  description = "Try to process a message x times before giving up and sending it to the deadletter queue"
  default     = 5

  validation {
    condition     = var.max_receive_count > 0
    error_message = "The value for maxReceiveCount must be greater than 0"
  }
}

variable "kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key that will be used to encrypt messages in the queue"
}