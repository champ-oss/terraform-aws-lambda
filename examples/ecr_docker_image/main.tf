provider "aws" {
  region = "us-east-1"
}

module "this" {
  source                         = "../../"
  git                            = "terraform-aws-lambda"
  name                           = "ecr"
  ecr_account                    = "912455136424"
  ecr_name                       = "terraform-aws-lambda"
  ecr_tag                        = var.ecr_tag # will get set at runtime by Terratest as GITHUB_SHA
  reserved_concurrent_executions = 1
  environment = {
    "FOO" = "BAR"
  }
}