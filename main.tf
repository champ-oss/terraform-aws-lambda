data "aws_region" "this" {}

locals {
  tags = {
    git       = var.git
    cost      = "shared"
    creator   = "terraform"
    component = var.name
  }
}

resource "null_resource" "wait_for_ecr" {
  triggers = {
    ecr_account = var.ecr_account
    ecr_name    = var.ecr_name
    ecr_tag     = var.ecr_tag
  }
  provisioner "local-exec" {
    command     = "sh ${path.module}/wait_for_ecr.sh"
    interpreter = ["/bin/sh", "-c"]
    environment = {
      DISABLED    = var.ecr_name == "" || var.disable_wait_for_ecr ? "y" : ""
      RETRIES     = 60
      SLEEP       = 5
      AWS_REGION  = data.aws_region.this.name
      ECR_REPO    = var.ecr_name
      IMAGE_TAG   = var.ecr_tag
      REGISTRY_ID = var.ecr_account
    }
  }
}
