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