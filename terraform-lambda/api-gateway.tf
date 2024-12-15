# Create an API Gateway that uses the lambda function defined in lambda.tf to autorize requests for all resources and routes
# autorizate any method to any route
# just autorize any request of any method, and if the lambda autorize it, passthrough the request to the destintion

# The destination of the requests validated is the uri vars.serviceEndpoint
# For the autentication tha lambda expects a header named "cpf"

# Create the REST API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = "${var.projectName}-api"
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Create the Lambda authorizer
resource "aws_api_gateway_authorizer" "lambda_authorizer" {
  name                   = "${var.projectName}-authorizer"
  rest_api_id            = aws_api_gateway_rest_api.api.id
  authorizer_uri         = aws_lambda_function.authorizer.invoke_arn
  authorizer_credentials = data.aws_iam_role.labrole.arn
  type                   = "REQUEST"
  identity_source        = "method.request.header.cpf"
}

# Create proxy resource to catch all paths
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

# ANY method for the proxy resource
resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lambda_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true,
    "method.request.header.cpf" = true
  }
}

# Integration for the proxy resource
resource "aws_api_gateway_integration" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  
  type                    = "HTTP_PROXY"
  uri                     = "${var.serviceEndpoint}/{proxy}"
  integration_http_method = "ANY"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

  credentials = data.aws_iam_role.labrole.arn
}

# Deployment and stage
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  
  depends_on = [
    aws_api_gateway_integration.proxy
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