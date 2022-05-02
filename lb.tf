resource "aws_lb_target_group" "this" {
  count                = var.enable_load_balancer ? 1 : 0
  target_type          = "lambda"
  deregistration_delay = var.deregistration_delay
  tags                 = merge(local.tags, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "main" {
  count            = var.enable_load_balancer ? 1 : 0
  target_group_arn = aws_lb_target_group.this[0].arn
  target_id        = aws_lambda_function.this.arn
  depends_on       = [aws_lambda_permission.lb[0]]
}

resource "aws_lb_listener_rule" "this" {
  count        = var.enable_load_balancer ? 1 : 0
  depends_on   = [aws_lb_target_group.this]
  listener_arn = var.listener_arn
  tags         = merge(local.tags, var.tags)

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[0].arn
  }

  condition {
    host_header {
      values = [var.dns_name]
    }
  }
}
