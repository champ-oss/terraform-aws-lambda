terraform {
  backend "s3" {}
  required_providers {
    keycloak = {
      source = "mrparkers/keycloak"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

locals {
  git               = "terraform-aws-alb"
  keycloak_hostname = "terraform-aws-lambda-apigw-kc"
  hostname          = "terraform-aws-lambda-apigw"
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

module "hash" {
  source   = "github.com/champ-oss/terraform-git-hash.git?ref=v1.0.12-fc3bb87"
  path     = "${path.module}/../.."
  fallback = ""
}

module "acm" {
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.111-28fcc7c"
  git               = local.git
  domain_name       = "${local.hostname}.${data.aws_route53_zone.this.name}"
  create_wildcard   = false
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = true
}

module "this" {
  depends_on                     = [module.keycloak, module.acm, time_sleep.this]
  source                         = "../../"
  git                            = "terraform-aws-lambda"
  name                           = "api-gateway"
  reserved_concurrent_executions = 1
  enable_api_gateway             = true
  api_gateway_dns_name           = "${local.hostname}.${data.aws_route53_zone.this.name}"
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
