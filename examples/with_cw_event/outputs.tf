output "arn" {
  description = "Lambda ARN"
  value       = module.this.arn
}

output "cloudwatch_log_group" {
  description = "alarm name output"
  value       = module.this.cloudwatch_log_group
}
