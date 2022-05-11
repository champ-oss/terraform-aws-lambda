provider "aws" {
  region = "us-east-1"
}

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/../python"
  output_path = "package.zip"
}

module "this" {
  source           = "../../"
  git              = "terraform-aws-lambda"
  name             = "zip"
  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256
  handler          = "app.handler"
  runtime          = "python3.9"
  environment = {
    "FOO" = "BAR"
  }
}
