output "arn" {
  description = "Lambda ARN"
  value       = module.this.arn
}

output "function_url" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url#function_url"
  value       = module.this.function_url
}