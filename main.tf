data "aws_region" "this" {}
data "aws_caller_identity" "this" {}

locals {
  trimmed_name = substr("${var.git}-${var.name}", 0, 56)
  name         = "${local.trimmed_name}-${random_id.this.hex}" # 64 characters max length

  tags = {
    git       = var.git
    cost      = "shared"
    creator   = "terraform"
    component = var.name
  }
}

resource "random_id" "this" {
  byte_length = 3
}

resource "null_resource" "wait_for_ecr" {
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
      AWS_REGION  = data.aws_region.this.name
      ECR_REPO    = local.ecr_name
      IMAGE_TAG   = var.ecr_tag
      REGISTRY_ID = local.ecr_account
    }
  }
}
