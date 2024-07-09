data "aws_region" "this" {
  count = var.enabled ? 1 : 0
}

moved {
  from = data.aws_region.this
  to   = data.aws_region.this[0]
}
data "aws_caller_identity" "this" {
  count = var.enabled ? 1 : 0
}

moved {
  from = data.aws_caller_identity.this
  to   = data.aws_caller_identity.this[0]
}

locals {
  trimmed_name = substr("${var.git}-${var.name}", 0, 56)
  name         = try("${local.trimmed_name}-${random_id.this[0].hex}", "") # 64 characters max length

  tags = {
    git       = var.git
    cost      = "shared"
    creator   = "terraform"
    component = var.name
  }
}

resource "random_id" "this" {
  count       = var.enabled ? 1 : 0
  byte_length = 3
}

moved {
  from = random_id.this
  to   = random_id.this[0]
}

resource "null_resource" "wait_for_ecr" {
  count = var.enabled ? 1 : 0
  triggers = {
    ecr_account = local.ecr_account
    ecr_name    = local.ecr_name
    ecr_tag     = var.ecr_tag
  }
  provisioner "local-exec" {
    command     = "sh ${path.module}/wait_for_ecr.sh"
    interpreter = ["/bin/sh", "-c"]
    environment = {
      DISABLED    = local.ecr_name == "" || var.disable_wait_for_ecr ? "y" : ""
      RETRIES     = 60
      SLEEP       = 10
      AWS_REGION  = data.aws_region.this[0].name
      ECR_REPO    = local.ecr_name
      IMAGE_TAG   = var.ecr_tag
      REGISTRY_ID = local.ecr_account
    }
  }
}

moved {
  from = null_resource.wait_for_ecr
  to   = null_resource.wait_for_ecr[0]
}
