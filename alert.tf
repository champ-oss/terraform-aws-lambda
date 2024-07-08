module "alert" {
  source         = "github.com/champ-oss/terraform-aws-alert.git?ref=d345d897de350e12a7545cb4061ab1901d31fbc2"
  git            = var.git
  log_group_name = try(aws_cloudwatch_log_group.this[0].name, "")
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
