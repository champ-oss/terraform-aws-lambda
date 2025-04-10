resource "aws_scheduler_schedule" "this" {
  count       = var.enable_event_bridge_schedule && var.enabled ? 1 : 0
  name        = local.name
  description = var.description

  flexible_time_window {
    mode                      = var.schedule_enable_flexible_time_window ? "FLEXIBLE" : "OFF"
    maximum_window_in_minutes = var.schedule_flexible_time_window_minutes
  }

  state                        = "ENABLED"
  schedule_expression          = var.event_bridge_schedule_expression
  schedule_expression_timezone = var.schedule_expression_timezone

  target {
    arn      = aws_lambda_function.this[0].arn
    role_arn = aws_iam_role.eventbridge[0].arn
  }
}
