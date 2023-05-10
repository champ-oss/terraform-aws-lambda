output "arn" {
  description = "Lambda ARN"
  value       = module.this.arn
}

output "domain_name" {
  description = "domain name"
  value       = local.domain_name
}