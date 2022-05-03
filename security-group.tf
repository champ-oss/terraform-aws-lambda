resource "aws_security_group" "this" {
  count       = var.enable_vpc ? 1 : 0
  name_prefix = "${var.git}-${var.name}"
  vpc_id      = var.vpc_id
  tags        = merge(local.tags, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "this" {
  count             = var.enable_vpc ? 1 : 0
  description       = "internet"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  security_group_id = aws_security_group.this[0].id
  cidr_blocks       = ["0.0.0.0/0"]
}