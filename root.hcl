locals {
  account_config = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_config  = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  profile = local.account_config.locals.profile
  region  = local.region_config.locals.region
}

remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    path = "${path_relative_to_include()}/terraform.state"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
  region  = "${local.region}"
  profile = "${local.profile}"
}
  EOF
}
