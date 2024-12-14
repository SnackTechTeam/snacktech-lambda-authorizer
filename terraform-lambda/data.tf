data "aws_iam_role" "labrole" {
  name = "LabRole"
}

data "aws_ecr_repository" "ecr_repository" {
  name = var.ecrRepositoryName
}
