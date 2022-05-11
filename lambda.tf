locals {
  image_uri = "${var.ecr_account}.dkr.ecr.${data.aws_region.this.name}.amazonaws.com/${var.ecr_name}:${var.ecr_tag}"
}

# tflint-ignore: terraform_comment_syntax
//noinspection ConflictingProperties
resource "aws_lambda_function" "this" {
  depends_on       = [null_resource.wait_for_ecr, time_sleep.wait_cloudwatch_logs]
  function_name    = "${var.git}-${var.name}"
  role             = aws_iam_role.this.arn
  package_type     = var.ecr_name != "" ? "Image" : "Zip"
  image_uri        = var.ecr_name != "" ? local.image_uri : null
  filename         = var.filename != "" ? var.filename : null
  handler          = var.handler != "" ? var.handler : null
  source_code_hash = var.source_code_hash != "" ? var.source_code_hash : null
  runtime          = var.runtime != "" ? var.runtime : null
  memory_size      = var.memory_size
  timeout          = var.timeout
  tags             = merge(local.tags, var.tags)

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
