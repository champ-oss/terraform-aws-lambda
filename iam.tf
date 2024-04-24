# tflint-ignore: terraform_comment_syntax
//noinspection ConflictingProperties
resource "aws_iam_role" "this" {
  name               = var.enable_iam_role_name_prefix ? null : local.trimmed_name
  name_prefix        = var.enable_iam_role_name_prefix ? var.git : null
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = merge(local.tags, var.tags)

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

data "aws_iam_policy_document" "this" {
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

resource "aws_iam_policy" "this" {
  name_prefix = var.git
  policy      = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "external" {
  count      = var.enable_custom_iam_policy ? 1 : 0
  policy_arn = var.custom_iam_policy_arn
  role       = aws_iam_role.this.name
}