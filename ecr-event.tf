locals {
  enable_update_on_ecr_push = var.enable_update_function_on_ecr_push && var.enabled && local.ecr_name != ""
}

# ECR push events are only delivered in the account that owns the repository
resource "aws_cloudwatch_event_rule" "ecr_push" {
  count       = local.enable_update_on_ecr_push ? 1 : 0
  name_prefix = substr(local.name, 0, 38) # Max length is 38
  description = "Update ${local.name} when ${local.ecr_name}:${var.ecr_tag} is pushed"
  tags        = merge(local.tags, var.tags)

  event_pattern = jsonencode({
    source      = ["aws.ecr"]
    detail-type = ["ECR Image Action"]
    detail = {
      action-type     = ["PUSH"]
      result          = ["SUCCESS"]
      repository-name = [local.ecr_name]
      image-tag       = [var.ecr_tag]
    }
  })
}

resource "aws_cloudwatch_event_target" "ecr_push" {
  count     = local.enable_update_on_ecr_push ? 1 : 0
  rule      = aws_cloudwatch_event_rule.ecr_push[0].name
  target_id = "update-function-code"
  arn       = aws_sfn_state_machine.ecr_push[0].arn
  role_arn  = aws_iam_role.ecr_push_events[0].arn
}

resource "aws_sfn_state_machine" "ecr_push" {
  count    = local.enable_update_on_ecr_push ? 1 : 0
  name     = local.name
  role_arn = aws_iam_role.ecr_push_sfn[0].arn
  tags     = merge(local.tags, var.tags)

  definition = jsonencode({
    Comment = "Update ${local.name} to the latest ${local.ecr_name}:${var.ecr_tag} image"
    StartAt = "UpdateFunctionCode"
    States = {
      UpdateFunctionCode = {
        Type     = "Task"
        Resource = "arn:aws:states:::aws-sdk:lambda:updateFunctionCode"
        Parameters = {
          FunctionName = aws_lambda_function.this[0].function_name
          ImageUri     = local.image_uri
          Publish      = var.publish
        }
        End = true
      }
    }
  })
}

resource "aws_iam_role" "ecr_push_events" {
  count              = local.enable_update_on_ecr_push ? 1 : 0
  name_prefix        = substr(local.name, 0, 38) # Max length is 38
  assume_role_policy = data.aws_iam_policy_document.assume_role_ecr_push_events[0].json
  tags               = merge(local.tags, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "ecr_push_events" {
  count  = local.enable_update_on_ecr_push ? 1 : 0
  role   = aws_iam_role.ecr_push_events[0].name
  policy = data.aws_iam_policy_document.ecr_push_events[0].json
}

resource "aws_iam_role" "ecr_push_sfn" {
  count              = local.enable_update_on_ecr_push ? 1 : 0
  name_prefix        = substr(local.name, 0, 38) # Max length is 38
  assume_role_policy = data.aws_iam_policy_document.assume_role_ecr_push_sfn[0].json
  tags               = merge(local.tags, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "ecr_push_sfn" {
  count  = local.enable_update_on_ecr_push ? 1 : 0
  role   = aws_iam_role.ecr_push_sfn[0].name
  policy = data.aws_iam_policy_document.ecr_push_sfn[0].json
}

data "aws_iam_policy_document" "assume_role_ecr_push_events" {
  count = local.enable_update_on_ecr_push ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["events.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "ecr_push_events" {
  count = local.enable_update_on_ecr_push ? 1 : 0
  statement {
    actions   = ["states:StartExecution"]
    resources = [aws_sfn_state_machine.ecr_push[0].arn]
  }
}

data "aws_iam_policy_document" "assume_role_ecr_push_sfn" {
  count = local.enable_update_on_ecr_push ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["states.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "ecr_push_sfn" {
  count = local.enable_update_on_ecr_push ? 1 : 0
  statement {
    actions   = ["lambda:UpdateFunctionCode"]
    resources = [aws_lambda_function.this[0].arn]
  }

  # Required by Lambda to pull the image on behalf of the caller
  statement {
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:SetRepositoryPolicy"
    ]
    resources = [
      "arn:aws:ecr:${data.aws_region.this[0].name}:${local.ecr_account}:repository/${local.ecr_name}"
    ]
  }
}
