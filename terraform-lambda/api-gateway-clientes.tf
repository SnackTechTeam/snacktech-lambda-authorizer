
# # Criação do endpoint para a raiz do recurso "Clientes"

resource "aws_api_gateway_resource" "clientes" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "Clientes"
}

#LIBERAR POST NA RAIZ
resource "aws_api_gateway_method" "clientes_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.clientes.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "clientes_post" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.clientes.id
  http_method = aws_api_gateway_method.clientes_post.http_method
  type                    = "HTTP_PROXY"
  uri                     = "${var.serviceEndpoint}/api/Clientes"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  
  credentials = data.aws_iam_role.labrole.arn
}