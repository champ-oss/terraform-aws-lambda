output "arn" {
  description = "Lambda ARN"
  value       = module.this.arn
}

output "domain_name" {
  description = "domain name"
  value       = local.domain_name
}

output "api_key_value" {
  description = "Generated API Key to use for requests"
  sensitive   = true
  value       = module.api_gateway.api_key_value
}