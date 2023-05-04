output "arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#arn"
  value       = aws_lambda_function.this.arn
}

output "invoke_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#invoke_arn"
  value       = aws_lambda_function.this.invoke_arn
}

output "function_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#function_name"
  value       = aws_lambda_function.this.function_name
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

output "role_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#name"
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#arn"
  value       = aws_iam_role.this.arn
}
