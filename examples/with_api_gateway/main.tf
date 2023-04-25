terraform {
  backend "s3" {}
}

provider "aws" {
  region = "us-east-2"
}

locals {
  git = "terraform-aws-alb"
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

data "aws_vpcs" "this" {
  tags = {
    purpose = "vega"
  }
}

data "aws_subnets" "private" {
  tags = {
    purpose = "vega"
    Type    = "Private"
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
}

data "aws_subnets" "public" {
  tags = {
    purpose = "vega"
    Type    = "Public"
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
}

module "acm" {
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.1-1cb7679"
  git               = local.git
  domain_name       = data.aws_route53_zone.this.name
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = true
}

module "hash" {
  source   = "github.com/champ-oss/terraform-git-hash.git?ref=v1.0.12-fc3bb87"
  path     = "${path.module}/../.."
  fallback = ""
}

# Used for JWT auth
module "keycloak" {
  source              = "github.com/champ-oss/terraform-aws-keycloak.git?ref=v1.0.23-30e273e"
  certificate_arn     = module.acm.arn
  public_subnet_ids   = data.aws_subnets.public.ids
  private_subnet_ids  = data.aws_subnets.private.ids
  vpc_id              = data.aws_vpcs.this.ids[0]
  domain              = data.aws_route53_zone.this.name
  zone_id             = data.aws_route53_zone.this.zone_id
  protect             = false
  skip_final_snapshot = true
  enable_cluster      = false
}

module "this" {
  source                         = "../../"
  git                            = "terraform-aws-lambda"
  name                           = "api-gateway"
  reserved_concurrent_executions = 1
  enable_api_gateway             = true
  api_gateway_dns_name           = "terraform-aws-lambda-apigw.oss.champtest.net"
  api_gateway_jwt_issuer         = "${module.keycloak.keycloak_endpoint}/realms/master"
  api_gateway_certificate_arn    = module.acm.arn
  zone_id                        = data.aws_route53_zone.this.zone_id
  ecr_account                    = "912455136424"
  ecr_name                       = "terraform-aws-lambda"
  ecr_tag                        = module.hash.hash

  environment = {
    "FOO" = "BAR"
  }
}
