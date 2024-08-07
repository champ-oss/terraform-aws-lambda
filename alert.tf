module "alert" {
  count          = var.enable_logging_alerts ? 1 : 0
  source         = "github.com/champ-oss/terraform-aws-alert.git?ref=v1.0.152-785932e"
  git            = var.git
  log_group_name = try(aws_cloudwatch_log_group.this[0].name, "")
  name           = "${var.name}-alert"
  filter_pattern = var.alert_filter_pattern
  slack_url      = var.alert_slack_url
  region         = var.alert_region
  enabled        = var.enabled
}
