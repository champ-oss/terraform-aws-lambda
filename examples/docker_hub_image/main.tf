provider "aws" {
  region = "us-east-1"
}

module "this" {
  source                         = "../../"
  git                            = "terraform-aws-lambda"
  name                           = "docker-hub"
  sync_image                     = true
  sync_source_repo               = "champtitles/terraform-aws-lambda"
  sync_source_tag                = var.ecr_tag # will get set at runtime by Terratest as GITHUB_SHA
  reserved_concurrent_executions = 1
  environment = {
    "FOO" = "BAR"
  }
}