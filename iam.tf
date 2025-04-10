# tflint-ignore: terraform_comment_syntax
//noinspection ConflictingProperties
resource "aws_iam_role" "this" {
  count              = var.enabled ? 1 : 0
  name               = var.enable_iam_role_name_prefix ? null : local.trimmed_name
  name_prefix        = var.enable_iam_role_name_prefix ? var.git : null
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json
  tags               = merge(local.tags, var.tags)

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_iam_role" "eventbridge" {
  count              = var.enable_event_bridge_schedule && var.enabled ? 1 : 0
  name_prefix        = substr(local.name, 0, 38) # Max length is 38
  assume_role_policy = data.aws_iam_policy_document.assume_role_eventbridge[0].json
  tags               = merge(local.tags, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_policy" "this" {
  count       = var.enabled ? 1 : 0
  name_prefix = var.git
  policy      = data.aws_iam_policy_document.this[0].json
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = var.enabled ? 1 : 0
  policy_arn = aws_iam_policy.this[0].arn
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_role_policy_attachment" "external" {
  count      = var.enable_custom_iam_policy && var.enabled ? 1 : 0
  policy_arn = var.custom_iam_policy_arn
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_role_policy_attachment" "eventbridge" {
  count      = var.enable_event_bridge_schedule && var.enabled ? 1 : 0
  policy_arn = aws_iam_policy.eventbridge[0].arn
  role       = aws_iam_role.eventbridge[0].name
}

resource "aws_iam_policy" "eventbridge" {
  count       = var.enable_event_bridge_schedule && var.enabled ? 1 : 0
  name_prefix = var.git
  policy      = data.aws_iam_policy_document.eventbridge[0].json
}
