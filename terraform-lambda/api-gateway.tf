# Create an API Gateway that uses the lambda function defined in lambda.tf to autorize requests for all resources and routes
# autorizate any method to any route
# just autorize any request of any method, and if the lambda autorize it, passthrough the request to the destintion

# The destination of the requests validated is the uri vars.serviceEndpoint
# For the autentication tha lambda expects a header named "cpf"

# Create the REST API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = "snacktech-api"
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Create the Lambda authorizer
resource "aws_api_gateway_authorizer" "lambda_authorizer" {
  name                   = "snacktech-authorizer"
  rest_api_id            = aws_api_gateway_rest_api.api.id
  authorizer_uri         = aws_lambda_function.authorizer.invoke_arn
  authorizer_credentials = data.aws_iam_role.labrole.arn
  type                   = "REQUEST"
  identity_source        = "method.request.header.cpf"
}


# Deployment and stage
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  
  depends_on = [
    aws_api_gateway_integration.clientes_post,
    aws_api_gateway_integration.proxy_cliente
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id  = aws_api_gateway_rest_api.api.id
  stage_name   = "prod"
}


output "stage_prod_invoke_url" {
  value = aws_api_gateway_stage.stage.invoke_url
}