data "aws_iam_policy_document" "eventbridge" {
  count = var.enable_event_bridge_schedule && var.enabled ? 1 : 0
  statement {
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      aws_lambda_function.this[0].arn
    ]
  }
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

data "aws_iam_policy_document" "assume_role_eventbridge" {
  count = var.enable_event_bridge_schedule && var.enabled ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["scheduler.amazonaws.com"]
      type        = "Service"
    }
  }
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
