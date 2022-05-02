resource "aws_route53_record" "this" {
  count   = var.enable_route53 ? 1 : 0
  name    = var.dns_name
  type    = "A"
  zone_id = var.zone_id

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = false
  }
}