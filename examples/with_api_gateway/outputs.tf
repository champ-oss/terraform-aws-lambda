output "keycloak_endpoint" {
  description = "keycloak endpoint url"
  value       = module.keycloak.keycloak_endpoint
}

output "keycloak_admin_password" {
  description = "keycloak admin pw"
  value       = module.keycloak.keycloak_admin_password
  sensitive   = true
}