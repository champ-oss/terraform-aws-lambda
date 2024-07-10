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

variable "enabled" {
  description = "module enabled"
  type        = bool
  default     = true
}

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/../../test/helper_files"
  output_path = "package.zip"
}

module "this" {
  source                         = "../../"
  git                            = "terraform-aws-lambda"
  name                           = "zip"
  filename                       = data.archive_file.this.output_path
  source_code_hash               = data.archive_file.this.output_base64sha256
  handler                        = "app.handler"
  runtime                        = "python3.9"
  reserved_concurrent_executions = 1
  enabled                        = var.enabled
  environment = {
    "FOO" = "BAR"
  }
}

output "arn" {
  description = "Lambda ARN"
  value       = module.this.arn
}

output "enabled" {
  description = "module enabled"
  value       = var.enabled
}