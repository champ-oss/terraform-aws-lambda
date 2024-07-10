output "arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#arn"
  value       = var.enabled ? aws_lambda_function.this[0].arn : ""
}

output "function_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#function_name"
  value       = var.enabled ? aws_lambda_function.this[0].function_name : ""
}

output "cloudwatch_log_group" {
  description = "Alarm name output"
  value       = var.enabled ? aws_cloudwatch_log_group.this[0].name : ""
}

output "security_group_id" {
  description = "Security Group ID"
  value       = var.enable_vpc && var.enabled ? aws_security_group.this[0].id : null
}

output "function_url" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url#function_url"
  value       = var.enable_function_url && var.enabled ? aws_lambda_function_url.this[0].function_url : null
}

output "role_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#name"
  value       = var.enabled ? aws_iam_role.this[0].name : ""
}

output "role_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#arn"
  value       = var.enabled ? aws_iam_role.this[0].arn : ""
}

output "api_gateway_v1_resource_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource#id"
  value       = var.enable_api_gateway_v1 && var.create_api_gateway_v1_resource && var.enabled ? aws_api_gateway_resource.this[0].id : null
}

output "api_gateway_v1_method_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method"
  value       = var.enable_api_gateway_v1 && var.enabled ? aws_api_gateway_method.this[0].id : null
}

output "api_gateway_v1_integration_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration"
  value       = var.enable_api_gateway_v1 && var.enabled ? aws_api_gateway_integration.this[0].id : null
}