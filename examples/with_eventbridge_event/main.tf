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

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/../../test/helper_files"
  output_path = "package.zip"
}

variable "enabled" {
  description = "Enable or disable the module"
  type        = bool
  default     = true
}

module "this1" {
  source                                = "../../"
  git                                   = "terraform-aws-lambda"
  enabled                               = var.enabled
  name                                  = "cloudwatch-event-bridge-to-lambda-trigger-test" # Test for name length errors
  filename                              = data.archive_file.this.output_path
  source_code_hash                      = data.archive_file.this.output_base64sha256
  handler                               = "app.handler"
  runtime                               = "python3.9"
  enable_event_bridge_schedule          = true
  event_bridge_schedule_expression      = "cron(* * * * ? *)" # every minute
  schedule_expression_timezone          = "America/New_York"
  schedule_enable_flexible_time_window  = true
  schedule_flexible_time_window_minutes = 180
  reserved_concurrent_executions        = 1
  environment = {
    "FOO" = "BAR"
  }
}

# Test for possible naming collisions
module "this2" {
  source                           = "../../"
  git                              = "terraform-aws-lambda"
  enabled                          = var.enabled
  name                             = "cloudwatch-event-bridge-to-lambda-trigger-test"
  filename                         = data.archive_file.this.output_path
  source_code_hash                 = data.archive_file.this.output_base64sha256
  handler                          = "app.handler"
  runtime                          = "python3.9"
  enable_event_bridge_schedule     = true
  event_bridge_schedule_expression = "cron(* * * * ? *)" # every minute
  schedule_expression_timezone     = "America/New_York"
  reserved_concurrent_executions   = 1
  environment = {
    "FOO" = "BAR"
  }
}

output "arn" {
  description = "Lambda ARN"
  value       = module.this1.arn
}

output "cloudwatch_log_group" {
  description = "alarm name output"
  value       = module.this1.cloudwatch_log_group
}

output "enabled" {
  description = "module enabled"
  value       = var.enabled
}
