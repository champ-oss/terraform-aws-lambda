moved {
  from = aws_cloudwatch_log_group.this
  to   = aws_cloudwatch_log_group.this[0]
}

moved {
  from = aws_iam_role.this
  to   = aws_iam_role.this[0]
}

moved {
  from = data.aws_iam_policy_document.assume_role
  to   = data.aws_iam_policy_document.assume_role[0]
}

moved {
  from = data.aws_iam_policy_document.this
  to   = data.aws_iam_policy_document.this[0]
}

moved {
  from = aws_iam_policy.this
  to   = aws_iam_policy.this[0]
}

moved {
  from = aws_iam_role_policy_attachment.ssm
  to   = aws_iam_role_policy_attachment.ssm[0]
}

moved {
  from = aws_iam_role_policy_attachment.this
  to   = aws_iam_role_policy_attachment.this[0]
}

moved {
  from = aws_lambda_function.this
  to   = aws_lambda_function.this[0]
}

moved {
  from = aws_lambda_permission.cloudwatch
  to   = aws_lambda_permission.cloudwatch[0]
}

moved {
  from = null_resource.wait_for_ecr
  to   = null_resource.wait_for_ecr[0]
}

moved {
  from = data.aws_region.this
  to   = data.aws_region.this[0]
}

moved {
  from = data.aws_caller_identity.this
  to   = data.aws_caller_identity.this[0]
}

moved {
  from = random_id.this
  to   = random_id.this[0]
}