provider "aws" {
  region = "us-east-1"
}

locals {
  git = "terraform-aws-lambda"
}

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/../python-encrypt"
  output_path = "package.zip"
}

module "this" {
  source                         = "../../"
  git                            = "terraform-aws-lambda"
  name                           = "zip"
  filename                       = data.archive_file.this.output_path
  source_code_hash               = data.archive_file.this.output_base64sha256
  handler                        = "app.handler"
  runtime                        = "python3.9"
  reserved_concurrent_executions = 1
  environment = {
    "FOO"  = "BAR"
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
  lifecycle {
    ignore_changes        = []
  }
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

