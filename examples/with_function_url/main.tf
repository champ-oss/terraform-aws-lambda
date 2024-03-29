terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.0.0"
    }
  }
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/../../test/helper_files"
  output_path = "package.zip"
}

module "this" {
  source                          = "../../"
  git                             = "terraform-aws-lambda"
  name                            = "function-url"
  filename                        = data.archive_file.this.output_path
  source_code_hash                = data.archive_file.this.output_base64sha256
  handler                         = "app.handler"
  runtime                         = "python3.9"
  enable_function_url             = true
  function_url_authorization_type = "NONE"
  dns_name                        = "terraform-aws-lambda-function-url.oss.champtest.net"
  zone_id                         = data.aws_route53_zone.this.zone_id
  reserved_concurrent_executions  = 1
}

output "arn" {
  description = "Lambda ARN"
  value       = module.this.arn
}

output "url" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url#function_url"
  value       = module.this.function_url
}