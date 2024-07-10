terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.0.0"
    }
  }
}

module "hash" {
  source   = "github.com/champ-oss/terraform-git-hash.git?ref=v1.0.12-fc3bb87"
  path     = "${path.module}/../.."
  fallback = ""
}

variable "enabled" {
  description = "module enabled"
  type        = bool
  default     = true
}

module "this" {
  source                         = "../../"
  enabled                        = var.enabled
  git                            = "terraform-aws-lambda"
  name                           = "docker-hub"
  sync_image                     = true
  sync_source_repo               = "champtitles/terraform-aws-lambda"
  ecr_tag                        = module.hash.hash
  ecr_name                       = "terraform-aws-lambda/docker-hub" # ECR repo to create and sync to
  reserved_concurrent_executions = 1
  environment = {
    "FOO" = "BAR"
  }
}

output "arn" {
  description = "Lambda ARN"
  value       = module.this.arn
}

output "enabled" {
  description = "module enabled"
  value       = var.enabled
}