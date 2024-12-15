
# # Criação do endpoint para a raiz do recurso "Pedidos"

resource "aws_api_gateway_resource" "pedidos" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "Pedidos"
}