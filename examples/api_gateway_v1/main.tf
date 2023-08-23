locals {
  git         = "terraform-aws-lambda-${random_id.this.hex}"
  domain_name = "${local.git}.${data.aws_route53_zone.this.name}"
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

resource "random_id" "this" {
  byte_length = 2
}

module "api_gateway" {
  source                    = "github.com/champ-oss/terraform-aws-api-gateway.git?ref=v1.0.8-9276037"
  git                       = "terraform-aws-lambda"
  domain_name               = local.domain_name
  zone_id                   = data.aws_route53_zone.this.zone_id
  enable_create_certificate = true
  cidr_blocks               = ["0.0.0.0/0"]
  enable_api_key            = true
  api_gateway_deployment_id = aws_api_gateway_deployment.this.id
}

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/../../test/helper_files"
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

  # attach the lambda to the root of API Gateway
  enable_api_gateway_v1           = true
  create_api_gateway_v1_resource  = false
  api_gateway_v1_api_key_required = true
  api_gateway_v1_rest_api_id      = module.api_gateway.rest_api_id
  api_gateway_v1_resource_id      = module.api_gateway.root_resource_id
  api_gateway_v1_http_method      = "GET"
  api_gateway_v1_resource_path    = "/"
}


module "lambda_test_path" {
  source                         = "../../"
  git                            = "terraform-aws-lambda"
  name                           = "api-gateway-v1-test2"
  filename                       = data.archive_file.this.output_path
  source_code_hash               = data.archive_file.this.output_base64sha256
  handler                        = "app.handler"
  runtime                        = "python3.9"
  reserved_concurrent_executions = 1

  # attach the lambda to /test path of API Gateway
  enable_api_gateway_v1             = true
  api_gateway_v1_api_key_required   = true
  api_gateway_v1_rest_api_id        = module.api_gateway.rest_api_id
  api_gateway_v1_parent_resource_id = module.api_gateway.root_resource_id
  api_gateway_v1_path_part          = "test"
  api_gateway_v1_http_method        = "GET"
}

resource "aws_api_gateway_deployment" "this" {
  depends_on  = [module.this, module.lambda_test_path]
  rest_api_id = module.api_gateway.rest_api_id
  triggers = {
    redeployment = sha1(jsonencode([
      module.api_gateway.root_resource_id,
      module.this.api_gateway_v1_resource_id,
      module.this.api_gateway_v1_method_id,
      module.this.api_gateway_v1_integration_id,
      module.lambda_test_path.api_gateway_v1_resource_id,
      module.lambda_test_path.api_gateway_v1_method_id,
      module.lambda_test_path.api_gateway_v1_integration_id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "arn" {
  description = "Lambda ARN"
  value       = module.this.arn
}

output "url" {
  description = "url of API Gateway endpoint"
  value       = "https://${local.domain_name}"
}

output "auth_token" {
  description = "Generated API Key to use for requests"
  sensitive   = true
  value       = module.api_gateway.api_key_value
}
