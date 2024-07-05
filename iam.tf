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

moved {
  from = aws_iam_role.this
  to   = aws_iam_role.this[0]
}

data "aws_iam_policy_document" "assume_role" {
  count = var.enabled ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

moved {
  from = data.aws_iam_policy_document.assume_role
  to   = data.aws_iam_policy_document.assume_role[0]
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

moved {
  from = aws_iam_role_policy_attachment.ssm
  to   = aws_iam_role_policy_attachment.ssm[0]
}

data "aws_iam_policy_document" "this" {
  count = var.enabled ? 1 : 0
  statement {
    actions = [
      # "logs:CreateLogGroup", # Dont allow log group creation since we manage that with Terraform
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses"
    ]
    resources = ["*"]
  }
}

moved {
  from = data.aws_iam_policy_document.this
  to   = data.aws_iam_policy_document.this[0]
}

resource "aws_iam_policy" "this" {
  count       = var.enabled ? 1 : 0
  name_prefix = var.git
  policy      = data.aws_iam_policy_document.this[0].json
}

moved {
  from = aws_iam_policy.this
  to   = aws_iam_policy.this[0]
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = var.enabled ? 1 : 0
  policy_arn = aws_iam_policy.this[0].arn
  role       = aws_iam_role.this[0].name
}

moved {
  from = aws_iam_role_policy_attachment.this
  to   = aws_iam_role_policy_attachment.this[0]
}

resource "aws_iam_role_policy_attachment" "external" {
  count      = var.enable_custom_iam_policy && var.enabled ? 1 : 0
  policy_arn = var.custom_iam_policy_arn
  role       = aws_iam_role.this[0].name
}