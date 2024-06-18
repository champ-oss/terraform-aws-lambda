locals {
  ecr_account = var.ecr_account != "" ? var.ecr_account : data.aws_caller_identity.this.account_id
  ecr_name    = var.sync_image ? "${var.ecr_name}-cache" : var.ecr_name
  image_uri   = "${local.ecr_account}.dkr.ecr.${data.aws_region.this.name}.amazonaws.com/${local.ecr_name}:${var.ecr_tag}"
}

# tflint-ignore: terraform_comment_syntax
//noinspection ConflictingProperties
resource "aws_lambda_function" "this" {
  depends_on                     = [null_resource.wait_for_ecr]
  function_name                  = local.name
  role                           = aws_iam_role.this.arn
  package_type                   = local.ecr_name != "" ? "Image" : "Zip"
  image_uri                      = local.ecr_name != "" ? local.image_uri : null
  filename                       = var.filename != "" ? var.filename : null
  handler                        = var.handler != "" ? var.handler : null
  source_code_hash               = var.source_code_hash != "" ? var.source_code_hash : null
  runtime                        = var.runtime != "" ? var.runtime : null
  memory_size                    = var.memory_size
  timeout                        = var.timeout
  description                    = var.description
  reserved_concurrent_executions = var.reserved_concurrent_executions
  tags                           = merge(local.tags, var.tags)

  dynamic "environment" {
    for_each = length(keys(var.environment)) > 0 ? [1] : []
    content {
      variables = var.environment
    }
  }

  dynamic "vpc_config" {
    for_each = var.enable_vpc ? [1] : []
    content {
      security_group_ids = [aws_security_group.this[0].id]
      subnet_ids         = var.private_subnet_ids
    }
  }

  dynamic "image_config" {
    for_each = var.image_config_command != null || var.image_config_entry_point != null || var.image_config_working_directory != null ? [
      1
    ] : []
    content {
      command           = var.image_config_command
      entry_point       = var.image_config_entry_point
      working_directory = var.image_config_working_directory
    }
  }

  lifecycle {
    ignore_changes = [
      filename,
      function_name,
      last_modified
    ]
  }
}

resource "aws_lambda_permission" "lb" {
  count         = var.enable_load_balancer ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.this[0].arn
}

resource "aws_lambda_permission" "cloudwatch" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "logs.${data.aws_region.this.name}.amazonaws.com"
}

resource "aws_lambda_permission" "api_gateway_v1" {
  count         = var.enable_api_gateway_v1 ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:${var.api_gateway_v1_rest_api_id}/*/${aws_api_gateway_method.this[0].http_method}${local.api_gateway_v1_resource_path}"
}

data "aws_organizations_organization" "this" {
  count = var.enable_org_access ? 1 : 0
}

resource "aws_lambda_permission" "api_gateway_v1" {
  count            = var.enable_org_access ? 1 : 0
  action           = "lambda:InvokeFunction"
  function_name    = aws_lambda_function.this.arn
  principal        = "*"
  principal_org_id = data.aws_organizations_organization.this.id
}
