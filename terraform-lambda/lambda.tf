resource "aws_lambda_function" "example_lambda" {
  function_name = "${var.projectName}-authorizer"  

  image_uri    = "${data.aws_ecr_repository.ecr_repository.repository_url}:${var.imageTag}"
  package_type = "Image"

  role          = data.aws_iam_role.labrole.arn
  timeout       = var.lambdaTimeout
  memory_size   = var.lambdaMemorySize

  environment {
    variables = var.lambdaEnvironmentVariables
  }
}