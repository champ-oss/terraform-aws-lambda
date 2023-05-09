terraform {
  backend "s3" {}
}

provider "aws" {
  region = "us-east-2"
}

locals {
  git         = "terraform-aws-lambda"
  domain_name = "${local.git}-apigw.${data.aws_route53_zone.this.name}"
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

module "api_gateway" {
  source                     = "github.com/champ-oss/terraform-aws-api-gateway.git?ref=38255163ea1727cc8b73776faee6bcf989866e61"
  git                        = "terraform-aws-lambda"
  api_gateway_v1_domain_name = local.domain_name
  zone_id                    = data.aws_route53_zone.this.zone_id
  enable_create_certificate  = true
  enable_lambda_integration  = true
  lambda_arn                 = module.this.arn
  enable_api_gateway_v1      = true
}

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/../python"
  output_path = "package.zip"
}

module "this" {
  source                            = "../../"
  git                               = "terraform-aws-lambda"
  name                              = "api-gateway-v1"
  filename                          = data.archive_file.this.output_path
  source_code_hash                  = data.archive_file.this.output_base64sha256
  handler                           = "app.handler"
  runtime                           = "python3.9"
  reserved_concurrent_executions    = 1
  enable_api_gateway_v1             = true
  api_gateway_v1_rest_api_id        = module.api_gateway.api_gateway_v1_id
  api_gateway_v1_parent_resource_id = module.api_gateway.api_gateway_v1_root_resource_id
  api_gateway_v1_path_part          = "test"
  environment = {
    "FOO" = "BAR"
  }
}
