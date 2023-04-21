# only used to encrypt and decrypt lambda env variables
module "kms" {
  source          = "github.com/champ-oss/terraform-aws-kms.git?ref=v1.0.30-44f94bf"
  git             = var.git
  name            = "alias/${var.git}-lambda"
  account_actions = []
}