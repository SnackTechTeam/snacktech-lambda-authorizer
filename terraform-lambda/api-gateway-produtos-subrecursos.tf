
# Criação dos endpoints para os subrecursos do recurso "Produtos"

resource "aws_api_gateway_resource" "proxy_produtos" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.produtos.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_produtos" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.proxy_produtos.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lambda_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "proxy_produtos" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy_produtos.id
  http_method = aws_api_gateway_method.proxy_produtos.http_method
  
  type                    = "HTTP_PROXY"
  uri                     = "${var.serviceEndpoint}/api/Produtos/{proxy}"
  integration_http_method = "ANY"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

  credentials = data.aws_iam_role.labrole.arn
}
