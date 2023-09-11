provider "aws" {
  region = "eu-central-1"

  # List of allowed AWS account IDs to prevent you from mistakenly using an incorrect one (and potentially end up destroying a live environment).
  # This is optional.
  allowed_account_ids = [
#    "123456789"
  ]

  # You should use a dedicated role to perform all actions instead of a personal IAM Access Key
  # see here for more information:
  # * https://support.hashicorp.com/hc/en-us/articles/360041289933-Using-AWS-AssumeRole-with-the-AWS-Terraform-Provider
  # * https://developer.hashicorp.com/terraform/tutorials/aws/aws-assumerole
#  assume_role {
#    role_arn = "arn:aws:iam::123456789:role/DeploymentRole"
#  }

  # These tags will be added to all taggable resources.
  default_tags {
    tags = {
      # Tag all resources with the application name.
      # You should register the "Application" tag as a cost allocation tag in order to get a simple way to check costs
      # for each running application.
      Application = "demo"

      # This tag should point to the current repository name (e.g. in GitHub). This will make it easier in the future
      # to find the infrastructure code that is responsible for a resource.
      Project     = "golang-api-demo"

      # Using this tag will allow you to find resources that were *not* created by Terraform (i.e. manually).
      ManagedBy   = "terraform"
    }
  }
}

terraform {
  backend "s3" {
    # Name of the S3 Bucket.
    bucket  = "golang-aws-demo"
    # Path to the state file inside the S3 Bucket.
    key     = "terraform/my-application-name.tfstate"
    # Enable server side encryption of the state file.
    encrypt = true

    # Name of DynamoDB Table to use for state locking and consistency.
    # The table must have a partition key named LockID with type of String.
    # This is optional but should be set to prevent multiple pipelines from changing resources concurrently.
    dynamodb_table = "my-locking-table"
  }
}
