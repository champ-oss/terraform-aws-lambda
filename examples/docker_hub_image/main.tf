provider "aws" {
  region = "us-east-1"
}

locals {
  git = "terraform-aws-lambda"
}


module "this" {
  source                         = "../../"
  git                            = "terraform-aws-lambda"
  name                           = "docker-hub"
  sync_image                     = true
  sync_source_repo               = "champtitles/terraform-aws-lambda"
  ecr_tag                        = var.ecr_tag                       # will get set at runtime by Terratest as GITHUB_SHA
  ecr_name                       = "terraform-aws-lambda/docker-hub" # ECR repo to create and sync to
  reserved_concurrent_executions = 1
  kms_key_arn                    = module.kms.arn
  environment = {
    "FOO"  = "BAR",
    "FOO2" = data.aws_kms_ciphertext.this.ciphertext_blob
  }
}

# only used to encrypt and decrypt lambda env variables
module "kms" {
  source          = "github.com/champ-oss/terraform-aws-kms.git?ref=v1.0.30-44f94bf"
  git             = local.git
  name            = "alias/${local.git}-lambda"
  account_actions = []
}

data "aws_kms_ciphertext" "this" {
  key_id    = module.kms.key_id
  plaintext = "BAR2"
}

resource "aws_iam_policy" "kms_env_vars" {
  name_prefix = "${local.git}-kms-env-vars"
  policy      = data.aws_iam_policy_document.kms_env_vars.json
}

resource "aws_iam_role_policy_attachment" "kms_env_vars" {
  role       = module.this.role_name
  policy_arn = aws_iam_policy.kms_env_vars.arn
}

data "aws_iam_policy_document" "kms_env_vars" {
  statement {
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:DescribeKey",
      "kms:ListKeys",
      "kms:GenerateDataKey",
    ]

    resources = [
      module.kms.arn,
    ]
  }
}