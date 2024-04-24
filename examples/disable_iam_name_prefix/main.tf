terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.0.0"
    }
  }
}

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/../../test/helper_files"
  output_path = "package.zip"
}

module "this" {
  source                         = "../../"
  git                            = "terraform-aws-lambda"
  name                           = "disable-iam-name-prefix"
  filename                       = data.archive_file.this.output_path
  source_code_hash               = data.archive_file.this.output_base64sha256
  handler                        = "app.handler"
  runtime                        = "python3.9"
  reserved_concurrent_executions = 1
  enable_iam_role_name_prefix    = false # disable randomly generated name
}

check "function_name" {
  assert {
    condition     = module.this.function_name == "terraform-aws-lambda-disable-iam-name-prefix"
    error_message = "Name of function is not as expected"
  }
}

check "role_arn" {
  assert {
    condition     = module.this.role_arn == "role/terraform-aws-lambda-disable-iam-name-prefix"
    error_message = "Role ARN is not as expected"
  }
}