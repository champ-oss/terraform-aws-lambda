# For Application Load Balancer
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

# For API Gateway
resource "aws_route53_record" "api_gateway" {
  count   = var.enable_api_gateway ? 1 : 0
  name    = aws_apigatewayv2_domain_name.this.domain_name
  type    = "A"
  zone_id = var.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}