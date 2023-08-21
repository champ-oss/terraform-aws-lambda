module "hash" {
  source   = "github.com/champ-oss/terraform-git-hash.git?ref=v1.0.12-fc3bb87"
  path     = "${path.module}/../.."
  fallback = ""
}

module "this" {
  source                         = "../../"
  git                            = "terraform-aws-lambda"
  name                           = "ecr"
  ecr_name                       = "terraform-aws-lambda"
  ecr_tag                        = module.hash.hash
  reserved_concurrent_executions = 1
  image_config_command           = ["app.handler"]
  environment = {
    "FOO" = "BAR"
  }
}

output "arn" {
  description = "Lambda ARN"
  value       = module.this.arn
}