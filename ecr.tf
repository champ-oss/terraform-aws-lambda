module "ecr_cache" {
  count            = var.sync_image ? 1 : 0
  source           = "github.com/champ-oss/terraform-aws-ecr-cache.git?ref=v1.0.14-8c7b3b7"
  name             = local.ecr_name
  sync_source_repo = var.sync_source_repo
  sync_source_tag  = var.ecr_tag

  lifecycle {
    ignore_changes = [
      name
    ]
  }
}
