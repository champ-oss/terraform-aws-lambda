resource "aws_apigatewayv2_api" "this" {
  count         = var.enable_api_gateway ? 1 : 0
  name          = "${var.git}-${var.name}"
  protocol_type = "HTTP"
  tags          = merge(local.tags, var.tags)
}

resource "aws_apigatewayv2_route" "this" {
  count              = var.enable_api_gateway ? 1 : 0
  api_id             = aws_apigatewayv2_api.this[0].id
  route_key          = "$default"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.this[0].id
  target             = "integrations/${aws_apigatewayv2_integration.this[0].id}"
}

resource "aws_apigatewayv2_authorizer" "this" {
  count            = var.enable_api_gateway ? 1 : 0
  api_id           = aws_apigatewayv2_api.this[0].id
  authorizer_type  = "JWT"
  identity_sources = var.api_gateway_identity_sources
  name             = "${var.git}-${var.name}"

  jwt_configuration {
    audience = var.api_gateway_jwt_audience
    issuer   = var.api_gateway_jwt_issuer
  }
}

resource "aws_apigatewayv2_integration" "this" {
  count              = var.enable_api_gateway ? 1 : 0
  api_id             = aws_apigatewayv2_api.this[0].id
  integration_type   = "HTTP_PROXY"
  integration_method = var.api_gateway_integration_method
  integration_uri    = aws_lambda_function.this.invoke_arn
  connection_type    = "INTERNET"

  tls_config {
    server_name_to_verify = var.api_gateway_dns_name
  }

  request_parameters = {
    "overwrite:header.host" = var.api_gateway_dns_name
  }
}

resource "aws_apigatewayv2_stage" "this" {
  count       = var.enable_api_gateway ? 1 : 0
  api_id      = aws_apigatewayv2_api.this[0].id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_domain_name" "this" {
  count       = var.enable_api_gateway ? 1 : 0
  domain_name = var.api_gateway_dns_name
  tags        = merge(local.tags, var.tags)

  domain_name_configuration {
    certificate_arn = var.api_gateway_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "this" {
  count       = var.enable_api_gateway ? 1 : 0
  api_id      = aws_apigatewayv2_api.this[0].id
  domain_name = aws_apigatewayv2_domain_name.this[0].id
  stage       = aws_apigatewayv2_stage.this[0].id
}

