module "alert" {
  source         = "github.com/champ-oss/terraform-aws-alert.git?ref=31dd996bf5e1f435042b655a9facbae5d9d0d4d1"
  git            = var.git
  log_group_name = aws_cloudwatch_log_group.this[0].name
  name           = "${var.name}-alert"
  filter_pattern = var.alert_filter_pattern
  slack_url      = var.alert_slack_url
  region         = var.alert_region
  enabled        = var.enable_logging_alerts
}

moved {
  from = module.alert[0]
  to   = module.alert
}
