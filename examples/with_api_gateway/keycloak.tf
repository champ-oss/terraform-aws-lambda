module "acm_keycloak" {
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.111-28fcc7c"
  git               = local.git
  domain_name       = "${local.keycloak_hostname}.${data.aws_route53_zone.this.name}"
  create_wildcard   = false
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = true
}

# Used to test JWT auth with the API Gateway authorizer
module "keycloak" {
  depends_on          = [module.acm_keycloak]
  source              = "github.com/champ-oss/terraform-aws-keycloak.git?ref=v1.0.23-30e273e"
  certificate_arn     = module.acm_keycloak.arn
  public_subnet_ids   = data.aws_subnets.public.ids
  private_subnet_ids  = data.aws_subnets.private.ids
  vpc_id              = data.aws_vpcs.this.ids[0]
  domain              = data.aws_route53_zone.this.name
  zone_id             = data.aws_route53_zone.this.zone_id
  keycloak_hostname   = local.keycloak_hostname
  protect             = false
  skip_final_snapshot = true
  enable_cluster      = false
}

provider "keycloak" {
  client_id     = "admin-cli"
  username      = "admin"
  password      = module.keycloak.keycloak_admin_password
  url           = module.keycloak.keycloak_endpoint
  initial_login = false
}

resource "time_sleep" "this" {
  depends_on      = [module.keycloak]
  create_duration = "60s"
}

data "keycloak_realm" "this" {
  depends_on = [time_sleep.this]
  realm      = "master"
}

data "keycloak_openid_client_scope" "this" {
  realm_id = data.keycloak_realm.this.id
  name     = "profile"
}

# API Gateway expects the "audience" field to be set in the JWT
resource "keycloak_openid_audience_protocol_mapper" "this" {
  realm_id                 = data.keycloak_realm.this.id
  client_scope_id          = data.keycloak_openid_client_scope.this.id
  name                     = "audience"
  included_client_audience = "account"
}