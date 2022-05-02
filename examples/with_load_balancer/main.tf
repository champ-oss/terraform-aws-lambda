provider "aws" {
  region = "us-east-1"
}

locals {
  git = "terraform-aws-alb"
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

module "vpc" {
  source                   = "github.com/champ-oss/terraform-aws-vpc.git?ref=v1.0.1-afc8890"
  git                      = local.git
  availability_zones_count = 2
  retention_in_days        = 1
}

module "acm" {
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.1-1cb7679"
  git               = local.git
  domain_name       = data.aws_route53_zone.this.name
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = true
}

module "alb" {
  source          = "github.com/champ-oss/terraform-aws-alb.git?ref=dfa6af4a7490ad56c85548e2364be4ea3e72b3d4"
  git             = local.git
  certificate_arn = module.acm.arn
  subnet_ids      = module.vpc.public_subnets_ids
  vpc_id          = module.vpc.vpc_id
  internal        = false
  protect         = false
}

module "this" {
  source             = "../../"
  git                = "terraform-aws-lambda"
  name               = "load-balancer"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets_ids
  zone_id            = data.aws_route53_zone.this.zone_id

  # Make the lambda public by attaching to the ALB
  listener_arn         = module.alb.listener_arn
  lb_dns_name          = module.alb.dns_name
  lb_zone_id           = module.alb.zone_id
  enable_load_balancer = true
  enable_route53       = true
  enable_vpc           = false

  dns_name    = "terraform-aws-lambda.oss.champtest.net"
  ecr_account = "912455136424"
  ecr_name    = "terraform-aws-lambda"
  ecr_tag     = var.ecr_tag # will get set at runtime by Terratest as GITHUB_SHA

  environment = {
    "FOO" = "BAR"
  }
}