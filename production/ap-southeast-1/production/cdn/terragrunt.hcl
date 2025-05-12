terraform {
  source = "../../../../modules/cdn/main.tf"
}

include {
  path = find_in_parent_folders("root.hcl")
}

dependency "s3" {
  config_path = "../s3"

  mock_outputs = {
    bucket_regional_domain_name = "bucket regional domain name"
    s3_bucket_id                = "s3 bucket id"
    s3_bucket_arn               = "s3 bucket ARN"
  }

  mock_outputs_allowed_terraform_commands = ["plan"]
}

locals {
  environment_config = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  environment = local.environment_config.locals.environment
}

inputs = {
  environment                 = local.environment
  bucket_regional_domain_name = dependency.s3.outputs.bucket_regional_domain_name
  s3_bucket_id                = dependency.s3.outputs.s3_bucket_id
  s3_bucket_arn               = dependency.s3.outputs.s3_bucket_arn
}

