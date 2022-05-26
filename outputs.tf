output "arn" {
  description = "Lambda ARN"
  value       = aws_lambda_function.this.arn
}

output "cloudwatch_log_group" {
  description = "Alarm name output"
  value       = aws_cloudwatch_log_group.this.name
}

output "security_group_id" {
  description = "Security Group ID"
  value       = var.enable_vpc ? aws_security_group.this[0].id : null
}

output "function_url" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url#function_url"
  value       = var.enable_function_url ? aws_lambda_function_url.this[0].function_url : null
}