module "ecr" {
  count            = var.sync_image ? 1 : 0
  source           = "github.com/champ-oss/terraform-aws-ecr.git?ref=v1.0.59-a528016"
  name             = var.ecr_name
  sync_image       = true
  sync_source_repo = var.sync_source_repo
  sync_source_tag  = var.ecr_tag
  force_delete     = true
}

module "ecr_cache" {
  count            = var.sync_image ? 1 : 0
  source           = "github.com/champ-oss/terraform-aws-ecr-cache.git?ref=v1.0.3-22096b6"
  name             = local.ecr_name
  sync_source_repo = var.sync_source_repo
  sync_source_tag  = var.ecr_tag
}
