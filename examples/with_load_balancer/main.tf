locals {
  git         = "terraform-aws-lambda-${random_id.this.hex}"
  domain_name = "${local.git}.${data.aws_route53_zone.this.name}"
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

data "aws_vpcs" "this" {
  tags = {
    purpose = "vega"
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

resource "random_id" "this" {
  byte_length = 2
}

module "acm" {
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.114-1c756c3"
  git               = local.git
  domain_name       = local.domain_name
  create_wildcard   = false
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = true
}

module "alb" {
  source          = "github.com/champ-oss/terraform-aws-alb.git?ref=v1.0.183-1946a45"
  git             = local.git
  certificate_arn = module.acm.arn
  subnet_ids      = data.aws_subnets.public.ids
  vpc_id          = data.aws_vpcs.this.ids[0]
  internal        = false
  protect         = false
}

module "hash" {
  source   = "github.com/champ-oss/terraform-git-hash.git?ref=v1.0.12-fc3bb87"
  path     = "${path.module}/../.."
  fallback = ""
}

module "this" {
  source                         = "../../"
  git                            = local.git
  name                           = "alb-test"
  vpc_id                         = data.aws_vpcs.this.ids[0]
  private_subnet_ids             = data.aws_subnets.private.ids
  zone_id                        = data.aws_route53_zone.this.zone_id
  reserved_concurrent_executions = 1

  # Make the lambda public by attaching to the ALB
  listener_arn         = module.alb.listener_arn
  lb_dns_name          = module.alb.dns_name
  lb_zone_id           = module.alb.zone_id
  enable_load_balancer = true
  enable_route53       = true
  enable_vpc           = false

  dns_name    = local.domain_name
  ecr_account = "912455136424"
  ecr_name    = "terraform-aws-lambda"
  ecr_tag     = module.hash.hash

  environment = {
    "FOO" = "BAR"
  }
}

output "arn" {
  description = "Lambda ARN"
  value       = module.this.arn
}

output "url" {
  description = "url of API Gateway endpoint"
  value       = "https://${local.domain_name}"
}