resource "time_sleep" "wait_cloudwatch_logs" {
  depends_on       = [aws_cloudwatch_log_group.this]
  destroy_duration = var.cloudwatch_destroy_wait
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.git}-${var.name}"
  retention_in_days = var.retention_in_days
  tags              = merge(local.tags, var.tags)
}