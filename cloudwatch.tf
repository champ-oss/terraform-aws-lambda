resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.git}-${var.name}-${random_id.this.hex}"
  retention_in_days = var.retention_in_days
  tags              = merge(local.tags, var.tags)

  lifecycle {
    ignore_changes = [
      name
    ]
  }
}

resource "aws_cloudwatch_event_rule" "this" {
  count               = var.enable_cw_event ? 1 : 0
  name                = local.name
  description         = "executes event"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "this" {
  count     = var.enable_cw_event ? 1 : 0
  rule      = aws_cloudwatch_event_rule.this[count.index].name
  target_id = "lambda"
  arn       = aws_lambda_function.this.arn
}

resource "aws_lambda_permission" "this" {
  count         = var.enable_cw_event ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this[count.index].arn
}
