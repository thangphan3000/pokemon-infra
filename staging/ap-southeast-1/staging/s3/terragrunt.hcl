terraform {
  source = "../../../../modules/s3/main.tf"
}

include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  environment_config = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  environment = local.environment_config.locals.environment
}

inputs = {
  environment = local.environment
}
