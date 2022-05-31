provider "aws" {
  region = "us-east-1"
}

module "this" {
  source                         = "../../"
  git                            = "terraform-aws-lambda"
  name                           = "docker-hub"
  sync_image                     = true
  sync_source_repo               = "champtitles/terraform-aws-lambda"
  ecr_tag                        = var.ecr_tag                       # will get set at runtime by Terratest as GITHUB_SHA
  ecr_name                       = "terraform-aws-lambda/docker-hub" # ECR repo to create and sync to
  reserved_concurrent_executions = 1
  environment = {
    "FOO" = "BAR"
  }
}