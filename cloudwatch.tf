resource "time_sleep" "wait_cloudwatch_logs" {
  depends_on       = [aws_cloudwatch_log_group.this]
  destroy_duration = var.cloudwatch_destroy_wait
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.git}-${var.name}"
  retention_in_days = var.retention_in_days
  tags              = merge(local.tags, var.tags)
}

resource "aws_cloudwatch_event_rule" "this" {
  count               = var.cw_schedule_expression != null ? 1 : 0
  name_prefix         = "${var.git}-${var.name}"
  description         = "executes event"
  schedule_expression = var.cw_schedule_expression
}

resource "aws_cloudwatch_event_target" "this" {
  count     = var.cw_schedule_expression != null ? 1 : 0
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "lambda"
  arn       = aws_lambda_function.this.arn
}

resource "aws_lambda_permission" "this" {
  count         = var.cw_schedule_expression != null ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this.arn
}
