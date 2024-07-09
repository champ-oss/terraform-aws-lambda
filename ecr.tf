module "ecr_cache" {
  count            = var.sync_image ? 1 : 0
  source           = "github.com/champ-oss/terraform-aws-ecr-cache.git?ref=v1.0.17-b7b8e9a"
  name             = local.ecr_name
  sync_source_repo = var.sync_source_repo
  sync_source_tag  = var.ecr_tag
  enabled          = var.enabled
}
