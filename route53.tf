resource "aws_route53_record" "this" {
  count   = var.enable_route53 && var.enable_load_balancer ? 1 : 0
  name    = var.dns_name
  type    = "A"
  zone_id = var.zone_id

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "function_url" {
  count   = var.enable_route53 && var.enable_function_url ? 1 : 0
  name    = var.dns_name
  type    = "CNAME"
  zone_id = var.zone_id
  records = [aws_lambda_function_url.this[0].function_url]
}
