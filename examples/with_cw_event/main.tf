data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/../helper_files"
  output_path = "package.zip"
}

module "this" {
  source                         = "../../"
  git                            = "terraform-aws-lambda"
  name                           = "cloudwatch"
  filename                       = data.archive_file.this.output_path
  source_code_hash               = data.archive_file.this.output_base64sha256
  handler                        = "app.handler"
  runtime                        = "python3.9"
  enable_cw_event                = true
  schedule_expression            = "rate(1 minute)"
  reserved_concurrent_executions = 1
  environment = {
    "FOO" = "BAR"
  }
}

output "arn" {
  description = "Lambda ARN"
  value       = module.this.arn
}

output "cloudwatch_log_group" {
  description = "alarm name output"
  value       = module.this.cloudwatch_log_group
}
