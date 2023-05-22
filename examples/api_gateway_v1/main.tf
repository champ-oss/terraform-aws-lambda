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
  source                     = "github.com/champ-oss/terraform-aws-api-gateway.git?ref=v1.0.3-62ff228"
  git                        = "terraform-aws-lambda"
  api_gateway_v1_domain_name = local.domain_name
  zone_id                    = data.aws_route53_zone.this.zone_id
  enable_create_certificate  = true
  enable_api_gateway_v1      = true

  # Attach the lambda to the root of the Api Gateway
  enable_lambda_integration = true
  lambda_arn                = module.this.arn
}

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/../python"
  output_path = "package.zip"
}

module "this" {
  source                         = "../../"
  git                            = "terraform-aws-lambda"
  name                           = "api-gateway-v1"
  filename                       = data.archive_file.this.output_path
  source_code_hash               = data.archive_file.this.output_base64sha256
  handler                        = "app.handler"
  runtime                        = "python3.9"
  reserved_concurrent_executions = 1

  # Attach the lambda to /test of the Api Gateway
  enable_api_gateway_v1             = true
  api_gateway_v1_rest_api_id        = module.api_gateway.api_gateway_v1_id
  api_gateway_v1_parent_resource_id = module.api_gateway.api_gateway_v1_root_resource_id
  api_gateway_v1_path_part          = "test"
}

# Create a separate resource to attach a lambda
resource "aws_api_gateway_resource" "this" {
  rest_api_id = module.api_gateway.api_gateway_v1_id
  parent_id   = module.api_gateway.api_gateway_v1_root_resource_id
  path_part   = "test2"
}

module "lambda_separate_resource" {
  source                         = "../../"
  git                            = "terraform-aws-lambda"
  name                           = "api-gateway-v1-test2"
  filename                       = data.archive_file.this.output_path
  source_code_hash               = data.archive_file.this.output_base64sha256
  handler                        = "app.handler"
  runtime                        = "python3.9"
  reserved_concurrent_executions = 1

  # Attach the lambda to the separate resource created above
  enable_api_gateway_v1          = true
  api_gateway_v1_rest_api_id     = module.api_gateway.api_gateway_v1_id
  create_api_gateway_v1_resource = false
  api_gateway_v1_resource_id     = aws_api_gateway_resource.this.id
  api_gateway_v1_resource_path   = aws_api_gateway_resource.this.path
}