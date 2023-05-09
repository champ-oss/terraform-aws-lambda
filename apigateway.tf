resource "aws_api_gateway_resource" "this" {
  count       = var.enable_api_gateway_v1 ? 1 : 0
  rest_api_id = var.api_gateway_v1_rest_api_id
  parent_id   = var.api_gateway_v1_parent_resource_id
  path_part   = var.api_gateway_v1_path_part
}

resource "aws_api_gateway_method" "this" {
  count         = var.enable_api_gateway_v1 ? 1 : 0
  rest_api_id   = var.api_gateway_v1_rest_api_id
  resource_id   = aws_api_gateway_resource.this[0].id
  http_method   = var.api_gateway_v1_http_method
  authorization = "NONE" # NOSONAR uses authentication from API Gateway root
}

resource "aws_api_gateway_integration" "this" {
  count                   = var.enable_api_gateway_v1 ? 1 : 0
  rest_api_id             = var.api_gateway_v1_rest_api_id
  resource_id             = aws_api_gateway_resource.this[0].id
  http_method             = aws_api_gateway_method.this[0].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.this.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.this.arn}/invocations"
}

