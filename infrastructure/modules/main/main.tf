module "kms" {
  source = "../kms"
  name   = var.name
}

module "database" {
  source = "../database"
  name   = var.name
}

module "api_gateway" {
  source = "../api_gateway"
  name   = var.name

  kms_key_arn = module.kms.key_arn
}

module "queue" {
  source      = "../queue"
  name        = var.name
  kms_key_arn = module.kms.key_arn
}

module "lambda" {
  source         = "../lambda"
  kms_key_arn    = module.kms.key_arn
  api_gateway_id = module.api_gateway.api_id
  database_name  = module.database.database_name
  name           = var.name
  queue_name     = module.queue.queue_name
}