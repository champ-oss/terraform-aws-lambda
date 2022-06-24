module "ecr" {
  count            = var.sync_image ? 1 : 0
  source           = "github.com/champ-oss/terraform-aws-ecr.git?ref=v1.0.44-f6939ec"
  name             = var.ecr_name
  sync_image       = true
  sync_source_repo = var.sync_source_repo
  sync_source_tag  = var.ecr_tag
}
