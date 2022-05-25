provider "aws" {
  region = "us-east-1"
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/../python"
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
  enable_route53                  = true
  dns_name                        = "terraform-aws-lambda-function-url.oss.champtest.net"
  zone_id                         = data.aws_route53_zone.this.zone_id
  reserved_concurrent_executions  = 1
}
